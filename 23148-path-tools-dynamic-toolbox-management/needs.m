% NEEDS Adds or removes toolbox(es) to the MATLAB search path
%
% needs()
% Returns the list of the available toolboxes. The toolboxes are defined
% in file defTbX.m  Names are case sensitive.
%
% needs('tbox')
% needs tbox
%   Adds the toolbox 'tbox' to the MATLAB path. Alternatively 
% needs(N)
%   where N is the number of the toolbox, as specified in defTBX.m
%
% needs('-tbox')
% needs -tbox
% needs(-N)
%   Removes toolbox 'tbox' from the MATLAB path.
%
%   The number of parameters to needs is not limited. The toolboxes are
% added/removed in the order of listing them.
%
% Example
% needs('EIGTOOL','-MYTBX1','MYTBX2')
% % adds EIGTOOL to the search path, removes MYTBX1 from the path and 
% % adds MYTBX2 to the path.
% 
% needs (10:20)     % adds all toolboxes with numbers from 10 to 20
%
% See also defTbX goto

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

function needs (varargin)

def = defTBX();

n = length(def);
M = [];
for i = 1:n
    M = [M; def(i).n i];
end
M = sortrows(M,1);      %| sort by number

if nargin == 0          %| Only show the options
    P = '   ID   Name        Description\n -------------------------------------\n';
    for k = 1:n
        i = M(k,2);
        if isfield(def(i),'info')      % show the toolbox info
            tab = char(32*ones( max(1, 12-length(def(i).name)), 1 ));    % spaces
            P = sprintf('%s %4d - %s%s%s\n', P, def(i).n, def(i).name,tab,def(i).info);
        else
            P = sprintf('%s %4d - %s\n', P, def(i).n, def(i).name);
        end
    end
    fprintf(P);

elseif nargin >= 1      %| Parse the data
    if nargin == 1
        fname = varargin{1};
    else
        fname = varargin;
    end

    t = length(fname);
    if ischar(fname)    %| Just one Toolbox
        fname = {fname};
        t = 1;
    elseif isnumeric (fname)
        f = cell(t,1);
        for i=1:t
            f{i} = fname(i);
        end
        fname = f;
    end

    if iscell(fname)    %| Many Toolboxes defined by name
        for i = 1:t
            tbx = fname{i};

            if isnumeric(tbx)       %| Toolboxes as numbers
                k = find( M(:,1) == abs(tbx) );
                if k ~= 0
                    if tbx > 0      %| add the toolbox
                        addtopath ( def(k).path );
                    else            %| remove the toolbox
                        if ~ isempty(strfind( path, def(k).path ))
                            removefrompath( def(k).path );
                        end
                    end
                end

            elseif ischar(tbx)      %| Toolboxes specified by strings
                if tbx(1) == '-'    %| remove the toolbox
                    add_tbx = 0;
                    tbx = tbx(2:end);
                else
                    add_tbx = 1;
                end

                for k = 1:n
                    if strcmpi( def(k).name , tbx )
                        if add_tbx
                            addtopath ( def(k).path );
                        else
                            removefrompath ( def(k).path );
                        end
                        break;
                    end
                end
            end

        end % cycling over the input arguments

    end % if cell input

end % if any input
end

%% Add to path
function addtopath( dirlist )
cpos = find( dirlist==';', 1, 'first');
if isempty(cpos)
    path( dirlist , path );
else
    path( dirlist(1:cpos-1), path );
    addtopath( dirlist(cpos+1:end) );
end
end

%% Remove from path
function removefrompath ( dirlist )
cpos = find( dirlist==';', 1, 'first');
P = path;
if isempty(cpos)
    if strfind( P, strtrim(dirlist) )
        rmpath ( dirlist );
    end
else
    if strfind( P, strtrim(dirlist(1:cpos-1)) )
        rmpath( dirlist(1:cpos-1) );
    end
    removefrompath( dirlist(cpos+1:end) );
end
end
