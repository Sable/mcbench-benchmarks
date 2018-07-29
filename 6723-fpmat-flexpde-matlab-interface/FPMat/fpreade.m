function [sv,u]=fpreade(fname)
% FPREADE reads the unformatted data produced by FlexPDE ELEVATION plot command.
% 
% Description:
% This utility function reads the unformatted
% data EXPORTED by FlexPDE using the ELEVATION
% plot command. This code has been tested under
% Matlb R13, R14, and FlexPDE 4.x.
%
% Syntax:
%       [sv,u]=fpreade(fname)
%              fpreade(fname)    
% 
% Input arguments:
% fname: a string contains the data file name (and its path).
%
% Output arguments:
% sv: vector of spatial variable
% u: matrix of values of u at exported grid points
%
% If fpreade is called without output arguments it simply
% will draw data in a 2D plot.   
%
% Limitaions:
%	1. Only one variable can be exported to each file.
%   2. Supported FlexPDE output files limited to unformatted data file.
%
% 
% See also FPREADSC, FPREADH
%

%{
___________________________________________________
File Properties:
Name:		fpreade.m
Subject:	Reading Elevation plot data from FlexPDE.
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
elseif nargout~=2
    error('Wrong number of output arguments')
else
    outputfcn='SendOut';
end


%% 2- Open the Data file and catch the error
[fid,errmsg] = fopen(fname,'r');
if fid == -1 % An error has been occured
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
svar=textscan(fid,'%f','headerLines',2);
data=textscan(fid,'%f','headerLines',2);
fclose(fid);


%% 5- Convert cell data to double data
svar=svar{1};
data=data{1};


%% 6 - Prepare output arguments
switch outputfcn
    case 'Plot'
        figure('Name',['Elevation Plot for: ',fname]);
        plot(svar,data);
        return
    case 'SendOut'
        sv=svar;
        u=data;
        return
end