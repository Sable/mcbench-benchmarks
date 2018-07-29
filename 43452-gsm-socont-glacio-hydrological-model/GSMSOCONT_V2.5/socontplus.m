function [qb,qsim,etr,s,h]=socontplus(rain,etp,A,lk,beta,surf,slope)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB code written by Bettina Schaefli
% Ecole Polytechnique Fédérale de Lausanne (EPFL),Switzerland
% E-mail: bettina.schaefli@a3.epfl.ch
% Based on an original code,socont.m, written by Markus Niggli & 
% Benoît Hingray, EPFL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code of the rainfall-runoff model SOCONT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% SOCONT has a linear and an non-linear reservoir for the slow
% and the quick discharge component; the  differential eqns for both 
% reservoirs are solved with a Runge-Kutta scheme of order 4

% The input and ouput variables are in mm/day

% The model has three parameters to calibrate: A, lk, beta
% A:    filling threshold of slow reservoir [mm]
% lk=log(k): the outflow parameter of the slow reservoir; unit: log [1/heure]
% beta: the parameter of the quickflow non-linear reservoir [m^(4/3)/s]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Initialisation and  transformation of variables and constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = zeros(size(rain));         % storage slow reservoir [mm]
pinf = zeros(size(rain));      % infiltrated rain [mm/h]
etr = zeros(size(rain));       % actual ET [mm/h]
qb = zeros(size(rain));        % baseflow [mm/h]
h = zeros(size(rain));         % storage quickflow reservoir (q=beta*h^(5/3)*slope^(1/2)) [m]
% plr = zeros(size(rain));       % effective rainfall [mm/h],initialis. not required
qquick = zeros(size(rain));    % quick discharge component mm/day
% qsim=zeros(size(rain));      % total discharge [mm/h], initialis. not required

rain=rain/24;   % [mm/h]
etp=etp/24;     % [mm/h]

DT=24; % the time step of the numerical scheme is fixed to 1 day, i.e. DT=24 hours
Q1=0;  % initial base flow (could be changed and given as input)
k=exp(lk);
s(1) = Q1/k; %stock slow
if s(1) > A
    s(1) = A; % maximum storage
end

% Computation of slow reservoir
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% with Runge-Kutta of order 4
% to solve ds/dt=pinf-qb-etr, s(to)=so;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 2:length(s);

    % the first estimation of s(i) is the previous storage:

    sprev = s(i-1); % [mm] previous storage

    % estimation 1: ds(i-1,i)/dt=f(t=ti-1;s=(i-1))

    pinfest1    =fpinf(rain(i),sprev,A);
    etrest1     =fetr(etp(i),sprev,A);
    qbest1      =fqb(k,sprev);
    dsest1      =(pinfest1-etrest1-qbest1)*DT; %delta storage=(in-out)*DT

    if dsest1>2*(A-sprev) % this test is necessary since next estimation uses sprev+dsest1/2 <=A
        dsest1=2*(A-sprev);
    end
    if dsest1<(-2*sprev)
        dsest1=-2*sprev;
    end

    %estimation 2: ds(i-1,i)/dt=f(t=ti+dt/2;s=s(i-1)+1/2*dsest1)
    pinfest2=fpinf(rain(i),sprev+dsest1/2,A);
    etrest2=fetr(etp(i),sprev+dsest1/2,A);
    qbest2=fqb(k,sprev+dsest1/2);
    dsest2=(pinfest2-etrest2-qbest2)*DT;

    if dsest2>2*(A-sprev) % this test is necessary since next estimation uses sprev+dsest2/2 <=A
        dsest2=2*(A-sprev);
    end
    if dsest2<(-2*sprev)
        dsest2=-2*sprev;
    end

    %estimation 3: ds(i-1,i)/dt=f(t=ti+dt/2;s=s(i-1)+1/2*dsest2)
    pinfest3=fpinf(rain(i),sprev+dsest2/2,A);
    etrest3=fetr(etp(i),sprev+dsest2/2,A);
    qbest3=fqb(k,sprev+dsest2/2);
    dsest3=(pinfest3-etrest3-qbest3)*DT;

    if dsest3>(A-sprev) % this test is necessary since next estimation uses sprev+dsest3/2 and sprev+dsest3/2<=A
        dsest3=(A-sprev);
    end
    if dsest3<(-sprev) % this test is necessary since next estimation uses sprev+dsest3/2 and sprev+dsest3/2>=0
        dsest3=-sprev;
    end

    %estimation 4: ds(i-1,i)/dt=f(t=ti+dt;s=s(i-1)+dsest3)
    pinfest4=fpinf(rain(i),sprev+dsest3,A);
    etrest4=fetr(etp(i),sprev+dsest3,A);
    qbest4=fqb(k,sprev+dsest3);
    dsest4=(pinfest4-etrest4-qbest4)*DT;

    if dsest4>A-sprev
        dsest4=A-sprev;
    end
    if dsest4<-sprev
        dsest4=-sprev;
    end

    pinf(i)=moyruku(pinfest1,pinfest2,pinfest3,pinfest4);
    % weighed mean according to classical Runge-Kutta
    etr(i)=moyruku(etrest1,etrest2,etrest3,etrest4);
    % qb(i)=moyruku(qbest1,qbest2,qbest3,qbest4);  
    % the above is not necessary since the balance is respected by computing In-Out=dV/dt
    ds=moyruku(dsest1,dsest2,dsest3,dsest4);

    if ds>A-sprev            % this perturbes the balance
        ds=A-sprev;
    end
    if ds<-sprev             % this perturbes the balance
        ds=-sprev;
    end
    s(i)=sprev+ds;
    qb(i)=pinf(i)-etr(i)-ds/DT;


end

% check the water balance: uncomment to show the balance
% warmup=1;
% a=[warmup+1:length(qb)];
% balslow=sum(pinf(a))-sum(qb(a))-sum(etr(a))-(s(length(s))-s(warmup))/DT

plr=rain-pinf; % effective rainfall

% Computation of non-linear quick reservoir 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Change of units
%           Transformation of discharge from mm/h to m/s
%           to avoid having mm2 and problems with the precision when
%           dividing by very big numbers


DT = DT*3600;       % transformation to s
surf = surf*1000000; %transformation to m2
plr = plr/1000/3600; %transformation to m/s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Runge-Kutta order 4 to solve
% dV/dt=surface*effective rainfall - surface*quickflow,
% with V=1/2*h*surface, V(to)=Vo [mm3/s]
% This becomes:
% dh/dt=2*(plr-qquick)=1/cst*(plr-qquick) [m/s], h(to)=ho [m];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cststock=1/2;   % this defines the form of the surface storage,
                % i.e. storage=cststock*surf*h
                % here fixed to a prismatic storage, could be changed
                % and be used as a parameter to calibrate
                

cstdebit=beta*slope^0.5/surf;   % defines the parameter in the differential eqn


for i=2:length(h);
    if plr(i)+h(i-1)==0         % if no input and no storage
        h(i)=0;
    else
        % Estimation 1: dh(i-1,i)/dt=f(t=ti-1;h=(i-1));
        qquickest1=fqquick(cstdebit,h(i-1)); % [m/s]
        dhest1=fhquick(plr(i),qquickest1,cststock,DT); % [m]

        if dhest1<-2*h(i-1)      % since next estimation with h(i-1)+dhest1/2 >=0
            dhest1=-2*h(i-1);
        end

        % Estimation 2: dh(i-1,i)/dt=f(t=ti+dt/2;h=h(i-1)+1/2*dhest1)
        qquickest2=fqquick(cstdebit,h(i-1)+dhest1/2);
        dhest2=fhquick(plr(i),qquickest2,cststock,DT);

        if dhest2<-2*h(i-1)      % since next estimation with h(i-1)+dhest2/2 >=0
            dhest2=-2*h(i-1);
        end

        % Estimation 3: dh(i-1,i)/dt=f(t=ti+dt/2;h=h(i-1)+1/2*dhest2)
        qquickest3=fqquick(cstdebit,h(i-1)+dhest2/2);
        dhest3=fhquick(plr(i),qquickest3,cststock,DT);

        if dhest3<-h(i-1)        % since next estimation with h(i-1)+dhest3 >=0
            dhest3=-h(i-1);
        end

        % Estimation 4: dh(i-1,i)/dt=f(t=ti+dt;h=h(i-1)+dhest3)
        qquickest4=fqquick(cstdebit,h(i-1)+dhest3);
        dhest4=fhquick(plr(i),qquickest4,cststock,DT);

        if dhest4<-h(i-1)
            dhest4=-h(i-1);
        end

        %        qquick(i)=moyruku(qquickest1,qquickest2,qquickest3,qquickest4); %[m/s]
        dh=moyruku(dhest1,dhest2,dhest3,dhest4);

        if dh<-h(i-1)            % this perturbes the balance
            dh=-h(i-1);
        end

        h(i)=h(i-1)+dh;
        qquick(i)=plr(i)-dh/DT*cststock;    
    end
end


% check the water balance: uncomment to show the balance
% warmup=1;
% a=[warmup+1:length(qsim)];
% balquick=sum(plr(a))-sum(qquick(a))-(h(length(h))-h(warmup))/DT*cststock


% Change the units back from m/s to mm/h
qquick=qquick*1000*3600;    % [mm/h]
DT = DT/3600;               % [h]
plr = plr*1000*3600;        % [mm/h]
h=h*1000;                   % [mm]



% Sum the discharge components
qsim=qb+qquick;             % [mm/h]

% Change units from mm/h en mm/day
qsim=qsim*24;               % [mm/day]
qquick=qquick*24;           % [mm/day]
qb=qb*24;                   % [mm/day]
etr=etr*24;                 % [mm/day]
plr=plr*24;                 % [mm/day]
pinf=pinf*24;               % [mm/day]




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etr=fetr(etp,stock,stockmax)

% computation of actual ET
%  original formulation of SOCONT
% similar models use slightly different formulations

etr=etp*(stock/stockmax)^0.5;

% note 09.12.2009: in theory, etr could become higher than the available 
% storage "stock"; however, this cannot happen at a daily time step where
% etp (potential ET) cannot be much higher than the storage (except with
% absurdly low stockmax); keep this in mind if using the formulation for
% climates with very high PET and with a different time step (e.g. month)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pinf=fpinf(rain,stock,stockmax)

% computation of infiltrated rain
%  original formulation of SOCONT
% similar models use slightly different formulations

pinf=rain*(1-(stock/stockmax)^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function qquick=fqquick(constante,stock)

% computation of quick discharge component
% original formulation of SOCONT

qquick=constante*stock^(5/3); %m/s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function qb=fqb(k,stock)

% computation of slow discharge component
% original formulation of SOCONT
qb=k*stock;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function deltah=fhquick(rainnet,qquick,constante,dt)

% original formulation of SOCONT
deltah=(rainnet-qquick)/constante*dt;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moyrk=moyruku(est1,est2,est3,est4)

% compute mean of Runge-Kutta estimations

moyrk=(est1+2*est2+2*est3+est4)/6;

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
