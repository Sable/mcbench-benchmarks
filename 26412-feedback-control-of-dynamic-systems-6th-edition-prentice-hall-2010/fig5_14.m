% Fig. 5.14   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
% script to initiate the RLTOOL like in Example 5.7
% click on Compensator Editor tab
% then right click in Dynamics Box
% add pole, set value to -12. That will produce Fig. 5.14 and the locus
%    in Fig. 5.11
% drag the pole from -12 to -9.   That will produce the RL in Fig. 5.13
% drag the pole from -9 to -4.   That will produce the RL in Fig. 5.12
% Play with the pole location more for your amusement   
% If you had added the compensator pole and zero through the compensartor editor,
%   you could have dragged either one around to see how it affected the RL   

clf
numL=[1 1];
denL=[1 0 0];
sysL=tf(numL,denL);
rltool(sysL)
