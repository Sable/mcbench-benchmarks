function averagingOfAnglesDemo
%
%       Robert Goldstein
%       Schepens Eye Research Institute
%       robert.goldstein@schepens.harvard.edu
%
%       this program solves the problems associated with averaging of
%       angles.
%       It incorporates three other functions
%           convertDegToRadians
%           convertRadToDegrees
%           shiftAnglesFromMinusPIToPI
%           AverageAnglesRadians
%
%           this driver program starts with angles measured from 0 to 360
%           degrees.  It then sets up several sets of 3 angles each, around
%           the problematic sections (cardinal directions) and averages
%           them to show we get the correct average
%
set1 = [359,0,1];  %should averge to zero degrees
set2 = [89, 90, 91] ;  %should average to 90 degrees
set3 = [179,180,181]; %should average to 180 degrees
set4 = [269, 270, 271]; %should average to -90 degrees
%
%           the below sets are the same as the above 4 sets, but in the
%           coordinate system ALREADY in -pi to +pi.  These programs should
%           work for those as well.
set5 = [-1,0, 1];  %should averge to zero degrees
set6 = [89, 90, 91] ;  %should average to 90 degrees
set7 = [179,180,-179]; %should average to 180 degrees
set7a = [-179,-178,-177]; %should average to -178 degrees
set8 = [-91, -90, -89]; %should average to -90 degrees


%       the below are widely separated angles
set9 = [0 90 180 270 360 ];  %should be zero average
set10 = [90 270];  %should be zero
set11 = [ 0 90 180 ]; % should be 90 or pi/4
set11a = [  0 -90 -180  ]; % should be -90 or -pi/2
set11b = [0 180];  %should average 90 or pi.
set12 = [0 270 180]; % should be -pi/2 or -90

%set1 = [359,0,1];  %should averge to zero degrees
set1 = convertDegToRadians(set1);
set1 = shiftAnglesFromMinusPIToPI(set1);
average = AverageAnglesRadians(set1);
%       average should be zero to 15 places
if(abs(average) > 1.e-15) 
    error('average is not zero');
else
    display('set1 [359,0,1] average correcct')
end

%set2 = [89, 90, 91] ;  %should average to 90 degrees
set2 = convertDegToRadians(set2);
set2 = shiftAnglesFromMinusPIToPI(set2);
average = AverageAnglesRadians(set2);
average = convertRadToDegrees(average);
%       average should be 90 to 13 places
if(abs(average-90) > 1.e-13) 
    error('set2 [89, 90, 91] average IS NOT 90');
else
    display('set2 [89, 90, 91] average correcct')
end


%set3 = [179,180,181]; %should average to 180 degrees
set3 = convertDegToRadians(set3);
set3 = shiftAnglesFromMinusPIToPI(set3);
average = AverageAnglesRadians(set3);
average = convertRadToDegrees(average);
%       average should be 180 OR -180 to 13 places
if(abs(average)-180 > 1.e-13) 
    error('set3 [179,180,181] average IS NOT 180');
else
    display('set3 [179,180,181] average correcct')
end


%set4 = [269, 270, 271]; %should average to 270 OR -90 degrees
set4 = convertDegToRadians(set4);
set4 = shiftAnglesFromMinusPIToPI(set4);
average = AverageAnglesRadians(set4);
average = convertRadToDegrees(average);
%       average should be -90  to 13 places
if(abs(average+90) > 1.e-13) 
    error('set4 [269, 270, 271] average IS NOT -90');
else
    display('set4 [269, 270, 271] average correcct')
end

%set5 = [-1,0, 1];  %should averge to zero degrees
set5 = convertDegToRadians(set5);
set5 = shiftAnglesFromMinusPIToPI(set5);
average = AverageAnglesRadians(set5);
average = convertRadToDegrees(average);
%       average should be 0  to 13 places
if(abs(average) > 1.e-13) 
    error('set5 = [-1,0, 1] average IS NOT 0');
else
    display('set5 [-1,0, 1] average correcct')
end

%set6 = [89, 90, 91] ;  %should average to 90 degrees
set6 = convertDegToRadians(set6);
set6 = shiftAnglesFromMinusPIToPI(set6);
average = AverageAnglesRadians(set6);
average = convertRadToDegrees(average);
%       average should be 90  to 13 places
if(abs(average-90) > 1.e-13) 
    error('set6 = [89, 90, 91] average IS NOT 90');
else
    display('set6 [89, 90, 91] average correcct')
end

%set7 = [179,180,-179]; %should average to 180 degrees
set7 = convertDegToRadians(set7);
set7 = shiftAnglesFromMinusPIToPI(set7);
average = AverageAnglesRadians(set7);
average = convertRadToDegrees(average);
%       average should be 180 or -180 to 13 places
if(abs(average)-180 > 1.e-13) 
    error('set7 = [179,180,-179] average IS NOT 180');
else
    display('set7 [179,180,-179] average correcct')
end

%set7a = [-179,-178,-177]; %should average to -178 degrees
set7a = convertDegToRadians(set7a);
set7a = shiftAnglesFromMinusPIToPI(set7a);
average = AverageAnglesRadians(set7a);
average = convertRadToDegrees(average);
%       average should be 180 or -180 to 13 places
if(abs(average+178) > 1.e-13) 
    error('set7a = [-179,-178,-177] average IS NOT -178');
else
    display('set7a [-179,-178,-177] average correcct')
end

%set8 = [-91, -90, -89]; %should average to -90 degrees
set8 = convertDegToRadians(set8);
set8 = shiftAnglesFromMinusPIToPI(set8);
average = AverageAnglesRadians(set8);
average = convertRadToDegrees(average);
%       average should be -90 to 13 places
if(abs(average+90) > 1.e-13) 
    error('set8 = [-91, -90, -89] average IS NOT -90');
else
    display('set8 [-91, -90, -89] average correcct')
end

%           NOTE FIVE ANGLES !!!
%set9 = [0 90 180 270 360];  %should be zero average
set9 = convertDegToRadians(set9);
set9 = shiftAnglesFromMinusPIToPI(set9);
average = AverageAnglesRadians(set9);
average = convertRadToDegrees(average);
%       average should be 0 to 13 places
if(abs(average) > 1.e-13) 
    error('set9 = [0 90 180 270 360] average IS NOT 0');
else
    display('set9 [0 90 180 270 360] average correcct')
end

%set10 = [90 270];  %should be zero or pi
set10 = convertDegToRadians(set10);
set10 = shiftAnglesFromMinusPIToPI(set10);
average = AverageAnglesRadians(set10);
average = convertRadToDegrees(average);
%       average should be 0 to 13 places
if(abs(average) > 1.e-13) 
    error('set10 = [90 270] average IS NOT 0');
else
    display('set10 [90 270] average correcct')
end

%set11 = [  0 90 180  ]; % should be 90 or pi/2
set11 = convertDegToRadians(set11);
set11 = shiftAnglesFromMinusPIToPI(set11);
average = AverageAnglesRadians(set11);
average = convertRadToDegrees(average);
%       average should be 90 to 13 places
if(abs(average-90) > 1.e-13) 
    error('set11 = [0 90 180] average IS NOT 90');
else
    display('set11 [0 90 180] average correcct')
end

%set11a = [  0 -90 -180  ]; % should be -90 or -pi/2
set11a = convertDegToRadians(set11a);
set11a = shiftAnglesFromMinusPIToPI(set11a);
average = AverageAnglesRadians(set11a);
average = convertRadToDegrees(average);
%       average should be -90 to 13 places
if(abs(average+90) > 1.e-13) 
    error('set11a = [0 -90 -180] average IS NOT -90');
else
    display('set11a [0 -90 -180] average correcct')
end


%set11b = [0 180];  %should average 90 or pi.
set11b = convertDegToRadians(set11b);
set11b = shiftAnglesFromMinusPIToPI(set11b);
average = AverageAnglesRadians(set11b);
average = convertRadToDegrees(average);
%       average should be 90 to 13 places
if(abs(average-90) > 1.e-13) 
    error('set11b = [0 180] average IS NOT 90');
else
    display('set11b [0 180] average correcct')
end

%set12 = [0 270 180]; % should be -pi/2 or 270 or -90
set12 = convertDegToRadians(set12);
set12 = shiftAnglesFromMinusPIToPI(set12);
average = AverageAnglesRadians(set12);
average = convertRadToDegrees(average);
%       average should be 270 to 13 places
if(abs(average+90) > 1.e-13) 
    error('set12 = [0 270 180] average IS NOT -90');
else
    display('set12 [0 270 180] average correcct')
end



end

