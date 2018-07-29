%EXAMPLE - A simple example which opens network Net1.inp, initiates some
%variables and solves the hydraulics and quality dynamics.

% Other m-files required: epanetloadfile.m, getdata.m, epanetclose.m,
% getenconstant.m, setdata.m
%

% Author: Demetrios Eliades
% University of Cyprus, KIOS Research Center for Intelligent Systems and Networks
% email: eldemet@gmail.com
% Website: http://eldemet.wordpress.com
% August 2009; Last revision: 21-August-2009

%------------- BEGIN CODE --------------


wdsfile='Net1.inp';
pumps={'9'};
tanks={'2'};
epanetloadfile(wdsfile);


TD              =5;   % duration in days
random          =0;   % random demands (1=yes, 0=no)

%Uncertainty
p_roughness     =0;   % roughness in all pipes
p_bulk          =0;   % bulk coefficients in all pipes
p_basedemands   =0;   % base demands
p_demandpattern =0;   % demand pattern
p_wall          =0;   % wall coefficients


lentanks=length(tanks);
lenpumps=length(pumps);

%set hydraulic time step 
TS=5; %in minutes
tstep=TS*60; 
setdata('EN_HYDSTEP', tstep);


%set report time step 
TR=5; %in minutes
treport=TR*60; % 
setdata('EN_REPORTSTEP', treport);


%set duration
tduration=TD*24*60*60; 
setdata('EN_DURATION', tduration);

%get number of patterns
patcount = getdata('EN_PATCOUNT');


if random==1
    %create set of random demands
    Demands_randomized=2.5*rand(patcount,(tduration/tstep));
    %set demands
    for i4=1:patcount
        setdata('SET_PATTERN',Demands_randomized(i4,:),i4);
    end %i4
end %if


%get base demands and add some white noise
basedemand=getdata('EN_BASEDEMAND');
basedemand_random=p_basedemands*2*(rand(length(basedemand),1)'-0.5).*basedemand+basedemand;
setdata('EN_BASEDEMAND',basedemand_random);

%get roughness coefficients and add some white noise
roughness=getdata('EN_ROUGHNESS');
roughness_random=p_roughness*2*(rand(length(roughness),1)'-0.5).*roughness+roughness;
setdata('EN_ROUGHNESS',roughness_random);

%get bulk coefficients (-0.5) and add some white noise
kbulk=getdata('EN_KBULK');
kbulk_random=p_bulk*2*(rand(length(kbulk),1)'-0.5).*kbulk+kbulk;
setdata('EN_KBULK',kbulk_random);

%get wall coefficients and add some white noise
kwall=getdata('EN_KWALL');
kwall_random=p_wall*2*(rand(length(kwall),1)'-0.5).*kwall+kwall;
setdata('EN_KWALL',kwall_random);


%printouts
fprintf('nodes = %d\n',getdata('EN_NODECOUNT'))
fprintf('links = %d\n',getdata('EN_LINKCOUNT'))
fprintf('tanks = %d\n',lentanks)
fprintf('pumps = %d\n',lenpumps)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% S O L V E   H Y D R A U L I C S
[d_N,tv] = getdata('EN_DEMAND');
[P] = getdata('EN_PRESSURE');
[Q] = getdata('EN_FLOW');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F I G U R E S
figure(1)
plot(Q);  %plot all flows
figure(2)
plot(P);  %plot all pressures

%close everything
epanetclose();


%------------- END OF CODE --------------
%Please send suggestions for improvement of the above code 
%to Demetrios Eliades at this email address: eldemet@gmail.com.
