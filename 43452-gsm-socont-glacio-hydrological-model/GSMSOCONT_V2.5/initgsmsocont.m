function [qobs,temp,prec,etp,constant,altmoy,corrpluie,lapse,tcrVal,tcrIntVal,...
    altstatT,altstatP,surfbandglac,surfbandnglac]= initgsmsocont(varargin)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB code written by Bettina Schaefli
% Ecole Polytechnique Fédérale de Lausanne,Switzerland
% E-mail: bettina.schaefli@epfl.ch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepares input for GSM-SOCONT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Load  the reference series for the catchment that are interpolated
% for each elevation band
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp=load('exTemp.txt');  % ASCII file, 1 colonne with mean daily temp in °C  
prec=load('exPrec.txt');  % ASCII file, 1 colonne daily precipitation (mm/d)
etp=load('exETP.txt');    % ASCII file, 1 colonne daily potential 
                          % evapotranspiration (mm/d) 
qobs=load('exqsim.txt');  % reference discharge (mm/d)

% the example files do not refer to any specific case study

% Load hypsometric curve data
hypsononglacier=load('exhypsononglacier.txt');
hypsoglacier=load('exhypsoglacier.txt');

lapse=-0.65; % decrease of temp. per 100m of altitude increase
corrpluie=7; % increase of precipitation in percent per 100 m of altitude 
             % difference with reference station
tcrVal=1;    % critical temperature for fuzzy transition between snow and 
             % rainfall; this is the temperature
             % where 50% of precipitation falls as snow, 50% as rain, 
             % see adjmeteott.m
tcrIntVal=2; % size of temperature intervall over which transition occures, 
             % see adjmeteott.m
altstatT=100; % temperature measurementstation altitude
altstatP=1500;% precipitation measurement station altitude

surfbv=80; % catchement surface
glac=45; % percentage of glaciation
slopenglac=0.3; %average slope of non glacier part of the catchment
constant=[surfbv,glac,slopenglac];


nobandglac=5;   % number of elevation bands for glacier part
nobandnglac=3;  % number of elevation bands for non glacier part

% compute surface of equi-surface elevation bands
if nobandglac==0
    surfbandglac=[];
    altmoy.glacier=[];
else
    surfbandglac(1:nobandglac,1)=1/nobandglac*surfbv*glac/100;
    altmoy.glacier=courbehypsoinv(hypsoglacier,nobandglac);
end

if nobandnglac==0
    surfbandnglac=[];
    altmoy.nonglacier=[];
else
    surfbandnglac(1:nobandnglac,1)=1/nobandnglac*surfbv*(1-glac/100);
    altmoy.nonglacier=courbehypsoinv(hypsononglacier,nobandnglac);
end

% Note: reference discharge has been obtained with gsmsocont.m and the
% following parameter set:
% agl=8; 
% an=4;
% lk=-8;
% A=1000;
% beta=301;
% kgl=3;
% kn=10;


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
