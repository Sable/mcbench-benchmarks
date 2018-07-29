function [C,fval]=optimPID(G,ctype,idx)
% OPTIMPID  Optimal PID tuning based on integral performance criteria
%
% [C,fval]=optimPID(G,ctype,idx) returns the optimal PID paraters based on
% specified controller type and performance criterion.
%
% Inputs:
%               G: The plant model as an LTI object
%           ctype: Controler type (1 = P, 2* = PI, 3 = PID)
%             idx: Performance criterion
%                  1  - ISE
%                  2  - IAE
%                  3  - ITSE
%                  4* - ITAE
% Outputs:
%               C: Controller transfer function as an LTI object
%            fval: optimal performance criterion
% Example:
%{
G=tf(1,[1 6 11 6 0]);
C1=optimPID(G,3,1);   % PID-Control, ISE index
C2=optimPID(G,3,2);   % PID-Control, IAE index
C3=optimPID(G,3,3);   % PID-Control, ITSE index
C4=optimPID(G,3,4);   % PID-Control, ITAE index
K=znpidtuning(G,3);   % Ziegler-Nichols stability margin tuning
t=0:0.1:30;
y1=step(feedback(C1*G,1),t);
y2=step(feedback(C2*G,1),t);
y3=step(feedback(C3*G,1),t);
y4=step(feedback(C4*G,1),t);
y=step(feedback(G*(K.kc*(1+tf(1,[K.ti 0])+tf([K.td 0],1))),1),t);
plot(t,y1,t,y2,t,y3,t,y4,t,y,'--','Linewidth',2)
legend('ISE','IAE','ITSE','ITAE','Z-N')
grid
%}
% By Yi Cao at Cranfield University on 8th Feb 2008
%

% Check inputs and outputs
error(nargchk(1,3,nargin));
error(nargoutchk(0,3,nargout));
assert(isa(G,'lti'),'G must be an LTI object.');

% default setting
if nargin<3
    idx=4;
end
if nargin<2
    ctype=2;
end
% Initial parameters using stability based tuning
[Gm,Pm,Wcg]=margin(G);
pu=2*pi/Wcg;
ku=Gm;
x=ku/2;
den=1;
if ctype==2
    x=ku/2.2*[1 1.2/pu];
    den=[1 0];
elseif ctype==3
    x=ku*2/pu/1.7*[pu/8 1 2/pu];
    den=[1 0];
end
% closed-loop response of initial tuning to find dt and tend
[y,t]=step(feedback(tf(x,den)*G,1));
% reduce dt by half for possible improvement in response speed
dt=(t(2)-t(1))/2;
% exptend tend twice to ensure closed-loop stability
t=0:dt:t(end)*2;
% redefine cost function to facilitate optimization 
cost = @(x) iecost(x,G,den,t,dt,idx);
opt=optimset('display','off','TolX',1e-9,'TolFun',1e-9,'LargeScale','off');
flag=0;
while ~flag % if flag=0 restart optimization from current solution
    [x,fval,flag]=fminunc(cost,x,opt); 
end
% the transfer function of optimal PID controller
C=tf(x,den);

function J=iecost(x,G,den,t,dt,idx)
% control error of step response
e=1-step(feedback(G*tf(x,den),1),t);
% performance calculation
switch idx
    case 1  % ISE
        J=e'*e*dt;
    case 2  % IAE
        J=sum(abs(e)*dt);
    case 3  % ITSE
        J=(t.*e'*dt)*e;
    case 4  % ITAE
        J=sum(t'.*abs(e)*dt);
end
