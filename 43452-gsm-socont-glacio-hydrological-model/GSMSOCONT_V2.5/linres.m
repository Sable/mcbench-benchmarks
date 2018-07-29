function [qout,h]=linres(k,qin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is part of the hydrological model GSM-SOCONT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function simulates  discharge as outflow of a linear reservoir 
% with the eqn dh(t)/dt = qin(t)-qout(t)=qin(t)-k* h(t)
% The solution to the differential eqn is approximated with implicit method
% {h(t)-h(t-1)}/timestep = qin(t)-k*h(t)
% with timestep = 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

qout(1)=0;
h(1)=0;
for i=2:length(qin)
    h(i,1)=(qin(i)+h(i-1))/(1+1/k);
    qout(i,1)=h(i)/k;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is part of the hydrological model GSM-SOCONT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Citation:
%   Schaefli, B., Hingray, B., Niggli, M. and Musy, A., 2005. 
%       A conceptual glacio-hydrological model for high mountainous catchments.     
%       Hydrology and Earth System Sciences, 9: 95 - 109.                                                                                             
%       http://www.hydrol-earth-syst-sci.net/9/95/2005/hess-9-95-2005.pdf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright and Disclaimer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Developed at EPFL, 2003-2005, version V2.4, Jan. 2011
% Copyright, 2013, EPFL, www.epfl.ch

% Neither the authors nor EPFL make any warranty, express or implied or
% assume any liability for the use of this Matlab code. Redistribution of 
% this source code, with or without modification is permitted provided
% that the copyright notice and the disclaimer are included.  
% If the software is modified to produce derivative works, such modified 
% software should be clearly marked, so as not to confuse it with the 
% current version.
%                                                                                               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB code written by Bettina Schaefli
% Ecole Polytechnique Fédérale de Lausanne,Switzerland
% E-mail: bettina.schaefli@a3.epfl.ch
% PLEASE REPORT ERRORS TO bettina.schaefli@a3.epfl.ch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


