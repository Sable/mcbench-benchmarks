function [MinCutGroupsList, MinCutWeight] = MinCut(SourceVertices, WeightedGraph)
%%% performs Min Cut algorithm described in "A Simple Min Cut Algorithm" by
%%% M. Stoer and F. Wagner.

%%% input - 
%%%     SourceVertices - a list of vertices that are forced to be kept in one side of the cut.
%%%     WeightedGraph - symetric matrix of edge weights. Wi,j is the edge connecting vertices i,j
%%%                     use Wi,j=0 or Wi,j == inf to indicate unconnected vertices.
%%% output -
%%%   MinCutGroupsList - two lists of verices, SECOND one contains the sourve vertives
%%%   MinCutWeight - sum of weight of edges alosng the cut

%%% (C) Yohai Devir 2006
%%% <my first name> AT WHOEVER D0T COM

    GraphDim = size(WeightedGraph,1);
    SourceVertices = SourceVertices(SourceVertices ~= 0); %remove zero vertices

    %%% remove self edges and ZEROed ones
    WeightedGraph = WeightedGraph+diag(inf(1,GraphDim));
    % for ii = 1:GraphDim
    %     WeightedGraph(ii,ii) = inf;
    % end
    WeightedGraph(WeightedGraph == 0) = inf;

    %%%Merge all Source Vrtices to one, so they'll be unbreakable, descending order is VITAL!!!
    SourceVertices = sort(SourceVertices);
    GroupsList = zeros(GraphDim);   %each row are the vertices melted into one vertex in the table.
    GroupsList(:,1) = 1:GraphDim;
    for ii=length(SourceVertices):-1:2;
        [WeightedGraph,GroupsList] = MeltTwoVertices(SourceVertices(1),SourceVertices(ii),WeightedGraph,GroupsList);
    end
    Split = GroupsList(:,1);

    %%% By now I have a weighted graph in which all seed vertices are
    %%% merged into one vertex. Run Mincut algrithm on this graph
    [MinCutGroupsList_L, MinCutWeight] = MinCutNoSeed(WeightedGraph);

    %%% Convert Data so the seed vertices will be reconsidered as different
    %%% vertices and not one vertex.
    for ii = 1:2
        MinCutGroupsList(ii,:) = Local2GlobalIndices(MinCutGroupsList_L(ii,:), Split);
    end

    if (length(find(MinCutGroupsList(1,:) == SourceVertices(1))) == 1)
        SeedLocation = 1;
    else
        SeedLocation = 2;
    end
    MinCutGroupsList_withSeed = [MinCutGroupsList(SeedLocation,(MinCutGroupsList(SeedLocation,:)~=0)) SourceVertices(2:length(SourceVertices))];
    MinCutGroupsList_withSeed = sort(MinCutGroupsList_withSeed);
    MinCutGroupsList_withSeed = [MinCutGroupsList_withSeed zeros(1,GraphDim - length(MinCutGroupsList_withSeed))];

    MinCutGroupsList_NoSeed = MinCutGroupsList(3 - SeedLocation,(MinCutGroupsList(3 - SeedLocation,:)~=0));
    MinCutGroupsList_NoSeed = sort(MinCutGroupsList_NoSeed);
    MinCutGroupsList_NoSeed = [MinCutGroupsList_NoSeed zeros(1,GraphDim - length(MinCutGroupsList_NoSeed))];

    MinCutGroupsList = [MinCutGroupsList_NoSeed ; MinCutGroupsList_withSeed];

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Perform ordinary Stoer & Wagner algorithm Min Cut algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [MinCutGroupsList, MinCutWeight] = MinCutNoSeed(WeightedGraph)
    GraphDim = size(WeightedGraph,1);
    GroupsList = zeros(GraphDim);
    GroupsList(:,1) = 1:GraphDim;

    MinCutWeight = inf;
    MinCutGroup = [];
    for ii = 1:GraphDim-1
        [OneBefore, LastVertex] = MinimumCutPhase(WeightedGraph);
        if OneBefore == -1 %Graph is not connected. LastVertex is a group of vertices not connected to Vertex 1
            MinCutGroup_L = LastVertex(LastVertex~=0); clear LastVertex; %it's not the last vertex

            MinCutGroupsList = [];
            for jj = 1:length(MinCutGroup_L);
                MinCutGroup_temp = GroupsList(MinCutGroup_L(jj));
                MinCutGroup_temp = MinCutGroup_temp(MinCutGroup_temp~=0);
                MinCutGroupsList = [MinCutGroupsList MinCutGroup_temp];
            end
            MinCutGroupsList = [MinCutGroupsList zeros(1,GraphDim - length(MinCutGroupsList))];

            jj = 1;
            for kk=1:GraphDim
                if (find(MinCutGroupsList(1,:) == kk)) 
                    MinCutGroupsList(2 ,jj) = kk;
                    jj = jj + 1;
                end
            end
            MinCutWeight = 0;
            return
        end %of: If graph is not connected
        Edges = WeightedGraph(LastVertex,:);
        Edges = Edges(isfinite(Edges));
        MinCutPhaseWeight = sum(Edges);
        if MinCutPhaseWeight < MinCutWeight
            MinCutWeight = MinCutPhaseWeight;
            MinCutGroup = GroupsList(LastVertex,:);
            MinCutGroup = MinCutGroup(MinCutGroup~=0);
        end
        [WeightedGraph,GroupsList] = MeltTwoVertices(LastVertex,OneBefore,WeightedGraph,GroupsList);
    end

    MinCutGroup = sort(MinCutGroup);
    MinCutGroupsList = [MinCutGroup zeros(1,GraphDim - length(MinCutGroup))];

    jj = 1;
    for kk=1:GraphDim
        if isempty(find(MinCutGroup(1,:) == kk,1)) 
            MinCutGroupsList(2 ,jj) = kk;
            jj = jj + 1;
        end
    end
return

%%% This function takes V1 and V2 as vertexes in the given graph and MERGES
%%% THEM INTO V1 !!
%%% The output is the UpdatedGraph inwhich both vertices are considered
%%% one, and updated GroupsList to reflect the change.
function        [UpdatedGraph,GroupsList] = MeltTwoVertices(V1,V2,WeightedGraph,GroupsList)
    t = min(V1,V2);
    V2 = max(V1,V2);
    V1 = t;

    GraphDim = size(WeightedGraph,1);
    UpdatedGraph = WeightedGraph;

    Mask1 = isinf(WeightedGraph(V1,:) );
    Mask2 = isinf(WeightedGraph(V2,:) );
    UpdatedGraph(V1,Mask1) = 0;
    UpdatedGraph(V2,Mask2) = 0;
    infMask = zeros(1,size(Mask1,2));
%     infMask(find(Mask1 & Mask2)) = inf;
    infMask((Mask1 & Mask2)) = inf;
    UpdatedGraph(V1,:)  =  UpdatedGraph(V1,:)  + UpdatedGraph(V2,:) + infMask;
    UpdatedGraph(:,V1) = UpdatedGraph(V1,:)';
    selectVec = true(1,GraphDim); selectVec(V2) = false;
%     UpdatedGraph = [UpdatedGraph(1:V2-1,:) ; UpdatedGraph(V2+1:GraphDim,:)]; %remove second vertex from graph
%     UpdatedGraph = [UpdatedGraph(:,1:V2-1)  UpdatedGraph(:,V2+1:GraphDim)];
    UpdatedGraph = UpdatedGraph(selectVec,selectVec);
    UpdatedGraph(V1,V1) = inf;                                                % group-group distance

    V1list = GroupsList(V1,( GroupsList(V1,:)~=0 ) );
    V2list = GroupsList(V2,( GroupsList(V2,:)~=0 ) );
    GroupsList(V1,:) = [V1list V2list zeros(1,size( GroupsList,2)- length(V1list) - length(V2list)) ]; %shorten grouplist
%     GroupsList = [GroupsList(1:V2-1,:) ;GroupsList(V2+1:GraphDim,:) ];
    GroupsList = GroupsList(selectVec,:);
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% perform one phase of the algorithm
%%%
%%% return [-1, B  ] in case of Unconnected Graph when B is a subgraph(s)
%%% that are not connected to Vertex 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [OneBefore, LastVertex] = MinimumCutPhase(WeightedGraph)
    GraphDim = size(WeightedGraph,1);
    GroupsList = zeros(GraphDim);
    GroupsList(:,1) = 1:GraphDim;

    if size(WeightedGraph,1) > 2
        FarestVertexGroup = 0;
        for ii = 1:GraphDim-1
            OneBefore         = FarestVertexGroup(1);
            PossibleVertices = WeightedGraph(1,1:size(WeightedGraph,2));
            PossibleVertices(isinf(PossibleVertices)) = 0;
            FarestVertex = find(PossibleVertices == max(PossibleVertices),1,'first');
            if FarestVertex == 1 %In case the Graph is not connected
                OneBefore = -1;
                LastVertex = GroupsList(1,:);
                return
            end
            FarestVertexGroup = GroupsList(FarestVertex,:);
            [WeightedGraph,GroupsList] = MeltTwoVertices(1,FarestVertex,WeightedGraph,GroupsList);
        end
        LastVertex = FarestVertexGroup(1);
    else
        OneBefore  = 1;
        LastVertex = 2;
    end
return

%%% Having a local list of indices in a global list and sublist of the
%%% local list, find the corresponding global indices.
function GlobalIndices = Local2GlobalIndices(LocalIndices, Split)
    if max(LocalIndices) > length(Split)
        error('Local indices are bigger than local split\n');
    end

    GlobalIndices = nan(length(LocalIndices),1);
    for ii=1:length(LocalIndices)
        if LocalIndices(ii) == 0
            GlobalIndices(ii) = 0;
        else
            GlobalIndices(ii) = Split(LocalIndices(ii));
        end
    end
return