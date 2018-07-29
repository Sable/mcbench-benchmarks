% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%

% problem 5 
% Graph of t^3*cos(10*pi*t)*p2(t-1)


t=-2:.01:5;

x=(t.^3).*cos(10*pi*t).*(heaviside(t)-heaviside(t-2));

plot(t,x)
