function pid2 = pid2pid(pid1,direction)
% PID2PID Convert from Form 2 back to Form 1 of PID controller.
%         PID2PID takes the 3 gains of the Form 1 PID controller and
%         converts them into the gains of the Form 2 PID controller.

% Author: Craig Borghesani
% Date: 11/13/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

if direction == 2,
 Kp = pid1(1);
 Ki = pid1(2);
 Kd = pid1(3);

 KP = max(roots([1, -Kp, Kd*Ki]));
 KI = Ki;
 KD = Kd/KP;

 pid2 = [KP,KI,KD,direction*20];

else

 KP = pid1(1);
 KI = pid1(2);
 KD = pid1(3);

 Kp = KP + KD*KI;
 Ki = KI;
 Kd = KD*KP;

 pid2 = [Kp,Ki,Kd,direction*20];
end

