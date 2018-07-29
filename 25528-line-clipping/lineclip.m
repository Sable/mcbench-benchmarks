% AUTHOR :   CHANDAN KUMAR
% SUBJECT:   COMPUTER GRAPHICS AND SOLID MODELLING.
% TITLE  :   LINE CLIPPING ALGORITHM (CYRUS BECK )
% DATE   :   31/08/09
function lineclip()
clc, clear all;
x = input('Give coord[ x0 y0 x1 y1]: ');
v = input('Give Viewport coord[vx0 vy0 vx1 vy1]: ');    
d = [(x(3)-x(1)) (x(4)-x(2)) -(x(3)-x(1))  -(x(4)-x(2))]; 
for i = 1:4
    if (i==1)||(i==3)
        j =1;
    else
        j =2;
    end
    t(i) = (v(i)-x(j))/d(j);
end
tl = min(t(1),t(3));
ti = max(t(2),t(4));
         
z(1) = x(1) +d(1)*ti ;   % x coord of clipped line
z(3) = x(1) +d(1)*tl ;   % end X coord of clipped line
z(2) = x(2) +d(2)*ti ;
z(4) = x(2) +d(2)*tl ;

plot([z(1) z(3)] ,[z(2) z(4)],'r-','LineWidth',2);   % Plots Clipped line
hold on,grid on
plot([v(1) v(1)] ,[v(2) v(4)],'b-','LineWidth',2);   % Plots Viewport
plot([x(1) z(3)],[x(2) z(4)],'k-');                  % Plots Unclipped line
legend('Clipped line','Viewport','Unclipped line',3)
plot([z(1) x(3)],[z(2) x(4)],'k-');                  % Plots Unclipped line
plot([v(1) v(3)] ,[v(2) v(2)],'b-','LineWidth',2);   % Plots Viewport
plot([v(3) v(3)] ,[v(2) v(4)],'b-','LineWidth',2);   % Plots Viewport
plot([v(1) v(3)] ,[v(4) v(4)],'b-','LineWidth',2);   % Plots Viewport
axis([v(1)-1 v(3)+1 v(2)-1 v(4)+1]);
title('Line clipping by Cyrus Beck algorithm')