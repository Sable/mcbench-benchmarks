function varargout=transpq(temp,rain,snowfall,etp,param,constant,surfband,cover,Hn0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is part of the hydrological model GSM-SOCONT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input-discharge transformation function of GSM-SOCONT
% it is run either for glacier cover or for non-glacier cover
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input variables: 
    % temp, rain, snowfall :    matrices containing 1 time series per band,
    %                           1 colonne per band, format NxM where N the
    %                           number of time steps and M the number of
    %                           bands
    % etp: 1 times series (vector) for the non-glacier catchment part
% Input parameters
    % param: hydrological model parameters to be calibrated
    % constant: model parameters that represent catchment characteristics
    % surfband: vector containing surfaces of the elevation bands
    % cover: equals 1: if computation for glacier, or 2 if for nonglacier
% Output variables
    % The exact output depends on whether cover =1 (glacier) or 2
    % (non-glacier), see end of the function where 'varargout' is defined
    %
    % qsim: total discharge from this catchment part (glacier or nonglacier),
    %       (equals an area-averaged mean of the discharges from the
    %       elevation bands), format Nx1
    % qb:   base-flow; equals zero if cover = 1 (glacier), format: Nx1
    % etr:  actual evapotranspiration, equals zero if cover = 1 (glacier),,
    %       format: Nx1
    % s:    evolution of the slow non-glacier reservoir equals zero if 
    %       cover=1 (glacier), format NxM
    % h:    evolution of the quick non-glacier  reservoir, equals zero 
    %       if cover = 1,(glacier), format NxM
    % Hnfgl: evolution of accumulation and melt on the glacier surface, 
    %        format NxM, equals 0 if cover = 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<9 % intial snow storage given or not
    Hn0=0;
end
    
dt=1; % daily time step, default value is 1 day
      % this is hard-coded here, could easily be changed;
      % attention: all parameters are defined for daily time step

surf=constant(1);
slope=constant(2);
nbandes=length(surfband);

agl=param(1);
an=param(2);
kgl=param(6);
kn=param(7);
lk=param(3);
A=param(4);
beta=param(5);

if length(Hn0)==1
    Hn=Hn0*ones(1,nbandes);
else
    if length(Hn0)~=nbandes
        'bad initial conditions for snow, see transpq.m'
        'first value is given to all bands'
        Hn=Hn0(1)*ones(1,nbandes);
    else
        Hn=Hn0.*ones(1,nbandes);
    end
end


% Simulation per band
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initialisation
if nbandes==0
    qsim=0;
    qb=qsim; etr=qsim;
else
    Mn=zeros(length(temp),nbandes);    % snow melt de neige [mm/jour]
    Hn=Mn;    % snow height de neige [mm]

    Peq=Mn;   % equivalent rainfall [mm/jour]
    Hnfgl=Mn;
    etr=Mn;
    if cover==1
        Mgl=Mn;   % ice melt [mm/jour]
    else
        Mgl=[]; 
    end


    % snow melt 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for j=1:nbandes
        for i=2:length(temp)
            % initial conditions: Hn(1)=0; %storage beginning day 1
            Hnprec=Hn(i-1,j);
            Nday=snowfall(i,j);
            Tday=temp(i,j);
            if Tday>0 % more complete would be: temp-tcrmelt but critical melt 
                      % temperature is set to 0; see Hock, 2003
                Mnday=an*Tday;
                if Mnday>Hnprec/dt+Nday
                    Mnday=Hnprec/dt+Nday; % mm/day
                end
            else Mnday=0;
            end

            Hn(i,j)=Hnprec+dt*Nday-dt*Mnday; % mm
            % storage end day i=storage beginning day i + in *time step - out*timestep, timestep=1
            % Mn cannot be > Hnprec+Nday, so Hn cannot become negative
            Mn(i,j)=Mnday;
        end
    end


    % if glacier cover
    if cover==1
        for j=1:nbandes
            for i=2:length(temp)
                Hnprec=Hn(i-1,j);
                Tday=temp(i,j);
                if Hnprec==0
                    if Tday>0 
                        Mglday=agl*Tday;
                    else Mglday=0;
                    end
                else Mglday=0;
                end

                Hnfgl(i,j)=Hnprec-dt*Mglday;         
                % evolution of overall storage, can be negative since glacier storage is infinite
                Mgl(i,j)=Mglday;
            end
        end
        Peq=rain+Mn+Mgl;        % equivalent rainfall
        Peq=Peq*surfband/surf;  % area-averaged mean
        Mgl=Mgl*surfband/surf;  % area-averaged mean

        qmgl  = linres(kgl,Mgl);          % ice melt discharge; since this is a linear transform
                                          % this does not need to be done per band
        qsim2 = linres(kn,Peq-Mgl);       % discharge due to snow melt and rainfall
        qsim  = qmgl+qsim2;

        qb=zeros(size(qsim));                       % baseflow, only relevant for non-glacier
        etr=qb;                                     % actual ET, only relevant for non-glacier
        
        % attention: this is an open system: transformation of snow to ice
        % is not modelled; ice melt stops if the glacier band is
        % snow covered
    end

    % if non-glacier cover

    if cover==2
        Peq=rain+Mn;
        for j=1:nbandes
            [qb(:,j),qsim(:,j),etr(:,j),s(:,j),h(:,j)]=socontplus(Peq(:,j),etp,A,lk,beta,surf,slope); 
            % etp is not distributed!
        end
        qsim=qsim*surfband/surf;                    % area-averaged mean
        qb=qb*surfband/surf;                        % area-averaged mean of base flow
        etr=etr*surfband/surf;                      % area-averaged mean of base flow
        Peq=Peq*surfband/surf;                      % area-averaged mean
        s=s*surfband/surf;
        h=h*surfband/surf;
    end

    % Note: the above is time-consuming; it can be replaced by
    % if cover==2
    %     Peq=rain+Mn;
    %     Peq=Peq*surfband/surf;
    %     [qb,qsim,etr]=socontplus(Peq,etp,A,lk,beta,surf,slope);
    % end
    % in many cases, the result is almost identical but this depends on the
    % value of the non-linear reservoir parameters and should be tested
    
end % end test whether there is at least one band to compute

if cover==1
    varargout={qsim,Hnfgl};
elseif cover==2
    varargout={qsim,qb,etr,s,h};
else
    error('myApp:argChk', 'wrong value for ''cover''')    
end

% In case, here the equations to test the water balance;
% prec=(snowfall+rain)*surfband/surf;
%Peq balance
% balPeq=sum(prec(2:end,:))+sum(Mgl(2:end,:))-sum(Peq(2:end,:))-((Hn(end,:)-Hn(1,:))/dt)*surfband/surf
% if cover==2
%     balSocont=sum(Peq(2:end,:))-sum(qsim(2:end,:))-sum(etr(2:end,:))-((s(end,:)-s(1,:))/dt)-((h(end,:)-h(1,:))/dt)
% end

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


