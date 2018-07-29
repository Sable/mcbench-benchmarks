     function output=user1chp()
           
%//input siganl form transmitter side for chip based\\
                  
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
                  
  f1=1;f2=0;f3=1;f4=0;f5=1;
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
    
           
               
         %//first transmit bit\\
         
k=1;
for i=1:nb1
    for j=1:31
        tb1(k)=mb1(i)*pb1(j);
        k=k+1;
    end
end
%disp(tb1);

     %//spreading of three  signals transmitted in the channel\\
       
n=1;
for i=1:k-1
    tb(n)=tb1(n);
    n=n+1;
end
%disp(tb);
 figure(1);
grid on;
subplot(2,1,1);
plot(tb);
title('Received signal with out noise for CB(single user)');
xlabel('Time');
ylabel('Amplitude');
g=awgn(tb,10);
%disp(g);
subplot(2,1,2);
plot(g);
title('Received signal with noise for CB(single user)');
xlabel('Time');
ylabel('Amplitude');

                    %//optimum weight for CB configuration\\
                    
%q=input('enter the no of bits');
q1=length(tb);
s=randsrc(1,q1);
c=complex(tb,s);
%disp(c);
d=conj(c);
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
%l=input('enter the no of bits');
l1=length(tb);
u1=complex(tb,l1);
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
dem=v*v1*a1;
beta=dem.^-1;
 %optimum weight
%Wopt=beta*a1*v';
temp=beta*v';
Wopt=temp*a1;
length(Wopt);
%disp('optimum weights for CB')
%disp(Wopt);
% subplot(2,2,3);
% plot(Wopt);
% title('Received signal with weight for CB');
% xlabel('Time');
% ylabel('weight');

                 %//beamformer output\\
                 
o=conj(Wopt)*c;
%disp('Beamformer output for CB')
%disp(o);
% subplot(2,2,4);
% plot(o);
% title('Beam former output with weight for CB');
% xlabel('Time');
% ylabel('weight');

   %//%receiver side\\
        %//reconstruction of user2 signal\\
        
s2=0;
t2=1;
for i=0:31:k-32
    for j=1:31
        ob2(t2)=o(i+j)*pb2(j)+s2;
        s2=ob2(t2);
        if ob2(t2)>0
            ob2(t2)=1;
        else ob2(t2)=0;
        end
    end
    t2=t2+1;
    s2=0;
end
%disp('second message is')
%disp(ob2);

      %//reconstruction of received signal from noise\\
            
for i=1:nb1
     if g(i)>0
            g2(i)=1;
        else g2(i)=0;
        end
    end
    
% disp(g2);

                  %//SINR CALCULATION FOR CB CONFIGURATION\\
hop1=conj(pb1)';
hx=conj(c)';
nr=hop1*hx';
 sum=nr*Wopt; 
 %disp('sum');
 %disp(sum);
 cm=sum'*sum;
 signal=mean(cm);
 % disp('cm');
 %disp(cm);
 hop2=conj(pb1)';
hx1=conj(g)';
nr1=hop2*hx1';
 sum1=nr1*Wopt; 
 %disp('sum');
 %disp(sum);
  cm1=sum1'*sum1;
  noise=mean(cm1);
 %disp('cm1');
 %disp(cm1);
 CSINR=signal/noise;
 length(CSINR);
 disp('CSINR');
 disp(CSINR);
  
                 %//GRAPH FOR DOA VERSUS SINR\\
              
     DOA=-80:20:80;
     figure(2);
    % grid on;
     plot(DOA,CSINR,'R-*');
     title('simulation for DOA versus CSINR');
     xlabel('DOA in degree');
     ylabel('CSINR in db');
     
                    %// BER CALCULATION FOR CB CONFIGURATION\\
                    
    k=biterr(m1,g2);
    output=k;
    disp('biterror rate for cb configuration');
    disp(k);
    
     %//GRAPH FOR NUMBER USERS VERSUS BER\\
            
     figure(3);
     plot(us,k,'R-*');
     
     title('simulation of No. of users Versus BER for chip based configuration(single user) ');
     xlabel('NUMBER USERS');
     ylabel('BER');

    
 
 