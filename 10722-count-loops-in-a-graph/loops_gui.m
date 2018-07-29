function loops_gui(cmd)
%LOOPS_GUI  Creates a GUI that counts the number of loops in a network
% This code counts the number of loops (cycles) in a network (graph) that
% is composed of nodes and edges. It employs an iterative algorithm that
% transforms the network into a tree (the ILCA - Iterative Loop Counting
% Algorithm). This is a "brute force" technique as there are no known (to
% my knowledge anyway) algorithms for providing a good estimation.
% 
% AUTHOR:   Joseph Kirk,2/2007
% EMAIL:    <jdkirk630@gmail.com>
% USAGE:    >> loops_gui;
% NOTES:    Refer to the README and the DETAILS files for more info

global HFIG NET LOOPLIST AXN AXH NUMLOOPS LOOPDIST ...
    NETPROPS REDUCENET COUNTLOOPS SAVENET SAVELOOPS CLEAR;

if nargin  ~=  1
    HFIG = figure('Name','Count Loops in a Network of Nodes and Edges','Numbertitle','off', ...
        'Menubar','none','Color',[0.8 0.8 0.8],'Position',[25,50,750,450],'Resize','off');
    AXN = axes('Units','pixels','Position',[30 95 300 300],'Visible','off');
    AXH = axes('Units','pixels','Position',[420 95 300 300],'Visible','off');
    FILEMENU = uimenu('Label','File');
    uimenu(FILEMENU,'Label','Load Net','Callback',[mfilename,'(''GETNET'')'],'Accelerator','N');
    uimenu(FILEMENU,'Label','Clear','Callback',[mfilename,'(''CLEAR'')']);
    uimenu(FILEMENU,'Label','Exit','Callback',[mfilename,'(''CLOSE'')'],'Separator','on');
    HELPMENU = uimenu('Label','Help');
    uimenu(HELPMENU,'Label','Help','Callback','msgbox(''Click the buttons! :)'',''Help'')');
    uimenu(HELPMENU,'Label','Readme','Callback','README');
    uimenu(HELPMENU,'Label','Algorithm Description','Callback','DETAILS');
    uimenu(HELPMENU,'Label','About Loops','Separator','on','Callback',['msgbox({'''',' ...
        ''' Iterative Loop Counting Algorithm Gui '','' Release 4 - February 2007 '','''',' ...
        ''' by Joseph Kirk '','' jdkirk630@gmail.com''},''About Loops'')']);
    uicontrol('Parent',HFIG,'Position',[30 25 90 30],'Style','pushbutton', ...
        'BackgroundColor',[1.0 0.65 0.65],'Tag','getnet','String','Get Net', ...
        'FontWeight','bold','Callback',[mfilename,'(''GETNET'')']);
    REDUCENET = uicontrol('Parent',gcf,'Position',[130 25 90 30],'Style','pushbutton', ...
        'BackgroundColor',[0.9 0.9 0.9],'Tag','reducenet','String','Reduce Net', ...
        'Enable','off','FontWeight','bold','Callback',[mfilename,'(''REDUCENET'')']);
    COUNTLOOPS = uicontrol('Parent',gcf,'Position',[230 25 90 30],'Style','pushbutton', ...
        'BackgroundColor',[0.9 0.9 0.9],'Tag','countloops','String','Count Loops', ...
        'Enable','off','FontWeight','bold','Callback',[mfilename,'(''COUNTLOOPS'')']);
    SAVENET = uicontrol('Parent',gcf,'Position',[330 25 90 30],'Style','pushbutton', ...
        'BackgroundColor',[0.9 0.9 0.9],'Tag','savenet','String','Save Net', ...
        'Enable','off','FontWeight','bold','Callback',[mfilename,'(''SAVENET'')']);
    SAVELOOPS = uicontrol('Parent',gcf,'Position',[430 25 90 30],'Style','pushbutton', ...
        'BackgroundColor',[0.9 0.9 0.9],'Tag','saveloops','String','Save Loops', ...
        'Enable','off','FontWeight','bold','Callback',[mfilename,'(''SAVELOOPS'')']);
    CLEAR = uicontrol('Parent',HFIG,'Position',[530 25 90 30],'Style','pushbutton', ...
        'BackgroundColor',[0.9 0.9 0.9],'Tag','clear','String','Clear', ...
        'Enable','off','FontWeight','bold','Callback',[mfilename,'(''CLEAR'')']);
    uicontrol('Parent',HFIG,'Position',[630 25 90 30],'Style','pushbutton', ...
        'BackgroundColor',[0.75 0.6 1],'Tag','done','String','Close', ...
        'FontWeight','bold','Callback',[mfilename,'(''CLOSE'')']);
    NETPROPS = uicontrol('Parent',gcf,'Position',[30 65 300 25],'Style','text', ...
        'BackgroundColor',[0.8 0.8 0.8],'Tag','netprops','String',' ','FontSize',12);
    NUMLOOPS = uicontrol('Parent',gcf,'Position',[25 415 700 30],'Style','text', ...
        'BackgroundColor',[0.8 0.8 0.8],'Tag','numloops','String',' ','FontSize',14);

else   %%% GUI callback routines %%%
    switch cmd
        case 'GETNET'
            Button = questdlg('Pick a network type:','Network Type', ...
            'Edge List File','Random Network','Edge List File');
            if ~isempty(Button)
                switch Button
                     case 'Edge List File'
                        % READ NET FROM FILE (PROMPT WILL APPEAR)
                        edge_list = read_edge_list(); % prompt user to select an edge list file
                        if ~isempty(edge_list)
                            USNET = edge_list2net(edge_list); % format the edgelist for loop counting
                            NET = sort_net(USNET);
                        else
                            return
                        end
                   case 'Random Network'
                        % GENERATE RANDOM NET (PROMPT WILL APPEAR)
                        prompt = {' Enter number of NODES for the random network: ', ...
                            ' Enter number of EDGES for the random network: '};
                        name = 'Random Network Setup';
                        answer = inputdlg(prompt,name,1,{'15','25'});
                        if ~isempty(answer)
                            num_nodes = str2double(answer{1});
                            num_edges = str2double(answer{2});
                            USNET = gen_rand_net(num_nodes,num_edges);
                            NET = sort_net(USNET);
                        else
                            return
                        end
                end
            else
                return
            end
            num_nodes = length(NET); num_edges = calc_num_edges(NET);
            disp(['  Net:  nodes = ' num2str(num_nodes) ' edges = ' num2str(num_edges)]);
            axes(AXN); plot_net(NET); title('Network');
            set(NETPROPS,'String',['Net has ' num2str(num_nodes) ' nodes and ' ...
                num2str(num_edges) ' edges']);
            set(REDUCENET,'BackgroundColor',[1.0 0.75 0.6],'Enable','on');
            set(COUNTLOOPS,'BackgroundColor',[1 1 0.75],'Enable','on');
            set(SAVENET,'BackgroundColor',[0.75 1 0.75],'Enable','on');
            set(CLEAR,'BackgroundColor',[0.6 0.75 1],'Enable','on');
            set(SAVELOOPS,'BackgroundColor',[0.9 0.9 0.9],'Enable','off');
            set(NUMLOOPS,'String',' ');
            axes(AXH); plot(NaN,NaN); set(AXH,'Visible','off');
        case 'REDUCENET'
            NET = reduce_net(NET);
            num_nodes = length(NET); num_edges = calc_num_edges(NET);
            disp(['   Reduced net:  nodes = ' num2str(num_nodes) ' edges = ' num2str(num_edges)]);
            axes(AXN); plot_net(NET); title('Reduced Network');
            set(NETPROPS,'String',['Net has ' num2str(num_nodes) ' nodes and ' ...
                num2str(num_edges) ' edges']);
        case 'COUNTLOOPS'
            prompt = {' Approximately how many loops do you expect? (Needed for waitbar progress) '};
            name = 'Loop Count (Estimate)';
            answer = inputdlg(prompt,name,1,{'1000'});
            if isempty(answer)
                return
            else
                num_est_loops = cell2mat(answer);
            end
            n = get_starting_node(NET); % give the path a nearly optimal starting node
            path = NET(n).node; % initialize the path
            current_edge = NET(n).edges(1); % initialize the first edge
            LOOPLIST = []; % initialize the loop list
            iterations = 0; % initialize the number of algorithm steps
            wbh = waitbar(0,['Searching Tree for Loops ... ' num2str(0) ' found']);
            while (length(path)>1 || ~isempty(current_edge))
                [NET,path,current_edge,LOOPLIST] = iterate_tree(NET,path,current_edge,LOOPLIST);
                iterations = iterations+1;
                waitbar(length(LOOPLIST)/str2double(num_est_loops),wbh, ...
                    ['Searching Tree for Loops ... ' num2str(length(LOOPLIST)) ' found']);
            end
            close(wbh);
            num_loops = length(LOOPLIST);
            disp(['    It took ' num2str(iterations) ' steps to complete the ILCA']);
            disp(['     There are ' num2str(num_loops) ' loops in the net']);
            axes(AXH);
            LOOPDIST = plot_loop_dist(NET,LOOPLIST);
            set(NUMLOOPS,'String',[num2str(num_loops) ' Loops Found ... in ' ...
                num2str(iterations) ' ILCA Iterations']);
            set(SAVELOOPS,'BackgroundColor',[0.75 1 0.75],'Enable','on');
        case 'SAVENET'
            prompt = {'Enter the name of the file (no file extension):'};
            name = 'Save Net to TXT File';
            answer = inputdlg(prompt,name,[1 50],{'net'});
            filename = cell2mat(answer);
            if ~isempty(filename)
                net2file(NET,[filename '.txt']);
            end
        case 'SAVELOOPS'
            prompt = {'Enter the name of the file (no file extension):'};
            name = 'Save Loops to TXT or MAT File';
            answer = inputdlg(prompt,name,[1 50],{'looplist'});
            filename = cell2mat(answer);
            if ~isempty(filename)
                Button = questdlg('Choose File Type:','File Type', ...
                'TXT File','MAT File','TXT File');
                if ~isempty(Button)
                    switch Button
                        case 'TXT File'
                            loops2file(LOOPLIST,[filename '.txt']);
                        case 'MAT File'
                            eval(sprintf([filename ' = LOOPLIST;']));
                            eval(sprintf('save %s %s',filename,filename));
                    end
                end
            end
        case 'CLEAR'
            NET = []; LOOPLIST = [];
            set(NUMLOOPS,'String',' ');
            set(NETPROPS,'String',' ');
            set(REDUCENET,'BackgroundColor',[0.9 0.9 0.9],'Enable','off');
            set(COUNTLOOPS,'BackgroundColor',[0.9 0.9 0.9],'Enable','off');
            set(SAVENET,'BackgroundColor',[0.9 0.9 0.9],'Enable','off');
            set(SAVELOOPS,'BackgroundColor',[0.9 0.9 0.9],'Enable','off');
            set(CLEAR,'BackgroundColor',[0.9 0.9 0.9],'Enable','off');
            axes(AXN);plot(NaN,NaN);set(AXN,'Visible','off');
            axes(AXH);plot(NaN,NaN);set(AXH,'Visible','off');
        case 'CLOSE'
            close;
        otherwise
            error('LOOPS_GUI: Invalid command!');
    end
end
return

%--------------------------------------------------------------------------
%------- SUBFUNCTIONS -----------------------------------------------------
%--------------------------------------------------------------------------
function net = gen_rand_net(num_nodes,num_edges)
% PURPOSE:  Generate an *undirected* random network of a given number of nodes/edges
% USAGE:    >> net = gen_rand_net(num_nodes,num_edges);
% INPUTS:   num_nodes  - number of nodes in the random network
%           num_edges  - number of edges in the random network
% OUTPUTS:  net  - network structure containing two fields: 'node' and 'edges'
%                     'node' is the ID of the current node
%                     'edges' is a vector that lists all the nodes connected to 'node'
% NOTES:    Does not guarantee a *connected* network (especially if 'num_edges' is small)
%           Allows nodes that are only 1-connected

num_nodes = abs(round(real(num_nodes)));
num_edges = abs(round(real(num_edges)));

if (num_nodes < 3)
    num_nodes = 3;
end
if (num_edges > num_nodes*(num_nodes-1)/2)
    num_edges = num_nodes*(num_nodes-1)/2;
elseif (num_edges < num_nodes)
    num_edges = num_nodes;
end
x = rand(1,num_nodes); y = rand(1,num_nodes);
tri = delaunay(x,y);
[nr,nc] = size(tri);
edge_list = zeros(3*nr,nc-1);
for e = 1:nr
    edge_list(3*e-2,:) = tri(e,[1 2]);
    edge_list(3*e-1,:) = tri(e,[1 3]);
    edge_list(3*e,:) = tri(e,[2 3]);
end
net = edge_list2net(edge_list);
n = length(net);
m = calc_num_edges(net);
iterations = 1;
while or(m ~= num_edges,n ~= num_nodes)
    if n == num_nodes
        if m < num_edges % add an edge
            edge_list = [edge_list; ceil(num_nodes*rand(1,2))];
        else % subtract an edge
            e = length(edge_list); r = ceil(e*rand);
            edge_list = edge_list([(1:r-1) (r+1:e)],:);
        end
    else
        if n < num_nodes % add a node
            for k = 1:n+1
                if isempty(find(edge_list == k,1))
                    edge_list = [edge_list; k ceil(n*rand)];
                    break
                end
            end
        else % subtract a node
            v = edge_list(ceil(length(edge_list)*rand),ceil(2*rand));
            edge_list = edge_list(edge_list(:,1)~=v,:);
            edge_list = edge_list(edge_list(:,2)~=v,:);
        end
    end
    net = edge_list2net(edge_list);
    n = length(net);
    m = calc_num_edges(net);
    iterations = iterations + 1;
end
disp([' The random net was generated after ' num2str(iterations) ' modifications']);

%--------------------------------------------------------------------------
function edge_list = read_edge_list()
% PURPOSE:  Read an edge list from file
% USAGE:    >> edge_list = read_edge_list();
% INPUTS:   filename  - (optional) string specifying name of the input file
% OUTPUTS:  edge_list  - Nx2 matrix of nodes where each row represents an edge connection

edge_list = [];
[fname,path] = uigetfile('*.txt','Load Edge List File ...');
if fname
    filename = [path fname];
else
    return
end
fid = fopen(filename,'rt');
edge_list = fscanf(fid,'%10i',[2,inf]);
fclose(fid);
edge_list = edge_list';

%--------------------------------------------------------------------------
function net = edge_list2net(edge_list)
% PURPOSE:  Transform an edge list into a network structure
% USAGE:    >> net = edge_list2net(edge_list);
% INPUTS:   edge_list  - Nx2 matrix of nodes where each row represents an edge connection
% OUTPUTS:  net  - network structure containing two fields: 'node' and 'edges'
%                  'node' is the ID of the current node
%                  'edges' is a vector that lists all the nodes connected to 'node'

net = [];
if isempty(edge_list)
    return
end
edge_list = abs(round(real(edge_list)));
ne = size(edge_list);
net(1).node = edge_list(1,1); net(1).edges = edge_list(1,2);
net(2).node = edge_list(1,2); net(2).edges = edge_list(1,1);
for idx = 2:ne(1)
    node_exists = 0;
    % if the node is already part of the net, update the list of edges
    for k = 1:length(net)
        if (edge_list(idx,1) == net(k).node)
            % do not update the edge list if the edge already exists
            if isempty(find([net(k).edges net(k).node] == edge_list(idx,2),1))
                net(k).edges = [net(k).edges edge_list(idx,2)];
            end
            node_exists = 1;
            break
        end
    end
    % if the node is new, add it to the end of the net along with the edge
    if ~node_exists
        net(k+1).node = edge_list(idx,1);
        net(k+1).edges = edge_list(idx,2);
    end
    node_exists = 0;
    % if the node is already part of the net, update the list of edges
    for k = 1:length(net)
        if (edge_list(idx,2) == net(k).node)
            % do not update the edge list if the edge already exists
            if isempty(find([net(k).edges net(k).node] == edge_list(idx,1),1))
                net(k).edges = [net(k).edges edge_list(idx,1)];
            end
            node_exists = 1;
            break
        end
    end
    % if the node is new, add it to the end of the net along with the edge
    if ~node_exists
        net(k+1).node = edge_list(idx,2);
        net(k+1).edges = edge_list(idx,1);
    end
end

%--------------------------------------------------------------------------
function net = sort_net(net)
% PURPOSE:  Puts all of the nodes in order from least to greatest
% USAGE:    >> net = sort_net(net);
% INPUTS:   net  - network structure containing two fields: 'node' and 'edges'
%                  'node' is the ID of the current node
%                  'edges' is a vector that lists all the nodes connected to 'node'
% OUTPUTS:  net  - sorted network structure containing two fields: 'node' and 'edges'
%                  'node' is the ID of the current node
%                  'edges' is a vector that lists all the nodes connected to 'node'

tmp = [];
nodes_list = zeros(1, length(net));
for k = 1:length(net)
    nodes_list(k) = net(k).node;
end
[sorted, order] = sort(nodes_list);
for k = 1:length(net)
    tmp(k).node = net(order(k)).node;
    tmp(k).edges = sort(net(order(k)).edges);
end
net = tmp;

%--------------------------------------------------------------------------
function num_edges = calc_num_edges(net)
% PURPOSE:  Calculates the number of edges in an undirected network
% USAGE:    >> num_edges = calc_num_edges(net);
% INPUTS:   net  - network structure containing two fields: 'node' and 'edges'
%                  'node' is the ID of the current node
%                  'edges' is a vector that lists all the nodes connected to 'node'
% OUTPUTS:  num_edges  - number of edges in the network

num_edges = 0;
for k = 1:length(net)
    num_edges = num_edges + length(net(k).edges);
end
num_edges = num_edges/2;

%--------------------------------------------------------------------------
function plot_net(net)
% PURPOSE:  Make a plot of the network structure
% USAGE:    >> plot_net(net);
% INPUTS:   net	- network structure containing two fields: 'node' and 'edges'
%                 'node' is the ID of the current node
%                 'edges' is a vector that lists all the nodes connected to 'node'

n = length(net);
nodeids = zeros(1,n);
for ii = 1:n
    nodeids(ii) = net(ii).node;
end
% place the nodes with equal spacing around a circle
wn = exp(j*2*pi/n); z = wn.^(0:n-1);
x = real(z); y = imag(z);
hold off
for ii = 1:n
    k = find(nodeids == net(ii).node);
    % plot a line for each edge connection
    for jj = 1:length(net(ii).edges)
        kk = find(nodeids == net(ii).edges(jj));
        plot([x(k) x(kk)],[y(k) y(kk)],'k-')
        hold on
    end
    % add the node ID for the current node to the graph
    if (x(k) >= 0 && y(k) >= 0)
        text(x(k),y(k),num2str(nodeids(k)),'VerticalAlignment','bottom','HorizontalAlignment','left');
    elseif (x(k) < 0 && y(k) >= 0)
        text(x(k),y(k),num2str(nodeids(k)),'VerticalAlignment','bottom','HorizontalAlignment','right');
    elseif (x(k) < 0 && y(k) < 0)
        text(x(k),y(k),num2str(nodeids(k)),'VerticalAlignment','top','HorizontalAlignment','right');
    else
        text(x(k),y(k),num2str(nodeids(ii)),'VerticalAlignment','top','HorizontalAlignment','left');
    end
end
plot(x,y,'r.')
hold off
set(gca,'XTick',NaN,'YTick',NaN)
axis([-1.2 1.2 -1.2 1.2])

%--------------------------------------------------------------------------
function net = reduce_net(net)
% PURPOSE:  Remove all 'singly connected' nodes and corresponding edges
% USAGE:    >> rnet = reduce_net(net);
% INPUTS:   net  - network structure containing two fields: 'node' and 'edges'
%                  'node' is the ID of the current node
%                  'edges' is a vector that lists all the nodes connected to 'node'
% OUTPUTS:  net  - reduced network structure containing two fields: 'node' and 'edges'
%                  'node' is the ID of the current node
%                  'edges' is a vector that lists all the nodes connected to 'node'

finished = 0;
while (~finished)
    finished = 1;
    for k = 1:length(net)
        % delete the node and edge connection
        if (length(net(k).edges) == 1)
            finished = 0;
            node = net(k).node;
            edge = net(k).edges;
            net(k) = [];
            % also delete the 'opposite direction edge'
            for kk = 1:length(net)
                if (net(kk).node == edge)
                    if (length(net(kk).edges) == 1)
                        net(kk) = [];
                    else
                        idx = find(net(kk).edges == node);
                        if ~isempty(idx)
                            net(kk).edges(idx) = [];
                        end
                    end
                    break
                end
            end
            break
        end
    end
end

%--------------------------------------------------------------------------
function n = get_starting_node(net)
% PURPOSE:  Pick the (nearly) optimal starting node
% USAGE:    >> n = get_starting_node(net);
% INPUTS:   net  - network structure containing two fields: 'node' and 'edges'
%                  'node' is the ID of the current node
%                  'edges' is a vector that lists all the nodes connected to 'node'
% OUTPUTS:  n  - index to the optimal network starting node

n = 1;
for k = 2:length(net)
    if (length(net(k).edges) > length(net(n).edges))
        n = k;
    end
end

%--------------------------------------------------------------------------
function [net,path,current_edge,loop_list] = iterate_tree(net,path,current_edge,loop_list)
% PURPOSE:  Execute the current iterative step in the loop counting algorithm
% USAGE:    >> [net,path,current_edge,loop_list] = iterate_tree(net,path,current_edge,loop_list);
% INPUTS:   net  - network structure containing two fields: 'node' and 'edges'
%                  'node' is the ID of the current node
%                  'edges' is a vector that lists all the nodes connected to 'node'
%           path  - an ordered vector of node values that are connected
%           current_edge  - the node ID of the current edge
%           loop_list  - a structure with one field named 'loop' containing a list of all loops found
% OUTPUTS:  net  - same as net input
%           path  - same as path input,potentially modified
%           current_edge  - the node ID of the next edge to be considered
%           loop_list  - same as loop_list input,potentially ammended

path_size = length(path);
% DONE - finished searching tree
if (path_size == 1 && isempty(current_edge))
    return
% CURRENT EDGE LIST FINISHED - go up tree
elseif (isempty(current_edge))
    current_edge = get_next_edge(net,path(path_size-1),path(path_size));
    path(path_size) = [];
% CURRENT EDGE IS THE SAME AS PREVIOUS VERTEX - move to next edge
elseif (length(path) > 1 && path(path_size-1) == current_edge)
    current_edge = get_next_edge(net,path(path_size),current_edge);
% LOOP FOUND!
elseif (check_path4loop(path,current_edge))
    loop = loop2std_form(path,current_edge);
    if ~compare_loop(loop,loop_list)
        loop_list = append_loop_list(loop_list,loop);
    end
    current_edge = get_next_edge(net,path(path_size),current_edge);
% NO LOOP FOUND - keep going down tree
else
    path = [path current_edge];
    current_edge = get_next_edge(net,path(path_size+1),[]);
end

%--------------------------------------------------------------------------
function loop_list = append_loop_list(loop_list,loop)
% PURPOSE:  Adds a loop to the end of a loop_list structure
% USAGE:    >> loop_list = append_loop_list(loop_list,loop);
% INPUTS:   loop_list  - a structure with one field named 'loop' containing
%                        a list of all previously found loops
%           loop  - 1xM vector containing a list of nodes that make a loop
% OUTPUTS:  loop_list  - the modified loop_list structure

if isempty(loop_list)
    loop_list.loop = loop;
else
    num_loops = length(loop_list);
    loop_list(num_loops+1).loop = loop;
end

%--------------------------------------------------------------------------
function status = check_path4loop(path,current_edge)
% PURPOSE:  Check to see if the current edge is in the path
% USAGE:    >> status = check_path4loop(path,current_edge);
% INPUTS:   path  - an ordered vector of node values that are connected
%           current_edge  - a node connected to the last node in path
% OUTPUTS:  status  - 1 if a loop has been found,0 otherwise

status = 0;
if find(path == current_edge,1)
    status = 1;
end

%--------------------------------------------------------------------------
function status = compare_loop(loop,loop_list)
% PURPOSE:  Check to see if the loop already exists in the loop_list
% USAGE:    >> status = compare_loop(loop,loop_list);
% INPUTS:   loop  - 1xM vector containing nodes that are connected in a loop
%           loop_list  - a structure with one field named 'loop' containing a list
%                        of all previously found loops
% OUTPUTS:  status  - equals 1 if 'loop' already exists,0 otherwise

status = 0;
if isempty(loop_list)
    return
end
for k = 1:length(loop_list)
    m = length(loop_list(k).loop);
    n = length(loop);
    % if the two loops have the same length,check if they are identical
    if (m == n)
        status = 1;
        for kk = 1:n
            if (loop_list(k).loop(kk) ~= loop(kk))
                status = 0;  % loops are different,move on to next
                break
            end
        end
        % loops are identical
        if status
            return
        end
    end
end

%--------------------------------------------------------------------------
function next_edge = get_next_edge(net,current_node,current_edge)
% PURPOSE:  Find the next edge of the current node in the network structure
% USAGE:    >> next_edge = get_next_edge(net,current_node,current_edge);
% INPUTS:   net  - network structure containing two fields: 'node' and 'edges'
%                  'node' is the ID of the current node
%                  'edges' is a vector that lists all the nodes connected to 'node'
%           current_node  - the ID of the current node in the path
%           current_edge  - the node ID of the current edge
% OUTPUTS:  next_edge  - the node ID of the next edge in the edges list for the current node

next_edge = [];
for k = 1:length(net)
    if (current_node == net(k).node)
        if isempty(current_edge)    % start with the first edge of the node
            next_edge = net(k).edges(1);
        else    % get the next edge in the list,if there is one
            kk = find(net(k).edges == current_edge);
            if kk < length(net(k).edges)
                next_edge = net(k).edges(kk+1);
            end
        end
        return
    end
end

%--------------------------------------------------------------------------
function loop = loop2std_form(path,current_edge)
% PURPOSE:  Take a loop found in the path and return the loop vector in *standard form*
% USAGE:    >> loop = loop2std_form(path,current_edge);
% INPUTS:   path  - an ordered vector of node values that are connected
%           current_edge  - the node ID of the current edge
% OUTPUTS:  loop  - 1xM vector of standard form loop,where M is the length of the loop
% NOTES:    Standard form is defined as having the smallest node ID at the front
%           of the list,and the smaller of the two neighbors listed second

ii = find(path == current_edge);
% get the loop from the path
loopy = path(ii:end);
n = length(loopy);
jj = find(loopy == min(loopy));
% order the loop with the smallest value first
loop = loopy([(jj:n) (1:jj-1)]);
% order the rest of the loop with the smaller of the two neighbors second
if loop(2) > loop(n)
    loop = [loop(1) fliplr(loop(2:n))];
end

%--------------------------------------------------------------------------
function nh = plot_loop_dist(net,loop_list)
% PURPOSE:  Plot the distribution of loops with length 'h'
% USAGE:    >> plot_loop_dist(net,loop_list);
% INPUTS:   net  - network structure containing two fields: 'node' and 'edges'
%                  'node' is the ID of the current node
%                  'edges' is a vector that lists all the nodes connected to 'node'
%           loop_list  - a structure with one field named 'loop' containing
%                        a list of all loops found

num_nodes = length(net);
num_loops = length(loop_list);
nh = zeros(1,num_nodes-2);
for k = 1:num_loops
    h = length(loop_list(k).loop);
    nh(1,h-2) = nh(1,h-2)+1;
end
% plot the number of loops of each length (h)
hold off
plot((3:num_nodes),nh(1,:),'b.-');
title(' Number of loops of length "h"');
xlabel(' h ');
ylabel(' N_h ');
set(gca,'XTick',(3:max(1,floor(num_nodes/10)):num_nodes))
set(gca,'YTick',(0:max(1,floor(max(nh)/10)):max(nh)))
axis([2 num_nodes+1 0 max(nh)*1.1]);
hold off

%--------------------------------------------------------------------------
function net2file(net,fname)
% PURPOSE:  Write the net to a file
% USAGE:    >> net2file(net,fname);
%               or
%           >> net2file(net);
% INPUTS:   net  - network structure containing two fields: 'node' and 'edges'
%                  'node' is the ID of the current node
%                  'edges' is a vector that lists all the nodes connected to 'node'
%           fname  - (optional) name of the file to write loops to
%                     must be a string with (recommended) .txt file extension

fid = fopen(fname,'w');
% print one edge per line with a tab separating each node
for k = 1:length(net)
    num_edges = length(net(k).edges);
    for kk = 1:num_edges
        if net(k).node < net(k).edges(kk)
            fprintf(fid,[num2str(net(k).node) '\t' num2str(net(k).edges(kk)) '\n']);
        end
    end
end
fclose(fid);

%--------------------------------------------------------------------------
function loops2file(loop_list,filename)
% PURPOSE:  Write the loop_list to a file
% USAGE:    >> loops2file(loop_list,filename);
%               or
%           >> loops2file(loop_list);
% INPUTS:   loop_list  - a structure with one field named 'loop' containing
%                        a list of all previously found loops
%           filename  - (optional) name of the file to write loops to
%                     must be a string with (recommended) .txt file extension

fid = fopen(filename,'w');
wb = waitbar(0,' Writing Loops to File ... ');
num_loops = length(loop_list);
% print one loop per line with a space separating each node
for k = 1:num_loops
    waitbar(k/num_loops,wb);
    loop_size = length(loop_list(k).loop);
    string = num2str(loop_list(k).loop(1));
    for kk = 2:loop_size
        string = [string ' ' num2str(loop_list(k).loop(kk))];
    end
    fprintf(fid,[string '\n']);
end
fclose(fid);
close(wb);
