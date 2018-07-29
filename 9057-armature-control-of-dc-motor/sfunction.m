function [sys,x0,str,ts]=abcrtoqdor(t,x,u,flag)
%dfsfgsfdgdghdhdfg
switch flag
    case 0
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 3
        sys=mdlOutput(t,x,u);
    case {1,2,4,9}
        sys=[];
    otherwise 
        error(['Unhandel flag =',num2str(flag)]);
end;
%========================================================================
%========================================================================
function [sys,x0,str,ts]=mdlInitializeSizes
sizes=simsizes;
sizes.NumContStates= 0;
sizes.NumDiscStates= 0;
sizes.NumOutputs= 1;
sizes.NumInputs= 2;
sizes.DirFeedthrough=1;
sizes.NumSampleTimes=1;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[-1 0];
%=========================================================================
%=========================================================================
function sys=mdlOutput(t,x,u);
%=========================================================================
 vc=u(1);
 vm=u(2);
q=(vc*pi)/(3*vm);
if q>1 
    q=1;
end
if q<-1 
    q=-1;
end
a=acos(q);
  sys=a*180/pi;