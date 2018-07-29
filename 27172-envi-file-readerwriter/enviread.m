function [D,info]=enviread(datafile,hdrfile)
%ENVIREAD Reads ENVI image file.
%[D,INFO]=ENVIREAD(DATAFILE,HDRFILE) provides images data (D) and a
%structure (INFO) whose fields correspond to header items.
%[D,INFO]=ENVIREAD(DATAFILE) assumes the header file is named
%"DATAFILE.hdr" and exists in the same directory.
%D will be in whatever number format (double, int, etc.) as in the ENVI
%file.

%Original version by Ian Howat, Ohio State Universtiy, ihowat@gmail.com
%Thanks to Yushin Ahn and Ray Jung
%Heavily modified by Felix Totir.

if nargin < 1
    error('You must specify at least one input');
elseif nargin <2
    hdrfile=[deblank(datafile),'.hdr']; %implicit name
end

info=envihdrread(hdrfile);
D=envidataread(datafile,info);


