function [cc] = chaincode(b,unwrap)
%   Freeman Chain Code
%
%   Description: Give Freeman chain code 8-connected representation of a
%                boundary
%   Author.....: Alessandro Mannini <mannini@esod.it>
%   Date.......: 2010, september
%
%   usage:
%   --------------------------------------------------------
%   [cc] = chaincode(b,u)
%
%   INPUT:
%   --------------------------------------------------------
%   b       - boundary as np-by-2 array; 
%             np is the number of pixels and each element is a pair (y,x) of
%             pixel coordinates
%   unwrap  - (optional, default=false) unwrap code;
%             if enable phase inversions are eliminated
%            
%
%   OUTPUT:
%   --------------------------------------------------------
%   cc is structure with the following fields:
%
%   cc.code     - 8-connected Freeman chain code as 1-by-np array (or
%                 1-by-(np-1) if the boundary isn't close)
%   cc.x0,cc.y0 - respectively the abscissa and ordinate of start point
%   cc.ucode    - unwrapped 8-connected Freeman chain code (if required)
%

%
%
%   used direction-to-code convention is:       3  2  1
%                                                \ | /
%                                             4 -- P -- 0
%                                                / | \
%                                               5  6  7
%   
%   and in terms of deltax,deltay if next pixel compared to the current:
%   --------------------------
%   | deltax | deltay | code |
%   |------------------------|
%   |    0   |   +1   |   2  |
%   |    0   |   -1   |   6  |
%   |   -1   |   +1   |   3  |
%   |   -1   |   -1   |   5  |
%   |   +1   |   +1   |   1  |
%   |   +1   |   -1   |   7  |
%   |   -1   |    0   |   4  |
%   |   +1   |    0   |   0  |
%   --------------------------
%

% check input arguments
if nargin>2 
    error('Too many arguments');
elseif nargin==0
    error('Too few arguments');
elseif nargin==1
    unwrap=false;
end    
% compute dx,dy  by a circular shift on coords arrays by 1 element
sb=circshift(b,[-1 0]);
delta=sb-b;
% check if boundary is close, if not cut last element
if abs(delta(end,1))>1 || abs(delta(end,2))>1
    delta=delta(1:(end-1),:);
end
% check if boundary is 8-connected
n8c=find(abs(delta(:,1))>1 | abs(delta(:,2))>1);
if size(n8c,1)>0 
    s='';
    for i=1:size(n8c,1)
        s=[s sprintf(' idx -> %d \n',n8c(i))];
    end
    error('Curve isn''t 8-connected in elements: \n%s',s);
end


% convert dy,dx pairs to scalar indexes thinking to them (+1) as base-3 numbers
% according to: idx=3*(dy+1)+(dx+1)=3dy+dx+4 (adding 1 to have idx starting
% from 1)
% Then use a mapping array cm
%   --------------------------------------
%   | deltax | deltay | code | (base-3)+1 |
%   |-------------------------------------|
%   |    0   |   +1   |   2  |      8     | 
%   |    0   |   -1   |   6  |      2     | 
%   |   -1   |   +1   |   3  |      7     | 
%   |   -1   |   -1   |   5  |      1     | 
%   |   +1   |   +1   |   1  |      9     | 
%   |   +1   |   -1   |   7  |      3     | 
%   |   -1   |    0   |   4  |      4     |  
%   |   +1   |    0   |   0  |      6     | 
%   ---------------------------------------

idx=3*delta(:,1)+delta(:,2)+5;
cm([1 2 3 4 6 7 8 9])=[5 6 7 4 0 3 2 1];

% finally the chain code array and the starting point
cc.x0=b(1,2);
cc.y0=b(1,1);
cc.code=(cm(idx))';

% If unwrapping is required, use the following algorithm
%
% if a(k), k=1..n is the original code and u(k) the unwrapped:
%
% - u(1)=a(1)
% - u(k)=g(k), 
%        g(k) in Z | (g(k)-a(k)) mod 8=0 and |g(k)-u(k-1)| is minimized  
%
if (unwrap) 
    a=cc.code;
    u(1)=a(1);
    la=size(a,1);
    for i=2:la
        n=round((u(i-1)-a(i))/8);
        u(i)=a(i)+n*8;
    end
    cc.ucode=u';
end    

end