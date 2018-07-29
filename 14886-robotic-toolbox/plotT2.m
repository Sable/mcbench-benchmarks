%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%input: 2 subsequent transformation matrixs
%%output: a figure representing position and orientation
%%of both frames with a green link connecting their origin

function plotT2(Tprev,Tnext)

plotT(Tprev);
plotT(Tnext)

px1=Tprev(1,4);
py1=Tprev(2,4);
pz1=Tprev(3,4);


px2=Tnext(1,4);
py2=Tnext(2,4);
pz2=Tnext(3,4);
hold on
grid on
%%plot 
line([px1,px2],[py1,py2],[pz1,pz2],'LineWidth',2,'Color','green','Tag','n');
xlabel('x');
ylabel('y');
zlabel('z');
title('T position and orientation');
hold off
end