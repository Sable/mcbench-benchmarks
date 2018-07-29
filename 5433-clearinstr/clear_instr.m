function clear_instr

% The following function clears all the instrument objects.
% Simple function to do the clean up job.

% Author: Amit Gaharwar

if isempty(instrfind) % This condition has been applied so that no error is generated when instrfind is empty
    return;
else
fclose(instrfind);
delete(instrfind);
clear instrfind;
end