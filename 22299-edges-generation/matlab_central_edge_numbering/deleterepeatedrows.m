function [matrix,I]=deleterepeatedrows(matrix)
%function: [element2edges, edge2nodes]=edge_numbering(elements)
%requires: deleterepeatedrows
%generates edges of (triangular) triangulation defined in elements
%elements is matrix, whose rows contain numbers of its element nodes 
%element2edges returns edges numbers of each triangular element
%edge2nodes returns two node numbers of each edge
%example: [element2edges, edge2nodes]=edge_numbering([1 2 3; 2 4 3])


%fast and short way suggested by John D'Ericco working in both 2D and 3D
matrixs=sort(matrix,2);
[dummy,J,I] = unique(matrixs,'rows');
%I=reshape(I,size(matrixs,2),size(I,1)/size(matrixs,2));
matrix=matrix(J,:);

%original code working only in 2D
% [matrixs,tags] = sortrows(sort(matrix,2));
% 
% % which ones were reps?
% k = find(all(diff(matrixs)==0,2));
% 
% %these rows of matrix are repeated 
% repeated=tags(k);
% 
% %and these rows will be removed
% removed=tags(k+1);
% 
% %both lists are sorted 
% [removeds, tags2]=sort(removed);
% repeateds=repeated(tags2);
% 
% % delete the tags to removed rows
% tags(k+1) = [];
% % and recover the original array, in the original order.
% matrix = matrix(sort(tags),:);
% 
% %row indices before matrix compression indicating repetition   
% I=insertvector((1:size(matrix,1))',repeateds,removeds);
% 
% %-------------------------------------------------------------
% function r=insertvector(v,pos_from,pos_to)
%      tf=false(1,numel(v)+numel(pos_to));
%      r=double(tf);
%      tf(pos_to)=true;
%      r(~tf)=v;
%      r(tf)=r(pos_from);    
% %-------------------------------------------------------------