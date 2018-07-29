function [ws,r] = temporalMP(y,B,nonnegative,maxiter,mindelta,deadzone)
    %[ws,r] = temporalMP(y,B,nonnegative,maxiter,maxr2,deadzone)
    %Perform matching pursuit (MP) on a one-dimensional signal y 
    %
    %temporalMP uses the matching pursuit algorithm to form a sparse
    %representation of a one-dimensional (temporal) signal y in terms of
    %basis elements B, such that:
    %
    %y approximately equals r
    %where r = sum_i conv(ws(:,i),B(:,i),'same'), 
    %and nnz(ws(:)) << length(y)
    %
    %Arguments:
    %    y: a mx1 signal
    %    B: an nxp basis. n is the length of each basis function and p is
    %       the number of such basis functions
    %    nonnegative (optional): if true, uses a variant of MP where ws are 
    %                            forced to be >= 0 (default false)
    %    maxiter and mindelta (optional): specifies when to stop iterating,
    %       when #iterations > maxiter or when the change |y-r|_2 is <
    %       mindelta, whichever comes first (defaults: 10000 and 0)
    %    deadzone (optional): if > 0, once a basis function has been added
    %       at time t, no additional weights will be added between t -
    %       deadzone and t + deadzone (default 0)
    %
    %Returns:
    %    ws: an mxn matrix of weights
    %     r: the approximation of y in terms of the weights and basis
    %     functions
    %
    %Example use:
    % sig = load('gong.mat'); %included in matlab
    % 
    % %Build a basis of Gabors
    % rg = (-500:500)';
    % sigmas = exp(log(2):.3:log(200));
    % gabors = exp(-.5*(rg.^2)*sigmas.^(-2)).*cos(rg*sigmas.^(-1)*2*pi*2);
    % 
    % %Express signal as a sparse sum of Gabors
    % [ws,r] = temporalMP(sig.y,gabors,false,5000);
    %
    % %See TryTemporalMP.m for more examples
    %
    %Algorithm: 
    %   The implementation pre-computes cross-correlations between the 
    %   basis and y using FFT-based convolution and does not perform 
    %   convolutions in the main loop. It also uses a 3-level tree to 
    %   search for the current maximal correlation, making each iteration
    %   O(sqrt(m)) rather than the usual O(mp). 
    %   
    %   The implementation thus uses computational tricks similar to those used
    %   in MPTK. While according to Krstulovic and Gribonval (2006) MPTK 
    %   iterations are O(log(m)) << O(sqrt(m)), in practice at the 
    %   O(sqrt(m)) level things become memory bound rather than CPU-bound.
    %   Thus this implementation is about as efficient as one could
    %   expect out a pure m-code MP implementation based on our current 
    %   understanding of MP algorithms.
    %
    %   On a 100s signal at 10 kHz and basis of 17 different elements each 
    %   1024 samples long, it does about 1000 iterations per second, an 
    %   order of magnitude more than a O(mp) implementation and about
    %   three orders of magnitude more than a generic implementation like 
    %   the one in SparseLab.
    %
    %Author:
    %   Patrick Mineault, patrick DOT mineault AT gmail DOT com
    %   http://xcorr.net
    %
    %History:
    %   08/08/2011: Added deadzone option
    %   04/08/2011: Tweaked performance for large signals/bases
    %   03/08/2011: Initial release
    %
    
    %Process arguments
    %It's more natural to work with y as a column vector, but it's faster
    %to work with a row vector because of the way memory is stored in
    %Matlab
    y = y(:)'; 
    if nargin < 3
        nonnegative = false;
    end
    if nargin < 4
        maxiter = 10000;
    end
    if nargin < 5
        mindelta = 0;
    end
    if nargin < 6
        deadzone = 0;
    end
    
    maxr2 = .9999;
    
    feedbackFrequency = 250;
    r2CheckFrequency  = 250;
    
    %Scale the basis to have sum(B.^2)
    scales = 1./sqrt(sum(B.^2));
    B = bsxfun(@times,B,scales)';
    
    %Pad y with zeros to avoid edge issues
    padsize = size(B,2);
    y = [zeros(1,padsize),y,zeros(1,padsize)];
    
    %Compute the convolution of y with each element in B
    if size(B,1) > 100
        C = myconvnfft(B(:,end:-1:1),y);
    else
        C = conv2(B(:,end:-1:1),y);
    end
    C = C(:,(size(B,2)+1)/2 + (0:length(y)-1));
    
    %Precompute the convolution of each basis function with the other basis
    %functions
    P = zeros(size(B,1),size(B,2)*2-1,size(B,1));
    for ii = 1:size(B,1)
        P(:,:,ii) = myconvnfft(B(:,end:-1:1),B(ii,:));
    end
    
    %Don't add basis function within the padding
    Cmask = false(1,length(y));
    Cmask(1:size(B,2)) = true;
    Cmask(end-size(B,2)+1:end) = true;
    
    C(:,Cmask) = 0;
    
    %The max operation only needs to be performed once per time point
    %This is a big saving computationally when there are many basis
    %functions
    if nonnegative
        Cmax = max(C);
    else
        Cmax = max(abs(C));
    end
    
    %Similarly, it's wasteful to do a full search every iteration. Ideally
    %you would use a binary tree to do the search for the max. This is an
    %alternative adapted to Matlab's data structures
    nsqrt = ceil(sqrt(length(Cmax)));
    Cmaxpad = nsqrt^2-length(Cmax);
    Cmax2 = max(reshape([Cmax,zeros(1,Cmaxpad)],nsqrt,nsqrt));
    
    r = zeros(1,length(y));
    ws = zeros(size(C));
    
    rgdelta  = (1:size(B,2));
    rgdelta  = rgdelta - mean(rgdelta);
    
    rgdelta2 = (1:size(B,2)*2-1);
    rgdelta2 = rgdelta2 - mean(rgdelta2);
    
    ii = 1;
    sy2 = sum(y.^2);
    while ii <= maxiter        
        %Pick the best basis, displacement
        %Find the max of Cmax2
        [themax,maxsqrt] = max(Cmax2);
        
        if themax^2 < mindelta
            %Time to go
            fprintf('Best delta decreases SSE by less than mindelta, ending\n');
            break;
        end
        
        rg = nsqrt*(maxsqrt-1) + (1:nsqrt);
        if rg(end) > length(Cmax)
            rg = rg(rg <= length(Cmax));
        end
        
        %Find the max of the relevant subset of Cmax
        [~,maxoffset] = max(Cmax(rg));
        %Find the max temporal offset
        maxj = (maxsqrt-1)*nsqrt + maxoffset;
        
        if nonnegative
            [~,maxi] = max(C(:,maxj));
        else
            [~,maxi] = max(abs(C(:,maxj)));
        end
        
        
        %update ws
        ws(maxi,maxj) = ws(maxi,maxj) + C(maxi,maxj);
        
        %Update r incrementally
        rg = maxj + rgdelta;
        delta = C(maxi,maxj)*B(maxi,:);
        
        r(rg) = r(rg) + delta;
        
        %Update C so that it reflects the correlation of y-r and B
        rg2 = maxj + rgdelta2;
        D = C(:,rg2) - reshape(C(maxi,maxj)*P(:,:,maxi),size(P,1),size(P,2));
        
        
        %Update Cmax
        if nonnegative
            Cmax(rg2) = max(D);
        else
            Cmax(rg2) = max(abs(D));
        end
        
        C(:,rg2) = D;
        
        if deadzone > 0
            Cmask(maxj-deadzone+1:maxj+deadzone-1) = 1;
            C(:,rg2) = bsxfun(@times,C(:,rg2),(~Cmask(rg2)));
            Cmax(rg2) = Cmax(rg2).*(~Cmask(rg2));
        end
        
        if rg2(end) > length(y) - size(B,2) -1 || ...
           rg2(1) < size(B,2) +1
            C(:,Cmask) = 0;
            Cmax(Cmask) = 0;
        end
        
        %Update relevant parts of Cmax2
        lopos = ceil(rg2(1)/nsqrt);
        hipos = ceil(rg2(end)/nsqrt);
         
        %select relevant portion of Cmax
        if hipos*nsqrt <= length(Cmax)
            Cmax2(lopos:hipos) = max(reshape(Cmax( ((lopos-1)*nsqrt+1):(hipos*nsqrt)),nsqrt,hipos-lopos+1));
        else
            %Pad with zeros
            A = Cmax( ((lopos-1)*nsqrt+1):end);
            A = [A,zeros(1,(hipos-lopos+1)*nsqrt-length(A))];
            Cmax2(lopos:hipos) = max(reshape(A,nsqrt,hipos-lopos+1));
        end
        
        
        %Give some feedback
        if mod(ii,feedbackFrequency) == 0
            fprintf('Iteration %d\n',ii);
        end
        
        %Check if R^2 > maxr2
        if maxr2 < 1 && mod(ii,r2CheckFrequency) == 0
            r2 = 1-sum((y-r).^2)/sy2;
            if r2 > maxr2
                fprintf('Max R^2 reached at iteration %d\n',ii);
                break;
            end
        end
        
        ii = ii + 1;
    end
    
    %Rescale ws to original scale and remove padding
    ws = bsxfun(@times,ws(:,padsize+1:end-padsize)',1./scales);
    r = r(padsize+1:end-padsize)';
end

%Convolution of a vector and a matrix
%uses the same algo as Bruno Luong's convnfft
function R = myconvnfft(M,v)
    nsize = size(M,2)+length(v)-1;
    vf = fft(v,nsize);
    Mf = fft(M,nsize,2);
    R  = ifft(bsxfun(@times,vf,Mf),[],2);
end