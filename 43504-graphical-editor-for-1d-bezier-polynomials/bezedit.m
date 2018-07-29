function bezedit(alpha, haxes, color, varargin)
    % BEZEDIT Draw and edit Bezier polynomial by dragging control points
    %
    %   BEZEDIT(ALPHA) draws the graph of a 1D Bezier polynomial or
    %   arbitrary degree. Draggable control points are also shown. As the
    %   control points are moved, the graph is updated. 
    %
    %   Written by Brian G. Buss
    
    if nargin<2   
        figure;
        haxes = gca;
        set(gca, 'XLim', [-0.2 1.2]);
    end
    if nargin<3
        color = 'b';
    end
    
    s = 0:0.01:1;
    line(s, bezier_vec(alpha, s), 'LineStyle', ':', 'Color', color, 'Parent', haxes);
    hline=line(s, bezier_vec(alpha, s), 'LineStyle', '-', 'Color', color, 'Parent', haxes, varargin{:});
    
    
    for k=1:length(alpha)
        hpoints(k)=impoint(haxes, [(k-1)/5 alpha(k)]);
        setPositionConstraintFcn(hpoints(k), makeConstrainToRectFcn('impoint', [(k-1)/5 (k-1)/5], [-inf inf]));
        addNewPositionCallback(hpoints(k), @(pos)update(haxes));
        setColor(hpoints(k), color);
        
        hcmenu = get(hpoints(k), 'uicontextmenu');
        exportmenu = uimenu(hcmenu, 'Label', 'Export', 'Callback', @(a,b)export(haxes));
        set(hpoints(k), 'uicontextmenu', hcmenu);
    end
    
    setappdata(haxes, 'alpha', alpha);
    setappdata(haxes, 'impoints', hpoints);
    setappdata(haxes, 'hline', hline);
end

function update(haxes)
    hpoints = getappdata(haxes, 'impoints');
    hline = getappdata(haxes, 'hline');
    
    alpha = zeros(1, length(hpoints));
    for k=1:length(hpoints)
        pos = getPosition(hpoints(k));
        alpha(k) = pos(2);
    end
    
    s = 0:0.01:1;
    set(hline, 'YData', bezier_vec(alpha, s));
end

function export(haxes)
    hpoints = getappdata(haxes, 'impoints');
    hline = getappdata(haxes, 'hline');
    
    alpha = zeros(1, length(hpoints));
    for k=1:length(hpoints)
        pos = getPosition(hpoints(k));
        alpha(k) = pos(2);
    end
    
    name=inputdlg('Enter variable name:', 'Save Bezier parameters to base workspace', 1);
    while (~isvarname(name{1}) && ~isempty(name))
        name=inputdlg(sprintf('''%s'' is not a valid variable name.\nEnter variable name:', name{1}), 'Save Bezier parameters to workspace', 1);
    end
    if isvarname(name{1})
        assignin('base',name{1},alpha);
    end  
end

function y = bezier_vec(alpha, s)
    y = zeros(size(alpha,1), size(s,2));
    for k=1:length(s)
        y(:,k) = bezier(alpha, s(k));
    end
end
