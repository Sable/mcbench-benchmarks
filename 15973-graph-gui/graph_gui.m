function graph_gui(A,xy)
%GRAPH_GUI  Draw and Edit Graphs of Vertices and Edges
% GRAPH_GUI(A,XY) Loads a graph into the GUI for editing
%
%   Controls:
%     Use the radio buttons to select an action
%       1. To DRAW a new VERTEX, select 'Draw' and 'Vertex'. Then click
%         inside the axes in the desired location.
%       2. To DELETE a VERTEX, select 'Delete' and 'Vertex'. Then click
%         inside the axis near the desired vertex.
%       3. To DRAW an EDGE, select 'Draw' and 'Edge'. Then click and hold
%         the mouse button down on the starting vertex and drag the mouse
%         to the vertex of the desired connection.
%           a. If 'Directed' is selected, a 1-way edge will be created from
%             the first vertex to the second.
%           b. If 'Undirected' is selected, a 2-way edge between the first vertex
%             and the second vertex will be created.
%         Note:
%           If no vertices exist, no edges will be created.
%       4. To DELETE an EDGE, select 'Delete' and 'Edge'. Then click and
%         hold the mouse button down on the starting vertex and drag the mouse
%         to the vertex of the desired connection to delete.
%           a. If 'Directed' is selected, only the 1-way edge between the
%             first vertex and the second will be deleted.
%           b. If 'Undirected' is selected, the entire 2-way edge between the
%             first vertex and the second vertex will be deleted.
%       5. Click the 'Latch Points' checkbox to toggle between rounded and
%         unrounded (x,y) points.
%       6. The number in the edit box specifies a rounding value. For example,
%         a value of 0.5 rounds each (x,y) point to the nearest 0.5
%       7. Click the 'Save Graph' button to save the adjacency matrix (A) and the
%         coordinates (xy) of the graph to a MAT file.
%
%       Note: The display at the bottom of the figure window shows either the (x,y)
%         coordinate of the mouse location or the ID of the closest vertex.
%
%       Note: The following line styles are used to display the graph
%           1. Undirected (2-way) edges are plotted in solid black lines
%           2. Directed (1-way) edges are plotted in two styles
%               a. If the edge connects a larger vertex ID with a smaller ID,
%                  the edge is plotted as a blue dashed line
%               b. If the edge connects a smaller vertex ID with a larger ID,
%                  the edge is plotted as a red dotted line
%           3. Any vertex that is connected to itself is plotted with a
%              black circle around it
%
%   Example:
%       graph_gui; % sets up a GUI to draw a new graph
%
%   Example:
%       n = 10; t = 2*pi/n*(0:n-1);
%       A = round(rand(n));
%       xy = 10*[cos(t); sin(t)]';
%       graph_gui(A,xy); % loads a graph into the GUI for editing
%
%   See also: gplot, gplotd (FEX #16131)
%
% Author: Joseph Kirk
% Email: jdkirk630@gmail.com
% Release: 1.1
% Release Date: 8/28/07

% set up the figure window
figure('Name','Draw a Graph', ...
    'Numbertitle','off', ...
    'Menubar','none', ...
    'ToolBar','figure', ...
    'Position',[300 100 525 550], ...
    'WindowButtonDownFcn',@clickButtonDown, ...
    'WindowButtonUpFcn',@clickButtonUp, ...
    'WindowButtonMotionFcn',@buttonMotion);
axes('Units','normalized', ...
    'Position', [0.1 0.1 0.8 0.75])

% radio buttons for choosing to draw or delete
ddpanel = uipanel('BackgroundColor',[0.9 0.9 0.9], ...
    'Position',[0.025 0.875 0.175 0.1]);
draw_radio = uicontrol(ddpanel, ...
    'Style','radiobutton', ...
    'String','Draw', ...
    'Units','normalized', ...
    'BackgroundColor',[0.9 0.9 0.9], ...
    'Value',1, ...
    'Position', [0.05 0.55 0.9 0.35], ...
    'Callback',@clickDrawRadio);
delete_radio = uicontrol(ddpanel, ...
    'Style','radiobutton', ...
    'String','Delete', ...
    'Units','normalized', ...
    'BackgroundColor',[0.9 0.9 0.9], ...
    'Value',0, ...
    'Position', [0.05 0.1 0.9 0.35], ...
    'Callback',@clickDeleteRadio);

% radio buttons for choosing a vertex or edge
vepanel = uipanel('BackgroundColor',[0.9 0.9 0.9], ...
    'Position',[0.225 0.875 0.175 0.1]);
vertex_radio = uicontrol(vepanel, ...
    'Style','radiobutton', ...
    'String','Vertex', ...
    'Units','normalized', ...
    'BackgroundColor',[0.9 0.9 0.9], ...
    'Value',1, ...
    'Position', [0.05 0.55 0.9 0.35], ...
    'Callback',@clickVertexRadio);
edge_radio = uicontrol(vepanel, ...
    'Style','radiobutton', ...
    'String','Edge', ...
    'Units','normalized', ...
    'BackgroundColor',[0.9 0.9 0.9], ...
    'Value',0, ...
    'Position', [0.05 0.1 0.9 0.35], ...
    'Callback',@clickEdgeRadio);

% radio buttons for choosing a directed or undirected edge
dupanel = uipanel('BackgroundColor',[0.9 0.9 0.9], ...
    'Position',[0.425 0.875 0.175 0.1]);
directed_radio = uicontrol(dupanel, ...
    'Style','radiobutton', ...
    'String','Directed', ...
    'Units','normalized', ...
    'BackgroundColor',[0.9 0.9 0.9], ...
    'Value',1, ...
    'Position', [0.05 0.55 0.9 0.35], ...
    'Enable','off', ...
    'Callback',@clickDirRadio);
undirected_radio = uicontrol(dupanel, ...
    'Style','radiobutton', ...
    'String','Undirected', ...
    'Units','normalized', ...
    'BackgroundColor',[0.9 0.9 0.9], ...
    'Value',0, ...
    'Position', [0.05 0.1 0.9 0.35], ...
    'Enable','off', ...
    'Callback',@clickUdirRadio);

% check box and text box for latching x/y points
lpanel = uipanel('BackgroundColor',[0.9 0.9 0.9], ...
    'Position',[0.625 0.875 0.175 0.1]);
latch_edt = uicontrol(lpanel, ...
    'Style','edit', ...
    'String','0.01', ...
    'Units','normalized', ...
    'Position', [0.05 0.55 0.9 0.35], ...
    'BackgroundColor',[1 1 1]);
latch_chk = uicontrol(lpanel, ...
    'Style','checkbox', ...
    'String','Latch Points', ...
    'Value',1, ...
    'Units','normalized', ...
    'Position', [0.05 0.1 0.9 0.35], ...
    'BackgroundColor',[0.9 0.9 0.9]);

% button to save A/xy
uicontrol('Style','pushbutton', ...
    'String','Save Graph', ...
    'Units','normalized', ...
    'Position', [0.825 0.875 0.15 0.1], ...
    'Callback',@saveGraph);

% text box to show x/y or vertex id
xy_txt = uicontrol('Style','text', ...
    'Units','normalized', ...
    'Position',[0 0 1 0.05], ...
    'FontSize',11, ...
    'FontWeight','b', ...
    'BackgroundColor',[0.8 0.8 0.8]);

if nargin < 2
    xy = [];
    A = [];
else
    plotGraph(A,xy);
end
eid = [];

%----- callback functions ------------------------
    function pt = getPoint()
        cpt = get(gca,'CurrentPoint');
        pt = cpt(1,1:2);
        if get(latch_chk,'Value')
            latch = str2double(get(latch_edt,'String'));
            if ~isnan(latch)
                pt = round(pt/latch)*latch;
            end
        end
    end

    function plotGraph(A,xy,ax)
        cla;
        if ~isempty(xy)
            plot(xy(:,1),xy(:,2),'.');
            if nargin < 3
                ax = axis;
            else
                minx = min([ax(1); xy(:,1)]);
                maxx = max([ax(2); xy(:,1)]);
                miny = min([ax(3); xy(:,2)]);
                maxy = max([ax(4); xy(:,2)]);
                ax = [minx maxx miny maxy];
            end
            dgplot(A,xy);
            axis(ax);
        end
    end

    function dgplot(A,xy)
        n = size(A,1);
        A = max(0,min(1,ceil(abs(A))));
        uA = A.*A'.*(1-eye(n));
        [ux,uy] = makeXY(uA,xy);            % undirected edges (2-way)
        [dxu,dyu] = makeXY(triu(A-uA),xy);  % directed edges (1-way, sm2lg)
        [dxl,dyl] = makeXY(tril(A-uA),xy);  % directed edges (1-way, lg2sm)
        [ix,iy] = makeXY(A.*eye(n),xy);     % self-connecting edges
        hold on
        plot(ux,uy,'k-')
        plot(dxu,dyu,'r:')
        plot(dxl,dyl,'b--')
        plot(ix,iy,'ko')
        plot(xy(:,1),xy(:,2),'k.')
        for k = 1:n
            text(xy(k,1),xy(k,2),['  ' num2str(k)],'Color','k','FontSize',12,'FontWeight','b')
        end
        hold off

        function [x,y] = makeXY(A,xy)
            x = NaN;
            y = NaN;
            if any(A(:))
                [ii,jj] = find(A);
                m = length(ii);
                xmat = [xy(ii,1) xy(jj,1)]';
                ymat = [xy(ii,2) xy(jj,2)]';
                x = [xmat; NaN(1,m)]; x = x(:);
                y = [ymat; NaN(1,m)]; y = y(:);
            end
        end
    end

    function id = getNearestVertex(pt)
        dsq = sum((xy-pt(ones(size(xy,1),1),:)).^2,2);
        id = find(dsq==min(dsq));
        id = id(1);
    end

    function clickButtonDown(varargin)
        pt = getPoint;
        ax = axis;
        if pt(1)>=ax(1) && pt(1)<=ax(2) && pt(2)>=ax(3) && pt(2)<=ax(4)
            if get(edge_radio,'Value')
                if ~isempty(xy)
                    eid = getNearestVertex(pt);
                end
            elseif get(draw_radio,'Value')
                n = size(xy,1);
                xy(n+1,:) = pt;
                A(n+1,n+1) = 0;
                plotGraph(A,xy,ax);
            else
                if ~isempty(xy)
                    id = getNearestVertex(pt);
                    xy(id,:) = [];
                    A(id,:) = [];
                    A(:,id) = [];
                    plotGraph(A,xy,ax);
                end
            end
        end
    end

    function clickButtonUp(varargin)
        if get(edge_radio,'Value') && ~isempty(xy)
            cpt = get(gca,'CurrentPoint');
            pt = cpt(1,1:2);
            ax = axis;
            if pt(1)>=ax(1) && pt(1)<=ax(2) && pt(2)>=ax(3) && pt(2)<=ax(4)
                id = getNearestVertex(pt);
                if get(draw_radio,'Value')
                    A(eid,id) = 1;
                else
                    A(eid,id) = 0;
                end
                if get(undirected_radio,'Value')
                    if id ~= eid
                        A(id,eid) = A(eid,id);
                    else
                        A(id,eid) = 0;
                    end
                end
                plotGraph(A,xy,ax);
            end
        end
    end

    function buttonMotion(varargin)
        pt = getPoint;
        if get(draw_radio,'Value') && get(vertex_radio,'Value')
            set(xy_txt,'String',[' x = ' num2str(pt) ' = y ']);
        elseif ~isempty(xy)
            id = getNearestVertex(pt);
            set(xy_txt,'String',[' id = ' num2str(id)]);
        else
            set(xy_txt,'String','');
        end
    end

    function saveGraph(varargin)
        str = inputdlg('Name of the MAT file','Save',1,{'mygraph'});
        if ~isempty(str)
            eval(sprintf('save %s A xy',str{1}));
        end
    end

    function clickDrawRadio(varargin)
        set(draw_radio,'Value',1);
        set(delete_radio,'Value',0);
    end

    function clickDeleteRadio(varargin)
        set(draw_radio,'Value',0);
        set(delete_radio,'Value',1);
    end

    function clickVertexRadio(varargin)
        set(vertex_radio,'Value',1);
        set(edge_radio,'Value',0);
        set(directed_radio,'Enable','off');
        set(undirected_radio,'Enable','off');
    end

    function clickEdgeRadio(varargin)
        set(vertex_radio,'Value',0);
        set(edge_radio,'Value',1);
        set(directed_radio,'Enable','on');
        set(undirected_radio,'Enable','on');
    end

    function clickDirRadio(varargin)
        set(directed_radio,'Value',1);
        set(undirected_radio,'Value',0);
    end

    function clickUdirRadio(varargin)
        set(directed_radio,'Value',0);
        set(undirected_radio,'Value',1);
    end
end
