% Source Code Listings for the Calspan Version
% of the FlOl Engine Response Model
% Based on Report DNA-TR-93-124 by Adam J. Baran
% and Dr. Michael G. Dunn of Calspan Corporation
%
% AFRL/RQTI Sept 2012
%
% engine parameters:
% xn1 - fan speed (rpm)
% xn2 - core speed (rpm)
%    (fan speed correlation)
% xigv - fan inlet variable guide vane angle (deg.)
% psl4 - fan discharge static pressure (psig)
% pt25 - fan discharge total pressure (psig)
% xoil1 - oil pressure [xn1 correlation) (psig)
%    (core speed correlation)
% thrust - thrust (lbf)
% air - airflow (lbm/sec)
% vgv -compressor inlet variable guide vane angle (deg.)
% cdp - compressor discharge pressure Cpsig)
% pyro - pyrometer temperature (F)
% egt - exhaust gas temperature (F)
% fuel - fuel flow (Pph)
% xoil2c - oil pressure [xn2 correlation] (psig)
%
%       (subscripts)
% ()nom - nominal value
% ()del - Cin/de)crement over current interval
% ()sumc - sum of (in/de)crements over previous intervals
%        (prescripts)
% f() - function which generates the value of the variable
%
% Normal syntax to run is "Dunnv1('infile.dat','outfile.dat')" from matlab
% prompt. To build datafile on first run just run "Dunnv1"...
%% Main Routine
function Dunnv1(Infile,Outfile)
dbstop if error
% Check for whether a runtime datafile exists
if nargin == 0 ;            % no formatted input file exists
    defaultdata ;
    Infile = 'infile.dat';
    Outfile = 'outfile.dat';
elseif nargin == 1 ;        % formatted input file exists
    Outfile = 'outfile.dat';
end ;
STOR = [];
%% -------------------------------
% ROUTINE - READIN DATA FILE
%  -------------------------------
% readindata(Infile) ; Read in data from inputfile ; IN = fopen(Infile,'r') ;
%if (Infile == ''); 
%%%    Infile = 'infile.dat' ; %%% Remove this when converting to input
%end; 
IN = fopen(Infile); %IN = fopen('infile.dat','w') 
[pla] = textread(Infile, '%f',1,'headerlines',4) ;
[pamb] = textread(Infile, '%f',1,'headerlines',6) ;
[tamb] = textread(Infile, '%f',1,'headerlines',8) ;
[debug] = textread(Infile, '%u',1,'headerlines',10) ;
[nenc] = textread(Infile, '%u',1,'headerlines',12) ;
% Preallocate the arrays
% ib = zeros(nenc,1); blend = zeros(nenc,1); c = zeros(nenc,1); delt = zeros(nenc,1);
[ib blend c delt] =  textread(Infile,'%u %u %f %f','headerlines',14) ;
fclose('all') ;
%% Start writting out Header Block of Output File
%% -------------------------------
% ROUTINE - WRITEOUT RESULTS
%  -------------------------------
%if (Infile == ''); 
%%%    Outfile = 'outfile.dat' ; %%% Remove this when converting to input
%end; 
OUT = fopen(Outfile,'w') ;
fprintf(OUT,'PEARL - F101 reponse model \n') ;
fprintf(OUT,'%s\n',datestr(now)) ;
fprintf(OUT,' \n') ; fprintf(OUT,' \n') ; fprintf(OUT,' \n') ;
fprintf(OUT,'inputs :  \n'); fprintf(OUT,' \n') ;
fprintf(OUT,'PLA (deg) from (16.5-80.0) =>  \n') ;
fprintf(OUT,'%-4.2e  \n',pla) ;
fprintf(OUT,'ambient pressure (psia) => ') ; fprintf(OUT,'%-4.2e  \n',pamb) ;
fprintf(OUT,'ambient temperature (F) => ') ; fprintf(OUT,'%-4.2e  \n',tamb) ;
fprintf(OUT,' \n') ;
fprintf(OUT,'#_of_encounters(-)(1-10)=> ') ; fprintf(OUT,'%-2i  \n',nenc) ;
fprintf(OUT,'enc#, blend (1=mpb,2=blend2), dust conc. (mg/m^3), duration (min) \n') ;
fprintf(OUT,' \n') ;
for i = 1:1:max(ib) ; % 'max(ib) is 'nenc' 
    fprintf(OUT,'%-2i \t %-1i \t %-4.2e \t  %-4.2e \n', ib(i), blend(i),c(i),delt(i));
end ;
fprintf(OUT,' \n') ;
fprintf(OUT,'debug mode (0=off,1=on)  => ') ; fprintf(OUT,'%-2i  \n',debug) ;
fprintf(OUT,' \n') ; fprintf(OUT,' \n') ;
fprintf(OUT,'calculation begun   \n') ; fprintf(OUT,' \n'); fprintf(OUT,' \n');
fprintf(OUT,' i blend dust cnc. time int. AIR FLOW   ACC DUST    N2     CDP    FUEL FLOW   THRUST  \n');
fprintf(OUT,'         (mg/m^3)  (min)     lbm/sec)  (kg)        (rpm)  (psig) (lbm/hr)    (lbf)   \n');
fprintf(OUT,'+--+---+--------+--------+-------------+----------+-------+------+----------+-------+ \n');
%% START MAIN LOGIC HERE
% Initialize all Runtime Engine Parameters to zero
ienc = 0; none = 0; dust = 0.; icdpflag = 0; cdplim = 54.; accdust = 0. ;
ibug = 0; time = 0. ;
xn2nom = 0.; xn2del = 0.; xn2sum = 0.;            % Spool speeds  
cdpnom = 0.; cdpdel = 0.; cdpsum = 0.;            % Compressor pressure
fuelnom = 0.; fueldel = 0.; fuelsum = 0.;         % Fuel mass flow
thrustnom = 0.; thrustdel = 0.; thrustsum = 0.;   % Engine Thrust
%%% F101 Specific DATA Here
const = 1.699e-06;                                % F101 engine correl. parameters for dust accum in F101                                
cdprate1 = 9.36e-03; cdprate2 = 1.59e-02;         % F101 engine correl. parameters for cdp w/ dust1 and 2
fuelrate1 = 1.22e-01; fuelrate2 = 3.32e-01;       % F101 engine correl. parameters for fuel mass flow w/ dust1 and 2
thrustrate1 = 1.41e-01; thrustrate2 = 3.33e-01;   % F101 engine correl. parameters for thrust w/ dust1 and 2
%%% F101 Specific DATA Here
% Calculate Ambient Density of Air (lbm/sec)
rhoamb = 144.*pamb/(53.3*(tamb+460.));            % Air equation of state
% Nominal clear air engine parameter values
xn2nom = FXN2NOM(pla) ;     % call function "figure nominal core speed from PLA"
xn2  = xn2nom ;             % set core speed from nominal core speed
air = FAIR(xn2) ;           % call function for "obtain air mass flow from core speed"
cdpnom = FCDPNOM(xn2) ;     % call function "get nominal compress discharge pressure from core speed"
cdp = cdpnom ;              % set comp. discharge pressure from nominal comp. discharge pressure
fuelnom = FFUELNOM(xn2) ;   % call function "get nominal fuel flow from core speed"
fuel = fuelnom ;            % set fuel flow from the nominal fuel flow
thrustnom = FTHRUSTNOM(xn2) ;
thrust = thrustnom ;
fprintf(OUT,'%2i\t%2i\t%4.1f\t%5.1f\t\t%4.1f\t\t%3.2e\t%6.1f\t%4.1f\t%6.1f\t%6.1f\n',0,0,0,0,air,accdust,xn2,cdp,fuel,thrust) ;
STORBASE = [0 0 0 0 0 air accdust xn2 cdp fuel thrust];
% LOOP over all dust clound encounters
for ienc = 1:1:nenc;
    %% Calculate Airflow, ingested dust over this interval and total accumulated dust
    % based on conditions at start of encounter
    air = FAIR(xn2);
    q = air/rhoamb ;
    dust = const*q*c(ienc)*delt(ienc) ; % Incremental Dust accumulation
    accdust = dust + accdust;           % Cumulative Dust accumulation
    %% Calculate Core Speed          %ibug %ib(ienc)%accdust %c(ienc)
    xn2rate = FXN2RATE(ibug,blend(ienc),accdust,c(ienc));
    xn2del = xn2rate*delt(ienc);
    xn2 = xn2nom - xn2del - xn2sum ;
    %% Calculate cdp
    cdpnom = FCDPNOM(xn2);
    if(blend(ienc) == 1);    % If dust blend #1 (mpb)
       cdprate = cdprate1 ;
    elseif(blend(ienc) == 2); % If dust blend #2 (blend-2)
       cdprate = cdprate2 ;
    end;
    cdpdel = cdprate*c(ienc)*delt(ienc);
    cdp = cdpnom + cdpdel + cdpsum ;
    %% Check for surge probability
    if((cdpdel+cdpsum >= cdplim)&&(icdpflag == 0));
       icdpflag = 1;
       cdpdelc = cdplim - cdpsum ;
       tau = cdpdelc/(cdprate*c(ienc));
       fprintf(OUT,'%s %3.1f  %s  %2i %s','*** engine surge at ',tau,'minutes into the',ienc,' -th encounter');
       fprintf(OUT,' \n') ;
    end
    %% Calculate Fuel Burn Rate
    fuelnom = FFUELNOM(xn2) ;
    if(blend(ienc) == 1);    % If dust blend #1 (mpb)
       fuelrate = fuelrate1 ;
    elseif(blend(ienc) == 2); % If dust blend #2 (blend-2)
       fuelrate = fuelrate2 ;
    end;
    fueldel = fuelrate*c(ienc)*delt(ienc) ;
    fuel = fuelnom + fueldel + fuelsum ; 
    %% Calculate Thrust
    thrustnom = FTHRUSTNOM(xn2) ;
    if(blend(ienc) == 1);    % If dust blend #1 (mpb)
       thrustrate = thrustrate1 ;
    elseif(blend(ienc) == 2); % If dust blend #2 (blend-2)
       thrustrate = thrustrate2 ;
    end; 
    thrustdel = thrustrate*c(ienc)*delt(ienc);
    thrust = thrustnom + thrustdel + thrustsum ;
    %% Updat the sum terms of each engine parameter
    xn2sum = xn2sum + xn2del ;
    cdpsum = cdpsum + cdpdel ;
    fuelsum = fuelsum + fueldel ;
    thrustsum = thrustsum + thrustdel ;   
    %% Write and store out runtime results
    fprintf(OUT,'%2i\t%2i\t%4.1f\t%5.1f\t\t%4.1f\t\t%3.2e\t%6.1f\t%4.1f\t%6.1f\t%6.1f\n',ienc,blend(ienc),c(ienc),delt(ienc),air,accdust,xn2,cdp,fuel,thrust) ; 
    time = time + delt(ienc);
    STOR(ienc,:) = [ienc time blend(ienc) c(ienc) delt(ienc) air accdust xn2 cdp fuel thrust];
end
STOR = [STORBASE ; STOR] ;
% Plot Out Trends
figure(1); scale = 0;
subplot(2,3,1); plot(STOR(:,2),STOR(:,4)); grid on ; axis([ 0 max(STOR(:,2)) 0 1.1.*max(STOR(:,4))]) ;
title('dust concentration at enc') ; xlabel('time (min)'); ylabel('concentration (mg/m^3)') ;
subplot(2,3,2); plot(STOR(:,2),STOR(:,6)); grid on ; 
if (scale == 1); axis([ 0 max(STOR(:,2)) 0 1.1.*max(STOR(:,6))]) ; end;
title('air flow') ; xlabel('time (min)'); ylabel('air mass flow (lbm/sec)') ;
subplot(2,3,3); plot(STOR(:,2),STOR(:,8)); grid on ; 
if (scale == 1); axis([ 0 max(STOR(:,2)) 0 1.1.*max(STOR(:,8))]) ; end;
title('fan speed') ; xlabel('time (min)'); ylabel('fan speed (rpm)') ;
subplot(2,3,4); plot(STOR(:,2),STOR(:,9)); grid on ;
if (scale == 1); axis([ 0 max(STOR(:,2)) 0 1.1.*max(STOR(:,9))]) ; end ;
title('compressor discharge pressure') ; xlabel('time (min)'); ylabel('pressure (psig)') ;
subplot(2,3,5); plot(STOR(:,2),STOR(:,10)); grid on ;
if (scale == 1); axis([ 0 max(STOR(:,2)) 0 1.1.*max(STOR(:,10))]) ; end;
title('fuel burn') ; xlabel('time (min)'); ylabel('fuel burn rate (pph)') ;
subplot(2,3,6); plot(STOR(:,2),STOR(:,11)); grid on ; 
if (scale == 1); axis([ 0 max(STOR(:,2)) 0 1.1.*max(STOR(:,11))]) ; end;
title('thrust') ; xlabel('time (min)'); ylabel('thrust (lbf)') ;
%
fclose(OUT) ;
% END of MAIN Routine
end
%% Calculate Airflow as a function a fan of fan speed
% "x" is passed from "xn2" and "y" is passed from "air"
function [y] = FAIR(x);  %%% F101 Specific DATA Here
%%% F101 Specific DATA Here
a0= 440922.79744; a1= -174.0731208; a2= 0.027346652504;
a3= -2.1376216416e-06; a4= 8.3178976743e-11; a5= -1.2891058570e-15;
p = [440922.79744 -174.0731208 0.027346652504 -2.1376216416e-06 8.3178976743e-11];
%%% F101 Specific DATA Here
if(x<10348.); 
    y=0.;
elseif(x>15000.); 
    y=0.;
elseif((x>=10348.)&&(x<=15000.));
    y = a0 + a1*x + a2*x^2 + a3*x^3 + a4*x^4 + a5*x^5;
%    y = polyval(p,x)
end
end
%% Calculate the nominal fuel a fan of fan speed, x is passed from xn2
function [y] = FFUELNOM(x) ;%%% F101 Specific DATA Here
%%% F101 Specific DATA Here
a0 = -49816.415015; a1 = 15.16955213; a2 = -0.00090483247417;
a3 = -1.0788972042E-07; a4 = 1.3439057313e-11; a5 = -3.6898802700E-16;
%%% F101 Specific DATA Here
if(x<10348.);
    y = 0. ;
elseif(x>15000.); 
    y = 0. ;
elseif((x>=10348.)&&(x<=15000.));
    y = a0 + a1*x + a2*x^2 + a3*x^3 + a4*x^4 + a5*x^5;
end
end
%% Function calculates the nominal thrust a fan of fan speed
function [y] = FTHRUSTNOM(x);%%% F101 Specific DATA Here
% 'x' is 'xn2' while 'y' is 'fthrustnom'
%%% F101 Specific DATA Here
a10=-90190833.084; a11=38206.13731; a12=-6.4537917919; a13=0.00054340227729;
a14=-2.2807645464e-08; a15=3.8182035691e-13;
a20=-26525834.184; a21=5596.7412494; a22=-0.24258263565; a23=-2.2544154617e-05;
a24=2.2276804666e-09; a25=-5.2033103514e-14;
%%% F101 Specific DATA Here
if(x<10543.) ; 
    y = 0. ;
elseif(x>15000.) ; 
    y = 0. ;
elseif((x>=10543.)&&(x<=13246.));
    y = a10 + a11*x + a12*x^2 + a13*x^3 + a14*x^4 + a15*x^5;
elseif((x>13426.)&&(x<=15000.));     % else
    y = a20 + a21*x + a22*x^2 + a23*x^3 + a24*x^4 + a25*x^5;
end
end
%%  Calculate Nominal value of Core Speed as function of power setting
function [y] = FXN2NOM(x);%%% F101 Specific DATA Here
% "x" is passed from the global variable "pla", and "y" is "xn2nom"
%%% F101 Specific DATA Here
a10=10353.360465; a11=0.18067978533; a20=10306.641571;
a21=220.99533596; a22=-21.326092808; a23=0.69563112177;
a24=-0.0087987179757; a25=3.8820512919e-05;
%%% F101 Specific DATA Here
if(x<16.5) ;
    y = 0. ;
elseif(x>80.); 
    y = 0. ;
elseif((x>=16.5)&&(x<30.));
    y = a10 + a11*x ;
elseif((x>=30.)&&(x<=80.));
    y = a20 + a21*x + a22*x^2 + a23*x^3 + a24*x^4 + a25*x^5 ;
end
end
%% Calculate Compressor Discharge Pressure from core speed 
function [y]= FCDPNOM(x);%%% F101 Specific DATA Here
% "x" is passed from "xn2" and "y" is passed at "cdpnom"
%%% F101 Specific DATA Here
a0 = 52767.656799 ; a1 = -20.435530217 ; a2 = 0.0031594211659 ;
a3 = -2.441489353e-07 ; a4 = 9.4426267256e-12 ; a5 = -1.4592076510e-16 ;
%%% F101 Specific DATA Here
if(x<10348.);
    y = 0. ;
elseif(x>15000.);
    y = 0. ;
elseif((x>=10348.)&&(x<=15000.));
    y = a0 + a1*x + a2*x^2 + a3*x^3 + a4*x^4 + a5*x^5 ;
end
end
%% Calculates core speed drop rate due to dust
function [y] = FXN2RATE(libug,lblend,lacc,lc) ;%%% F101 Specific DATA Here
%% where 'libug' is passed from 'ibug', is debug mode
% where 'li' is passed from 'i', is cloud encounter index counter 
% where 'lacc' is passed from 'acc', is sum accumulation of dust
% where 'lc' is passed from 'c', concentration of the dust cloud
% where 'y' is passed back as 'fxn2rate', the core speed drop rate
%%% F101 Specific DATA Here 
a110 = 0. ; a111 = 0.031091666884 ; a120 = 2.2386 ; a130 = 0.41616348802 ; 
a131= 0.062687011283 ; a210= -0.023120229598 ; a211= 0.19569725331 ;
a212= -0.001954960762 ; a213= 6.9569031307e-06;
%%% F101 Specific DATA Here
if(lacc<=0.); y = 0.0; end;
if(lblend==1);                  % Model for the mpb blend
    if(lacc<72.);
        if((lc>=0.)&&(lc<72.));
            y = a110 + a111*lc ;
        elseif((lc>=72.)&&(lc<=293.));
            y = a120 ;
        elseif(lc>293);
            y = 1.0e10 ;
        end;
    elseif(lacc>=72.);
        if((lc>=0.)&&(lc<=282.));
            y = a130 + a131*lc ;
        elseif(lc>282.);
            y = 1.0e10;
        end;
    end;
elseif(lblend==2);              % Model for Blend #2
    if((lc>=0.)&&(lc<=295.));
        y = a210 + a211*lc + a212*lc^2 + a213*lc^3 ;
    elseif(lc>295.);
        y = 1.0e10;
    end;
end
end
%% DEFAULT DATA INPUT FILE
function defaultdata() ;
%% --------------------------------
%       DEFAULT DATA INPUT FILE
%  --------------------------------
% Write out a formatted 'infile.dat' for user editing if none exists in the
% directory where 'Dunnv1.m' is run. 
% Defualt INPUT VALUES BLOCK
pla = 80.0 ;    % 65 percent throttle (from 16.5 to 80) 
tamb = 59.0 ;   % Ambient temperature (in degF)
pamb =  14.7 ;  % Ambient pressure (in psia)
nenc = 10 ;     % No. of dust cloud encounters (No. of enc)
% Dust cloud encounter index numbers
ib = [0 1 2 3 4 5 6 7 8 9 10];
% CMAS blend (1 = mpb, 2 = blend2), as defined in DNA TR-92-121
blend = [0 2 2 2 2 2 2 2 2 2 2];
% dust conc. (mg/m^3) 
c = [0. 100. 100. 100. 100. 100. 100. 100. 100. 100. 100.];
% duration (min)
delt = [0.0 6.0 6.0 6.0 6.0 6.0 6.0 6.0 6.0 6.0 6.0];
% debug mode {0=off, 1=on}
debug = 0;
% Write out these properties into default file in carefully formatted
% output 
IN = fopen('infile.dat','w') ;
fprintf(IN,'PEARL - F101 reponse model \n') ;
fprintf(IN,' \n') ;
fprintf(IN,' \n') ;
fprintf(IN,'PLA (deg) from (16.5-80.0) =>  \n') ;
fprintf(IN,'%-4.2e  \n',pla) ;
fprintf(IN,'ambient pressure (psia) =>  \n') ;
fprintf(IN,'%-4.2e  \n',pamb) ;
fprintf(IN,'ambient temperature (F) =>  \n') ;
fprintf(IN,'%-4.2e  \n',tamb) ;
fprintf(IN,'debug mode (0=off,1=on)  =>  \n') ;
fprintf(IN,'%-2i  \n',debug) ;
fprintf(IN,'#_of_encounters(-)(1-10)=>  \n') ;
fprintf(IN,'%-2i  \n',nenc) ;
fprintf(IN,'enc#, blend (1=mpb,2=blend2), dust conc. (mg/m^3), duration (min) \n') ;
fprintf(IN,' \n') ;
for i = 1:1:nenc; fprintf(IN,'%-2i \t %-1i \t %-4.2e \t  %-4.2e \n', ib(i+1),blend(i+1),c(i+1),delt(i+1));end;
fclose(IN); % Close file
end