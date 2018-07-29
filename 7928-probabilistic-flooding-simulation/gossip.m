% This script generates a random deployed wireless network, and
% probabilistic broadcast is simulated.
% In probabilistic broadcast, each node re-transmits the packet according
% to a probability. 
% A link on probabilistic broadcast:
% http://lsewww.epfl.ch/Documents/acrobat/SCS03.pdf
% A link on DFS algorithm:
% http://en.wikipedia.org/wiki/Depth-first_search

clear;
rand('state', 5);
numOfNodes = 200;   %   number of nodes
envSize=100;        %   envsizeXenvsize environment
txRange = 15;
global floodProb;   %   the pre-defined probability to broadcast;
global savedTransmission;   % The number of saved re-transmissions;

savedTransmission = 0;
global xLocation;   % Array containing the X-coordinations of wireless nodes;
global yLocation;   % Array containing the Y-coordinations of wireless nodes;
xLocation = rand(numOfNodes,1) * envSize;
yLocation = rand(numOfNodes,1) * envSize;   %x,y coords of nodes

% Generate the adjacent matrix to represent the topology graph of the
% randomly deployed wireless networks;
distMatrix = zeros(numOfNodes,numOfNodes);
for i=1:numOfNodes
   for j=1:numOfNodes
      distMatrix(i,j)=sqrt((xLocation(i)-xLocation(j))^2 + (yLocation(i)-yLocation(j))^2); %distance between node pairs
   end
end
% If the Euclidean distance between two nodes is less than the transmission range, there
% exists a link.
global connMatrix;
connMatrix = ( distMatrix < txRange);  %binary connectivity matrix

% The broadcast will start from a sink node;
sinkNode = 1; % sink node;

% Array visited[] stores the boolean value if the broadcast has reach the node.
global visited;
visited = zeros(1, numOfNodes);

% Show the topology;
figure(1);
plot(xLocation, yLocation, '.');
text(xLocation(sinkNode), yLocation(sinkNode), 'sink');
% title(['p = ' num2str(floodProb)]);
% sink node;

visited(sinkNode) = 1;

% recursive Depth first search is adopted to traverse the whole graph;
DFS(sinkNode);
savedTransmission
return;