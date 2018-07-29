function [xo,mx,sx,ignores] = lars_scale(x,varargin)
% A utility function for the 'lars' function.


global RESOLUTION_OF_LARS;
lars_init();

if length(varargin)==2  % recovery
    mx = varargin{1};
    sx = varargin{2};
    xo = x .* repmat(sx,size(x,1),1) + repmat(mx,size(x,1),1);
    sx = NaN;
    ignores = NaN;
    return;
elseif length(varargin)==0 %scaling
    mx = mean(x);
    xo = x - repmat(mx,size(x,1),1);
    sx = sum(xo.^2).^(1/2);
    ignores = find(sx < RESOLUTION_OF_LARS);                % Drop too small vectors.
    sx(ignores)=inf;
    xo = xo ./ repmat(sx,size(x,1),1);
    return;
else
    error('Usage of the function "scale" is wrong.');
end

return;
