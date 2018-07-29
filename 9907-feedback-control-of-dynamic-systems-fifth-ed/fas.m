%  Figure 9.54      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
function y = fas(u)
if u < 0.0606,
   y = 0.1 ;
elseif u < 0.0741, 
   y = 0.1 + (u-0.0606)*20; 
else y = 0.9;
end