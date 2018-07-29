%findMIS is an heuristic algorithm for solving Maximum Independent Set problem (MIS).
%Algorithm run in O(n^2) time, where n is the number of vertices (worst case).
%Experimentally: time = 8.1e-007*n^2 + 2.2e-005*n + 0.00012 seconds, (see screenshot)
%An independent set of a graph is a subset of vertices in which no two vertices are
%adjacent. Given a set of vertices, the maximum independent set problem calls 
%for finding the independent set of maximum cardinality.

%The algorithm has been independently developped but is similar to:
%Balaji, Swaminathan, Kannan, "A Simple Algorithm to Optimize 
%Maximum Independent Set", Advanced Modeling and Optimization, Volume 12, Number 1, 2010

%Notation:
%The neighborhood of v is defined by N(v) ={u in V such that u is adjacent to v}
%The DEGREE of a vertex v in V, denoted by deg(v) and is defined by the number of
%neighbors of v.
%The SUPPORT of a vertex v in V is defined by the sum of the degree of the vertices 
%which are adjacent to v, i.e., support(v) = s(v) = sum( deg(u) ) where u are all 
%vertices in N(v).

%INPUTS:
% "AD" is the adjacency matrix. It must be of logicals values!
% "priority" is used to break the ties (parity) situations that occur when more than one 
% max set can be selected. Consider for example the trivial case of two nodes connected  
% by one edge: there are two possible maximum independent set. By using priority you can 
% decide which vertex has to selected first.
% Try for example:
% x=findMIS(logical([0 1; 1 0]),[1 2]) %Higher priority to node 1
% and
% x=findMIS(logical([0 1; 1 0]),[2 1]) %Higher priority to node 2 

%OUTPUTS:
%x is an binary array where x(i)=1 if vertex i belongs to the Maximum independent set
% and x(i)=0 if belongs to the Minimum vertex cover.

% % --------------------------------
% % Author: Dr. Roberto Olmi
% % Email : robertoolmi at gmail.com
% % --------------------------------

function x=findMIS(AD,priority)

%M is the adjacency matrix of the constraint network
[N M]=size(AD);
if N~=M
    error('Adjacency matrix AD must be square')
end
x=-ones(N,1);
nID=1:N;

%Finds the vertices with the minimum degree
degree=sum(AD,1);
md = min(degree);
minDeg = degree==md; %vertices with the minimum degree

if sum(minDeg)>1 %If more than one vertex have the min number of adjacent vertices:
    support=zeros(size(minDeg));
    %For each minimum degree vertex consider the support (sum of degrees of all it adjacent vertices)
    for i=find(minDeg)
        support(i)=sum(degree(AD(i,:)));
    end
    %Find the vertices with the maximum support
    %The values of each of the corresponding variables will be set to 1
    %and all their adjacent vertices will be set to 0
    %The corresponding rows and columns of the adjacency matrix will be removed
    %The algorithm is called recursively until the adjacency matrix is not empty

    ms=max(support);
    if ms>0
        %minDeg_maxSup -> vertices with minimum degree which maximize the support
        minDeg_maxSup = find(support==ms); 
    else %if support is full of 0 -> all the vertices minDeg have deg=0
       minDeg_maxSup=find(minDeg); 
    end
else
    minDeg_maxSup=find(minDeg); 
end
if length(minDeg_maxSup)>1 
        [mp j]=min(priority(minDeg_maxSup));
        nodSel=minDeg_maxSup(j); 
else
    nodSel=minDeg_maxSup;
end

x(nodSel)=1;
x(AD(nodSel,:))=0;

assigned=x>-1;
AD(assigned,:)=[];
AD(:,assigned)=[];
nID(assigned)=[];
priority(assigned)=[];
if numel(AD)
    x(nID)=findMIS(AD,priority);
end
% % % --------------------------------
% % % Author: Dr. Roberto Olmi
% % % Email : robertoolmi at gmail.com
% % % --------------------------------
