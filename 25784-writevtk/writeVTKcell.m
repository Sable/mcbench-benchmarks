function writeVTKcell(filename,t,p,u)
% vtk export
% creates a vtk-file filename.vtk containing simplicial mesh data (2- or 3d)
% and additional cell data
%
% input: filename   destination 
%                   (string)
%        p          array of N points 
%                   (Nxd matrix where d denotes the dimension)
%        t          triangulation/tetrahedralization of the points in p
%                   (Mxd+1 array, where M denotes the number of simplices)
%        u          mesh function assigning a real number to every element
%                   of the triangulation/tetrahedralization
%                   (Mx1 array)
%
% example usage:
%        2d: p=rand(10,2); 
%            t=delaunayn(p); 
%            u=sum(t,2);
%            writeVTKcell('test2d',t,p,u);
%        3d: p=rand(10,3); 
%            t=delaunayn(p); 
%            u=sum(t,2);
%            writeVTKcell('test3d',t,p,u);
% (the result is accessible with paraview!)
%
% (c) Daniel Peterseim, 2009-11-07

[np,dim]=size(p);
[nt]=size(t,1);
celltype=[3,5,10];

FID = fopen(strcat(filename,'.vtk'),'w+');
fprintf(FID,'# vtk DataFile Version 2.0\nUnstructured Grid Example\nASCII\n');
fprintf(FID,'DATASET UNSTRUCTURED_GRID\n');

fprintf(FID,'POINTS %d float\n',np);
s='%f %f %f \n';
P=[p zeros(np,3-dim)];
fprintf(FID,s,P');

fprintf(FID,'CELLS %d %d\n',nt,nt*(dim+2));
s='%d ';
for k=1:dim+1
    s=horzcat(s,{' %d'});
end
s=cell2mat(horzcat(s,{' \n'}));
fprintf(FID,s,[(dim+1)*ones(nt,1) t-1]');

fprintf(FID,'CELL_TYPES %d\n',nt);
s='%d\n';
fprintf(FID,s,celltype(dim)*ones(nt,1));

fprintf(FID,'CELL_DATA %s\nSCALARS u float 1\nLOOKUP_TABLE default\n',num2str(nt));
s='%f\n';
fprintf(FID,s,u);

fclose(FID);