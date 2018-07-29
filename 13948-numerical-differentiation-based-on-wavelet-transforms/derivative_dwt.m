function dudx=derivative_dwt(u,wt_name,wt_level,dx,trt_flag)
%
% Differentiation (Derivative) of Sampled Data Based on Discrete Wavelet Transform
%
% dudx=derivative_dwt(u,wt_name,wt_level,dx)
%
% u:        uniformly-sampled data
% wt_name:  name of the wavelet function (haar or spl)
% wt_level: level of wavelet decomposition
% dx:       sampling interval (default=1)
% trt_flag: flag of translation-rotation transformation for boundary effect (default=1)
% dudx:     differentiations of data (u)
%
%See also
%           derivative_cwt
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

if strcmp(wt_name,'haar')    
    h0=[sqrt(2)/2 sqrt(2)/2];  %the decomposition low-pass filter
    h1=[-sqrt(2)/2 sqrt(2)/2]; %the decomposition high-pass filter    
elseif strcmp(wt_name,'spl')
    h0=[0.125 0.375 0.375 0.125]*sqrt(2);
    h1=[-2 2]*sqrt(2);
else
    error('wavelet name error');
end

y0=u;

% Algorithme a Trous
for n=1:wt_level    
    h0_atrous=[h0' zeros(length(h0),2^(n-1)-1)]';
    h0_atrous=h0_atrous(1:(length(h0)-1)*(2^(n-1)-1)+length(h0));
    
    h1_atrous=[h1' zeros(length(h1),2^(n-1)-1)]';
    h1_atrous=h1_atrous(1:(length(h1)-1)*(2^(n-1)-1)+length(h1));
        
    y1=conv(y0,h1_atrous);
    y0=conv(y0,h0_atrous);    
end

index=round(length(y1)/2-length(u)/2)+[1:length(u)];
dudx=y1(index);

wt_scale=2^wt_level;

if strcmp(wt_name,'haar')
    dudx=-dudx/wt_scale^(3/2)*4;
elseif strcmp(wt_name,'spl')
    dudx=-dudx/wt_scale^(3/2);   
else
    error('wavelet name error');
end

dudx=dudx/dx+a;

