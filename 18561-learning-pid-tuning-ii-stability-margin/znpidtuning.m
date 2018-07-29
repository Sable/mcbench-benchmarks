function [k,ku,pu]=znpidtuning(g,ctype)
% ZNPIDTUNING   Ziegler-Nichols PID tuning tool
% [k,ku,pu] = znpidtuning(g,type) returns a pid controller based the famous
% Ziegler-Nichols tuning rule.
% Inputs:
%    g: the palnt model in a lti object (control system toolbox)
% type: controller type: 1) P-controller, 2) PI-controller, 3) PID-controller
% Outputs:
%    k: structured controller parameters
%   ku: ultimate gain
%   pu: ultimate period
%
% Example: PI controller for a first-order plus time-delay system
%{
T=10;
dt=2;
G=tf(1,[T 1]);
G.InputDelay=dt;    % the plant
k=znpidtuning(G,2); 
C=k.kc*(1+tf(1,[k.ti 0]));  % the PI-controller
H=minreal(feedback(ss(G*C),1)); % the closed loop transfer function
step(H)
%}
% By Yi Cao at Cranfield University on 31st January 2008
%

%Input check
error(nargchk(1,2,nargin));
if ~isa(g,'lti')
    error('The plant model is not a LTI object.')
end
% default type is PI-controller
if nargin<2
    ctype=2;
end
% first let us get stability margins
[Gm,Pm,Wcg]=margin(g);
% If we increase the gain by the Gm, the system is critically stable. Hence
% the ultimate gain in dB equals to the gain margin, i.e.
% 20 * log10(ku) = Gm, hence:
% ku=10^(Gm/20);
% In Control System Toolbox, the gain margin is shown in dB in the graph,
% but returns in normal ratio.
ku=Gm;
% If we increase the gain by ku, the system will ocsillate at Wcg
% frequency, hence
pu=2*pi/Wcg;
% Controller parameters based on Ziegler-Nichols' tuning rule
switch ctype
    case 1              % P-controller
        k.kc=ku/2;
    case 2              % PI-controller
        k.kc=ku/2.2;
        k.ti=pu/1.2;
    case 3              % PID-controller
        k.kc=ku/1.7;
        k.ti=pu/2;
        k.td=pu/8;
end

