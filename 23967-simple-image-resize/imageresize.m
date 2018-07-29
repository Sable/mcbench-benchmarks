%====================================================%
%===========ECEN 5793: DIP===========================%
%===========PROJECT 1================================%
%====================================================%
function A3 = imageresize(B3,p,m)
% Zoom or shrink a image
% Input:image B3: gray-image or RGB image
%       p: ratio, zooming (p>1), shrink(p<1)
%       m: mode; =0:(default) nearest neighbor interpolation 
%                =1: Bilinear interpolation
%                =2: Bicubic interpolation
% Output: image A3
% @Trung Duong, trungd@okstate.edu
% Jan 25, 2009
%====================================================%
% Input checking and default values
error(nargchk(2, 3, nargin, 'struct'));
if nargin < 3, m = 0; end

dimB = length(size(B3));
if dimB== 2 % GRAY-IMAGE INPUT:
    A3 = gray_resize(B3,p,m); 
elseif dimB== 3 % COLOR RGB-IMAGE INPUT:
    AR = gray_resize(B3(:,:,1),p,m);
    AG = gray_resize(B3(:,:,2),p,m);
    AB = gray_resize(B3(:,:,3),p,m);
    A3 = zeros([size(AR) 3]);
    A3(:,:,1) = AR;
    A3(:,:,2) = AG;
    A3(:,:,3) = AB;
else
    error('Improper input image');
end
    
%**************************************************%
%==================================================%
% Sub-Function: Resize a gray-image
% Same input argument with imageresize()
function A = gray_resize(B,p,m)
% Initialize new-grid and output
[N,M] = size(B);
xp = 1:1/p:N+1/p; yp = 1:1/p:M+1/p;
A = zeros(length(xp),length(yp));
% Symmetric Padding
npad = 3;
B = sym_pad(B,npad);
switch m
    case 0 % Nearest neighbor interpolation
        U = round(xp); V = round(yp);
        U(find(U<1)) = 1; V(find(V<1)) = 1; 
        U(find(U>N)) = N; V(find(V>M)) = M; 
        A = B(U+npad,V+npad);
    case 1 % Bilinear interpolation
        % Floor of (xp,yp)
        xf = floor(xp);     yf = floor(yp);
        % Distance to top-left neighbors                
        [XF,YF] = ndgrid(xf,yf);
        [XP,YP] = ndgrid(xp,yp);      
        u = XP - XF;         v = YP  - YF;        
        % Change xf, yf for new padding image
        xf = xf + npad; yf = yf + npad;
        % Interpolation
        A = (1-u).*(1-v).*B(xf,yf)   + ...
                 (1-u).*v    .*B(xf,yf+1) + ...
                 u   .*(1-v) .*B(xf+1,yf) + ...
                 u   .*v     .*B(xf+1,yf+1);           
   case 2
        % Floor of (xp,yp)
        xf = floor(xp);yf = floor(yp);
        % Distance to top-left neighbors      
        [XF,YF] = ndgrid(xf,yf);
        [XP,YP] = ndgrid(xp,yp);
        u = XP - XF;        v = YP - YF;        
        % Change xf, yf for new padding image
        xf = xf + npad; yf = yf + npad;
        % Interpolation: 16 neighbors
        for i = -1:2
            for j = -1:2
                if i==-1, sgi = -1; else sgi = 1; end
                if j==-1, sgj = -1; else sgj = 1; end                
                A = A + mex_hat(sgi*(i-u)).*mex_hat(sgj*(j-v)).*B(xf+i,yf+j);
            end
        end       
   otherwise
        error('Undefined Interpolation method');
end
%**************************************************%
%==================================================%
% Sub-Function: Mexican-hat kernel
function hx = mex_hat(x)
    hx = zeros(size(x));
    x = abs(x);
    ind1 = find(x<=1);  ind2 = find(x>1 & x<=2);

    hx(ind1) = 1 - 2*x(ind1).^2 + x(ind1).^3;
    hx(ind2) = 4 - 8*x(ind2) + 5*x(ind2).^2 - x(ind2).^3;
% END of sub-function
%==================================================%
% Sub-Function: symmetric padding, by default 2 pixels
% Input: gray image
function Bp = sym_pad(B,n)
    Bp = zeros(size(B)+2*n);
    Bp(n+1:end-n,n+1:end-n) = B;
    % Padding symmetrically 4 boundaries
    Bp(n:-1:1,n+1:end-n) = B(1:n,:);
    Bp(n+1:end-n,n:-1:1) = B(:,1:n);
    Bp(end-n+1:end,n+1:end-n) = B(end:-1:end-n+1,:);
    Bp(n+1:end-n,end-n+1:end) = B(:,end:-1:end-n+1);
% END of sub-function
%==================================================%


