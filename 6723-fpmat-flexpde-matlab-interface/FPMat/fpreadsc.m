function [sv1,sv2,u]=fpreadsc(fname)
% FPREADSC reads the unformatted data EXPORTED by FlexPDE on a rectangular grid.
%
% Description:
% This utility function reads the unformatted
% data EXPORTED by FlexPDE using SURFACE/CONTOUR 
% plot commands.
% Limitation: Acts only on rectangular domains.
% This code has been tested under Matlab R13, R14
% and FlexPDE 4.x.
% 
% Input arguments:
% fname: a string contains the data file name (and its path).
%
% Output arguments:
% sv1: vector of spatial variable 1 (usually x, z, or r)
% sv2: vector of spatial variable 2 (usually y, z, or r)
% u: matrix of values of u at exported grid points
%
% Syntax:
%       [sv1,sv2,u]=fpreadsc(fname)
%                   fpreadsc(fname)    
% 
% If fpreadsc is called without requesting output arguments
% it will simply draw data in a 3D surfc plot.   
%
% Limitaions:
%	1. The FlexPDE export command restricted to a regular "rectangular grid".
%      So 3D graphs, on complex irregular geometries can not be read by FPMat.
%	2. Only one variable can be exported to each file.
%   3. Supported FlexPDE output files limited to unformatted data file.
%
%
% See also FPREADH, FPREADE, SURFC
%

%{
__________________________________________________
File Properties:
Name:		fpreadsc.m
Subject:	Reading Surface and Contour plots data from FlexPDE.
Category:	FPMat: FlexPDE Interface
Author:		Mohammad Rahmani
Created:	Dec. 3, 2004
Version: 	1.0
Comments:	See FPMat Interface.pdf for more information
______________________________________________________


Mohammad Rahmani
Chemical Eng. Dep.
Amir-Kabir Uni. of Technology
Tehran, IRAN
Mohammad.Rahmani@Gmail.com

%}

%% 1 - Check for input/output arguments
if nargin<1 
    error('Not enough input arguments')
end
if nargout==0
    outputfcn='Plot';
elseif nargout~=3
    error('Wrong number of output arguments')
else
    outputfcn='SendOut';
end


%% 2- Open the Data file and catch the error
[fid,errmsg] = fopen(fname,'r');
if fid == -1 % An error has been occurred
    error([fname, '!??  ',errmsg])
end;


%% 3- Bypass the header of data file
% This header normally is a FlexPDE header enclosed in {}
while (feof(fid) ~= 1)	% ignore lines till }
  tline = fgetl(fid);
  if (tline == '}')
    break
    end
end


%% 4- Read the rest of data  and close the file
% Note: Each data section has been separated by
% two line headers from the next section. This 
% is the FlexPDE convention for Contour and Surface
% plots.
x=textscan(fid,'%f','headerLines',2);
y=textscan(fid,'%f','headerLines',1);
data=textscan(fid,'%f','headerLines',1);
fclose(fid);


%% 5- Convert cell data to double data
x=x{1};
nx=length(x);
y=y{1};
ny=length(y);
data=data{1};

%% Reshape the data to cast in the form of 3D plots
% Very Important Note:
% The FlexPDE exported surface and contour plots data
% has a rectangular form and contains nx elements for
% the first spatial variable, ny elements for the second
% spatial variable and nx*ny elements for the exported variable.
% The format of data for exported variables has ny blocks each
% contains nx elements. The following lines cast these data in a form
% suitable for Matlab 3D plots.
[y,x]=meshgrid(y,x);
data=reshape(data,nx,ny);


%% 6 - Prepare output arguments
switch outputfcn
    case 'Plot'
        figure('Name',['Surface-Contour plot for: ',fname]);
        surfc(x,y,data);
        return
    case 'SendOut'
        sv1=x;
        sv2=y;
        u=data;
        return
end