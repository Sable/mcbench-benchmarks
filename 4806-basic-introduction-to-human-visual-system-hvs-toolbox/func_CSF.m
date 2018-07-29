function func_GrayCSF
% Show Contrast Sensitive Function (CSF) via gray Sinwave stimulus
% This function is part of the toolbox "Basic introduction to HVS"
%
% Command line
% ----------------------
% func_GrayCSF
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
freq = logspace(0.1, 0.9, 100)';
C = logspace(-2, 0, 100);
L = 100;

x = linspace(-1.5 * pi, 0.5 * pi, 100); 
y = linspace(1, 100, 100); 
[xx,yy] = meshgrid(x, y); 
[newfreq , newC] = meshgrid(freq, C);

z = L .* (newC .* sin(2 .* pi .* newfreq .* xx) + 1); 

imshow(z, []);
shading interp; 
axis('off') 