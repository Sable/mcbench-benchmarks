function [element2edges, edge2nodes]=getEdges(elements)
%function: [element2edges, edge2nodes]=edge_numbering(elements)
%requires: deleterepeatedrows
%generates edges of (triangular) triangulation defined in elements
%elements is matrix, whose rows contain numbers of its element nodes 
%element2edges returns edges numbers of each triangular element
%edge2nodes returns two node numbers of each edge
%example in 2D: [element2edges, edge2nodes]=getEdges([1 2 3; 2 4 3])
%example in 3D: [element2edges, edge2nodes]=getEdges([1 2 3 4; 1 2 3 5; 1 2 4 6])

%2D case
if (size(elements,2)==3)
    %extracts sets of edges 
    edges1=elements(:,[2 3]);
    edges2=elements(:,[3 1]);
    edges3=elements(:,[1 2]);

    %as sets of their nodes (vertices)
    vertices=zeros(size(elements,1)*3,2);
    vertices(1:3:end,:)=edges1;
    vertices(2:3:end,:)=edges2;
    vertices(3:3:end,:)=edges3;

    %repeated sets of nodes (joint edges) are eliminated 
    [edge2nodes,element2edges]=deleterepeatedrows(vertices);
    element2edges=reshape(element2edges,3,size(elements,1))';
end

%3D case
if (size(elements,2)==4)
    %extracts sets of edges 
    edges1=elements(:,[2 3]);
    edges2=elements(:,[3 1]);
    edges3=elements(:,[1 2]);
    edges4=elements(:,[3 4]);
    edges5=elements(:,[1 4]);
    edges6=elements(:,[2 4]);
    
    %as sets of their nodes (vertices)
    vertices=zeros(size(elements,1)*6,2);
    vertices(1:6:end,:)=edges1;
    vertices(2:6:end,:)=edges2;
    vertices(3:6:end,:)=edges3;
    vertices(4:6:end,:)=edges4;
    vertices(5:6:end,:)=edges5;
    vertices(6:6:end,:)=edges6;
    
    %repeated sets of nodes (joint edges) are eliminated 
    [edge2nodes,element2edges]=deleterepeatedrows(vertices);
    element2edges=reshape(element2edges,6,size(elements,1))';
end


