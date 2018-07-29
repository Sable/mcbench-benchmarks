function [out,basis,p]=PolyMaskFilter(in,order,mask,basis)
% PolyMaskFilter:   Polynomial filter under mask constraint
%
%   [out,basis,p]=PolyMaskFilter(in,order,mask,basis)
%   Poly filter: fit a ORDERth polynomial function on the data and
%       interpolate on all the image
%
% CWRU, OS 05mar03
%  modif by OS may03 to use weighted LS: cov matrix too big for an image
%                   does not work
%  modif by OS 29may03, use a subsample if Weights are given and implement
%                   weighted least square
%  modif by OS 22sep03, use orthogonal polynomial. Can be given as an input
%                   argument,... not so ppolymial


% --- where to fit the polynomial function
if ~exist('mask'),
    mask = (abs(in)>0.0001);
else
    mask = logical(mask);
end

% --- test if weighted LS 
isw = sum(sum(mask>0 & mask<1))>1;
DIM = size(in);

% --- compute the basis
if ~exist('basis')
%     flag_basis = 0;
    Ni = DIM(1)*DIM(2);
    [x,y] = meshgrid(0:DIM(1)-1,0:DIM(2)-1);
    x = x'/(DIM(1)-1) - 0.5;
    y = y'/(DIM(2)-1) - 0.5;
    
    % --- build the basis
    kp = 0;
    for kx=0:order,
        for ky=0:order,
            if (kx+ky)<=order,
                kp = kp+1;
                basis(:,:,kp) = x.^kx .* y.^ky;
%                 [kx ky]
            end
        end
    end
end

% newI    = in.*(mask>0);
newI = in;
newI(~mask) = 0;
[wx,wy] = find( newI > 0);
idx     = sub2ind(size(in),wx,wy);
Ydata   = in(idx);
W = mask(idx);

X = [];
for k=1:size(basis,3),
    temp = basis(:,:,k);
    X = [X temp(idx)]; 
end

    
if isw,
    Ns = length(Ydata);
    % --- get a subsample of size 1000 max (about 1000)
    if Ns>1000,
        di = round(Ns/1000);
        index = [1:di:Ns]';
%         Xdata = Xdata(index,:);
        X = X(index,:);
        W = diag(W(index));
        Ydata = Ydata(index);
    end
end

if ~isw,
    p = X\Ydata;
else
    p = inv(X'*W*X)*X'*W*Ydata;
end

F = reshape(basis,DIM(1)*DIM(2),size(basis,3))*p;
F = reshape(F,DIM(1),DIM(2));
out = F;

