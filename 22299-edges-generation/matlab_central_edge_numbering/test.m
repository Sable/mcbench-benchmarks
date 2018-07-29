%2D level 0 
%tic
load elements.mat
fprintf('2D triangulation:  %d elements, ',size(elements,1));
fprintf('%d nodes ',max(max(elements)));
[element2edges, edge2nodes]=getEdges(elements);
edge2elements=entryInWhichRows(element2edges); 
fprintf('--> %d edges numbered. \n',size(edge2nodes,1));
%toc


%2D level 1 
%tic
load elements_1.mat
fprintf('2D triangulation:  %d elements, ',size(elements,1));
fprintf('%d nodes ',max(max(elements)));
[element2edges, edge2nodes]=getEdges(elements);
edge2elements=entryInWhichRows(element2edges); 
fprintf('--> %d edges numbered. \n',size(edge2nodes,1));
%toc

%2D level 9 
tic
load elements_9.mat
fprintf('2D triangulation:  %d elements, ',size(elements,1));
fprintf('%d nodes ',max(max(elements)));
tic
[element2edges, edge2nodes]=getEdges(elements);
edge2elements=entryInWhichRows(element2edges); 
fprintf('--> %d edges numbered. \n',size(edge2nodes,1));
toc

%3D 
%tic
elements=[1 2 3 4; 1 2 3 5];
fprintf('3D triangulation:  %d elements, ',size(elements,1));
fprintf('%d nodes ',max(max(elements)));
[element2edges, edge2nodes]=getEdges(elements);
edge2elements=entryInWhichRows(element2edges); 
fprintf('--> %d edges numbered. \n',size(edge2nodes,1));
%toc

%3D 
tic
load elements3D
fprintf('3D triangulation:  %d elements, ',size(elements,1));
fprintf('%d nodes ',max(max(elements)));
[element2edges, edge2nodes]=getEdges(elements);
edge2elements=entryInWhichRows(element2edges); 
fprintf('--> %d edges numbered. \n',size(edge2nodes,1));
toc
