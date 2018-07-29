function varargout=gsmsocparprior(parset,parrange)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is part of the hydrological model GSM-SOCONT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function if run without input yields prior parameter ranges for the
% model parameters; if run with "parset" as input, the function checks
% whether the parameters lie within physical constraints; if run with
% parset,parrange as input, it checks that the parameter set "parset"
% lies, in addition, within paramrange
% output: parrange (if no input)
%         p, parameter set plausibility, value 0: if param set not possible
%         parrange (updated with physical constraints)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% order of parameters [agl,an,lk,A,beta,kgl,kn];
physlimin=[0 0 NaN 0 0 1 1];
% numerical constraint on residence times kgl and kn,
% cannot be smaller than 1 day, the simulation time step
physlimax=[NaN NaN log(1/24) NaN NaN NaN NaN];
% numerical constraint on log(1/residence time) lk,
% k=exp(lk) [units: 1/h] not smaller than 1 day, the simulation time step

if nargin<2
    priormin=[4,1,-12,10,100,1,1]; % order of parameters [agl,an,lk,A,beta,kgl,kn];
    priormax=[20,12,-1,3000,30000,30,60];
% see also Table 4 of
%  http://www.hydrol-earth-syst-sci.net/9/95/2005/hess-9-95-2005.pdf
else
    priormin=parrange(1,:); priormax=parrange(2,:);
end
% check physical limits
priormin=max(priormin,physlimin);
priormax=min(priormax,physlimax);

if nargin==0    
    parrange=[priormin;priormax];
    varargout=parrange;
else
    veto=0;
    veto=veto+sum(parset<priormin);
    veto=veto+sum(parset>priormax);
    p=max(0,1-veto);
    if nargout==1
        varargout={p}; 
    else
        parrange=[priormin;priormax]; % updated parrange
        varargout={p,parrange}; 
    end
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
