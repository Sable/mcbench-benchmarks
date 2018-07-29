function [frini frfin elmprp ielmprp conecc inud nud]=frame3dsap2000longitud
%%%%%%%%%%%%%%%%%%           SAP2000 v14           %%%%%%%%%%%%%%%%%%%%%
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%Entrada con txt%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nud= load('nudos.txt');
%nud
%[nudos]=sap2000nudos
[inud jnud]=size(nud);
conecc=load('conecctividad.txt');
%ds=sap2000elementos
[iconecc jconecc]=size(conecc);
rest=load('restricciones.txt');
%[restricciones]=sap2000restricciones
[irest jrest]=size(rest);
elmprp=load('elemento.txt');
%[finlfram]=sap2000framematiner
%elmprp
[ielmprp jelmprp]=size(elmprp);
%%%%%%%%%%%%%%%%%%%%%%
%hallando la longitud%
%%%%%%%%%%%%%%%%%%%%%%
frini=[0 0 0 0];
frfin=[0 0 0 0];
%primero ordenamos inicio
%frini=zeros(ielmprp,4);
%frfin=zeros(ielmprp,4);
for j=1:1:ielmprp   
   for i=1:1:inud
       if conecc(j,2)==nud(i,1);
      frini=[frini;nud(i,:)];%[2,3]
       end
       if conecc(j,3)==nud(i,1);
      frfin=[frfin;nud(i,:)];%[2,3]
       end
   end
end
 frini(1,:)=[];  
 frfin(1,:)=[];


