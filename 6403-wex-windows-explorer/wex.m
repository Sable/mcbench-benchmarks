function wex(directory)
% WEX opens the Windows Explorer in selected Directory
%
%   WEX does call the Windows Explorer in the wished Directory, which the
%   user does enter as input.
%   One Option is only to enter a single letter from the Root Drive or to
%   enter a complete Path Directory information.
%
%   Options: >> wex                   - Opens in the Current Directory
%            >> wex d                 - Opens Explorer in path 'd:\'
%            >> wex d:\applications   - Opens Path in 'd:\applications'
%            >> wex; wex('d'); wex('d:\applications') - Opens all
%

%% AUTHOR    : Frank Gonzalez-Morphy 
%% $DATE     : 13-Mar-2001 18:10:27 $ 
%% $Revision : 1.12 $ 
%% DEVELOPED : R12.0 
%% FILENAME  : wex.m 

if ~ispc
    error('  :: Sorry these is only available under Windows !')
end


if nargin == 0
    choice = 'curdir';   % Current Directory
elseif nargin >= 1
    choice = 'adr';
end


switch choice
    case 'curdir'
        % Opens the Windows Explorer in current Directory (= pwd)
        !explorer /e, .\ &
    case 'adr'
        % If input is only one character, like C D M then the path
        % will be completed like c:\, d:\ or M:\.
        % If Input has more then just one letter, then the addrss
        % will be keep and Windows Explorer opened there.
        if length(directory) == 1
            ewrd = strcat('explorer /e,', directory);     % explorer /e,d
            exw = ':\ &';                                   % :\
            comd = [ewrd exw];                            % explorer /e,d:\
            dos(comd);
        else
            comd = strcat('explorer /e,', directory);     % explorer /e, D:\applications
            dos(comd);
        end
    otherwise
        disp('  :: Wrong Input, Type ... help wex ... for correct Options !')
end

% Created with NEWFCN.m by Frank González-Morphy  
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [wex.m] ======  
