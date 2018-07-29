function details()
%
% I. INTRODUCTION
%     The MATLAB(R) program contained within this directory counts the total
% number of loops (cycles) in a network (graph) that consists of nodes and edges.
%     This file describes the loop counting algorithm and requirements for
% user-defined networks. Refer to the 'README.m' file for setup and installation
% proceedures.
%
%
% II. USER-DEFINED NETWORK SETUP/REQUIREMENTS
%     When running 'loop_gui.m', the user is allowed to choose either a randomly
% generated network or a user specified file.
%     If the user selects 'Random Network', they will be prompted for the number
% of nodes and the number of edges. The random network that gets generated is not
% necessarily connected completely. There may be one or more sub-graphs. The
% network is also undirected (both directions along edges specified).
%     If the user selects 'Edge List File', they will be prompted to search their
% files for an appropriate network (some standard edge list files are in the
% 'nets/' directory. The format of the file should be as follows...
%
% EACH ROW OF THE FILE MUST HAVE TWO INTEGERS WHERE EACH INTEGER REPRESENTS A
% NODE-ID AND THE ROW REPRESENTS AN EDGE CONNECTION BETWEEN THOSE TWO NODES.
% The node IDs can be any value so long as it is an integer. Also, the rows do
% not need to be in any specific order, and any repeated edges are ignored.
%
% EXAMPLE: a valid complete graph of 4 nodes could look like any of these
% 1 2             3 1             7 81
% 1 3             4 2             32 104
% 1 4             1 2             81 104
% 2 3    (or)     4 3    (or)     32 7
% 2 4             2 3             104 7
% 3 4             1 4             81 32
%
%
% III. ALGORITHM DESCRIPTION
%     The Iterative Loop Counting Algorithm (ILCA) searches for loops by moving
% along a dynamic path. The use of this dynamic path essentially turns the network
% into a tree, and the path at any given time is a line from the top of the tree
% to any of the nodes on the branches. Loops occur whenever a node ID exists in 2
% separate places on the path.
%
% However, before the ILCA can be implemented, the network is first transformed
% into a structure with 2 fields ('node' is the node ID and 'edges' is a list of
% all the nodes connected to this particular node)
%
% EXAMPLE: a simple undirected graph of 4 nodes and 5 edges can be represented
% by something like the following edge list
% 1 2
% 1 3
% 2 3
% 2 4
% 3 4
% ... and the corresponding structure would be:
% net(1).node = 1;
% net(1).edges = [2 3];
% net(2).node = 2;
% net(2).edges = [1 3 4];
% net(3).node = 3;
% net(3).edges = [1 2 4];
% net(4).node = 4;
% net(4).edges = [2 3];
%
% The tree is then generated using the following rules:
%     1. Initialize the tree with the first node.
%     2. For the current node, look at the next edge in the 'edges' list.
%     3. If the edge is the same as the node 2 stems up the tree, move on the the
%         next edge in the list (Ignored because the search must not be allowed to
%         go back along the same edge it was just on)
%     4. If the edge is the same as another node in the path, a loop has been found.
%         Compare and save it, and move on to the next edge in the list.
%     5. If a loop is not found, continue down the tree and update the path. (This
%         current edge gets added to the path, and becomes the current node)
%     6. If the 'edges' list for the current node has been exhausted, go up to the
%         previous node and update the path.
%     7. Continue steps 2-6 until step 8 is true.
%     8. If the current node is the first node, and all of its edges have been
%         completely exhausted, the algorithm is finished.
%
% The tree for the example net (although it never really exists except virtually)
% would look like:
%
%                                             1
%                                         /       \
%                                     /               \
%                                 /                       \
%                             /                               \
%                         /                                       \
%                     2                                               3
%                 /       \                                       /       \
%             /               \                               /               \
%         3                       4                       2                       4
%     /       \                   |                   /       \                   |
% 1**             4               3               1**             4               2
%                 |           /       \                           |           /       \
%                 2**     1**             2**                     3**     1**             3**
%
% ** Indicates that a loop was found. (Since the dynamic path starts at the top of
% the tree and goes down into the different branches, a loop is found whenever a
% node has been repeated in the branch.)
%
% The ILCA starts down the left side of the tree and keeps descending until it
% finds a loop. If a loop is found, it is put in *Standard Form* so it can be
% compared with previous loops that have been found. In this way, no loops are
% repeated. (This comparison part of the algorithm is the limiting function as the
% number of loops gets large. Each new loop must be compared with all the loops
% that have been found.)
%
% Standard Form - a loop is in standard form if the smallest node ID is declared
% first, and the smaller ID of that node's neighbors is declared second.
%
% For this example, the loops are found in the following order:
% 1 2 3 (1)    ->  1 2 3
% 2 3 4 (2)    ->  2 3 4
% 1 2 4 3 (1)  ->  1 2 4 3
% 2 4 3 (2)    ->  2 3 4       **Not added. Already found!
% 1 3 2 (1)    ->  1 2 3       **Not added. Already found!
% 3 2 4 (3)    ->  2 3 4       **Not added. Already found!
% 1 3 4 2 (1)  ->  1 2 4 3     **Not added. Already found!
% 3 4 2 (3)    ->  2 3 4       **Not added. Already found!
%
% The ILCA would report 3 loops found for this example:
% 1 2 3
% 2 3 4
% 1 2 4 3
% (This example is contained in 'nets/example04.txt' for reference).
%
%
% Please direct questions/comments to:
% Joe Kirk
% jdkirk630@gmail.com
%
clc
help details