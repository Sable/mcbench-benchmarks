%% Load data and compute layout
load('~/matlab/fpack/matlabBGL/graphs/cores_example.mat')


%% Just plot the graph, similar to gplot
figure;
tic;
[he,hv]=wgPlot(A,xy);
toc


%% Make your vertices weighted, this change the size of the vertices. 
figure;
tic;
[he,hv]=wgPlot(A,xy,'vertexWeight',rand(length(A),1));
toc


%% Vertex weight can be store as the diagonal of A. You can scale the size 
% so they are larger, and make the edge thicker.
A(speye(size(A)))=rand(length(A),1);
figure;
tic;
[he,hv]=wgPlot(A,xy,'vertexWeight',rand(length(A),1),'vertexScale',200,'edgeWidth',2);
toc


%% You can color the vertices by adding vertex metadata to specify their
% color and even use the color map of your choice.
figure;
tic;
[he,hv]=wgPlot(A,xy,'vertexWeight',rand(length(A),1),'vertexMetadata',rand(length(A),1),'vertexColorMap',copper);
toc


%% You can even color the edges by providing a weighted adjacency matrix.
A(find(A))=(rand(size(find(A)))+0.01)*10;  % make non-zero element of A random between 0.01 to 10.
figure;
tic;
[he,hv]=wgPlot(A,xy,'vertexWeight',rand(length(A),1),'vertexMetadata',rand(length(A),1),'vertexScale',200,'edgeWidth',2);
toc


%% It is pretty fast for large graphs too. You can also specify the
% colormap for the edges.
load('~/matlab/fpack/matlabBGL/graphs/cs-stanford.mat')
xy=fruchterman_reingold_force_directed_layout(max(A,A'),'force_pairs','grid','initial_temp',1000,'iteration',1); 
% Patient! This WILL take a minute

A(find(A))=(rand(size(find(A)))+0.01)*100;  % make non-zero element of A random.
figure;
tic;
[he,hv]=wgPlot(A,xy,'vertexWeight',rand(length(A),1),'vertexMetadata',rand(length(A),1),'edgeColorMap',pink);
toc



