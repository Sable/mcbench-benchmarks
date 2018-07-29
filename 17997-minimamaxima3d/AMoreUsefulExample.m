%This is a more real-life example

load DataTest; %load some simulation data for acoustic pressure coming from a focused device

h1=figure;
subplot(1,2,1);

 [X,Y,Z]=meshgrid(Rx,Ry,Rz);
 pf = abs(uf); 

[Maxima,MaxPos,Minima,MinPos]=MinimaMaxima3D(pf,1,0,10,10); %We find the first 10 minima and maxima

ufa=20*log10(abs(uf)/max(abs(uf(:))));

is=isosurface(X,Y,Z,ufa,-6); %we display the focused pressure at -6dB
patch(is,'facecolor','red','edgecolor','none');
view(24,28);
lighting gouraud;
camlight;
daspect([1 1 1]);
title(sprintf('(%3.1f,%3.1f,%3.1f) mm',CoordinatesToEval(nc,1)*1000, CoordinatesToEval(nc,2)*1000,CoordinatesToEval(nc,3)*1000));
xlabel('x (mm)');
ylabel('y (mm)');
zlabel('z (mm)');
for nm=1:5
   %we display the location of the maxima, note that for my needs I
   %switched X<->Y 
   posmax=[Rx(MaxPos(nm,2)),Ry(MaxPos(nm,1)),Rz(MaxPos(nm,3))];
   line([posmax(1)-1 posmax(1)+1],[posmax(2) posmax(2)],[posmax(3) posmax(3)],'linewidth',1,'color','b');
   line([posmax(1) posmax(1)],[posmax(2)-1 posmax(2)+1],[posmax(3) posmax(3)],'linewidth',1,'color','b');
   line([posmax(1) posmax(1)],[posmax(2) posmax(2)],[posmax(3)-1 posmax(3)+1],'linewidth',1,'color','b');
   TT=['\bf \leftarrow ' char(nm+96)];
   Align='Cap';
   FSize=12;
   text(posmax(1),posmax(2),posmax(3),TT,'FontSize',FSize,'color','b','VerticalAlignment',Align,'Tag','IgnoreReFormatting','HorizontalAlignment','center');
end
grid on;
subplot(1,2,2);

xlim([0 10]);
ylim([0 10]);
daspect([1 1 1]);

TT={};
TT{1}='First 5 Maxima';
for nm=1:5
    posmax=[Rx(MaxPos(nm,2)),Ry(MaxPos(nm,1)),Rz(MaxPos(nm,3))];
    TT{nm+1}= [char(nm+96) sprintf(': %4.3f%',Maxima(nm)) ', X=' sprintf('%2.1f, ',posmax(1)) ', Y=' sprintf('%2.1f',posmax(2)) ', Z=' sprintf('%2.1f',posmax(3))]; 
end
Align='Cap';
FSize=12;

t1=text(-1.5,7,TT,'FontSize',FSize,'color','k','VerticalAlignment',Align,'BackgroundColor','w','Edgecolor','k','Margin',4);
set(gca,'visible','off');
set(t1,'visible','on');

%at end, you should see three iosurfaces, where in each isosurface we can
%see that global maxima is inside the -6dB region (as expected for my
%needs) and we can see that the other 4 maxima are located oustide this
%region (what for me is also expected).