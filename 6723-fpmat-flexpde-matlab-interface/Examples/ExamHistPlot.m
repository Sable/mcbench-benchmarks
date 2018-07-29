% FPMat Interface
% Example of History plot data

% Read history plot data
% The data has been generated in FlexPDE
% by running Example02.PDE

fpreadh('U1.flx');
fpreadh('U1Err.flx');
% Call fpreadh with output arguments
[t,u]=fpreadh('U2.flx');
disp([t,u])
[t2,u2]=fpreadh('U2Err.flx');
figure('Name','xx'); plot(t2,u2)

