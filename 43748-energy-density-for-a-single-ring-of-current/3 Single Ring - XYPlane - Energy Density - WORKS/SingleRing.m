
%(c) 2013 The Polywell Guy - http://thepolywellblog.blogspot.com/


function Vector = SingleRing(Point, Parameters)
% The Point is a point listed as [X value, Y value]
% The Line is a struct listed as .Slope and .Xintersection
% The vector is a array listed as [x direction 1, slope]


if isNeg(Point(2))
    RingPoint = [0, -Parameters.a];
else
    RingPoint = [0, Parameters.a];
end

Line = MakeLine(RingPoint, Point);
LineVector = [1,Line.Slope];
XAxisVector = [0,1];

VectorInfo = Quadrant(RingPoint, Point);

angle = FindBigAngle(LineVector, XAxisVector, VectorInfo.Big, ~VectorInfo.Positive);


PolarCoord = struct('z',Point(1),'r',Point(2));


Vector = struct('X',0,'Y',0,'Brad',0,'Bline',0);
Vector.X = cos(angle*0.0174532925);
Vector.Y = sin(angle*0.0174532925);
Vector.Brad = Brad(PolarCoord, Parameters);
Vector.Bline = Bline(PolarCoord,Parameters);

end


function angle = FindBigAngle(vector1, vector2, Big, Negative)
%This function returns the large angle between two vectors listed as [x,y]

if (isinf(vector1(2))||isinf(vector2(2)))
    angle = 180;   
else
    dp = dot(vector1, vector2);
    length1 = sqrt(sum(vector1.^2));
    length2 = sqrt(sum(vector2.^2));
    angle = acos(dp/(length1*length2))*180/pi;
end

if Big
   angle = 180-angle;
end

if Negative
    angle = -angle;
end
end



function line = MakeLine(Point1, Point2)
% returns the X intersection of line, defined by two points
line = struct('Slope', 0, 'Xintersection', 0);
XVal = (Point1(1) - Point2(1));
YVal = (Point1(2) - Point2(2));

slope = YVal/XVal;
line.Xintersection = -(Point2(2)-(Point2(1)*(slope)))/(slope);
line.Slope = slope;
end



function Sol = isNeg(A)
% returns 1 if negative, 0 all else
if isnan(A)
    Sol = 0;
else
    if A < 0
        Sol = 1;
    else
        Sol = 0;
    end
end
end


function Line = Bline(PolarCoord, Parameters)
% This calculates the linear magnetic field for WB-6, RETURNS IN GUASS

a = Parameters.a;
Mu = Parameters.Mu;
I = Parameters.Current*Parameters.Turns;

z = abs(PolarCoord.z);
r = abs(PolarCoord.r);

m = (4*a*r)/(z*z+(a+r)^2);

P1 = ((Mu*I)/(2*pi));
[K,E] = ellipke(m);
Part2 = (m/(4*a*r*r*r))^(1/2);
P3 = ((a*m-(r*(2-m)))/(2-2*m))*E;
P3 = r*K+P3;
Line = P1*Part2*P3*10000;
end



function Rad = Brad(PolarCoord, Parameters)
% This calculates the Radial magnetic field for WB-6, RETURNS IN GUASS
z = abs(PolarCoord.z);
r = abs(PolarCoord.r);


a = Parameters.a;
Mu = Parameters.Mu;
I = Parameters.Current*Parameters.Turns;


m = (4*a*r)/(z*z+(a+r)^2);
[K,E] = ellipke(m);
Part1 = ((2-m)/(2-2*m))*(E-K);
Part2 = (m/(4*a*r*r*r))^(1/2);
Part3 = (Mu*I*z)/(2*pi);
Rad = Part1*Part2*Part3*10000;
end





function VectorInfo = Quadrant(RingPoint, Point)
% This function figures out where the given point is relative to the two
% rings.  There are 8 quadrants, each relative to one of the two ring
% locations.  The vectors must be pointed in different directions in eqch
% quadrant and this function defines that based on wiether the big or small
% angle should be found and if the vector is pointing in the positive or
% negative direction. 

VectorInfo = struct('Interpolate',0,'Big',0,'Positive',0,'Quad',0);

Sel = [0,0,0];
if isNeg(Point(2))
    Sel(1) = 2;
else
    Sel(1) = 1;
end
if isNeg(Point(1)-RingPoint(1))
    Sel(2) = 2;
else
    Sel(2) = 1;
end
if isNeg(Point(2)-RingPoint(2))
    Sel(3) = 2;
else
    Sel(3) = 1;
end

if isequal(Sel,[1,2,1])
  VectorInfo.Quad = 1;
  VectorInfo.Big = 0;
  VectorInfo.Positive = 0;
 
elseif isequal(Sel,[1,1,1])
VectorInfo.Quad = 2;
  VectorInfo.Big = 1;
  VectorInfo.Positive = 1;
  
elseif isequal(Sel,[1,2,2])
VectorInfo.Quad = 3;  
  VectorInfo.Interpolate = 1;
  VectorInfo.Big = 0;
  VectorInfo.Positive = 0;    
         
elseif isequal(Sel,[1,1,2])
VectorInfo.Quad = 4;     
  VectorInfo.Interpolate = 1;
  VectorInfo.Big = 1;
  VectorInfo.Positive = 1;       
         
elseif isequal(Sel,[2,2,1])
VectorInfo.Quad = 5;   
  VectorInfo.Interpolate = 1;
  VectorInfo.Big = 1;
  VectorInfo.Positive = 1;    
  
elseif isequal(Sel,[2,1,1])
VectorInfo.Quad = 6;    
  VectorInfo.Interpolate = 1;
  VectorInfo.Big = 0;
  VectorInfo.Positive = 0;    
  
elseif isequal(Sel,[2,2,2])
VectorInfo.Quad = 7;  
  VectorInfo.Interpolate = 0;
  VectorInfo.Big = 1;
  VectorInfo.Positive = 1;    
  
else
VectorInfo.Quad = 8;       
  VectorInfo.Interpolate = 0;
  VectorInfo.Big = 0;
  VectorInfo.Positive = 0;           
end
end

