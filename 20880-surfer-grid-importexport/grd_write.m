function grd_write(matrix,xmin,xmax,ymin,ymax,namefile)

% Function to write a MatLab matrix as a GRD file 
%                         (Golden Software Surfer, ASCII format)
%
% grd_write(matrix,xmin,xmax,ymin,ymax,namefile)
%
% Input:
%      matrix = matrix to export
%      xmin,xmax,ymin,ymax = grid limits
%      namefile = name of the file to be written (include ".grd" extension)
% Output:
%      grd file in current directory
%
% Coded by Alberto Avila Armella

% Get grid dimensions
aux=size(matrix);
nx=aux(2);ny=aux(1);

grdfile=fopen(namefile,'w');                % Open file
fprintf(grdfile,'%c','DSAA');               % Header code
fprintf(grdfile,'\n %i %i',[nx ny]);        % Grid size
fprintf(grdfile,'\n %f %f',[xmin xmax]);    % X limits
fprintf(grdfile,'\n %f %f',[ymin ymax]);    % Y limits
fprintf(grdfile,'\n %f %f',[min(min(matrix)) max(max(matrix))]); % Z limits
fprintf(grdfile,'\n');
for jj=1:ny                                 % Write matrix
    for ii=1:nx
        fprintf(grdfile,'%g %c',matrix(jj,ii),' ');
    end
    fprintf(grdfile,'\n');
end
fclose(grdfile);

disp(strcat('File written: ',namefile))