function  add(varargin)
%ADD add file(s) to current svn directory.
%   Adds files to current svn directory with TortoiseSVN.
%   If no argument is given, it will add the current directory.
%
svn('add',varargin{:})
