function speed=score2speed(score,game_type)
% speed is time step

if score>1000
    score=mod(score,1000)+700;
end

score=10*floor(score/10);

a=-984.8988;

b1=1.8513e+004;
b2=1.3580e+004;

% 100,200, ... points:
%px=0:100:1000;
s1=floor(score/100);
px1=s1;
px2=(s1+1);
py1=a*px1+b1;
py2=a*px2+b2; %b1<b2

sp1=interp1([px1 px2],[py1 py2],score/100);

speed=sp1/44100;

% speed=0;
% speed=0.3*speed;
if speed<0
    speed=0;
end

if game_type~=1
    speed=speed-0.08;
end



