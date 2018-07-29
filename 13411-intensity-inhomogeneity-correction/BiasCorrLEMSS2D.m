function [B,x,Icor,B0] = BiasCorrLEMSS2D(I,Imask,V_mean,V_std,options,B0);
% BiasCorrLEMSS2D: Correct for Inhomo by local entropy minimization with splines support
%
%   [B,x,B0] = BiasCorrLEMSS2D(I,Imask,V_mean,V_std,options,B0);
%   B: Final bias filed
%   x: corrected iamge (x=I/B)
%   B0: Initial bias field in case it has been modified by the funciton
%   I: input image (should be in  [0 255])
%   mask: idientify the pixels subject to bias field
%   V_mean: mean of the background 
%   V_std: std of the background
%   options: structure with options. to innitialize the stucture call the
%   fucntion without input argument
% option = BiasCorrLEMSS2D
% option = 
%            Nknots: [30 30] knot spacings in y and x direction
%          NiterMax: 3 number of iteration max
%      flag_display: 1 if 1, display intermediate results in a new figure
%             overs: -1, if 1 pad the image to get an even number of knots
%         normalize: 1, if 1 notrmalize the image
%     flag_allknots: 1, if 1 optimze the knots at the image border
%        GainSmooth: 0, gain to force the spline to be smooth by constraining the second derivatives 
%             Bgain: 0.5000, average of the bias field over the pixels with signal            
%   B0: Initial Bias field
%
%   Olivier Salvado, 20-jan-04, Case Western Resrve University
%  Salvado et al. IEEE TMI 25(5):539-552


conds = 'v';

% --- define the default options
optionsdef.Nknots = [30 30];    % how meny pixels between knots
optionsdef.NiterMax = 3;    % 3 iteration max
% optionsdef.flag_filter = 0;     % no AD filter prior
optionsdef.flag_display = 1;    % all display on
optionsdef.overs = -1;       % automatic with Nknots to get even number of knots
optionsdef.normalize = 1;   % do normalize images
optionsdef.flag_allknots = 1;   % update all the knots
optionsdef.GainSmooth = 0;
% optionsdef.PolyOrder = 3;
optionsdef.Bgain = 0.5;

if nargin == 0, % no vargin, return the options
    B = optionsdef;
    x = [];
    return
end

if ~exist('options','var'), % if no option specify, use the default
    options = optionsdef;
end


% --- read the options
Nknots = options.Nknots;
NiterMax = options.NiterMax;
% flag_filter = options.flag_filter;
flag_display = options.flag_display;
overs = options.overs;
normalize = options.normalize;
flag_allknots =options.flag_allknots;
GainSmooth = options.GainSmooth;
% PolyOrder = options.PolyOrder;
Bgain = options.Bgain;

randn('state',0);
disp('')
disp(' -------------------- BIAS correction ------------------------')
disp('    2D With Local Entropy Minimization with Spline support  V3')

% -- log transform
logtransform = 0;
if logtransform==0,
    disp('  Using multiplicative bias: y=bx')
elseif logtransform==1
    disp('  Using Log transformed data: y=x+b');
end


clf
set(gcf,'BackingStore','on');

% --- add 'overs' lines with rt  around
[nr,nc] = size(I);
if overs<0, % automatic wiht Nknots,
    temp = nr/Nknots(1);
    k = floor(temp);
    epsilon = temp-k;
    nrp = Nknots(1)*(k+1);  % new dimension
    oversr = ceil((nrp-nr)/2);   % overs to get the new diimension
    
    temp = nc/Nknots(2);
    k = floor(temp);
    epsilon = temp-k;
    ncp = Nknots(2)*(k+1);  % new dimension
    oversc = ceil((ncp-nc)/2);   % overs to get the new diimension
    
else
    oversr = overs;
    oversc = overs;
end

if overs~=0, % need to oversize
    Imask = padarray(Imask,[oversr oversc],0,'both');
    I = padarray(I,[oversr oversc],V_mean,'both');
    if exist('B0','var'),
        B0 = padarray(B0,[oversr oversc],'replicate');
    end
end

% --- normalize the image
if normalize, % no normalization to be able to compare B to Btrue...
    If = imfilter(I,fspecial('gaussian',31,11));
    Rnorm = 100/max(If(:));
    y = double(I)*Rnorm;
    V_mean = V_mean * Rnorm;
    V_std = V_std * Rnorm;
else
    y = double(I);
    Rnorm = 1;
end

% --- Initialize B
mask = (Imask == 1);
Gauss = fspecial('gaussian',30,10);
pol = 0;
pol_old = 1;

% --- Initialize B
mask = (Imask == 1);
Gauss = fspecial('gaussian',30,10);
pol = 0;
pol_old = 1;

% --- build the grid
i = [1:size(y,1)];
j = [1:size(y,2)];
[ii,jj] = ndgrid(i,j);

% --- get the knots and B(knots)
NknotsI = round(size(y,1)/Nknots(1));
NknotsJ = round(size(y,2)/Nknots(2));
ik = round(linspace(1,size(y,1),NknotsI));
jk = round(linspace(1,size(y,2),NknotsJ));
[iik,jjk] = ndgrid(ik,jk);

% --- tag the knots to be updated
if 0,
    Mknots = zeros(NknotsI,NknotsJ);
    for ki=1:NknotsI,
        for kj=1:NknotsJ,
            if mask(ik(ki),jk(kj)) == 1,
                Mknots(ki,kj) = 1;
            end
        end
    end
    Mknots = (Mknots>0);
else,   % make all the knots valid except the borders
    Mknots = ones(NknotsI,NknotsJ);
    Mknots(1,:) = 0;
    Mknots(end,:) = 0;
    Mknots(:,1) = 0;
    Mknots(:,end) = 0;
end


% ik,jk: all the knots vectors size(ik)=[1,Nknots];
% Mknots: 1 when the knots need to be optimized
Bk = B0(ik,jk);         % B at the knots

% --- sort the knots from higher B to lower B
[dummy,knotlist] = sort(-Bk(:).*Mknots(:));       % go from brightest to dimmest
% knotlist = [1:Nknots*Nknots];                                   % does not sort the knots
Bk = Bk + 0*randn(size(Bk));
Bk0 = Bk;
Hx = inf;

% --- compute for B0
pp0 = csape({ik,jk}, Bk0,conds);
B0 = fnval(pp0,{i,j});
% ratioB0 = max(B0(mask));
ratioB0 = mean(B0(mask))/Bgain;
B0 = B0/ratioB0;
x0 = y;
x0 = y./B0.*Imask + (1-Imask).*y;

% --- main loop
Nktot = NknotsI*NknotsJ;
tic
iter = 1;
again = 1;
B = B0;
B = Bgain*B/mean(B(mask));

while again;   % iteration of the fitting
    Mopt = zeros(size(y));
    Mlead = zeros(size(y));
    Bkold = Bk;
    Hxold = Hx;
    for idx=1:Nktot,           % iteration on the knots
        k = knotlist(idx);        % next on the list
        %         k = idx;                        % does not sort the knots
        if (flag_allknots | (Mknots(k)>0)),          % this knot needs to be updated (all the knots now)
            
            if flag_display,
                subplot(243)
                hold on, plot(jjk(k),iik(k),'r+'), hold off
                subplot(244)
                hold on, plot(jjk(k),iik(k),'r+'),
                plot(jjk(:),iik(:),'co')
                hold off
                drawnow
            end
            
            % --- get the incremental mask around the knot
            Mnew = zeros(size(y));          % blank mask
            if (iik(max(k-1,1))<iik(k)), imin = iik(k-1); else imin=iik(k);end
            if (iik(min(k+1,Nktot))>iik(k)), imax = iik(k+1); else imax=iik(k);end
            if (jjk(max(k-NknotsI,1))<jjk(k)), jmin = jjk(k-NknotsI); else jmin=jjk(k);end
            if (jjk(min(k+NknotsI,Nktot))>jjk(k)), jmax = jjk(k+NknotsI); else jmax=jjk(k);end
            zonei = (ii>=imin) & (ii<=imax);              % mask for all the i
            zonej = (jj>=jmin) & (jj<=jmax);    % mask for all the j
            Mnew = zonei & zonej & mask;
            
            % --- get the area within 2 knots around the knot under
            % optimization
            zone = 5;
            whik = mod( k , length(ik) );   
            whjk = ceil( k / length(ik) );
            imin = ik( max( 1 ,whik-zone) );
            imax = ik( min( NknotsI ,whik+zone) );
            jmin = jk( max( 1 ,whjk-zone) );
            jmax = jk( min( NknotsJ ,whjk+zone) );
            area =[imin imax jmin jmax];    
            
            if sum(Mnew(:))>300, % There should be enough data in the mask
                
                if idx<6000,
                    Mlead = Mlead | Mnew;
                end
                Mopt = Mlead | Mnew;
                
                % --- optimize entropy by moving the knot k
                % ============================
                option = optimset('TolX',1e0,'Display','off',...
                    'DiffMaxChange',1,...
                    'DiffMinChange',0.01,...
                    'NonlEqnAlgorithm','lm');
                %                 'DiffMaxChange',max(6-idx,1),...
                %                 'DiffMinChange',1/(idx+1)^2,...
                
                %     Bkoptim = fminsearch(@optfungo0,Bk(k),option,ik,y,Bk,k,i);
                upperBnd = Bk(k)*1.15;
                lowerBnd = max( 0.1 , Bk(k)*0.85 );
                [Bkoptim] = fminbnd(@optfungo7,lowerBnd,upperBnd,option,...
                    ik,jk,y,Bk,k,i,j,Mopt,mask,GainSmooth,area,B,Bgain);
                
                if Bkoptim>0,
                    Bk(k) = Bkoptim;
                    
                    % --- find the spline
                    %     pp = csapi(ik, Bk, i);
                    pp = csape({ik,jk}, Bk,conds);
                    
                    % --- interpolate B
                    %     B = fnval(spi,i);
                    B = fnval(pp,{i,j});
                    %                     ratioB = max(B(mask));
                    ratioB = mean(B(mask))/Bgain;
                    B = B/ratioB;
                    
                    % --- reconstruct 
                    x = y;
                    %                     x(mask) = y(mask)./B(mask);
                    x = y./B.*Imask + (1-Imask).*y;

                end
                PDFx = hist(x(mask),[1:1:300]);                
                % --- display
                if flag_display,
                    subplot(221)
                    row = round(nr/2);
%                     ycor = y./B;
%                     ycor(~mask) = y(~mask);
%                     ycor = y./B.*Imask + (1-Imask).*y;
                    
                    plot([B(row,:)*200 ; B0(row,:)*200 ; y(row,:)  ; x(row,:)]')
                    legend('B estimated','B0','y','xhat')
                    ylim([0 300])
                    
                    subplot(243)
                    imagesc(x),axis image,title('image reconstructed x'),axis off
                    
                    subplot(244)
                    temp = B;
                    imagesc(B,[0 1.3]),axis image,axis off,title('Bias estimated')
                    
                    subplot(248), 
%                     imagesc(Bk),axis image,axis off
                    imagesc(Mopt+Mnew),axis image, axis off
                    
                    subplot(247),imagesc(y),axis image,title('image initial'),axis off
                    %                 subplot(248),imagesc(B./Btrue,[0.9 1.1]),axis image,axis off,colorbar
                    %                 title('B/Btrue')
                    %                subplot(248),imagesc(Mopt),axis image, axis off
                    
                    subplot(223)
                    subplot(223),plot([1:1:300],PDFx), title('histogram of x estimated'),
                end                    
                    % --- entropy calculation
                    PDFx = PDFx((PDFx>0));
                    PDFx = PDFx / sum(PDFx(:));
                    Hx = -sum( PDFx.*log(PDFx) );
            end
        end % if
    end % for
    if flag_display & 1,
        disp([' Entropy: ' num2str(Hx)])
    end
    Bchange = mean( abs(Bk(:)-Bkold(:))./abs(Bkold(:)) )*100;
    Hchange = (Hx-Hxold)./abs(Hxold(:)) *100;
    again = (iter<=1) | ( (iter<NiterMax)  & (Bchange>0.5) & (abs(Hchange)>0.001));
    disp([' Change on knots:' num2str(Bchange) ' %'])
    disp([' Change on H:' num2str(Hchange) ' %'])
    iter = iter +1;
end


ProcTime = toc

pause(1)
clf
if flag_display,
    ymax = max(y(:));
    subplot(221),imagesc(y,[0 ymax]),axis image,axis off,title('Original')
    subplot(222),imagesc(x,[0 ymax]),axis image,axis off,title('Corrected with LEMS')
    subplot(223),hist(y(:),[0:300]);
    subplot(224),hist(x(:),[0:300]);
    colormap(gray(256))
end

x = x / Rnorm;

% --- correct original (without filtering) for B
Icor = I./B.*Imask + (1-Imask).*I;

% --- resize to original size
if overs~=0, % need to resize
    x = x(oversr+1:end-oversr,oversc+1:end-oversc);
    Icor = Icor(oversr+1:end-oversr,oversc+1:end-oversc);
    B = B(oversr+1:end-oversr,oversc+1:end-oversc);
    B0 = B0(oversr+1:end-oversr,oversc+1:end-oversc);
end

% ------------------------ FUNCTION FOR OPTIM
function [Hx,B,x,PDFx]= optfungo7(Bkoptim,ik,jk,y,Bk,k,i,j,Mopt,M,GainSmooth,area,B,Bgain);
conds = 'v';
% --- find the spline
%     pp = csapi(ik, Bk, i);
Bk(k) = Bkoptim;
pp = csape({ik,jk}, Bk,conds);

% --- interpolate B
% B = fnval(pp,{i,j});
% % B = B/max(B(M));
% B = 0.5*B/mean(B(M));

if 0,
    B = fnval(pp,{i,j});
else
    Barea = fnval(pp,{i(area(1):area(2)),j(area(3):area(4))});
    B(area(1):area(2),area(3):area(4)) = Barea;
end
B = Bgain*B/mean(B(M));

% --- reconstruct 
x = y./B;
% x(~M) = y(~M);  % the bias does not affect the background

% --- entropy calculation
PDFx = hist(x(Mopt),[1:0.5:400]);
% PDFx = filtfilt([0.5],[1 -0.5],PDFx);
PDFx = PDFx((PDFx>0));
Hx = -sum( PDFx.*log(PDFx) );

if GainSmooth>0   % use a smoothness constraint
    N = length(y(Mopt));
    Hmax= log(N);
    Hmin = -N*log(N);
    Hx = -(Hx - Hmax)/Hmin;             % normalized entropy
    
    if 0,
        Bder2 = fnder(pp,[1 1]');
        Bder2 = (fnval(Bder2,{i,j})/N).^2;
        Smoothness = sum(Bder2(:));
    else
        Eb2 = imfilter(Bk,[0 -1 0;-1 4 -1;0 -1 0],'full','replicate');
        Eb4 = imfilter(Eb2,[0 -1 0;-1 4 -1;0 -1 0],'full','replicate');
        Eb4 = (Eb4(3:end-2,3:end-2)/N).^2;
        Smoothness = sum(Eb4(:));
    end
    Hx = Hx + GainSmooth*Smoothness;
end

return