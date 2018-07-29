function func_ContrastMasking
% Show Contrast masking effect of HVS
% This function is part of the toolbox "Basic introduction to HVS"
%
% Command line
% ----------------------
% func_ContrastMasking
% input:  None
%
% output: CSF figure
%
% More information can be found in 
% S. E. Palmer, "Vision Science: From Photons to Phenomenology," MIT Press,
% Cambridge, MA, 1999.
%
%
% Jing Tian Apr.24 2004
% Contact me : scuteejtian@hotmail.com
% Homepage : http://ikanchi.yeah.net
% This program is written in Apr.2003 during my postgraduate in 
% NTU, Singapore.
% ----------------------


freq = 1;
C = 0.3;
L = 100;

x = linspace(- 1.5 * pi, 0.5 * pi, 100); 
y = linspace(1, 100, 100); 
[xx,yy] = meshgrid(x, y); 

z1 = L .* (C .* sin(2 .* pi .* freq .* xx) + 1); 
imwrite(z1, gray(256), 'contrastmasking1.bmp', 'bmp');

d = 0.1;
C = C + d;

z2 = L .* (C .* sin(2 .* pi .* freq .* xx) + 1); 
imwrite(z2, gray(256), 'contrastmasking2.bmp', 'bmp');

C = 0.6
z3 = L .* (C .* sin(2 .* pi .* freq .* xx) + 1); 
imwrite(z3, gray(256), 'contrastmasking3.bmp', 'bmp');

C = C + d;
z4 = L .* (C .* sin(2 .* pi .* freq .* xx) + 1); 
imwrite(z4, gray(256), 'contrastmasking4.bmp', 'bmp');
