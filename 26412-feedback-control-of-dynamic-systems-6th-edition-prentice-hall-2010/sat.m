%  Function sat      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
function y=sat(x);
% sat is the saturation function with unit limits and unit slope.
if x>1
y=1;
elseif x<-1 
y=-1;
else 
y=x;
end
