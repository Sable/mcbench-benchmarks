function d=subdir(rootpath)
% SUBDIR    Returns the paths of all subdirectories of the rootpath
%   d=subdir(rootpath)
%
%   Input:
%       rootpath,   directory to be searched. All subdirectories in the
%                   rootpath are returned
%
%   Output:
%       d,          cell array containing all subdirectories of rootpath
%
%   author:   Tim Myers [myers@metronaviation.com]
%   version:  1.0
%   date:     20-May-2005
%
%   Requires dirdir from P. Macey on Matlab Central File Exchange:
%   http://www.mathworks.com/matlabcentral/files/1570/dirdir.m
%

d=[];
dnew=dirdir(rootpath);

%append subdirectories of root path
for i=1:numel(dnew)
    d=[d; {[rootpath '\' dnew(i).name]}];
end

%initialize search array. 1=directory has been searched.
s=zeros(length(d),1);
while 1
    %find index of subdirectories yet to be searched
    index=find(s==0);
    if isempty(index)
        %all subdirectories have been searched
        return
    else
        %path of subdirectory to be searched
        dtemp=char(d(index(1)));
        %new subdirectories to add to the list
        dnew=dirdir(dtemp);
        %current directory has been searched
        s(index(1))=1;  
    end 
    %append new directories
    for i=1:numel(dnew)
        d=[d; {[dtemp '\' dnew(i).name]}];
    end
    s=[s; zeros(numel(dnew),1)];
end

