function file = relfile(file,refpath)
%RELFILE   Relative filename
%   RELFILE(FILE,PATH) returns the relative path of the specified FILE
%   with respect to the reference path, PATH. FILE can be a string
%   containig the file name or a cell string array to convert multiple
%   file names.
%
%   RELFILE(FILE) returns the relative path with respect to the current
%   MATLAB working directory.
%
%   Note that this function is case-sensitive.
%
%   See also rel2fullfile, fileparts, fullfile, filesep.

% Written by: Takeshi Ikuma
% Date: 10/31/2009
% Revision History:
%  (12/03/2010) allow '/' as the file separator in Windows
%  (01/19/2011) allow multiple file to be converted at once
%  (08/31/2011) case insensitive comparison for Windows
%  (05/16/2013) whole function rewritten to use regexp with 'split' option
%  (05/17/2013) if file is under refpath, returns relative path starting with '.'
%  (09/27/2013) fixed the bug reported by igor

error(nargchk(1,2,nargin));

if nargin<2, refpath = ''; end

if isempty(file), return; end
if isempty(refpath), refpath = pwd; end

% make sure the input is char not cellstr, convert if necessary
if iscellstr(file)
   % if cell array, use recursion
   file = cell(size(file));
   for n = 1:numel(file)
      file{n} = rel2fullfile(file{n},refpath);
   end
elseif ~ischar(file)
   error('FILE must be a string or a cellstr array.');
end

if iscellstr(refpath), refpath = char(refpath); end
if ~ischar(refpath) || size(refpath,1)~=1
   error('PATH must be a string');
end

% check if file is already fullfile, & if so exit immediately 
switch computer
   case {'PCWIN' 'PCWIN64'} % Win
      % replace all slash with backslash
      file = strrep(file,'\',filesep);
      refpath = strrep(refpath,'\',filesep);
      strcmpfcn = @strcmpi; % path is case insensitive
   case {'GLNXA64' 'MACI64'} % Unix
      strcmpfcn = @strcmp; % path is case sensitive
   otherwise
      error('Unsupported operating system.');
end

% split file name into cell array of folders
pathsepexp = ['(?<!\' filesep ')\' filesep '(?!\' filesep ')'];
fileparts = regexp(file,pathsepexp,'split');
refparts = regexp(refpath,['\' filesep '{1,2}'],'split');

% remove empty path parts
fileparts(cellfun(@isempty,fileparts))=[];
refparts(cellfun(@isempty,refparts))=[];

Nfile = numel(fileparts);
Nref = numel(refparts);
N = min(Nfile,Nref);

I = find(~strcmpfcn(fileparts(1:N),refparts(1:N)),1,'first');
if isempty(I) % complete match
   I = N+1;
   pdir = {};
elseif I==1 % nothing in common, return the full path
   return;
else
   pdir = repmat({'..'},1,Nref-I+1);
end

if isempty(pdir) && I>N
   file = '';
else
   file = fullfile(pdir{:},fileparts{I:end});
end

% Copyright (c)2009-2013, Takeshi Ikuma
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%     notice, this list of conditions and the following disclaimer. *
%     Redistributions in binary form must reproduce the above copyright
%     notice, this list of conditions and the following disclaimer in the
%     documentation and/or other materials provided with the distribution.
%     * Neither the name of the <ORGANIZATION> nor the names of its
%     contributors may be used to endorse or promote products derived from
%     this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

