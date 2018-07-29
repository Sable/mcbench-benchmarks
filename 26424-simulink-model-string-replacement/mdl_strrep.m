function mdl_strrep(object,S1,S2)
%MDL_STRREP Replace string in Simulink object name with another
%  MDL_STRREP(OBJECT,S1,S2) replaces all occurrences of the string S1 in 
%  the name of a Simulink object and its children with the string S2. This 
%  enables the user to remove undesired characters in bulk or replace 
%  phrases when the model is used in a different context.
%
%  MDL_STRREP(OBJECTS,S1,S2) replaces all occurrences of the string S1 in 
%  the name of all Simulink objects defined in a cell array. The function
%  will not include any children of the objects defined. This enables the
%  user to fully specify the objects they wish to manipulate.
%
%  Examples: 
%    mdl_strrep(bdroot,' ','_')
%      replaces spaces in all blocks of current model with an underscore
%    cr = sprintf('\n');
%    mdl_strrep(gcb,cr,'')
%      removes any carriage returns in current block's name and any of its
%      components if it's a subsystem
%    myblocks = find_system(bdroot,'BlockType','Scope');
%    mdl_strrep(myblocks,'Scope','Probe')
%      finds all Scopes in the model and replaces the phrase "Scope" with
%      "Probe"
%
% Coded by Will Campbell, MathWorks Inc.
% will.campbell@mathworks.com
% January 20, 2010
% Copyright 2010 The MathWorks, Inc.

% Did the user provide a cell? Then they are deciding the individual blocks
if iscellstr(object)
    objects = object;
else
    % Identify all children of object that have the string that needs replacing
    objects = find_system(object,'Regexp','on','Name',S1);
end

% Determine the new names for the objects
%  1) Extract everything after the last single /
%  2) Remove double slashes for single slashes
%  3) Replace S1 with S2 in what's left
newnames = regexprep(objects,'([^/]+/)(?!/)','${strrep($1,$1,'''')}');
newnames = strrep(newnames,'//','/');
newnames = strrep(newnames,S1,S2);

% Replace each object's name
% You have to work your way up the hierarchy rather than down it. 
% If you don't and go i = 1:L, then the you run the risk of changing a 
% subsystem's name before you change its components, which will result in
% an error.
L = length(newnames);
for i = L:-1:1 
    set_param(objects{i},'Name',newnames{i})
end

% Only supply a replacement count if we ran find_system
if ~iscellstr(object)
    fprintf(['mdl_strrep has edited ' num2str(L) ' objects.\n'])
end