function [M]=match(S,L)
%out=match(S,L)
%these function match dimension Shorter vector with Larger by fill zero
%input vectors can be array vector or cell vector or symbolic vector
for y=length(S)+1:length(L)
    if iscell(S) && iscell(L)
        S{1,y}=0;
    else
        S(1,y)=0;
    end
end        
M=S;