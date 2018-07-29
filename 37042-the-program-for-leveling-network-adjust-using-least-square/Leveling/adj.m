%This m code adjust the value and output the result 
%filename=input file 
%output=output file 
%This program write by Renoald
%Any questions or error in this program please email to Renoald@live.com
function    adj(filename,output)
[ben,V1]=benmark(filename);%ben=bnckmark V=benmark value 
[sta1,sta2,V,std]=station(filename);%sta1 and sta1 -stn1 and 2 V=value std=standard deviation
n=length(V1);
fid=fopen(output,'w');
fprintf(fid,'Benchmark\n');
fprintf(fid,'station    Elevation value\n')
%fprintf('number of benchmark:%d\n',n);
num=ones(n,1);
for i=1 : n 
    C=ben{1,i};
  num(i,1)=unicode2native(C);
end
for i=1 : n 
    fprintf(fid,'%s           %.4f\n',ben{1,i},V1(i,1))
end
fprintf(fid,'********************************\n');
fprintf(fid,'observations\n');
fprintf(fid,'From   To     Elevation value    (+/-)std\n');

%number of observation 
n1=length(V);
%fprintf('number of observation:%d\n',n1);
num1=ones(n1,1);
num2=ones(n1,1);
for i=1 : n1 
    C1=sta1{1,i};
      num1(i,1)=unicode2native(C1);
C2=sta2{1,i};
 num2(i,1)=unicode2native(C2);
end
to_tum=[num1
       num2];
 to=unique(to_tum);
 %number of station 
 numT=length(to);
 %fprintf('number of station:%d\n',numT);
 %number of parameter 
 
numA=numT-n;
TT=to;
  %fprintf('number of parameter:%d\n',numA);
  for i=1 :  n
      for j=1 : numT
           if num(i,1)==TT(j,1)
              TT(j,1)=0;
           end
               
               
          %fprintf('%d : %d \n',i,j)
      end
  end
  K=0;
  para=ones(numA,1);
  for j=1 : numT 
  if TT(j,1) ~=0
      K=K+1;
      para(K)=TT(j,1);
  end
  end
  for i=1 : n1 
    fprintf(fid,'%s      %s       %.5f          %.4f \n',sta1{1,i},sta2{1,i},V(i,1),std(i,1));
  end
  %A matrrik

  A=zeros(n1,numA);
  for i=1 : numA 
      for j=1 : n1
           if para(i,1)==num1(j,1)
               A(j,i)=1;
           
           end
          %fprintf('%d : %d \n',i,j)
      end
  end
  for i=1 : numA 
      for j=1 : n1
           if para(i,1)==num2(j,1)
               A(j,i)=-1;
           end
          %fprintf('%d : %d \n',i,j)
      end
  end
 %B matric
B=zeros(n1,1);
for i=1 : n 
    for j=1 : n1 
        if num(i,1)==num1(j,1)
            B(j,1)=V1(i,1);
        end
    end
end
 for i=1 : n 
    for j=1 : n1 
        if num(i,1)==num2(j,1)
            B(j,1)=-V1(i,1);
        end
    end
end
%fprintf('%.4f\n',B)
fprintf(fid,'number of benchmark:%d\n',n);
fprintf(fid,'number of station:%d\n',numT);
fprintf(fid,'number of observation:%d\n',n1);
fprintf(fid,'number of parameter:%d\n',numA);
%disp('Design Matrix A:');
%disp(A)
%disp('B Matrix:');
%disp(B)
%disp(' L Matrix:');
%disp(V)
LB=V-B;
%disp('Lb Matrix:');
%disp(LB)
%weight 
W=zeros(n1,n1);
for i=1 : n1
    W(i,i)=1/(std(i,1)^2);
end
%disp('Weight Matrix:')
%disp(W);
%Normal Matrix :inv(A'PA)
a1=A'*W*A;
N=inv(a1);
%disp('Normal Matrix:')
%disp(N)
%A'P*L
a2=A'*W*LB;
%disp('L+V:');
%disp(a2);
%X value 
X=N*a2;
%disp('X value:')
%disp(X)
%residual 
VV=A*X-LB;
%disp('residual:');
%disp(VV)
%reference std 
V1=VV'*W*VV;
V2=V1/(n1-numA);
ref=sqrt(V2);
fprintf(fid,'reference std =+/-%.4f\n',ref);
%std for X 
nn=length(X);
stdX=ones(nn,1);
for i=1 : nn 
    stdX(i,1)=ref*sqrt(N(i,i));
end
fprintf(fid,'Adjusted X value and std:\n');
fprintf(fid,'stn    elev     +/-std\n');
for i=1 :numA
    CK=native2unicode(para(i));
    fprintf(fid,'%s    %.4f   %.4f\n',CK,X(i,1),stdX(i,1));
end
%adjusted observation
LA=V+VV;
%disp(LA);
%std observation
stdOb=ref*A*N*A';
fprintf(fid,'----------------------\n');
fprintf(fid,'From     To  Adjusted   Residual   +/-std\n');
for i=1 : n1 
    fprintf(fid,'%s        %s  %.5f  %.5f   %.5f\n',sta1{1,i},sta2{1,i},LA(i,1),VV(i,1),stdOb(i,i))
end
fclose(fid);
