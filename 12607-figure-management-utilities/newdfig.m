function fighandle=newdfig(varargin)
% fighandle = newdfig(numfigs,figname)  create NEW Docked FIGures.
%   "fighandle" is a vector of handle numbers for the figures.
%   "numfigs" determines the number of figures to create.
%   "figname" is an optional string for each figure's name.
%   Examples: 
%       newdfig('Title'), newdfig Title, newdfig
%       figh=newdfig(3); figh=newfig(2,'Title');

%   Copyright 2006 Mirtech, Inc.
%   created 08/27/2006  by Mirko Hrovat on Matlab Ver. 7.2
%   Mirtech, Inc.       email: mhrovat@email.com
numfigs=[];  
ftitle=[];
if nargin~=0,
    for n=1:length(varargin),
        arg=varargin{n};
        if isnumeric(arg),
            numfigs=arg;
        elseif ischar(arg),
            ftitle=arg;
        end
    end  % for
end  % if nargin
if isempty(numfigs),    numfigs=1;  end
if isempty(ftitle),     ftitle='';  end

figh=zeros(1,numfigs);
for n=1:numfigs,
    figh(n)=figure('Name',ftitle,'WindowStyle','docked');
end

if nargout==1,
    fighandle=figh;
end
