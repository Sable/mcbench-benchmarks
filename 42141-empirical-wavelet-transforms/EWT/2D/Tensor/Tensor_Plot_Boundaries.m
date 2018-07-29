function Tensor_Plot_Boundaries(f,BR,BC)

%========================================================
% function Tensor_Plot_Boundaries(f,BR,BC)
%
% This function plot the boundaries detected for both 
% the rows and columns and the log of the spectrum of
% the input image
%
% Inputs:
%   -f: input image
%   -BR: list of boundaries for the rows
%   -BC: list of boundaries for the columns
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%========================================================
color='white';
figure;
imshow(log(1+abs(fftshift(fft2(f)))),[]);
[r,c]=size(f);

%plot the vertical boundaries
for i=1:length(BR)
   hold on
   p1 = [1 round(c*0.5*(1+BR(i)/pi))];
   p2 = [r round(c*0.5*(1+BR(i)/pi))];
   plot([p1(2),p2(2)],[p1(1),p2(1)],'Color',color,'LineWidth',2)
   hold on
   p1 = [1 round(c*0.5*(1-BR(i)/pi))];
   p2 = [r round(c*0.5*(1-BR(i)/pi))];
   plot([p1(2),p2(2)],[p1(1),p2(1)],'Color',color,'LineWidth',2)
end

%plot the horizontal boundaries
for i=1:length(BC)
   hold on
   p1 = [round(r*0.5*(1+BC(i)/pi)) 1];
   p2 = [round(r*0.5*(1+BC(i)/pi)) c];
   plot([p1(2),p2(2)],[p1(1),p2(1)],'Color',color,'LineWidth',2)
   hold on
   p1 = [round(r*0.5*(1-BC(i)/pi)) 1];
   p2 = [round(r*0.5*(1-BC(i)/pi)) c];
   plot([p1(2),p2(2)],[p1(1),p2(1)],'Color',color,'LineWidth',2)
end