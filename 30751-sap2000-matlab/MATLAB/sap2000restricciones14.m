function [restricciones]=sap2000restricciones14(filenam)
%%%%%%%%%%%%%%%%%%           SAP2000 v14           %%%%%%%%%%%%%%%%%%%%%
%programa registrado por MECAVIL ingenieria-ciencia
%bresler_lin@hotmail.com
%%% el primera columna es la de los nudos y las seis restantes son de
%clear
%clc
arc=fopen(filenam,'r');
arc;
encuentra =0;
while encuentra==0
    linea=fgets(arc);
    if not(isempty(findstr('JOINT RESTRAINT ASSIGNMENTS',linea)));
        encuentra=1;
   end
end
% nudosrest=[0;0;0;0;0;0;0];
 linea=fgets(arc);
 f=1;
 encuentra=0;
 joi=[0];
 pp2=[0,0,0,0,0,0];
 while encuentra==0;
[s11 s12 s13 s14 s15 s16 s17] = strread(linea,'%s %s %s %s %s %s %s');
s11=char(s11);
s11;
[e11 e22]=strread(s11,'%s %f', 'delimiter','=');%ok
joi=[joi;e22];%ok
s12=char(s12);s13=char(s13);s14=char(s14);
s15=char(s15);s16=char(s16);s17=char(s17);
v=[s12,s13,s14,s15,s16,s17];
[e113 e223 ]=strread(v,'%s %[YesNo]', 'delimiter','=');
[fp1 fp2]=size(e223);
e223=e223';
e223;
pp=[0];

for i=1:1:fp1
     po=strcmp('Yes',e223(i));
     pp=[pp po];
end
pp(:,1)=[];
pp;
 pp2=[pp2;pp];

     f=f+1;
     linea=fgets(arc);
     linea;
%ojo tener cuidado si no se incluso     
     if not (isempty(findstr('TABLE:',linea)))
         encuentra=1;
     end
 end
 fclose(arc);

pp2(1,:)=[];
joi(1,:)=[];
joi;
pp2;

restricciones=[joi pp2];
restricciones
save restricciones.txt restricciones -ASCII ;

