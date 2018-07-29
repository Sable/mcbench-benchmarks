%% resize.m
%
%  Resize volume
%  resize x,y slices, then y,z slices
%
%  Created: Dec 31st, 2011
%  Changed: Dec 31st, 2011
%
function Y = resize(X,scale,mode)

    if nargin<2; scale = 1; end;
    if nargin<3; mode  = 'bilinear'; end;
    
    if numel(scale)>1
        newsize = scale;
    else
        newsize = ceil(size(X) * scale);
    end;
    
    if isequal(newsize,size(X)); Y = X; return; end;

    % resize x,y slices
    X = imresize(X,[newsize(1) newsize(2)], mode);
    
    % resize y,z slices
    Y = permute(X,[2 3 1]); % permute so y,z slices are 1st/2nd coordinates
    Y = imresize(Y, [newsize(2) newsize(3)], mode);
    Y = permute(Y,[3 1 2]); % permute back to x,y,z

end
