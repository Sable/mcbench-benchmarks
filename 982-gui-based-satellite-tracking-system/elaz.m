% Prabhakar. S
% AE 110 Lab Assignment
% Satellite Tracking Program
% Satellite:  NOAA 12
% Program Name elaz : Elevation-Azimuth being called by the program sts

% Orbital Elements ready for degree to radians conversion!
% Two Line Elements and the Epoch Data are obtained from the GUI Interface

load variables.mat; % Loading the variables from the GUI Interface sts
I2 = yoe;		% Year of epoch
J2 = moe;			% Month of epoch
%h2 = hoe;       % Hour of epoch
%m2 = mioe;       % Minute of epoch
%K2 = doe + hoe/24 + mioe/(24*60);		% Day of epoch
K2=doe;
zero=0; % For printing a single digit month or day preceeded by a zero.
%ut=.08235372;
%frac=.08235372; % fraction of the day from the TLE

% This calculation is to find the Julian Date,
% JD Fortran code written by Fliegel and Van Flandern [1968]
% Handout by Dr. P

JD = (367*I2 - (fix(7*(I2 + fix((J2 + 9)/12))/4)) + fix((275*J2)/9) + K2 + 1721013.5 + frac);

%JD = (K2 - 32075 + round(1461 * (I2 + 4800 + (J2 -14)/12)/4 ...
%+ 367* (J2 - 2 - (J2 - 14)/12*12)/12 - 3*((I2 + 4900 + (J2 - 14)/12)/100)/4)) ;
% fprintf('\n Two Line Elements Data - 28 Dec 2000, Time 11:30:00\n');
% fprintf(' The Julian Date is %f',JD);

% Propagation begins
I = yoe;								% Year
J = moe;								% Month
%h = hoe;   				   		% Hour
%m = mioe;     				 		% Minute
%K = doe + hoe/24 + mioe/(24*60);	% Day
K=doe;

JD0 = (367*I - (fix(7*(I + fix((J + 9)/12))/4)) + fix((275*J)/9) + K + 1721013.5 + frac);

%JD0 = (K - 32075 + round(1461 * (I + 4800 + (J -14)/12)/4 ...
%+ 367 * (J - 2 - (J - 14)/12*12)/12 - 3*((I + 4900 + (J - 14)/12)/100)/4)) ;

I3 = yoe;							% Year
J3 = moe;							% Month
%h3 = hoe;       					% Hour
%m3 = mioe;       				% Minute
%K3 = (doe+pro) + h3/24 + m3/(24*60);	% Day
K3 = (doe+pro);

JD1 = (367*I3 - (fix(7*(I3 + fix((J3 + 9)/12))/4)) + fix((275*J3)/9) + K3 + 1721013.5 + frac);

%JD1 = K3 - 32075 + round(1461 * (I3 + 4800 + (J3 -14)/12)/4 ...
%  + 367 * (J3 - 2 - (J3 - 14)/12*12)/12 - 3*((I3 + 4900 + (J3 - 14)/12)/100)/4);
% Propagation ends here.

% Propagation step Size
step = 5/(24*60); % right now for every 5 minutes
j=1;


fprintf('\n\t\t\t SATELLITE    TRACKING    SYSTEM  \n');
fprintf(' ---------------------------------------------------------------------------');
fprintf('\n				             G r e g o r i a n   D a t e \n');
fprintf(' ---------------------------------------------------------------------------');
fprintf('\n  Julian Date      Azimuth     Elevation  Month/Day/Year Hour:Minute:Seconds\n');
fprintf(' ---------------------------------------------------------------------------');

while JD0<JD1;   
   
% Declaring variables and initializing values 

degtorad = pi/180;		% Radians conversion factor
i = incl*degtorad;		% Inclination
CapOmega = raan*degtorad;		% Right Ascension of the Ascending Node - denoted by symbol Capital Omega
ecc = e;					% Eccentricity
SmallOmega = aop*degtorad;						% Argument of Periapsis - denoted by  small Omega 
Mo = ma * degtorad;		% Initial Mean anomaly
n = revs;	   		% Mean Motion (revs/day)
GP = 3.986e5;				% Gravitational parameter - denoted by nu
a = 24000;					% Semi-major Axis
% a = (GP/n^2)^(1/3);
% fprintf('Semi-major axis is computed to be :\n',a);

Latitude = 0 * degtorad;
Longitude = 280 * degtorad;	
L = ((90*degtorad) - Latitude);			

We = 6.300388097;		% Angular velocity of planet Earth
perturb = 98.9246096453622 * degtorad; % Perturbation due to the Oblateness 
tq = 2448621.5; % JD for 
Qg = perturb + We * (JD0 - tq);
Q = Qg + Longitude;

tp = JD - Mo/n;
M = n * (JD0 - tp);

E = M;				          		% Use M for the first value of E
	f=M-E+ecc*sin(E);			 		% Kepler's Equation
	while abs(f)>0.00000001; 		% Loop for Kepler's equation begins
		f=M-E+ecc*sin(E);			 	%	
		fd=-1+ecc*cos(E);			 	% 
		E=E-f/fd;						%
	end;							 		% loop for Kepler's eqn ends here!


% Computing true anomaly and radius

TA=2*atan((((1+ecc)/(1-ecc))^0.5)*tan(E/2));
    if TA<0;
    	  TA=2*pi+TA;
    end;

r=a*(1-ecc*cos(E)); % radius


% Coordinate transformations

adot = (-(3/2) * n * 1.0827e-3 * (6378.14/a)^2 * cos(i))/(1-ecc^2)^2;
A = CapOmega + adot * (JD0 - JD);
SmallOmega = SmallOmega + adot * (JD0 - JD);

Rseu = [0; 0; 6378.14];
Txyz = [ cos(A) -sin(A) 0; sin(A) cos(A) 0; 0 0 1 ] * [ 1 0 0; 0 cos(i) -sin(i); 0 sin(i) cos(i)] * ...
   [ cos(SmallOmega) -sin(SmallOmega) 0; sin(SmallOmega) cos(SmallOmega) 0; 0 0 1 ];
Tseu = [ cos(L) 0 -sin(L); 0 1 0; sin(L) 0 cos(L)] * [ cos(Q) sin(Q) 0; -sin(Q) cos(Q) 0; 0 0 1];
ruvw = [ (r * cos(TA)); (r * sin(TA)); 0 ];
Pseu = Tseu*(Txyz*ruvw) - Rseu;
P = (Pseu(1)^2 + Pseu(2)^2 + Pseu(3)^2)^0.5;

El = (asin ( Pseu(3)/P ))/degtorad;
Az = (atan2 ( Pseu(2), -Pseu(1)))/degtorad;
	if Az < 0;
   	Az = 360 + Az;
   end;
   
%Loop begins here  %if El>0;
		
array(j,1) = JD0;
array(j,3) = Az;
array(j,4) = El;
%array(j,5) = cat(year,month,day);
j = j+1;
% loop ends here

JD0 = JD0 + step;
			% Gregorian Date from Julian Date 
			% This calculation is valid for any Julian Day Number including negative JDN and 
			% produces a Gregorian date (or possibly a proleptic Gregorian date)

			Z = floor(JD0 - 1721118.5); % JD0 is the Julian Date in propagation 
			R = (JD0 - 1721118.5 - Z);  % R is the fractional part of JD0
			G = (Z - .25);  
			A = (floor(G / 36524.25));  % Calculate the value of A which is the number of full centuries
			B = (A - (A / 4)); % The value of B is this number of days minus a constant
			year = (floor((B+G) / 365.25)); % Calculate the value of Y, the year in a calendar whose years start on March 1
			C = (B + Z - floor(365.25 * year));  % Day count
         month = (fix((5 * C + 456) / 153));  % Month
         UT = (C - fix((153 * month - 457) / 5) + R); % Calculation for UTC
         day = floor(UT);  % Gregorian Day
                    
						if month > 12; 
		      			year = year + 1 ;
		      			month = month - 12; 
                  end; 
                  UT = UT - floor(UT);
         UT = UT*24;
         hr = floor(UT);   %  hour
         UT = UT-floor(UT);
	      UT =UT* 60;
	      min = floor(UT);  % minute
   	   UT =UT- floor(UT);
      	UT =UT* 60;
         secs = round(UT); % seconds 
         if secs==60;
            min=min+1;
            secs=0;
         end;
         % Gregorian Date conversion algorithm ends here
         
         % computations for printintg two digits in case year,month,day,min and secs is < 10
         % (i.e) to print third month, 3 as 03 and day 5 as 05 etc..
         ZERO=int2str(zero);
			MIN=int2str(min); % converting minute into a string
			if min <10;
		  			 MinNew=strcat(ZERO,MIN);
                  min=MinNew;
               else;
                  min=MIN;
               end;
               
         	DAY=int2str(day); % converting DAY into a string
				 if day <10;
		  				 DayNew=strcat(ZERO,DAY);
                   day=DayNew;
                else;
                  day=DAY;
         	 end;
          HR=int2str(hr); % converting Hour into a string
					if hr <10;
		  				 HrNew=strcat(ZERO,HR);
                   hr=HrNew;
               else;
                 	 hr=HR;
		          end;
                
                MONTH=int2str(month); % converting month into a string
						if month <10;
			  				 MonthNew=strcat(ZERO,MONTH);
   	                month=MonthNew;
            	   else
         	         month=MONTH;
                  end;
                  
                 SECS=int2str(secs); % converting seconds into a string
						if secs <10;
			  				 SecsNew=strcat(ZERO,SECS);
   	                secs=SecsNew;
            	   else
         	         secs=SECS;
			         end;

         % computations for printing two digits ends here!
             
         if El>0; 
            fprintf('\n %f | %f | %f |  %s/%s/%4d  |  %s:%s:%s  |',JD0, Az, El, month,day,year, hr,min,secs);
            %plot(El,Az);
         end;   
end;
fprintf('\n ---------------------------------------------------------------------------\n');
fprintf('\n\t\t\t       End of Output\!!! \n\n\n');
