function [t,u]=fpreadh(fname)
% FPREADH reads the unformatted data exported by FlexPDE HISTORY plot command.
% 
% Description:
% This utility function reads the unformatted
% data EXPORTED by FlexPDE using the HISTORY
% plot command. This code has been tested under
% Matlb R13, R14, and FlexPDE 4.x.
%
% Syntax:
%       [sv,u]=fpreadh(fname)
%              fpreadh(fname)    
% 
% Input arguments:
% fname: a string contains the data file name (and its path).
%
% Output arguments:
% t: vector of time data points.
% u: matrix of values of u at exported grid points
%
% If fpreadh is called without output arguments it simply
% will draw data in a 2D plot.   
%
% Limitaions:
%	1. Only one variable can be exported to each file.
%   2. Supported FlexPDE output files limited to unformatted data file.
%
% 
% See also FPREADE, FPREADSC

%{

___________________________________________________
File Properties:
Name:		fpreadh.m
Subject:	Reading History plot data from FlexPDE
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
nc=0;
while (feof(fid) ~=1)
    nc=nc+1;
    data(nc)=textscan(fid,'%f','headerLines',1);  
end
fclose(fid);


%% 5- Convert cell data to double data matrix
svar=svar{1};
data=cell2mat(data);


%% 6 - Prepare output arguments
switch outputfcn
    case 'Plot'
        figure('Name',['History Plot for: ',fname]);
        plot(svar,data);
        return
    case 'SendOut'
        t=svar;
        u=data;
        return
end