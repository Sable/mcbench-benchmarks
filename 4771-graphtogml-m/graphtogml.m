function graphtogml(fname, adjacency, names, positions)
%GRAPHTOGML - Outputs an adjacency network in GML format.
%  The particular output is optimised for use in yEd.
%  
%  function graphtogml(fname, adjacency, names, positions)
%  
%  FNAME is the output filename. You need to include the '.gml' 
%  extension.
%
%   ADJACENCY is the adjacency matrix of the graph. Note the
%   matrix is in child-parent format. In other words ADJACENCY(A,B)
%   is 1 if there is a directed edge from parent B to child A, or
%   0 otherwise. In other words matrix action involves propagation 
%   down the network.
%
%   NAMES is a cell array of the names of the graph nodes, one cell
%   for each node. If omitted or empty, then the nodes are labelled 
%   by number.
%
%   POSITIONS is an Nx2 matrix giving the node positions. Each component
%   is ideally (but not necessarily) between 0 and 1. If missing or empty
%   it will be randomly initialised.
%
%   See http://www.yworks.com/en/products_yed_about.htm) for yEd.
%


%
%   (c) Copyright Amos Storkey, University of Edinburgh 2004. (Licence Code M).
%   For licence agreement see http://www.anc.ed.ac.uk/~amos/varlicence.html
%   or write to Amos Storkey. School of Informatics. 5 Forrest Hill. Edinburgh. UK.

%
if nargin<3
    names = [];
end
if nargin<4
    positions = [];
end
num_nodes = length(adjacency);
if isempty(names)
  for ii = 1:length(adjacency)  
    names{ii} = num2str(ii);
  end
end

if isempty(positions)
    positions(1:num_nodes,1:2) = rand(num_nodes,2);
end


positions = 600*positions;

fid=fopen(fname,'w');
fprintf(fid,'%s\n','graph [');
fprintf(fid,'%s\n',' id 0');
fprintf(fid,'%s\n',' version 0');
fprintf(fid,'%s\n',' graphics [');
fprintf(fid,'%s\n',' ]');
fprintf(fid,'%s\n',' LabelGraphics [');
fprintf(fid,'%s\n',' ]');

for ii = 1:length(adjacency)
 fprintf(fid,'%s\n',' node [');
 fprintf(fid,'%s\n',['  id ' num2str(ii)]);
 fprintf(fid,'%s\n',['  label "' names{ii} '"']);
 fprintf(fid,'%s\n','  graphics [');
 fprintf(fid,'%s\n',['   x ' num2str(positions(ii,1))]);
 fprintf(fid,'%s\n',['   y ' num2str(positions(ii,2))]);
 fprintf(fid,'%s\n','   type "oval"');
 fprintf(fid,'%s\n','  ]');
 fprintf(fid,'%s\n','  LabelGraphics [');
 fprintf(fid,'%s\n','   type "text"');
 fprintf(fid,'%s\n','  ]');
 fprintf(fid,'%s\n',' ]');
end
for ii=find(adjacency(:))'
 [ss,tt]=ind2sub(size(adjacency),ii);
 fprintf(fid,'%s\n',' edge [');
 fprintf(fid,'%s\n',['  label ""']);
 fprintf(fid,'%s\n',['  source ' num2str(tt)]);
 fprintf(fid,'%s\n',['  target ' num2str(ss)]);
 fprintf(fid,'%s\n','  LabelGraphics [');
 fprintf(fid,'%s\n','   type "text"');
 fprintf(fid,'%s\n','  ]');
 fprintf(fid,'%s\n',' ]');
end

 fprintf(fid,'%s\n',' ]');
fclose(fid);
