function dudx=derivative_cwt(u,wt_name,wt_scale,dx,trt_flag)
%
% Differentiation (Derivative) of Sampled Data Based on Continuous Wavelet Transform
%
% dudx=derivative_cwt(u,wt_name,wt_scale,dx)
%
% u:        uniformly-sampled data
% wt_name:  name of the wavelet function  
%           (gaus1, haar, spl, db1, bior1.1, bior1.3, bior1.5 or sym1)
%           For quadratic spline (spl) functon, please add the spline function first by using the following code. 
%           wavemngr('add','Quadratic Spline','spl',4,'','spline_scale_function',[-1 1]);
% wt_scale: scale parameter of wavelet transform
% dx:       sampling interval (default=1)
% trt_flag: flag of translation-rotation transformation for boundary effect (default=1)
% dudx:     differentiations of data (u)
%
%See also
%           derivative_dwt
%
% Reference:
% J. W. Luo, J. Bai, and J. H. Shao, 
% "Application of the wavelet transforms on axial strain calculation in ultrasound elastography," 
% Prog. Nat. Sci., vol. 16, no. 9, pp. 942-947, 2006.

if nargin<5
    trt_flag=1;
end
if nargin<4
    dx=1;
end

if trt_flag
    x=(1:length(u))*dx;
    a=(u(end)-u(1))/(x(end)-x(1));
    b=u(1)-a*x(1);
    u=u-a*x-b;
else
    a=0;
end

wt_name=lower(wt_name);

dudx=cwt(u,wt_scale,wt_name);

if strcmp(wt_name,'gaus1')
    dudx=-dudx/wt_scale^(3/2)/(2*pi)^(1/4);
elseif strcmp(wt_name,'haar')
    dudx=-dudx/wt_scale^(3/2)*4;
elseif strcmp(wt_name,'spl')
    dudx=-dudx/wt_scale^(3/2);
elseif strcmp(wt_name,'db1')
    dudx=-dudx/wt_scale^(3/2)*4;
elseif strcmp(wt_name,'bior1.1')
    dudx=-dudx/wt_scale^(3/2)*4;
elseif strcmp(wt_name,'bior1.3')
    dudx=-dudx/wt_scale^(3/2)*4;
elseif strcmp(wt_name,'bior1.5')
    dudx=-dudx/wt_scale^(3/2)*4;
elseif strcmp(wt_name,'sym1')
    dudx=-dudx/wt_scale^(3/2)*4;
end

dudx=dudx/dx+a;

