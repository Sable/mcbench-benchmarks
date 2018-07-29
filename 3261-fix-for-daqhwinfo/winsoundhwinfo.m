function info = winsoundhwinfo

% WINSOUNDHWINFO
%
% Function to provide separate lists of AI and AO channels.
% Work around for toolbox assumption that one list fits all.
%
% Output boards do not have to be in the same order as the inputs in
% Windows Multimedia Settings (Control Panel).
%
% New fields added to output of daqhwinfo(AI) or daqhwinfo(AO):
%
%   .InputBoardNames
%   .OutputBoardNames
%   .InstalledInputBoardIds
%   .InstalledOutputBoardIds
%   .InputObjectConstructorName
%   .OutputObjectConstructorName
%
% 
% NOTE: DAQHWINFO standard fields are included for compatibility, 
% but you should avoid using .InstalledBoardIds, .BoardNames and 
% .ObjectConstructorName
%
% (c) Richard Medlock 2003.



% First get the HWINFO for WINSOUND...
info = daqhwinfo('winsound');

% Number Of Boards...
nBoards = length(info.InstalledBoardIds);

% For each Board In the List, Create an AI and an AO Object, and
% Read the true board name from the device...

for i = 0:nBoards-1
    
    % Check to make sure that the device supports inputs/outputs:
    hasInput = ~isempty(info.ObjectConstructorName{i+1,1});
    hasOutput = ~isempty(info.ObjectConstructorName{i+1,2});
    
    if hasInput
        AI = analoginput('winsound',i);             % Create AI Object        
        AIInfo = daqhwinfo(AI);                     % Get DAQInfo for AI
        AIName{i+1} = AIInfo.DeviceName;            % Get AI DeviceName
        AIID{i+1} = num2str(i);                     % Store AI BoardID
        AIConstructor{i+1} = ...                    % AI Constructor
            ['analoginput(''winsound'',' num2str(i) ')'];
        clear AI                                    % Tidy Up
    end
    
    if hasOutput
        AO = analogoutput('winsound',i);            % Create AO Object
        AOInfo = daqhwinfo(AO);                     % Get DAQInfo for AO
        AOName{i+1} = AOInfo.DeviceName;            % Get AO DeviceName
        AOID{i+1} = num2str(i);                     % Store AO BoardID
        AOConstructor{i+1} = ...                    % AO Constructor
            ['analogoutput(''winsound'',' num2str(i) ')'];
        clear AO                                    % Tidy Up
    end
    
end

info.InputBoardNames = AIName;
info.OutputBoardNames = AOName;
info.InstalledInputBoardIds = AIID;
info.InstalledOutputBoardIds = AOID;
info.InputObjectConstructorName = AIConstructor;
info.OutputObjectConstructorName = AOConstructor;