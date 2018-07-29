function PlotBezier1(Px,Py,n)

% calling function to get parametrix values of bezier curve
[Qx,Qy]=CubicBezier1(Px,Py,n);

%%%%% PLOTTING SECTION %%%%%%%%
plot(Qx,Qy,'LineWidth',2);      %Qx(t) vs Qy(t)

plot(Px,Py,'ro','LineWidth',2); %control points
plot(Px,Py,'g:','LineWidth',2); %control polygon

axis square

%%%%% PLOTTING SECTION %%%%%%%%

% % % --------------------------------
% % % Author: Dr. Murtaza Khan
% % % Email : drkhanmurtaza@gmail.com
% % % --------------------------------
