
% A program of type script
% Program name is Q609.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'Q609' in the command window.

clear all
clc
disp(' ');
disp('This program answers question 9 of chapter 6')
disp(' ')
disp('----------------------------------------------------------------------')
disp(' ')
disp('To see A and B matrices that are describing the system, press Enter')
pause
disp(' ')
A=[9 8 -5;7 5 6]
B=[3 11]'

disp('The system is underdetermined and has many solutions, to see the basic solution , press Enter')
pause
X=A\B
disp('To see another solution, Press Enter')
pause
X=pinv(A)*B

disp('TO CLEAR SCREEN, PRESS ENTER')
pause
clc
