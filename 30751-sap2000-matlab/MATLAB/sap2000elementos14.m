function [ds]=sap2000elementos14(filenam)
%%%%%%%%%%%%%%%%%%           SAP2000 v14           %%%%%%%%%%%%%%%%%%%%%
%programa registrado por MECAVIL ingenieria-ciencia
%bresler_lin@hotmail.com
%%%este programa enumera los elementos y su nudo inicial y final
%arc=fopen('quimica3.$2k','r');
%filenam
arc=fopen(filenam,'r');
arc;
encuentra =0;
while encuentra==0
    linea=fgets(arc);
    if not(isempty(findstr('CONNECTIVITY - FRAME',linea)));
        encuentra=1;
   end
end
 conecc=[0;0;0];
 linea=fgets(arc);
 f=1;
 encuentra=0;
 while encuentra==0;
     [s1 s2 s3 s4 ] = strread(linea,'%s %s %s %s');
      s1=char(s1);s2=char(s2);s3=char(s3);
      v=[s1,s2,s3];
 [e1 e2]=strread(v,'%s %f ', 'delimiter',' =')  ;  
  conecc=[ conecc e2(:,1)];
     f=f+1;
     linea=fgets(arc);
     linea;
     if not (isempty(findstr('COORDINATE SYSTEMS',linea)))
         encuentra=1;
     end
 end
 fclose(arc);
   conecc(:,1)=[];
   conecc= conecc';
    conecc;
  [aw1 aw2]=size( conecc)  
  
  ds=[0 0 0];
  for i=1:1:aw1;
      ds=[ds;conecc(i,:)];
  end
  ds(1,:)=[];
inifr=ds(:,2);
finfr=ds(:,3);
  save elemento.txt ds -ASCII  ;%%%%%LOPUSE por no corregir las inercias
    save conecctividad.txt ds -ASCII  ;
%save quimicainicio.txt inifr -ASCII  ;
%save quimicafin.txt finfr -ASCII  ;