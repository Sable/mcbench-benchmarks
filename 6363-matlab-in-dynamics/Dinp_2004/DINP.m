function dinp
%                   Program DINP starts a Dynamics Package
clc
disp(' ***************************************************************    ')
disp('                        D Y N A M I C S                             ')
disp(' ***************************************************************    ')
disp('                                                                    ')
disp('   The following programs solve the second problem of Dynamics:     ')
disp(' derive differencial equations, resolve them analytically or        ')
disp(' numerically, and plot the relative graphics.                       ')
disp('   There is no necessity to write a procedure-function for the      ')
disp(' derivatives! It is generated automatically.                        ')
disp('   You can choose in-line the most proper Solver to your problem.   ')
disp('   All the data can be input from data files or in-line mode.       ')
disp('   You can run these programs repeatedly with different values      ')
disp(' of some parameters p1, p2, ..., and ini-conditions without         ')
disp(' their restart.                                                     ')
%
n = 0;
while n ~= 9
 disp('                                                                       ')
 disp('                   *****  M E N U  *****                               ')
 disp('  =====================================================================')
 disp('  1. DTX    - rectilinier motion of a particle;                        ')
 disp('  2. DTXY   - planar motion of a particle in Cartesian coordinates;    ')
 disp('  3. DTPC   - planar motion of a particle in polar coordinates;        ')
 disp('  4. ROT    - rotational motion of a body;                             ')
 disp('  5. EKIN   - theorem of the kinetic energy;                           ')
 disp('  6. LAGRE1 - Lagrange equation  for systems with 1 degree  of freedom;')
 disp('  7. LAGRE2 - Lagrange equations for systems with 2 degrees of freedom;')
 disp('  8. LAGREN - Lagrange equations for systems with N degrees of freedom.')                              
 disp('  9. E X I T                                                           ')
 n = input(' Enter number of your choice, please : ');
 if n == 1
     help dtx;
     ans = input('  Start this program ? (Y/N) : ', 's'); disp(' ');
     if ans == 'y' | ans == 'Y', dtx, end;
   elseif n == 2
     help dtxy;
     ans = input('  Start this program ? (Y/N) : ', 's'); disp(' ');
     if ans == 'y' | ans == 'Y', dtxy, end;
   elseif n == 3
     help dtpc;
     ans = input('  Start this program ? (Y/N) : ', 's'); disp(' ');
     if ans == 'y' | ans == 'Y', dtpc, end;
   elseif n == 4
     help rot;
     ans = input('  Start this program ? (Y/N) : ', 's'); disp(' ');
     if ans == 'y' | ans == 'Y', rot, end;
   elseif n == 5
     help ekin;
     ans = input('  Start this program ? (Y/N) : ', 's'); disp(' ');
     if ans == 'y' | ans == 'Y', ekin, end;
   elseif n == 6
     help lagre1;
     ans = input('  Start this program ? (Y/N) : ', 's'); disp(' ');
     if ans == 'y' | ans == 'Y', lagre1, end;
   elseif n == 7
     help lagre2;
     ans = input('  Start this program ? (Y/N) : ', 's'); disp(' ');
     if ans == 'y' | ans == 'Y', lagre2, end;
   elseif n == 8
     help lagren;
     ans = input('  Start this program ? (Y/N) : ', 's'); disp(' ');
     if ans == 'y' | ans == 'Y', lagren, end;
 end
 clc
end