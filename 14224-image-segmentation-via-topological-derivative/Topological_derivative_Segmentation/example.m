% 
% LNCC - Laboratório Nacional de Computação Científica.
% Petrópolis, RJ, Brazil, March 2007.
% 
% Permission to use for evaluation purposes is granted provided that 
% proper acknowledgments are given. For a commercial licence, contact 
% nacho@lncc.br or feij@lncc.br.
% 
% This software comes with no warranty, expressed or implied. By way of
% example, but not limitation, we make no representations of warranties
% of merchantability or fitness for any particular purpose or that the
% use of the software components or documentation will not infringe any
% patents, copyrights, trademarks, or other rights.
% 
% The remaining files are copyright Ignacio Larrabide. Permission is
% granted to use the material for noncommercial and research purposes.
% 
imIn = imread('angio.bmp');
imIn = imIn(75:120,80:185);
figure(1);
imshow(imIn);
imOut = Segmentation_Continuum_TD(imIn);
figure(2);
imshow(imOut);
imOut = Segmentation_Discrete_TD(imIn);
figure(3);
imshow(imOut);

