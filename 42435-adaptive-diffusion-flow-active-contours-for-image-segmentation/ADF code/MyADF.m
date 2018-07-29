function [u,v] = MyADF(f, weights,iter,sigma,deltat,fil,show)
% MyADF       Compute the Adaptive Diffusion Flow (ADF) force field .
%     [u,v] = MyADGVF(f, weights, iter)
%    
%     Inputs
%  f           ----> edge map, d1-by-d2 matrix for 2D, and d1-by-d2-by-d3 matrix for 3D.   
%  weights     ----> weights=0 ,GGVF weighting parameter, 
%                    weights=1  ,GVF weigthing parameter,which usually ranges from 0.01 to 0.2.   
%  iter        ----> ADF iteration number, which usually ranges from 20 to 100.
%  sigma       ----> gaussia filter parameter
%  deltat      ----> time step of solving u,v
%  fil         ----> fil='selctive',selective smoothing
%              ----> fil='medfilt', median filtering
%              ----> fil='null', no filtering,default
%  show        ----> whether show each iteration result of force field or not
%                    show='ns', no show, default
%                    show='is', show
               
%     Outputs
%     u          x-Component of ADF force field
%     v          y-Component of ADF force field
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%  Ref.
%  [1]  Yuwei Wu, Yunde Jia, Yuanquan Wang, ¡°Adaptive Diffusion Flow for
%  Parametric Active Contours¡±£¬20th International Conference on Pattern Recognition (ICPR),2010, PP.2788-2791.
%  [2]  Yuwei Wu, Yuanquan Wang, Yunde Jia. Adaptive Diffusion Flow Active
%  Contours for Image Segmentation. (Accepted by CVIU,2013, DOI http://dx.doi.org/10.1016/j.cviu.2013.05.003 )
%  [2]	J. F. Ning, C. K. Wu, Liu Shigang, Yang Shuqin, ¡°NGVF: An improved
%  external force field for active contour mode,¡± Pattern Recognition Letters, 28: 58-63, 2007
%  [3]	P. Blomgren, T. F. Chan, Pep Mulet, C. K. Wong, 
% ¡°Total variation image restoration: numerical methods and extension,¡± 
%  ICIP, vol. 3, PP. 384¨C387, 1997
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% by Yuwei Wu and Yuanquan Wang @2009.4.20
%Media Computing and Intelligent Systems Lab
%BeiJing Insititute of Technology
%100081,P.R.C
%%
if ~exist('fil') fil='null'; end
if ~exist('show') show='ns'; end
if (nargin<5) error('not enough arguments (at least 6 should be given)'); end
%%

%%
    time = clock;
%%
    f = double(f);
    fmin = min(f(:));
    fmax = max(f(:));
    f = (f-fmin)/(fmax-fmin);           % Normalize f to the range [0,1]
    
    %%  Compute coefficient m (Eq. 6)
    f0 = f;
    f0 = BoundMirrorExpand(f0);
    kk = autok(f0);
    k0 = kk*5^0.5;
    [row,col,nchannel]=size(f0);
    beta = ones(row,col,nchannel);
    indexn = find(f0<=k0);
    beta(indexn) = (1-(f0(indexn)/k0).^2).^2;
    alpha = 1-beta;
    
    [fx,fy] = gradient(f);       % Calculate the gradient of the edge map
    fx = BoundMirrorExpand(fx);
    fy = BoundMirrorExpand(fy);
    f = BoundMirrorExpand(f);  % Take care of boundary condition
    u = fx; v = fy;              % Initialize GVF to the gradient
    SqrMagf = fx.*fx + fy.*fy ; % Squared magnitude of the gradient field
%% Compute coefficient g and h
if weights(1) == 1,        % similar to gradient vector flow
    g = weights(2);
    h = SqrMagf;           % a rule to determine this weight......
elseif weights(1) == 0,    % similar to generalized gradient vector flow
    K2 = power(weights(2),2);
    g = exp(-SqrMagf/K2);
    h = 1-g;
end

%%
% compute p  =               1
  %                1+ ------------------    ** denotes convolution 
  %                    1+g(|G**Du|.^2)      Du represents gradient of u  
    f = f*255;
    f = Gaus_filter(f,sigma);
    [fx,fy] = gradient(f); 
    SqrMagf = fx.*fx + fy.*fy ;
    pu = 1+1./(1+SqrMagf.^0.5);
    pv = 1+1./(1+SqrMagf.^0.5);

%% Iteratively solve for the ADF u,v  (minimiz Eq.5 using variational
%   calculus) 

     u = BoundMirrorEnsure(u);
     v = BoundMirrorEnsure(v);

 for i=1:iter,  
%  compute both tangent component utt and normal component unn     
     [row,col,nchannel]=size(u);
     %compute center difference of u
     % WN  N  EN
     % W   O  E 
     % WS  S  ES
     
     u = Gaus_filter(u,sigma);  %|G**Du|),**denots convolution
     v = Gaus_filter(v,sigma);  %|G**Dv|),**denots convolution
       
     ux=(u(:,[2:col col],:)-u(:,[1 1:col-1],:))/2;%Ix=(E-W)/2
     uy=(u([2:row row],:,:)-u([1 1:row-1],:,:))/2;%Iy=(S-N)/2
     uxx=u(:,[2:col col],:)+u(:,[1 1:col-1],:)-2*u;%Ixx=E+W-2*O
     uyy=u([2:row row],:,:)+u([1 1:row-1],:,:)-2*u;%Iyy=S+N-2*O
     ESWN=u([2:row row],[2:col col],:)+u([1 1:row-1],[1 1:col-1],:);%ES+WN
     ENWS=u([1 1:row-1],[2:col col],:)+u([2:row row],[1 1:col-1],:);%EN+WS
     uxy=(ESWN-ENWS)/4;%Ixy=Iyx=((ES+WN)-(EN+WS))/4
  
     utt=(uxx.*uy.^2-2*ux.*uy.*uxy+uyy.*ux.^2)./(ux.^2+uy.^2+eps);
     unn=(uxx.*ux.^2+2*ux.*uy.*uxy+uyy.*uy.^2)./(ux.^2+uy.^2+eps);
    
     ux = BoundMirrorEnsure(ux);
     uy = BoundMirrorEnsure(uy);  
     uxx = BoundMirrorEnsure(uxx);
     uyy = BoundMirrorEnsure(uyy);
     uxy = BoundMirrorEnsure(uxy); 
     utt = BoundMirrorEnsure(utt);
     unn = BoundMirrorEnsure(unn); 
    
% compute both tangent component vtt and normal component vnn 
    [row,col,nchannel]=size(v);
    %compute center difference of v
    % WN  N  EN
    % W   O  E 
    % WS  S  ES
    vx=(v(:,[2:col col],:)-v(:,[1 1:col-1],:))/2;%Ix=(E-W)/2
    vy=(v([2:row row],:,:)-v([1 1:row-1],:,:))/2;%Iy=(S-N)/2
    vxx=v(:,[2:col col],:)+v(:,[1 1:col-1],:)-2*v;%Ixx=E+W-2*O
    vyy=v([2:row row],:,:)+v([1 1:row-1],:,:)-2*v;%Iyy=S+N-2*O
    ESWN=v([2:row row],[2:col col],:)+v([1 1:row-1],[1 1:col-1],:);%ES+WN
    ENWS=v([1 1:row-1],[2:col col],:)+v([2:row row],[1 1:col-1],:);%EN+WS
    vxy=(ESWN-ENWS)/4;%Ixy=Iyx=((ES+WN)-(EN+WS))/4
    
    vtt=(vxx.*vy.^2-2*vx.*vy.*vxy+vyy.*vx.^2)./(vx.^2+vy.^2+eps);
    vnn=(vxx.*vx.^2+2*vx.*vy.*vxy+vyy.*vy.^2)./(vx.^2+vy.^2+eps);
     
    vx = BoundMirrorEnsure(vx);
    vy = BoundMirrorEnsure(vy);  
    vxx = BoundMirrorEnsure(vxx);
    vyy = BoundMirrorEnsure(vyy);
    vxy = BoundMirrorEnsure(vxy); 
    vtt = BoundMirrorEnsure(vtt);
    vnn = BoundMirrorEnsure(vnn);
    %----------------------------------------------------------------------
    %
     grad2u=(ux.*ux + uy.*uy).^0.5;
     grad2v=(vx.*vx + vy.*vy).^0.5;

     dmsu=sqrt(1+ux.*ux + uy.*uy);
     dmsv=sqrt(1+vx.*vx + vy.*vy);
     
%  Iteratively solve for the ADF u,v  (minimiz Eq.5 using variational calculus) 

   u = u + deltat* g.*(alpha.*((dmsu.^(pu-2)).*utt...
         +((pu-2).*(grad2u.^2).*(dmsu.^(pu-4))+dmsu.^(pu-2)).*unn)+ beta.*unn)...
         - deltat*h.*(u-fx);
   v = v + deltat* g.*(alpha.*((dmsv.^(pv-2)).*vtt...
         +((pv-2).*(grad2v.^2).*(dmsv.^(pv-4))+dmsv.^(pv-2)).*vnn)+ beta.*vnn)...
         - deltat*h.*(v-fy);
% -------------------------------------------------------------------------

%   whether postprocessing   
    if strcmp(fil,'selective')
        k=autok(u);
        u=smooth_diffusion(u,'tky','cat',1,k,0.25,2);
        k=autok(v);
        v=smooth_diffusion(v,'tky','cat',1,k,0.25,2); 

    elseif strcmp(fil,'medfilt')
        u=medfilt2(u);
        v=medfilt2(v);
    elseif strcmp(fil,'null')
        u=u;
        v=v;
    end

% whether show solve process 
    if strcmp(show,'is')
         A=strcat('the number of itetation ',num2str(i));       
         mag = sqrt(u.*u+v.*v);
         px = u./(mag+1e-10); py = v./(mag+1e-10); 
         figure;
         hold on
         quiver(px,py,'r');
         axis off; axis equal; axis 'ij';     % fix the axis 
         title(['Adaptive GVF field ' A]);
    end
    
  fprintf(1, '%3d', i);
  if (rem(i,20) == 0)
     fprintf(1, '\n');
  end 
end

  fprintf(1, '\n'); 
 %%   
u = BoundMirrorShrink(u);
v = BoundMirrorShrink(v);

time = etime(clock,time)


