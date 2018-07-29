function It=smooth_diffusion(I,edgestop,method,niter,K,dt,gamma)
% Catte's Selective Smoothing Diffusion
% I:input gray or color image
% edgestop:(edge stop function)
%       ='lin':linear diffusion,    g=1
%       ='pm1':perona_malik,        g=1/(1+(x/K)^2)
%       ='pm2':perona-malik,        g=exp(-(x/K)^2)
%       ='tky':Tukey's biweight,    g= / (1-(x/K).^2).^2 ,|x|<=K
%                                      \  0              ,otherwise
% method='dir':direct-Anisotropic Diffusion,    ut=div(g(|Du|)*Du)
%       ='cat':Catte-Selective Diffusion,       ut=div(g(|G**Du|)*Du)
%       **denots convolution
%       ='Alvarez':Alvarez-degradation Diffusion,ut=g(|G**Du|*|Du|*div(Du/|Du|)

% niter:number of iterations-default 100
% K:(edge threshold parameter)
% Io;noise free image(if presented:used to compute SNR)
% dt:time increment-default 0.2
%gamma:the parameter of gaussian convolution

%Ref.
%1.P. Perona and J. Malik, ¡°Scale-Space and Edge Detection Using Anisotropic Diffusion,¡± IEEE. Trans. Patt.
%Anal. and Machine Intell., vol. 12, no. 7, pp 629¨C639,1990.
%2.M. J. Black, G. Sapiro, D. H. Marimont and D. Hegger,¡°Robust Anisotropic Diffusion,¡± IEEE Trans. Image
%Processing, vol. 7, no. 3, pp. 421¨C432, Mar. 1998.
%3.Francine Catt¨¦; Pierre-Louis Lions; Jean-Michel Morel; Tomeu Coll,"Image Selective Smoothing and Edge Detection by Nonlinear Diffusion"
%SIAM Journal on Numerical Analysis, Vol. 29, No. 1. (Feb., 1992), pp. 182-193.

% by Yuwei Wu 2009.4.3
%wuyuwei@bit.edu.cn
%Media Computing and Intelligent Systems Lab
%BeiJing Insititute of Technology
%100081,PRC

if ~exist('niter') niter=100; end
if ~exist('K') K=15; end
if ~exist('dt') dt=0.2; end
if (nargin<3) error('not enough arguments (at least 3 should be given)'); end

[row,col,nchannel]=size(I);

%Compute the coefficient (k,a) of normalization g()
if strcmp(edgestop,'lin')
    k=1;
elseif strcmp(edgestop,'pm1')
    k=K;%gradient threshold normalization
    a=1;%amplitude normalization
elseif strcmp(edgestop,'pm2')
    k=K*(2^0.5);
    a=1/(2*exp(-0.5));
elseif strcmp(edgestop,'tky')
    k=K*5^0.5;
    a=25/32;
end


for i=1:niter
    
    %%
    %Compute the value of gradient in (N,S,E,W)
    %    N
    % W  O  E 
    %    S
    if strcmp(method,'dir') % P-M
         Gn=[I(1,:,:);I(1:row-1,:,:)]-I;  %N-O
         Gs=[I(2:row,:,:);I(row,:,:)]-I;  %S-O
         Ge=[I(:,2:col,:) I(:,col,:)]-I;  %E-O
         Gw=[I(:,1,:) I(:,1:col-1,:)]-I;  %W-O
    end
    if strcmp(method,'cat')%Selective Diffusion
        I_bak=I;
        H=fspecial('gaussian',3,gamma);
        I=convn(I,H,'same');

        % I = Gaus_filter(I,gamma);
        % four directional gradient after guassian smoothing
        Gsn=[I(1,:,:);I(1:row-1,:,:)]-I;  %N-O
        Gss=[I(2:row,:,:);I(row,:,:)]-I;  %S-O
        Gse=[I(:,2:col,:) I(:,col,:)]-I;  %E-O
        Gsw=[I(:,1,:) I(:,1:col-1,:)]-I;  %W-O
        %G=G_bak;G<=Gs
        Gn=Gsn;Gs=Gss;Ge=Gse;Gw=Gsw;
    end
  %% Compute the diffusion coefficient
    if strcmp(edgestop,'lin')%isotropic diffusion (gaussian)
        Cn=k;Cs=k;Ce=k;Cw=k;
    elseif strcmp(edgestop,'pm1')%anisotropic diffusion(PM1)-(K=5)
             Cn=1./(1+(Gn/k).^2).*a;
             Cs=1./(1+(Gs/k).^2).*a;
             Ce=1./(1+(Ge/k).^2).*a;
             Cw=1./(1+(Gw/k).^2).*a;
    elseif strcmp(edgestop,'pm2')%anisotropic diffusion (PM2)
            Cn=exp(-(Gn/K).^2).*a;
            Cs=exp(-(Gs/k).^2).*a;
            Ce=exp(-(Ge/k).^2).*a;
            Cw=exp(-(Gw/k).^2).*a;
    elseif strcmp(edgestop,'tky')%anisotropic diffusion (Tukey)
            Cn=zeros(row,col,nchannel);Cs=Cn;Ce=Cn;Cw=Cn;
            indexn=find(abs(Gn)<=k);
            indexs=find(abs(Gs)<=k);
            indexe=find(abs(Ge)<=k);
            indexw=find(abs(Gw)<=k);
            Cn(indexn)=(1-(Gn(indexn)/k).^2).^2*a;
            Cs(indexs)=(1-(Gs(indexs)/k).^2).^2*a;
            Ce(indexe)=(1-(Ge(indexe)/k).^2).^2*a;
            Cw(indexw)=(1-(Gw(indexw)/k).^2).^2*a;
    end
   %% 
     if strcmp(method,'Alvarez')
        I_bak=I;
        H=fspecial('gaussian',3,gamma);
        I=convn(I,H,'same');
         %central difference
         % WN  N  EN
         % W   O  E 
         % WS  S  ES
        Ix=(I(:,[2:col col],:)-I(:,[1 1:col-1],:))/2;%Ix=(E-W)/2
        Iy=(I([2:row row],:,:)-I([1 1:row-1],:,:))/2;%Iy=(S-N)/2
        Ixx=I(:,[2:col col],:)+I(:,[1 1:col-1],:)-2*I;%Ixx=E+W-2*O
        Iyy=I([2:row row],:,:)+I([1 1:row-1],:,:)-2*I;%Iyy=S+N-2*O
        ESWN=I([2:row row],[2:col col],:)+I([1 1:row-1],[1 1:col-1],:);%ES+WN
        ENWS=I([1 1:row-1],[2:col col],:)+I([2:row row],[1 1:col-1],:);%EN+WS
        Ixy=(ESWN-ENWS)/4;%Ixy=Iyx=((ES+WN)-(EN+WS))/4
        
        Du=(Ix.^2+Iy.^2).^0.5;
        if strcmp(edgestop,'pm1')
            g=1./(1+(Du/k).^2).*a;
        elseif strcmp(edgestop,'pm2')
            g=exp(-(Du/K).^2).*a;
        elseif strcmp(edgestop,'tky')
            g=zeros(row,col,nchannel);
            index=find(abs(Du)<=k);
            g(index)=(1-(Du(index)/k).^2).^2*a;
        end
        kDu=g.*(Ixx.*Iy.^2-2*Ix.*Iy.*Ixy+Iyy.*Ix.^2)./(Ix.^2+Iy.^2+eps);
 
     end 
  %%   
    %Solve PDE diffusion using gradient descent
    if strcmp(method,'cat')
    I=I+dt*(Cn.*Gn+Cs.*Gs+Ce.*Ge+Cw.*Gw);
    elseif strcmp(method,'Alvarez')
    I=I+dt*kDu;
     elseif strcmp(method,'dir')%direct-Anisotropic Diffusion
        %G<=G_bak;
 I=I+dt*(Cn.*Gn+Cs.*Gs+Ce.*Ge+Cw.*Gw);
    end

end
It=I;

    



