function [nudos]=sap2000nudos(filenam)
%programa registrado por MECAVIL ingenieria-ciencia
%bresler_lin@hotmail.com
%carga los nudos del archivo sap2000
%genera cuatros archivos txt
%[filenam pathnam]=recibetodo
%%%%%%%%%%%%%%%%%%           SAP2000 v14           %%%%%%%%%%%%%%%%%%%%%
%pathnam
%filenam
arc=fopen(filenam,'r');
arc;
encuentra =0;
while encuentra==0;
    linea=fgets(arc);
    if not(isempty(findstr('JOINT COORDINATES',linea)));
        encuentra=1;
   end
end
 nudos=[0;0;0;0];
 linea=fgets(arc);
 f=1;
 encuentra=0;
 while encuentra==0;
     [s1 s2 s3 s4 s5 s6 s7] = strread(linea,'%s %s %s %s %s %s %s');
      s1=char(s1);s4=char(s4);s5=char(s5);s6=char(s6);
      v=[s1,s4,s5,s6];
 [e1 e2]=strread(v,'%s %f ', 'delimiter',' =')  ;  
 nudos=[nudos e2(:,1)];
     f=f+1;
     linea=fgets(arc);
     linea;
     if not (isempty(findstr('JOINT PATTERN DEFINITIONS',linea)));
         encuentra=1;
     end
 end
 fclose(arc);
  nudos(:,1)=[];
  nudos=nudos';
xx=nudos(:,2);
yy=nudos(:,3);
zz=nudos(:,4);
%    class(nudos)
save nudos.txt nudos -ASCII
%save quimicaXXX.txt xx -ASCII
%save quimicaYYY.txt yy -ASCII
%save quimicaZZZ.txt zz -ASCII
%  save (nudos, 'nudos', '-ascii')

%%%%%%%%%%%%%%%%%%           SAP2000 v14           %%%%%%%%%%%%%%%%%%%%%