function grafica2000nudos
%%%%%%%%%%%%%%%%%%           SAP2000 v14           %%%%%%%%%%%%%%%%%%%%%
%programa registrado por MECAVIL ingenieria-ciencia
%bresler_lin@hotmail.com
%numera los nudos
%clf
%cla
graficaTRIDIMENSIONAL
[frini frfin elmprp ielmprp conecc inud nud]=frame3dsap2000longitud;
%%%%%%%%%%%%%%%%%%%%%%
%enumeracion frames%%%
%%%%%%%%%%%%%%%%%%%%%%
%M=(frfin(:,[2 3 4])+frini(:,[2 3 4]))./2;
%axis('auto')

%for i=1:1:ielmprp
% text(M(i,1),M(i,2),M(i,3),[{'\color{blue}'} [,int2str( conecc(i,1) ),]],'FontSize',7) 
%end
%%%%%%%%%%%%%%%%%%%%%%
%enumeracion nudos%%%
%%%%%%%%%%%%%%%%%%%%%%
figure(1),hold on
for i=1:1:inud
 text(nud(i,2),nud(i,3),nud(i,4),[{'\color[rgb]{0 0 0}'} [,int2str(nud(i) ),]],'FontSize',8)  
end 
hold off