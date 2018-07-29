% function runsteamcondenser
% RUNSTEAMCONDENSER  Examples to show how to use the steam condenser model.
% By Yi Cao at Cranfield University on 24 January 2008
% Example 1
%%
K=10.8;                 % PID controller gain
TI=2.56;                % PID controller integral time constant
TD=0;                   % PID controller derivative time constant
u=0;                    % zero for closed loop simulation
sim('SteamCondenser')   % run the model
for k=1:4               % plot results
    subplot(4,1,k);
    plot(y.time,y.signals(k).values,'linewidth',2)
    title(y.signals(k).title)
    grid
end
xlabel('time, s')
%%
%Example 2
% To tune the PID controller through the process reaction curve approach
K=0;TI=1;TD=0;          % make the system open loop
u=1;                    % size od step input test
sim('SteamCondenser')   % run open loop test
[Kp,tau,td]=ReactionCurve(y.time,y.signals(4).values); % Reaction curve
td=td-10;               % adjust time delay from the step test starting time                         
K=-(0.9/Kp)*(tau/td);   % PID tuning based on reaction curve                              
TI=3.3*td;                                            
u=0;                    % closed-loop without test input
sim('SteamCondenser')   % run closed-loop test
for k=1:4               % plot results
    subplot(4,1,k);
    plot(y.time,y.signals(k).values,'linewidth',2)
    title(y.signals(k).title)
    grid
end
xlabel('time, s')
