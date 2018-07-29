function [qsim,qb,etr,s,h,Hnfgl]=gsmsocont(tempglac,tempnglac,rainglac,rainnglac,...
    snowglac,snownglac,etp,param,constant,surfbandglac,surfbandnglac)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is part of the hydrological model GSM-SOCONT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function simulates the catchment discharge given temperature, rainfall 
% snowfall and model parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% input variables: 
    % tempglac, rainglac, snowglac: 
    %           matrices containing 1 time series per glacier band,
    %           1 column per band, format NxM where N the
    %           number of time steps and M the number of glacier bands
    % tempnglac, rainnglac, snownglac: 
    %           as above for non-glacier part, format: NxK where
    %           K is the number of non-glacier bands
    % etp: 1 times series (format Nx1) for the non-glacier catchment part
% input parameters
    % param: hydrological model parameters to be calibrated
    % constant: model parameters that represent catchment characteristics
    %           surfbv=constant(1); entire catchment area
    %           pglac=constant(2);  slope=constant(3);
    % surfbandglac: vector containing surfaces of the glaciers elevation bands
    % surfbandnglac: for the non-glaciers elevation bands
% Output variables
    % qsim: total discharge (mm/d), format Nx1
    % qb:   base-flow (mm/d) with respect to entire catchment area  format: Nx1
    % etr:  actual evapotranspiration (mm/d) with respect to entire catchment
    %       area  format: Nx1
    % s:    evolution of the slow non-glacier reservoir (mm), format NxK
    % h:    evolution of the quick non-glacier  reservoir (mm),format NxK
    % Hnfgl: evolution of accumulation and melt on the glacier surface, 
    %        format NxM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% check input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=size(tempglac,1);
    
if (size(tempnglac,1)~=N|size(rainglac,1)~=N|...
        size(rainnglac,1)~=N|size(snowglac,1)~=N|size(snownglac,1)~=N...
        |size(etp,1)~=N)
    error('myApp:argChk','Some input series do not have correct size')
end
if length(param)~=7
    error('myApp:argChk','Not all hydrological parameters to calibrate are given')
end
nobandglac=size(tempglac,2);
nobandnglac=size(tempnglac,2);
if (size(rainglac,2)~=nobandglac|size(rainnglac,2)~=nobandnglac|...
        size(snowglac,2)~=nobandglac|size(snownglac,2)~=nobandnglac)
        error('myApp:argChk', 'Some input series do not have correc number of bands')
end
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
pglac=constant(2);
slopenglac=constant(3);
surfglac=constant(1)*pglac/100;
surfnglac=constant(1)*(100-pglac)/100;

constant1=[surfglac,0];         % constant to be used to simualate 
                                % glacier part, slope not used here
constant2=[surfnglac,slopenglac]; % constant to simulate non-glacier part

% simulation glacier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if and(pglac>0,~isempty(surfbandglac))
    cover=1;
    [qsimglac,Hnfgl]=transpq(tempglac,rainglac,snowglac,etp,param,constant1,...
        surfbandglac,cover); 
   
else
    qsimglac=zeros(length(tempglac),1);
    Hnfgl=qsimglac;
end

% simulation non-glacier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if and(pglac<100,~isempty(surfbandnglac))
    cover=2;
    [qsimnglac,qb,etr,s,h]=transpq(tempnglac,rainnglac,...
        snownglac,etp,param,constant2,surfbandnglac,cover);
else
    qb=zeros(N,1);
    etr=qb;
    s=qb;
    h=qb;
end

% qsim total
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if or(pglac==0,isempty(surfbandglac))
    % note: if there is a very small glacier surface, it can have zero bands
    qsim=qsimnglac;
elseif or(pglac==100,isempty(surfbandnglac))
    qsim=qsimglac;
else
    qsim=pglac/100*qsimglac+(1-pglac/100)*qsimnglac;
    qb=(1-pglac/100)*qb;  %  base flow with respect to entire catchment area
    etr=(1-pglac/100)*etr; %  ET with respect to entire catchment area
end

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



