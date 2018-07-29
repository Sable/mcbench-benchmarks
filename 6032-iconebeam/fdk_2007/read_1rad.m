
function [RAD]=read_1rad(i_pr,Directory,prefix)

% for this demonstration
global Sinog

RAD= Sinog(i_pr,:);
% trick to allow Bi linear interpolation
RAD=repmat(RAD,6,1);

return
