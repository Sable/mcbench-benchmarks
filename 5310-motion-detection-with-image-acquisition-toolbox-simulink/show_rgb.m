function dummy = show_rgb(u,orient, videoRes)
%SHOW_RGB Display an MxN RGB video frame encoded as an Mx3N matrix.
%  SHOW_RGB(A) displays an RGB video frame where A is an Mx3N RGB matrix,
%  with the R, G, and B components concatenated as follows:
%          R = A(:,     1 : N/3)
%          G = A(:, N/3+1 : 2*N/3)
%          B = A(:, 2*N/3 : end)

% Copyright 2003 The MathWorks, Inc.

hfig = findobj('type','figure','tag','RGBVideo');
if nargout>0, dummy = 0; end
if nargin==0,
    % Close figure
    if ~isempty(hfig),
        delete(hfig);
    end
else
    % Update/open figure
    [M,N] = size(u);
    if N/3 ~= floor(N/3),
        error('Input must have number of columns exactly divisible by 3.');
    end
    u = reshape(uint8(u),M,N/3,3);
    if (nargin<2) || ~orient,
        u = cat(3, fliplr(u(:,:,1)'), fliplr(u(:,:,2)'), fliplr(u(:,:,3)'));
    end
    
    if isempty(hfig),
        hfig = figure('numbertitle','off', ...
            'name',gcb, ...
            'tag','RGBVideo', ...
            'menubar','none', ...
            'pos', [130 525 videoRes(2) videoRes(1)], ...
            'integerhandle','off', ...
            'CreateFcn', {@movegui, 'northeast'});
        ud.himage = image(u);
        set(ud.himage,'erasemode','none');
        set(hfig,'userdata',ud);
        set(gca, 'drawmode','fast', 'pos',[0 0 1 1]);
    else
        ud = get(hfig,'userdata');
        set(ud.himage,'cdata',u);
    end
end

% [EOF]
