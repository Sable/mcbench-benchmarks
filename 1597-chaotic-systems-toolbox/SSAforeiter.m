function xf=SSAforeiter(x,dim,tau,k,fs,e)
%Syntax: xf=SSAforeiter(x,dim,tau,k,fs,e)
%________________________________________
%
% Iterated forecasting for SSA.
%
% xf is the forecasted time series values.
% x is the time series.
% dim is the embedding dimension.
% tau is the time delay.
% k is the vector with the indices of the components to be reconstructed.
% fs is the number of the out-of-sample time series values to be forecasted.
% e is the minimum value to ensure convergence.
%
%
% Reference:
%
% Elsner J B, Tsonis A A (1996): Singular Spectrum Analysis - A New Tool in
% Time Series Analysis. Plenum Press.
%
%
% Alexandros Leontitsis
% Department of Education
% University of Ioannina
% 45110 - Dourouti
% Ioannina
% Greece
%
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% 14 Jul 2001

if nargin<1 | isempty(x)==1
   error('You should provide a time series.');
else
   % x must be a vector
   if min(size(x))>1
      error('Invalid time series.');
   end
   x=x(:);
   % N is the time series length
   N=length(x);
end


if nargin<5 | isempty(fs)==1
    fs=floor(N/10);
else
    % fs must be scalar
    if sum(size(fs))>2
        error('fs must be scalar.');
    end
    % fs must be positive
    if fs<=0
        error('fs must be positive.');
    end
end

if nargin<6 | isempty(e)==1
    e=0.001*range(x);
else
    % e must be scalar
    if sum(size(e))>2
        error('e must be scalar.');
    end
    % e must be positive
    if e<0
        error('e must be positive.');
    end
end

mx=mean(x);
x=x-mx;

for i=1:fs
    %disp(i)
    % Give an intial value to x(N+1)
    x(N+1)=max(x);
    yq=x(N+1);
    
    % Initialize y with a value that will let at least 1 iteration in
    % the following loop.
    y=0;
        
    while abs(y-yq)>e

        % Update the old y
        yq=x(N+1);

        % SSA
        [pc,s,v]=SSA(x,dim,tau);
        
        % SSA inverse
        xr=SSAinv(pc,v,tau,k);
        
        % A new value for x(N+1)
        y=xr(N+1);
        
        % Update x
        x=[x(1:N);y];
        
    end
    
    xf(i,1)=x(N+1);
    N=N+1;
end

xf=xf+mx;