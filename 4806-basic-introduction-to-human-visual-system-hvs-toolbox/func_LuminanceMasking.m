function func_LuminanceMasking
% Show luminance masking effect of HVS
% This function is part of the toolbox "Basic introduction to HVS"
%
% Command line
% ----------------------
% func_LuminanceMasking
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
C = 0.05;
L = 100;

x = linspace(-1.5 * pi, 0.5 * pi, 100); 
y = linspace(150, 50, 100); 
[xx,yy] = meshgrid(x, y); 

i = 1;
for L = 100 : 20 : 200;
	z = L .* C .* sin(2 .* pi .* freq .* xx) + L; 
	imagesc(z);
	colormap gray; 
	shading interp; 
	ch = ['luminancemasking', num2str(i), '.bmp'];
	imwrite(z, gray(256), ch, 'bmp');
	i = i + 1;
end
