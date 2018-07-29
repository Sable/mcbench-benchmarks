function yprime = pid_ctrl(t,y,er,er1,er2)

T=360; K=14.9;               % System parametrs
Kp = 0.5; Ki = 0.05; Kd = 3; % PID Controller parametrs

yprime = [y(2); ((1/T)*(-y(2)+ K*Kd*er2 + K*Kp*er1 + K*Ki*er))];