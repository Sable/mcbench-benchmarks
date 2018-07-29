function plotGraphBasic(G,markerSize,addText)
%function plotGraph(G) plots graph G.
% Inputs:
%   G is a structure inplemented as data structure in this as well as other
%   graph theory algorithms.
%   G.Adj   - is the adjacency matrix (1 for connected nodes, 0 otherwise).
%   G.x and G.y -   are row vectors of size nv wiht the (x,y) coordinates of
%                   each node of G.
%   G.nv    - number of vertices in G
%   G.ne    - number of edges in G
%
%   markerSize  -  controls the size of each node in the graph
%   addText - toggles text display (1 - on, 0 off).
%   Note: The color of each node is computed based on the
%         its degree. 
%
%Created by Pablo Blinder. blinderp@bgu.ac.il
%
%Last updated 25/01/2005


%generate plot. Decompose to single lines for more detailed formatting
figure;
[XX,YY]=gplot(G.Adj,[G.x' G.y'],'k-');
i=~isnan(XX);
XX=XX(i);YY=YY(i);
XX=reshape(XX,2,length(XX)/2);
YY=reshape(YY,2,length(YY)/2);
hLines=line(XX,YY);
set(hLines,'color','k');

hold on;
kv=full(diag(G.Adj*G.Adj));
kvGroups=unique(setdiff(kv,0));
nGroups=length(kvGroups);
map=jet(max(kvGroups)); 
kv(kv<1)=1;%scale lowest to first 
Pv=num2cell(map(kv,:),2);
if kvGroups==1; kvGroups=2; end %Safeguard aginst single values
set(gca,'Clim',[1 max(kvGroups)]);


Pn(1)={'MarkerFaceColor'};

% Now draw the plot, one line per point.
h = [];
for i=1:G.nv
    h = [h;plot(G.x(i),G.y(i),'ko')];
end


ht=[];
ti=1;
if addText
    for i=1:G.nv
        if ti
            ht = [ht;text(G.x(i)+0.1*G.x(i),G.y(i)+0.1*G.y(i),num2str(i))];
            ti=0;
        else
            ti=1;
        end
    end
end

set(h,'LineWidth',1,...
    'MarkerEdgeColor','k',...
    'MarkerSize',markerSize,Pn,Pv);
set(gca,'Visible','Off','YDir','reverse');
colormap(map);
hc=colorbar;

set(hc,'FontSize',8,'FontW','Demi')
set(hc,'Visible','off')
set(gcf,'Color','w')

