function fsmplay(filename, speed)
% Play an fsm file as a sequence of single wavelength images.
%   fsmplay(filename, speed)
%       filename is the full path to a PE .fsm file.
%       speed is frames per second

data = fsmload(filename);
fsmplaydata(data, speed);

