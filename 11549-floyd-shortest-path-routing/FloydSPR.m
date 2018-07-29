%% Floyd algorithm
function [S, P]=FloydSPR(AdjMax)
% *INPUT:* 
% AdjMax: Adjacent matrix that represents a weighted, directed graph
%
% *OUTPUT:*
% S: distance to destination node
% P: next hop node
%
% *DESCRIPTION*
% Given a input adjacent matrix (AdjMax) that represents a weighted, directed graph. 
% The function finds the shorest path from one vertex 'i' to another 'j'. 
% The return values includes a matrix (S) that denotes the shortest distance 
% between vertices 'i' and 'j', and a matrix (P) that denotes the next vertex 'k' 
% on the path from vertex 'i' to vertex 'j' 


N=min(length(AdjMax(:,1)),length(AdjMax(1,:)));
P=-1*ones(N,N);
S=AdjMax;

for k=1:N
    for i=1:N
        for j=1:N
            if S(i,k)==inf
                continue;
            end
            if S(k,j)==inf
                continue;
            end
            if S(i,j)>S(i,k)+S(k,j)
                if P(i,k)==-1
                    P(i,j)=k;   
                else
                    P(i,j)=P(i,k);
                end
                S(i,j)=S(i,k)+S(k,j);
            end
        end
    end
end

%% END