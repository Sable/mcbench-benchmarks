% This script runs program rundivcrl
% for nine coordinate systems and puts
% the output in rundivcrl.tst
if exist('rundivcrl.tst','file')==2
  delete rundivcrl.tst
end
syms x y z
vxyz=[x*y,y*z,z*x]; 
diary rundivcrl.tst
% rundivcrl(vxyz,cordname,tn,noprint) call list
rundivcrl(vxyz,@cylin,[10*rand,rand*2*pi,rand*10]);
rundivcrl(vxyz,@sphr,[10*rand,rand*pi,rand*2*pi]);
rundivcrl(vxyz,@cone,[2*rand,rand*pi/2,rand*2*pi]);
rundivcrl(vxyz,@elipcyl,[2*rand,rand*2*pi,2*rand]);
rundivcrl(vxyz,@elipsod,[rand,1+rand,2+rand]);
rundivcrl(vxyz,@notort,[2*rand,rand*pi,rand*2*pi]);
rundivcrl(vxyz,@oblate,[2*rand,rand*pi,rand*2*pi]);
rundivcrl(vxyz,@parab,[2*rand,2*rand,2*rand]);
rundivcrl(vxyz,@toroid,[rand*2,rand*2*pi,rand*2*pi]);
diary off