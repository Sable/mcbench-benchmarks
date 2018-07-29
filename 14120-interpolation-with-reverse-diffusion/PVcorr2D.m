function [I,Flow,H] = PVcorr2D(Ir,ratio,option);
%   PVcorr2D:   partial vollume correction with reverse difusion
%
%   [I,Flow,H] = PVcorr2D(Ir,ratio,option);
%
%  Ir: image to be interpolated
% ratio: 2 for x2 interpolation
% option: structure with parameters
% option.Niter = 200; Maxnumber of iteration
% option.tol = 0.001; tolerance for stopping
% option.f_H = 1; if 1, compute the entropy
% option.f_display = 1; if 1 dispaly intermediate results
% option.f_PVE = 1; if 1 use flow constraint 
% option.ordmax = 5; neighbor to compute max flow (out of 8 neighbors)
% option.ordmin = 4; neighbor to compute min flow (out of 8 neighbors)
% for the two last options, one can try 6 and 3, or 7 and 2
%
% I: corrected image
% Flow: flow across iterations
% H: entropy across iterations if option.f_H is set to 1
% 
% OS, Case Western Reserve University, 16jul04
%
% From paper:
% Olivier  Salvado, Claudia M. Hillenbrand, and David L. Wilson, 
% “Partial Volume Reduction by Interpolation with Reverse Diffusion,” 
% International Journal of Biomedical Imaging, 
% vol. 2006, Article ID 92092, 13 pages, 2006. doi:10.1155/IJBI/2006/92092
%
% available online at: 
% http://www.hindawi.com/GetArticle.aspx?doi=10.1155/IJBI/2006/92092&e=cta



optiondef.Niter = 200;
optiondef.tol = 0.001;
optiondef.f_H = 1;
optiondef.f_display = 1;
optiondef.f_PVE = 1;
optiondef.ordmax = 5;
optiondef.ordmin = 4;


if nargin == 0,
    I = optiondef;
    return
end

if ~exist('option','var'),
    option = optiondef;
end

Niter = option.Niter;
tol = option.tol;
f_H = option.f_H;
f_display = option.f_display;
f_PVE = option.f_PVE;  % flag = 1 to use PVE constraints
ordmax = option.ordmax;
ordmin = option.ordmin;



[Mx,My,Mxy,Myx,I] = PVEMaskGeneration(Ir,ratio);
[Ny,Nx] = size(I);

% --- init parameters
noise = 0;
if noise>0,
    % to remove noise as in bicubic interp to avoid aliasing artifact
    I = imfilter(I,fspecial('gaussian',11,0.75),'same','symmetric');
end

NiterDisp = Niter;
Dx = [2:Nx Nx];
Dy = [2:Ny Ny];
C = 4;
kernelG = fspecial('gaussian',3*ratio+1,ratio/2);%ratio*3+1,9);
% kernelG = fspecial('average',ratio);%ratio*3+1,9);
Gt0 = 1;  % thermal energy
H = 0;
iter = 0;
bins = [-0.1:0.01:1.1];
Nbins = length(bins);
Npix = Ny*Nx;
Hmax= -Nbins*log(Npix/Nbins);
Hmin = -Npix*log(Npix);


again = 1;
if f_display,
    disp('')
    disp('  Starting correction')
end
stop  = 0;
Flowf(1) = 0;
while again,
    Iold = I;
    iter = iter +1;
    If = imfilter(I,kernelG,'same','replicate');
    % --- uses the filtered image for the gradient
%     bal = 1;
%     grady =  (If(Dy,:) - If)*bal - 0.5*(1-bal)*(I(Dy,:) - I );
%     gradx =  (If(:,Dx) - If )*bal - 0.5*(1-bal)*(I(Dy,:) - I );
    grady =  (If(Dy,:) - If);
    gradx =  (If(:,Dx) - If );
    
    
    % ---- compute flow limits
    if 1,
        Imin = I-ordfilt2(I,ordmin,[1 1 1; 1 0 1; 1 1 1],'symmetric');
        Imax = ordfilt2(I,ordmax,[1 1 1; 1 0 1; 1 1 1],'symmetric')-I;
    else
        K = ones(2*ratio-1,2*ratio-1);
        K(ratio,ratio) = 0;
        KS = sum(K(:));
        Imin = I-ordfilt2(I,KS/2-3,K,'symmetric');
        Imax = ordfilt2(I,KS/2+4,K,'symmetric')-I;
    end
    
    % --- actual flows
    flowx1 = min(   (Imax(:,Dx))/C    ,    min( max(0,gradx) , Imin/C       ) ) ;             % grad >0
    flowx2 = max( -Imax/C        ,    max( min(0,gradx) , -Imin(:,Dx)/C ) );   % grad<0
    
    flowy1 = min(   Imax(Dy,:)/C    ,    min( max(0,grady) , Imin/C       ) ) ;             % grad >0
    flowy2 = max(  -Imax/C        ,    max( min(0,grady) , -Imin(Dy,:)/C ) );   % grad<0
    
    % --- block the flow across pseudo boundaries if f_PVE
    if f_PVE,
        flowx    = Mx.*(flowx1 + flowx2);    % in fact either 1 or 2
        flowy    = My.*(flowy1 + flowy2);    % in fact either 1 or 2
    else
        flowx    = (flowx1 + flowx2);    % in fact either 1 or 2
        flowy    = (flowy1 + flowy2);    % in fact either 1 or 2
    end    
    
    % --- update the image
    flow_tot = (flowx+flowy);
    I = I - flow_tot;
    I(:,Dx(1:end-1)) = I(:,Dx(1:end-1)) + flowx(:,1:end-1);
    I(Dy(1:end-1),:) = I(Dy(1:end-1),:) + flowy(1:end-1,:);
    
    % entropy
    if f_H | f_display,
        hi = hist(I(:),bins);
%         Npix = Ny*Nx;
%         Hmin = 1/Npix*log(1/Npix);
%         Hmax = Npix*log(Npix);
        H(iter) = -sum( hi(hi>0).*log(hi(hi>0)) );
        H(iter) = (H(iter)-Hmin) / (Hmax-Hmin) ;
    end
    
    % --- compute metrics
    Flow(iter) = sum(abs(flow_tot(:)))*0.1;

    if iter>1,
        Flowf(iter) = Flow(iter)*0.5+0.5*Flowf(iter-1);
        if f_H,
            Hf(iter) = H(iter)*0.5+Hf(iter-1)*0.5;
        end

%         stop = abs(Flowf(iter)-Flowf(iter-1))/Flowf(iter-1)<tol;
        if Flowf>Flowmax,Flowmax = Flowf(iter);end
        stop = (Flowf(iter)<Flowmax*tol);
    else
        Flowf(iter) = Flow(iter);
        Flowmax = Flowf(1);
        if f_H,
            Hf(iter) = H(iter);
        end
    end
    
    
    
    if (f_display & (mod(iter,round(Niter/NiterDisp)) == 0) ),
        
        M(iter) = im2frame(uint8(I*255),gray(256));
        subplot(221)
        imagesc(Ir,[0 1]),title('I0'),axis image
        subplot(222)
        imagesc(I,[0 1]),title(['I corrected, Iteration : ' num2str(iter) ' / ' num2str(Niter)]),axis image
        
        if f_H,
            subplot(245)
            plot([Flow' Flowf'])
            title(['Flow'])
            subplot(246)
             plot([H' Hf'])      
             title(['Entropy'])
        else,
           subplot(223)
            plot([Flow'-mean(Flow) Flowf'-mean(Flow)])      
            title(['Flow'])
        end
        subplot(224)
        bar(bins,hi),xlim([-0.5 1.5])
    end
    
    
    % --- end the simulation
    again = ((iter<Niter) & (~stop | 0));
    drawnow
    
end
if f_display
    disp('end')
end



% ===============  SUB FUNCTIONS =======================

function [Mx,My,Mxy,Myx,I] = PVEMaskGeneration(I0,N);
%
% [Mx,My,Mxy,Myx,I] = PVEMaskGeneration(I0,N);
%
% Generate masks to be used for reverse diffusion PVE correction
%

if N<2,
    disp('error N should be >=2');
    return;
end

% --- resize with nearest neigbhors
I = imresize(I0,N);
[Ly,Lx]= size(I);

% --- build the masks
Mx = ones(size(I));
My = Mx;
Mxy = Mx;
Myx = Mx;
Dx = [N:N:Lx];
Dy = [N:N:Ly];

Mx(:,Dx) = 0;
My(Dy,:) = 0;
Mxy(Dy,:) = 0;
Mxy(:,Dx) = 0;
Myx(:,Dx) = 0;
Myx(Dy-(N-1),:) = 0;
