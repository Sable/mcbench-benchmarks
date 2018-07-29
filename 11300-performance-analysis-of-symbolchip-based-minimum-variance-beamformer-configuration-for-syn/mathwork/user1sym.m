function output=user1sym()
%**************************************************************************
 %*************************************************************************
                %//input signal form transmitter side for symbol based\\
clear all;
close all;
clc;
us=1;
nb1=5;
m1=[ 1 0 1 1 1];

                    %//message1 into polar form\\
                    
for i=1:nb1
    if m1(i)==1
        mb1(i)=m1(i);
    else
        mb1(i)=-1;
    end
end 
  % disp(mb1);
   
             
  
                  %//generation of maximal length sequence1\\
                  
  f1=1;f2=1;f3=0;f4=0;f5=1;
m=(2^5)-1;
for j=1:m
    p=xor(f2,f5);
    f5=f4;
    op1(j)=f5;
    f4=f3;
    f3=f2;
    f2=f1;
    f1=p;
    
end
  %disp(op1);
  
                    %//msequence1 into polar form\\
                    
    for i=1:31
        
         if op1(i)==1
             pb1(i)=1;
         else
         pb1(i)=-1;
        end
    end 
    %disp(op1);
    %disp(pb1);
   
                  
    
                    %//spreading signals from transmitter side\\
               
                         %//first transmit bit\\
         
k=1;
for i=1:nb1
    for j=1:31
        tb1(k)=mb1(i)*pb1(j);
        k=k+1;
    end
end
%disp(tb1);

   
                         %//%receiver side\\
                    %//reconstruction of user1 signal\\
        
s2=0;
t2=1;
for i=0:31:k-32
    for j=1:31
        ob2(t2)=tb1(i+j)*pb1(j)+s2;
        s2=ob2(t2);
        if ob2(t2)>0
            ob2(t2)=1;
        else ob2(t2)=0;
        end
    end
    t2=t2+1;
    s2=0;
end
%disp(' message is')
%disp(ob2);
n1=awgn(ob2,10);
 figure(1);
grid on;
subplot(2,1,1);
plot(ob2);
title('Received signal with out noise for SB (single user)');
xlabel('Time');
ylabel('Amplitude');
%g=awgn(ob2,10);
%disp(g);
subplot(2,1,2);
plot(n1);
title('Received signal with noise for SB (single user)');
xlabel('Time');
ylabel('Amplitude');
     
                    %//reconstruction of received signal from noise\\
            
for i=1:nb1
     if n1(i)>0
            g2(i)=1;
        else g2(i)=0;
        end
    end
    
% disp(g2);

                 % //calculating optimum weight using minimum variance\\
                 
 ob=randint(1,31);                
q=length(10);
%q1=input('enter the sequence');
s=randsrc(1,q);
c1=complex(ob,s);               
%disp(c);
d=conj(c1);
d1=d*d';
%disp(d1);
m=mean(d1);
lamda=5;
teta=45;
k=((2*pi)/lamda);
K=4;
for i=0:K-1
    v=(exp(j*k*i*d*sin(teta)))';
end             
%disp(v);
v1=conj(v)';
teta=30;
k=((2*pi)/lamda);
K=5;
for i=0:K-1
    eta=exp(sqrt(-1)*k*i*d*sin(teta))';
end  
%u1=[2+2j 3-1j 4+3j 5+2j]'
%m=randsrc(1,124);
%a=randsrc(1,124);
l=length(10);
%l1=input('enter the sequence');
u1=complex(ob,l);
u=eta*u1;
u2=conj(u)';
u3=u*u2;
Ru=mean(u3);

%Ru1=imresize(Ru,[124 124]);
%a1=inv(Ru1);
%a1=Ru1';
a1=Ru';
%disp(a1);
%calculating beta value
%g=1;
dem1=v*v1*a1;
beta1=dem1.^-1;
 %optimum weight
%Wopt=beta*a1*v';
temp1=beta1*v';
Wopt1=temp1*a1;
%disp(Wopt1);
%  subplot(2,2,3);
% plot(Wopt1);
% title('Received signal with optimum weight for SB');
% xlabel('Time');
% ylabel('weight');

                    %//beamformer output\\
            
o1=conj(Wopt1)*ob2;
%disp('Beamformer output for SB')
%disp(o1);
%  subplot(2,2,4);
% plot(o1);
% title('Beamformer output  for SB');
% xlabel('Time');
% ylabel('Beam former output');

                    %//SINR CALCULATION FOR SB CONFIGURATION\\
                 
%s=length(m2);
%q1=input('enter the sequence');
s=randsrc(1,q);
c=complex(ob2,s);             
              
hop1=conj(pb1)';
hob1=conj(c)';
nr3=hop1*hob1';
sum2=nr3'*Wopt1;
%disp('sum2');
%disp(sum2);
cm2=sum2'*sum2;
signal1=mean(cm2);
%disp('cm2');
%disp(cm2);
hop2=conj(pb1)';
hx2=conj(n1)';
nr5=hop2*hx2';
 sum3=nr5'*Wopt1; 
 %disp('sum');
 %disp(sum);
  cm3=sum3'*sum3;
  noise1=mean(cm3);
 %disp('cm3');
 %disp(cm3);
 SSINR=signal1/noise1;
 disp('SSINR');
 disp(SSINR);
 
                %//GRAPH FOR DOA VERSUS SINR\\
           
    DOA=-80:10:80;
    figure(4);
    plot(DOA,SSINR,'B-*');
    title('simulation for DOA versus SSINR');
    xlabel('DOA in degree');
    ylabel('SINR in db');
    

                %// BER CALCULATION FOR SB CONFIGURATION\\
          
       k1=biterr(m1,g2);
       output=k1;
       disp('biterror rate for Sb configuration');
       disp(k1);
       
                 %//GRAPH FOR NUMBER USERS VERSUS BER\\
            
     figure(5);
     plot(us,k1,'R-*');
     
     title('simulation for NUMBER USERS VERSUS BER SYMBOL BASED) ');
     xlabel('NUMBER USERS');
     ylabel('BER');
