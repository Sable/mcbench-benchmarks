function [MATE] = card_match(adj2);
% [mate] = card_match(adj) constructs a (Non-weighted) maximum cardinality matching 
%             on a graph represented by ADJ-acency matrix with edge IDs as elements 
% OUTPUT: mate(i) = j means edge (i,j)=(j,i) belongs to the matching. 
%
% REMARKs: 
%      a vertex _v_ is called "outer" when there is an alternating path from _v_ to 
% an unmatched vertex _u_ that starts with a matched edge. 
%
% MATLAB implementation of H. Gabow's labelling scheme explaned in JACM 23, pp221-34 
% by Dr. Leonid Peshkin MIT AI Lab Dec 2003 [inspired by Ed Rothberg C code Jun 1985]
% http://www.ai.mit.edu/~pesha
%
%      1 2 3                                                   4-edge(1,2)
%  1   0 4 5   sample  ADJ matrix for the following graph: (2)---(1)---(3)
%  2   4 0 0                                                         5-edge(1,3)
%  3   5 0 0
%   we assume no isolated vertices and un-directed graph (symmetric ADJ) 
global MATE LABEL OUTER FIRST Nnds qcount adj break_ties
break_ties = 1;      % need this to debug and have deterministic outcome sometimes 
adj = adj2;
   % step E0 {Initialize]  (read the graph) 
Nedgs = length(find(adj))/2;  % number of edges    V
Nnds = length(adj);           % Number of vertices   U (Rothberg) or V (Gabow)
MATE  = zeros(1, Nnds);       %               and unmatched; 
OUTER = zeros(1, Nnds); 
FIRST = zeros(1, Nnds);      % in a given search, FIRST(v) is the first non-outer vertex in P(v) for some outer v 
qcount = 0; qptr=0;

MATE = greedy_match(adj, Nnds);     % start off with a greedy matching   
%  for u = find(mate == 0)   % cycle through unmatched nodes
%  OUTER = union(OUTER, u) % add to the list of nodes
% FIRST(u) = 0;
 %end
  %  MATE = [0     3     2     6     0     4];
 % for i = 1:Nnds,  AdjLst{i} = find(adj(i,:)); end  % is NO faster then find(adj())
neg_ones = -1 * ones(1, Nnds);    % speeds up comput a bit
for u = 1:Nnds  % step E1 [find unmatched vertex] - outer cycle through unmatched vertices
	if (MATE(u) ~= 0)
		continue
    end
    LABEL = neg_ones;                %  all vertices are nonouter 
    qcount = qcount+1; 
    OUTER(qcount) = u;
	LABEL(u) = 0;
                % step E2 [choose an edge] 
	while (qcount ~= qptr)   % while queue is not empty 
        qptr = qptr+1; x = OUTER(qptr);
        for y = find(adj(:,x))';
				% y is adjacent to an outer vertex */
			if ((MATE(y) == 0) & (y ~= u))   % step E3 [augment the matching] found an augmenting path 
				MATE(y) = x;
				REMATCH(x,y);
				qptr = qcount;
				break;   % go to E7 
			elseif (LABEL(y) >= 0)   % step E4 [assign edge labels]   created a blossom 
				DOLABEL(x, y, adj(x,y));   % y is outer, we call L 
			else               % step E5 [assign a vertex label]   extended the search path 
				v = MATE(y);
				if (LABEL(v) < 0)     % if _v_  is  nonouter 
					LABEL(v) = x;
					FIRST(v) = y;
					qcount = qcount+1; OUTER(qcount) = v;
                end
            end
        end
    end
            % step E7 [stop the search] 
    qcount = 0;
	qptr = 0;
end        

%  greedy matching.  If a random vertex is unmatched, check all adjacent vertices 
%  to see if any of them are also unmatched.  If so, match with a random available.
% 
function [mate] = greedy_match(adj, Nnds);
global break_ties
mate = zeros(1, Nnds);
if break_ties
    ind = randperm(Nnds);
else
    ind = 1:Nnds;
end
for i = ind
    adj_list = find(adj(:,i));    %  very expensive operation .... 
    list_size = length(adj_list);
    if list_size > 0
        j = adj_list(ceil(rand*list_size));
        mate(j) = i;
        mate(i) = j;
        adj(i, :) = 0;  adj(:, i) = 0; % erase edges from this pair 
        adj(j, :) = 0;  adj(:, j) = 0; % erase edges from this pair 
    end
end

% x and y are adjacent and both are outer.  Create a blossom. (Rothberg)
%
% assigns the edge label n(xy) to nonouter vertices. Edge xy connects outer
% vertices x and y. DOLABEL sets _join_ to the first nonouter vertex in both 
% P(x) and P(y), then it labels all nonouter vertices preceeding _join_ in P9x) or P(y). 
function DOLABEL (x, y, edge)
global MATE LABEL OUTER FIRST qcount
r = FIRST(x);      %  step L0
s = FIRST(y);
if ((r*s == 0) | (r == s))        %   no vertices can be labeled
	return    
end
flag = -edge;
LABEL(r) = flag;
LABEL(s) = flag;
if (s ~= 0)         % step L1 [switch paths]
	temp = r; r = s; s = temp;  % swap  r <-> s
end
          % step L2 [next nonouter vertex]
r = FIRST(LABEL(MATE(r)));    %  r is set to the next nonouter vertex in P(x) and P(y) 
if (r ==0) return, end
while (LABEL(r) ~= flag) 
	LABEL(r) = flag;
	if (s ~= 0) 
		temp = r; r = s; s = temp; % step L1: swap paths
    end
	r = FIRST(LABEL(MATE(r)));
    if (r ==0) return, end
end
join = r;
          % step L3 {label vertices in P(x), P(y)] 
    % all nonouter vertices between x and _join_, or  y and _join_, will be assigned edge labels.     
LabelSub(FIRST(x), edge, join);   % calls to Gabow's "step L4"
LabelSub(FIRST(y), edge, join);
          % step L5 [update FIRST]
for ndx = 1:qcount  
    i = OUTER(ndx);   % for each outer vertex i 
	if ((FIRST(i) >0) & (LABEL(FIRST(i)) > 0))   % if  FIRST(i) is outer  
		FIRST(i) = join;  % _join_ is now the first nonouter vertex in P(i)
    end
end
return      % step  L6 

% Make all non-outer vertices in the blossom outer (Rothberg)
% step L4: [Label v]
function LabelSub (v, edge, join)
global MATE LABEL OUTER FIRST qcount
while (v ~= join) & (v ~=0)     %  & (v ~= 0) by Pesha  LPM 
	LABEL(v) = edge;
	FIRST(v) = join;
	qcount = qcount+1; OUTER(qcount) = v;
	v = FIRST(LABEL(MATE(v)));
end

% Augment the matching along the augmenting path defined by LABEL (Rothberg) 
%    R(v,w) = REMATCH  (Gabow notation)
% "rematches edges in the augmening path. Vertex v is outer. 
% Part of path (w)*P(v) is in the augmenting path. It gets rematched by REMATCH(v,w)
%   Although REMATCH sets MATE(v) <- w, it does not se MATE(w)<- v. This is done in
% step E3 or another call to REMATCH. 
function REMATCH(v, w)      %  This is a recursive routine
global MATE LABEL Nnds adj
t = MATE(v);               %  step R1: 
MATE(v) = w;
if ((t == 0) | (MATE(t) ~= v))
	return;                % the path is completely rematched
elseif (LABEL(v) <= Nnds)  %  %  step R2 : rematch a path (v has a vertex label)
	MATE(t) = LABEL(v);    
	REMATCH(LABEL(v), t);
	return;
else                       %  step R3: rematch two paths (v has an edge label) 
	[x, y] = find(triu(adj) == LABEL(v));
	REMATCH(x, y);
	REMATCH(y, x);
	return;
end
