function grafica2000frame
%%%%%%%%%%%%%%%%%%           SAP2000 v14           %%%%%%%%%%%%%%%%%%%%%
%programa registrado por MECAVIL ingenieria-ciencia
%bresler_lin@hotmail.com
%numera los frames
%clf
graficaTRIDIMENSIONAL

[frini frfin elmprp ielmprp conecc inud nud]=frame3dsap2000longitud;
%%%%%%%%%%%%%%%%%%%%%%
%enumeracion frames%%%
%%%%%%%%%%%%%%%%%%%%%%
M=(frfin(:,[2 3 4])+frini(:,[2 3 4]))./2;
axis('equal')
figure(1),hold on
for i=1:1:ielmprp
 text(M(i,1),M(i,2),M(i,3),[{'\color{blue}'} [,int2str( conecc(i,1) ),]],'FontSize',7) 
end
hold off
