function [matrix xmin xmax ymin ymax]=grd_read_v2(namefile)
% Function to read a GRD file
%                  (from Golden Software Surfer, ASCII format)
%
% [matrix xmin xmax ymin ymax]=grd_read_v2(name of file)
%
% Input:
%      nomarch = name of the file to be read, including ".grd" extension
% Output:
%      matrix =  matrix of the read data
%      xmin xmax ymin ymax = grid limits
%
% Coded by Alberto Avila Armella.
%          UPDATED & IMPROVED BY Jose Maria Garcia-Valdecasas

grdfile=fopen(namefile,'r');    % Open file
code=fgetl(grdfile);            % Reads surfer code 'DSAA'
% Grid dimensions (number of nodes)
aux=str2num(fgetl(grdfile)); nx=aux(1); ny=aux(2);
% X limits
aux=str2num(fgetl(grdfile)); xmin=aux(1); xmax=aux(2);
% Y limits
aux=str2num(fgetl(grdfile)); ymin=aux(1); ymax=aux(2);
% Z limits
aux=str2num(fgetl(grdfile)); zmin=aux(1); aux(2);
% Read matrix
[matrix,count] = fscanf(grdfile, '%f', [nx,ny]);
matrix=matrix';   % Trasposes matrix

fclose(grdfile);



