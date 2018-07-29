function [tempaj,rain,snow]=adjmeteott(temp,precip,altmoy,lapse,altstatT,...
    corrprecip,altstatP,tcrVal,tcrIntVal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is part of the hydrological model GSM-SOCONT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB code written by Bettina Schaefli
% Ecole Polytechnique Fédérale de Lausanne,Switzerland
% E-mail: bettina.schaefli@epfl.ch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function interpolates input for GSM-SOCONT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
%   For the names of input variables and constants, see initgsmsocont.m
% Output:
%   tempaj, rain, snow: 
%       Matrices containing 1 time series per band,
%       1 colonne per band, format NxM where N the
%       number of time steps and M the number of bands
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note: the separation between snow- and rainfall is based on a fuzzy
% threshold, not a single threshold as in the original paper Schaefli et
% al.2005
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


noband=length(altmoy);
N=length(temp);

tempaj  =zeros(N,noband);
snow    =zeros(N,noband);
rain    =zeros(N,noband);

tcrinf=tcrVal-tcrIntVal/2;
tcrsup=tcrVal+tcrIntVal/2;


for j=1:noband
        tempaj(:,j)     =temp+lapse*(altmoy(j)-altstatT)/100;
        precipaj(:,j)   =precip+corrprecip/100*precip*(altmoy(j)-altstatP)/100;
        
        indneg=find(precipaj(:,j)<0);
        if ~isempty(indneg)
            '100% precipitation reduction for band'
            j
            'see adjmeteott.m'
        end
        precipaj(indneg,j)=0;   
    
        %separation snow-rain
        kinf=find(tempaj(:,j)<=tcrinf);
        snow(kinf,j)=precipaj(kinf,j);        
        kint=find(and(tcrinf<tempaj(:,j),tempaj(:,j)<tcrsup));
        % the above is empty if tcrIntVal==0
        % in Matlab, an empty index is not a problem, nothing happens
        snow(kint,j)=precipaj(kint,j).*(tcrsup-tempaj(kint,j))/tcrIntVal;
        rain(:,j)=precipaj(:,j)-snow(:,j);
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