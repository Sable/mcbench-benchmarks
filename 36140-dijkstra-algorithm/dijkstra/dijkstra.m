%---------------------------------------------------
% Dijkstra Algorithm
% author : Dimas Aryo
% email : mr.dimasaryo@gmail.com
%
% usage
% [cost rute] = dijkstra(Graph, source, destination)
% 
% example
% G = [0 3 9 0 0 0 0;
%      0 0 0 7 1 0 0;
%      0 2 0 7 0 0 0;
%      0 0 0 0 0 2 8;
%      0 0 4 5 0 9 0;
%      0 0 0 0 0 0 4;
%      0 0 0 0 0 0 0;
%      ];
% [e L] = dijkstra(G,1,7)
%---------------------------------------------------
function [e L] = dijkstra(A,s,d)

if s==d
    e=0;
    L=[s];
else

A = setupgraph(A,inf,1);

if d==1
    d=s;
end
A=exchangenode(A,1,s);

lengthA=size(A,1);
W=zeros(lengthA);
for i=2 : lengthA
    W(1,i)=i;
    W(2,i)=A(1,i);
end

for i=1 : lengthA
    D(i,1)=A(1,i);
    D(i,2)=i;
end

D2=D(2:length(D),:);
L=2;
while L<=(size(W,1)-1)
    L=L+1;
    D2=sortrows(D2,1);
    k=D2(1,2);
    W(L,1)=k;
    D2(1,:)=[];
    for i=1 : size(D2,1)
        if D(D2(i,2),1)>(D(k,1)+A(k,D2(i,2)))
            D(D2(i,2),1) = D(k,1)+A(k,D2(i,2));
            D2(i,1) = D(D2(i,2),1);
        end
    end
    
    for i=2 : length(A)
        W(L,i)=D(i,1);
    end
end
if d==s
    L=[1];
else
    L=[d];
end
e=W(size(W,1),d);
L = listdijkstra(L,W,s,d);
end