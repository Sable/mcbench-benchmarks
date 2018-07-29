function graficaTRIDIMENSIONAL
[frini frfin elmprp ielmprp conecc inud nud]=frame3dsap2000longitud;
%%%%%%%%%%%%%%%%%%           SAP2000 v14           %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
%%graficando frames%%%
%%%%%%%%%%%%%%%%%%%%%%
rr=[frini(:,2),frfin(:,2)];
tt=[frini(:,3),frfin(:,3)];
uu=[frini(:,4),frfin(:,4)];
%axis equal  %% esta modifica el gui generaba el eje

figure(1),hold on
for i=1:1:ielmprp
plot3(rr(i,:),tt(i,:),uu(i,:),'Color',[1 0 0]);
%close(figure(1));
end
view([39 26])
hold off  
axis('equal')