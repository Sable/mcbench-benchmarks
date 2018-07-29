%% PID Controller tunning using ZN - 'S' curve method
% Input format
% s=1 - for PI;     s = 2 - for PID
% in - Set value
% out - final output value (Settling Value)
% t1 - Time taken to reach 23.8% of setvalue
% t2 - Time taken to reach 63.2% of setvalue


function [O]=ZN_PI_PID(s,in,out,t1,t2)
if nargin~=5
    disp('Not enough Input Argument')
%     disp('Input format')
%     disp('1 - for PI;  2 - for PID')
%     disp('Setvalue')
%     disp('Settling Value')
%     disp('Time taken to reach 23.8% of setvalue')
%     disp('Time taken to reach 63.2% of setvalue')
else
    tau=1.5*(t2-t1);
    td=t2-tau;
    Kp=out/in;
    if s==1
        %% PI Controller
        O.Kc=(.9*tau)/(Kp*td);
        O.Ti=(3.33*td);
        O.Ki=O.Kc/O.Ti;
    elseif s==2
        %% PID Controller
        O.Kc=(1.2*tau)/(Kp*td);
        O.Ti=(2*td);
        O.Ki=O.Kc/O.Ti;
        O.Td=0.5*td;
        O.Kd=O.Kc*O.Td;
    else
       disp('Invalid Choice')
    end
end