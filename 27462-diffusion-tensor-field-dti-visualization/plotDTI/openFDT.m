%-fanDTasia ToolBox------------------------------------------------------------------
% This Matlab script is part of the fanDTasia ToolBox: a Matlab library for Diffusion 
% Weighted MRI (DW-MRI) Processing, Diffusion Tensor (DTI) Estimation, High-order 
% Diffusion Tensor Analysis, Tensor ODF estimation, Visualization and more.
%
% A Matlab Tutorial on DW-MRI can be found in:
% http://www.cise.ufl.edu/~abarmpou/lab/fanDTasia/tutorial.php
%
%----------------------------------------------
%openFDT
%This function opens an image volume in fanDTasia(FDT) file format.
%fanDTasia is an on-line tool for DTI DW-MRI processing.
%
%example 1: A=openFDT('DTI.fdt')
%A is a 4-dimensional matrix that contains a set of volume images.
%
%example 2: [A,B]=openFDT('DTI.fdt')
%A is a 4-dimensional matrix that contains a set of volume images.
%B is a Nx4 matrix that contains the gradient orientations and bvalues.
%B is read from a .txt file with the same name as the fdt file. (In example2: DTI.txt)
%
%----------------------------------------------
%
%Downloaded from Angelos Barmpoutis' web-page.
%
%This program is freely distributable without 
%licensing fees and is provided without guarantee 
%or warrantee expressed or implied. 
%
%Copyright (c) 2007 Angelos Barmpoutis. 
%
%VERSION : 20110611
%
%-----------------------------------------------

function [data,bval]=openFDT(name)

fid=fopen(name,'r','b');

for i=1:4
  sz(i)=fread(fid,1,'int');
end

	data=zeros(sz(1),sz(2),sz(3),sz(4));
	for c=1:sz(4)
       for z=1:sz(3)
          for y=1:sz(2)
              data(:,y,z,c)=fread(fid,sz(1),'float');
          end
       end
	end

fclose(fid);

if nargout==2
    bname=name;
    bname(length(name))='t';
    bname(length(name)-1)='x';
    bname(length(name)-2)='t';
    bval=open_TXT(bname);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bval=open_TXT(fnm)
%this simple function opens a txt file that contain 4 columns of numbers
%An example of such a text file is here:
%0.1 100.23 24.3 0.334
%10.345 0.2 1.23 123.4
%... as many lines you want.


fid=fopen(fnm,'r');

if fid==-1
    fprintf(1,'ERROR: FILE CANNOT BE OPENED\n');
    return;
end

bval=[];
b=zeros(1,4);
while feof(fid)==0
    b=fscanf(fid,'%f',4)';
    bval=[bval;b];
end

fclose(fid);