function rundynam
% This program is primarily based on examples from
% 'Advanced Mathematics and Mechanics Applications
% Using MATLAB', 3rd Ed., by Howard Wilson, Louis
% Turcotte, and David Halpern, CRC Press, 2002.
opt=100;
while 1 %opt~=13
   clc, close, opt=listcases;
   switch opt   
   case 1  
     disp('NONLINEAR MOTION OF A DAMPED PENDULUM')
     disp('Press return to see two typical cases')
     pause, runpenl(2.421), runpenl(2.41) 
   case 2 
     disp('FORCED RESPONSE OF A VISCOUSLY')
     disp('DAMPED SPRING-MASS SYSTEM')
     disp('Press return to see the motion'), pause
     smdplot; pause(2) 
   case 3 
     disp('MOTION OF A FALLING ELASTIC CHAIN')
     disp('Press return to see the motion'), pause
     runchain; pause(2)   
   case 4 
     stringmo; pause(2)
   case 5 
     disp('WAVES IN A STRING HAVING A TRIANGULAR')
     disp('INITIAL DEFLECTION.')
     disp('Press return to see the motion')
     pause, strngwave; pause(2)   
   case 6 
     disp('WAVES IN A SIMPLY SUPPORTED BEAM HAVING')
     disp('A TRIANGULAR INITIAL DEFLECTION')
     disp('This motion is quite different from what happens in')
     disp('a string because waves of different frequency travel')
     disp('at different speeds in a beam. To see the animation,')
     disp('press return.')
     pause, beamwave; pause(2)
   case 7 
     runtop; pause(2) 
   case 8 
     disp(' ')
     disp('NATURAL VIBRATION MODES OF A PIN CONNECTED TRUSS')
     %disp('Press return to see the first 12 vibration modes')
     disp('Press return to see several vibration modes')
     disp('of a truss.'), pause
     trusvibs; pause(2)      
   case 9 
     disp('NATURAL VIBRATION MODES OF AN ELLIPTIC MEMBRANE')
     disp('The first ten even modes of a membrane with semi-')
     disp('diameters of 1 and 1/2 will be found (the calcu-')
     disp('lation takes awhile). PRESS RETURN TO BEGIN')
     disp(' '), pause
     elipmodes(1,.5,1,11,.01,15,101); pause(2) 
   case 10 
     disp('MOTION OF A RECTANGULAR MEMBRANE WITH')
     disp('AN OSCILLATING CONCENTRATED LOAD')
     disp('Press return to see the animation.'), pause
     rectwave(2,1,1,5,15.5,1.5,.5); pause(2) 
   case 11 
     disp('MOTION OF A CIRCULAR MEMBRANE WITH')
     disp('AN OSCILLATING CONCENTRATED LOAD')
     disp('Press return to see the animation.'), pause
     circwave; pause(2) 
   case 12 
     disp('FORCE MOVING ON A SEMI-INFINITE STRING')
     disp('Press return to see cases where 1) the force')
     disp('moves faster that the wave speed and 2) the ')
     disp('force moves slower than the wave speed.')
     pause, forcmove(.8,1,10,15); pause(2); close
     forcmove(1,.8,10,15); pause(2)
   case 0 
     disp('All done'), disp(' '), return
   otherwise 
     if opt>13|isempty(opt)
       disp('Invalid option'), pause(2), close
     end
   end
end

%=========================================================

function option=listcases
head=sprintf(...
['\n                DYNAMICS EXAMPLES FROM',...
'\n    Advanced Mathematics and Mechanics Applications',...
'\n         Using MATLAB, 3rd Ed., CRC Press, 2003      \n',...
'\nSelect an option:  \n',...
' 1: Nonlinear pendulum motion       2: Forced spring-mass response   \n',...
' 3: Falling elastic chain           4: String shaken at one end      \n',...
' 5: Initially deflected string      6: Initially deflected beam      \n',...
' 7: Spinning top precession         8: Truss vibration modes         \n',...
' 9: Elliptic membrane vibr. modes  10: Waves in a rectangular membr. \n',...
'11: Waves in circular membrane     12: Moving force on a string      \n',...
' 0: Stop                          \n']);
disp(head), option=input(' > ? ');, disp(' ')
