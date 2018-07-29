% DEFTBX Definition of the available toolboxes
%
%   This function contains the specifications of the user toolboxes.
%   The specification is updated by the user, but the function is not meant
% for direct usage.
%   Alter the code of the function to list your toolboxes. Each toolbox is
% specified as a structure with the following fields:
%   d.n    - an integer number (identifier for the toolbox)
%   d.name - the name for the toolbox
%   d.info - information about the toolbox
%   d.path - path to the toolbox
%
%   The name is used by the functions "needs" and "goto" to load/unload the
% toolbox. The name is not case dependent. No space characters are allowed.
% needs GRAPH   % loads the toolbox with name 'graph'
%
%   Alternatively, instead of the name one can use the number of the toolbox
% needs(10:20)  % loads all toolboxes with numbers from 10 to 20
%
% If "needs" is evoked without arguments the numbers, name and information
% for all available toolboxes is visualized.
%
%   The path to the toolbox is specified in the field "path". If the
%   toolbox requires several folders, these should be separated by
%   semicolon 
% d.path = 'C:\Matlab\MyToolboxes\GRAPH; C:\Matlab\MyToolboxes\GRAPH\demo'
%
% See also needs goto

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

function definitions = defTBX()

persistent def      % saves time, by storing the structures in memory

if isempty(def) == 1
    dd = struct('n',[],'name','','info','','path','');
    d = dd;
    def = [];

    %---------------------------------------------------------------------
    %--------------- START DEFINING YOUR TOOLBOXES HERE ------------------
    
    % % For each toolbox you want to define:
    % % 1. make a copy of the following lines
    % % 2. uncomment them
    % % 3. modify them accordingly
    %--- START COPY ---- START COPY ---- START COPY
    % d.n    = 0;
    % d.name = '';
    % d.info = '';
    % d.path = '';
    % def = [def d];    % do not change this line!
    %--- END COPY ---- END COPY ---- END COPY

    d.n    = 1;
    d.name = 'home';
    d.info = 'My working folder';
    d.path = 'D:\MyWork';
    def    = [def d];

    d.n    = 2;
    d.name = 'mix';
    d.info = 'Mixtured of M files I downloaded from the Internet';
    d.path = 'D:\Toolboxes\_mix_';
    def    = [def d];

    d.n    = 200;
    d.name = 'EIGTOOL';
    d.info = 'Eigenvalue toolbox';
    d.path = 'D:\Toolboxes\EIGTOOL; D:\Toolboxes\EIGTOOL\demo';
    def    = [def d];

    %-------------------------- STOP HERE --------------------------------
    %#####################################################################

end
definitions = def;

