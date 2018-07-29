% GOTO Changes the current folder to the folder of a specified toolbox
%
% goto('tbox')
% goto tbox
%   Changes the current folder to the folder of the 'tbox' toolbox.
% Alternatively
% goto(N)
%   where N is the number (identifier) of the toolbox.
%
% goto()
%   Returns the list of the available toolboxes. The toolboxes are defined
% in file defTBX.m.
%
% Example
% goto('EIGTOOL')       % goes to the folder, where EIGTOOL is
% goto EIGTOOL          % equivalent to the above
%
% See also needs defTBX

% Copyright 2009-2011        Andrey Popov
% This function is distributed under BSD license (see code for details).
% Original authors information:
% Andrey Popov       andrey.popov @ gmx.net       www.p0p0v.com/science
% Last update: 06.11.2011

% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.

function goto (tbx)

if nargin == 0
    needs();
    return
end

def = defTBX();
n = length(def);
M = [];
for i = 1:n
    M = [M; def(i).n i];
end

if isnumeric(tbx)       %| Toolboxes as numbers
    k = find( M(:,1) == abs(tbx) );
    if k ~= 0
        eval(['cd ' depath(def(k).path)]);
    end

elseif ischar(tbx)      %| Toolboxes specified by strings
    for k = 1:n
        if strcmpi( def(k).name , tbx )
            eval(['cd ' depath(def(k).path)]);
            break;
        end
    end
end
end

%% Extract only the first path in case of many
function pth = depath(pth)
ind = find(pth==';',1);
if ~isempty(ind)
    pth = pth(1:ind);
end
end

