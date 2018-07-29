function xf=SSAeye(x,dim,tau,k,fs,e)
%Syntax: xf=SSAeye(x,dim,tau,k,fs,e)
%___________________________________
%
% Iterated forecasting for SSA.
%
% xf is the forecasted time series values.
% x is the time series.
% dim is the embedding dimension.
% tau is the time delay.
% k is the number of the first principal components to be reconstructed.
% fs is the number of the out-of-sample time series values to be forecasted.
% e is the presicion papameter.
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
% 14 Oct 2003

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
    e=1000;
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

% Estimate the mean
mx=mean(x);

% Subtract the mean
x=x-mean(x);

% Estimate all the possible values for x(N+1)
y=linspace(min(x),max(x),e);
    
for i=1:fs
    %disp(i)
    
    % SVD in the original time series
    [pca,s,v]=SSA(x,dim,tau);
    
    % Estimate the original eigendirections
    b=v(:,1:k).*(ones(dim,1)*s(1:k)');
    
    for j=1:e

        % SVD on the time series with the candidate value
        [pc,s,v]=SSA([x;y(j)],dim,tau);
        
        % Estimate the candidate eigendirections
        a=v(:,1:k).*(ones(dim,1)*s(1:k)');
        
        %xr=SSAinv(pc,v,tau,1:k);
        
        % Estimate the difference according to the Frobenius norm
        z(j)=norm(a-b,'fro')+norm(pc(1:end-1,1:k)-pca(:,1:k),'fro');
        %z(j)=z(j)+norm(pc(end,1:k)-pca(end,1:k))/k;
        
    end
    
    % Find the minimum difference
    [z,j]=min(z);
    
    % Update the original time series
    x(N+1)=y(j);
    
    xf(i,1)=x(N+1);
    N=N+1;
end

% Add the mean
xf=xf+mx;