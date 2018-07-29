function [year,month,day,hour,minu,sec,dayweek,dategreg] = julian2greg(JD)
% ______________________________________________________________________________________________
% This function converts the Julian dates to Gregorian dates.
%
% 0. Syntax:
% [day,month,year,hour,min,sec,dayweek] = julian2greg(JD)
%
% 1. Inputs:
%     JD = Julian date.   
%
% 2. Outputs:
%     year, month, day, dayweek = date in Gregorian calendar.
%     hour, min, sec = time at universal time.
%
% 3. Example:
%  >> [a,b,c,d,e,f,g,h] = julian2greg(2453887.60481)
%  a = 
%     2006      
%  b =
%     6
%  c =
%     1
%  d =
%     2
%  e =
%     30
%  f =
%     56
%  g = 
%     Thursday
%  h =
%       1     6     2006     2     30     56
%
% 4. Notes:
%     - For all common era (CE) dates in the Gregorian calendar.
%     - The function was tested, using  the julian date converter of U.S. Naval Observatory and
%     the results were similar. You can check it.
%     - Trying to do the life... more easy with the conversions.
%
% 5. Referents:
%     Astronomical Applications Department. "Julian Date Converter". From U.S. Naval Observatory.
%               http://aa.usno.navy.mil/data/docs/JulianDate.html
%     Duffett-Smith, P. (1992).  Practical Astronomy with Your Calculator.
%               Cambridge University Press, England:  pp. 8,9.
%
% Gabriel Ruiz Mtz.
% Jun-2006
% ____________________________________________________________________________________________

error(nargchk(1,1,nargin))

I = floor( JD + 0.5);
Fr = abs( I - ( JD + 0.5) );	 

if I >= 2299160 
     A = floor( ( I- 1867216.25 ) / 36524.25 );
     a4 = floor( A / 4 );
     B = I + 1 + A - a4;
else
     B = I;
end 

C = B + 1524;
D = floor( ( C - 122.1 ) / 365.25 );
E = floor( 365.25 * D );
G = floor( ( C - E ) / 30.6001 );
day = floor( C - E + Fr - floor( 30.6001 * G ) );

if G <= 13.5 
    month = G - 1;
else
    month = G - 13;
end

if month > 2.5
    year = D - 4716;
else
    year = D - 4715;
end

hour = floor( Fr * 24 );
minu = floor( abs( hour -( Fr * 24 ) ) * 60 );
minufrac = ( abs( hour - ( Fr * 24 ) ) * 60 ); 
sec = ceil( abs( minu - minufrac ) * 60);
AA = ( JD + 1.5 ) / 7;
nd = floor( (abs( floor(AA) - AA ) ) * 7 );
dayweek ={ 'Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday'};
dayweek = dayweek{ nd+1};
format('long', 'g');
dategreg = [ day month year hour minu sec ];
	   
