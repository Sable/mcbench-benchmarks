function [BE,I]=vms_sp_read(filename,pl);
% function [BE,I]=vms_sp_read(filename,pl);
%
% function for reading Kratos spectral VMS files into two vectors
% BE - binding energy scale
% I - intensity values
% pl=1 - the spectra will be plotted
%
% example:
% [X1,C1]=vms_sp_read('s_C_1s_1.vms',0);
%
% Written by K. Artyushkova

% Kateryna Artyushkova
% Postdoctoral Scientist
% Department of Chemical and Nuclear Engineering
% The University of New Mexico
% (505) 277-0750
% kartyush@unm.edu 
% 
% 11/13/2003

n = textread(filename,'%f',1,'delimiter','.','headerlines',60); % number of points in spectrum
I = textread(filename,'%f',n,'delimiter','.','headerlines',63); % vector of intensity values


PhE = textread(filename,'%f',1,'delimiter','.','headerlines',27); % Photon Kinetic energy
KEstart = textread(filename,'%f',1,'delimiter','.','headerlines',47); % start Kineting energy
BEstart=PhE-KEstart; % start Binding energy

step = textread(filename,'%f',1,'delimiter','.','headerlines',48); %scanning step in eV
BEend=BEstart-n*step+step; % end Binding energy
BE=[BEstart:-step:BEend]; % vector of Binding energy
BE=BE';

%displaying image
if pl==1
plot(BE,I)
set(gca,'Xdir','reverse')
end

