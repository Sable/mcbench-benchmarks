function reverplot(BE,I)
% script to plot binding energy BE axis in reverse order
% I - spectral intensity- can be one spectrum or multiple spectra
% X=[BEstart:-0.1:BEend]
%
% written by K.Artyushkova

% Kateryna Artyushkova
% Postdoctoral Scientist
% Department of Chemical and Nuclear Engineering
% The University of New Mexico
% (505) 277-0750
% kartyush@unm.edu 
% 
% 7/27/2001

plot(abs(BE),I)
set(gca,'Xdir','reverse')
