function [Y,T]=derivs(x,dim)
%Syntax: [Y,T]=derivs(x,dim) 
%____________________________ 
%
% The phase space reconstruction of a time series x whith the derivatives approach,
% in embedding dimension m.
% 
% Y is the trajectory matrix in the reconstructed phase space.
% T is the phase space length.
% x is the time series. 
% dim is the embedding dimension.
%
%
% Reference:
%
% Packard N H, Cruchfield J P, Farmer J D, Shaw R S (1980): Geometry from a Time
% Series. Physical Review Letters 45: 712-715
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
% 11 Mar 2001.

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

if nargin<2 | isempty(dim)==1
    dim=2;
else
    % dim must be scalar
    if sum(size(dim))>2
        error('dim must be scalar.');
    end
    % dim must be an integer
    if dim-round(dim)~=0
        error('dim must be an integer.');
    end
    % dim must be positive
    if dim<=0
        error('dim must be positive.');
    end
end


% Initialize the phase space
Y=zeros(N,dim);

% Phase space reconstruction with the derivatives approach
Y(:,1)=x;
for i=2:dim
    Y(:,i)=[diff(Y(:,i-1));0];
end

% Total points on phase space 
T=N-(dim-1);

% Remove the meaningless points
Y(T+1:end,:)=[];
