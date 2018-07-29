function func_ColorCSF
% Show Contrast Sensitive Function (CSF) via color Sinwave stimulus
% This function is part of the toolbox "Basic introduction to HVS"
%
% Command line
% ----------------------
% func_ColorCSF
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


% parameter of Sinwave stimulus
% freq : frequency
% C    : Contrast
% low : step : high
freq = logspace(0.2 , 1 , 100)';
C = logspace(-2, 0 , 100);
L = 100;

x = linspace(-pi, pi, 100); 
y = linspace(1, 100, 100); 
[xx,yy] = meshgrid(x, y); 
[newfreq , newC] = meshgrid(freq, C);


z = L .* (newC .* sin(pi .* newfreq .* xx) + 1); 
imshow(z, []); 

% change colormap according to   A color map matrix may have any number of rows, but it must have
%     exactly 3 columns.  Each row is interpreted as a color, with the
%     first element specifying the intensity of red light, the second 
%     green, and the third blue.
x = linspace(0,1,256);
y = [1 2 3];
[yy, xx] = meshgrid(y, x);
y = zeros(256, 1);
xx(:, 3) = y;
y = xx(:, 2);
xx(:, 2) = y(end : -1 : 1);
 
colormap(xx);
shading interp; 
axis('off');
