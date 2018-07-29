function output=user12sym()

%**************************************************************************
 %*************************************************************************
                %//input signal form transmitter side for symbol based\\
 clear all;
close all;
clc;
% us=input('enter the number of users');
% nb1=input('number of bits for user1');
% m1=input('enter the message sequence1');
% nb2=input('number of bits for user2');
% m2=input('enter the message sequence2');
% nb3=input('number of bits for user3');
% m3=input('enter the message sequence3');
% nb4=input('number of bits for user4');
% m4=input('enter the message sequence4');
% nb5=input('number of bits for user5');
% m5=input('enter the message sequence5');
us=3;
nb1=25;
nb2=25;
nb3=25;
nb4=25;
nb5=25;
nb6=25;
nb7=25;
nb8=25;
nb9=25;
nb10=25;
nb11=25;
nb12=25;
m1=[1 1 1 1 1 0 1 1 1 0 1 0 1 1 1 1 0 1 1 0 1 0 1 1 1];
m2=[1 1 0 1 1 1 1 0 1 1 1 0 1 1 0 1 1 1 1 0 1 1 1 0 1];
m3=[1 0 1 1 0 1 1 0 1 1 1 0 1 0 1 1 0 1 1 0 0 1 0 1 1 ];
m4=[1 1 1 1 0 1 1 1 0 1 1 0 1 1 1 1 1 1 0 1 1 0 1 1 1];
m5=[1 1 1 1 0 1 1 0 1 1 1 0 1 1 1 1 0 1 1 1 1 1 0 0 1];
m6=[1 0 1 1 0 1 0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 0 0 1 0];
m7=[1 1 1 1 0 1 1 1 1 1 1 0 1 1 1 1 1 1 0 1 1 0 1 0 1];
m8=[1 0 1 0 0 0 1 1 1 0 1 1 1 1 0 1 1 1 1 0 1 1 1 0 1 ];
m9=[1 1 1 1 1 0 1 1 0 0 0 1 1 1 1 1 1 0 1 1 1 0 1 1 1];
m10=[1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 1 1 0 1 1 0 1 1];
m11=[1 0 1 1 1 1 1 0 1 1 0 1 1 0 1 1 1 0 1 1 1 0 1 0 1];
m12=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 ];



                    %//message1 into polar form\\
                    
for i=1:nb1
    if m1(i)==1
        mb1(i)=m1(i);
    else
        mb1(i)=-1;
    end
end 
  % disp(mb1);
   
                %//message2 into polar form\\
                
for i=1:nb2
    if m2(i)==1
        mb2(i)=m2(i);
    else
        mb2(i)=-1;
    end
end 
  %disp(mb2);
  
                %//message3 into polar form\\
                
for i=1:nb3
    if m3(i)==1
        mb3(i)=m3(i);
    else
        mb3(i)=-1;
    end
end 
  %disp(mb3);
  
       %//message4 into polar form\\
                
for i=1:nb4
    if m4(i)==1
        mb4(i)=m4(i);
    else
        mb4(i)=-1;
    end
end 
  %disp(mb4);
  
    %//message5 into polar form\\
                
for i=1:nb5
    if m5(i)==1
        mb5(i)=m5(i);
    else
        mb5(i)=-1;
    end
end 
  %disp(mb5);
  
       %//message6 into polar form\\
                
for i=1:nb6
    if m6(i)==1
        mb6(i)=m6(i);
    else
        mb6(i)=-1;
    end
end 
  %disp(mb6);
  
    %//message7 into polar form\\
                
for i=1:nb7
    if m7(i)==1
        mb7(i)=m7(i);
    else
        mb7(i)=-1;
    end
end 
  %disp(mb7);
  
        %//message8 into polar form\\
                    
for i=1:nb8
    if m8(i)==1
        mb8(i)=m8(i);
    else
        mb8(i)=-1;
    end
end 
  % disp(mb8);
  
        %//message9 into polar form\\
                    
for i=1:nb9
    if m9(i)==1
        mb9(i)=m9(i);
    else
        mb9(i)=-1;
    end
end 
  % disp(mb9);
  
        %//message10 into polar form\\
                    
for i=1:nb10
    if m10(i)==1
        mb10(i)=m10(i);
    else
        mb10(i)=-1;
    end
end 
  % disp(mb10);
  
            %//message11 into polar form\\
                    
for i=1:nb11
    if m11(i)==1
        mb11(i)=m11(i);
    else
        mb11(i)=-1;
    end
end 
  % disp(mb11);
  
               %//message12 into polar form\\
                    
for i=1:nb12
    if m12(i)==1
        mb12(i)=m12(i);
    else
        mb12(i)=-1;
    end
end 
  % disp(mb12);   
  
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
    
                    %//generation of maximal length sequence2\\
        
  f1=1;f2=0;f3=0;f4=1;f5=1;
m=(2^5)-1;
for j=1:m
    p=xor(f3,f5);
    f5=f4;
    op2(j)=f5;
    f4=f3;
    f3=f2;
    f2=f1;
    f1=p;
    
end
  %disp(op2);
  
                    %//msequence2 into polar form\\
                    
    for i=1:31
        if op2(i)==1
             pb2(i)=1;
         else
         pb2(i)=-1;
        end
    end 
    %disp(op2);
    %disp(pb2);
    
                     %//generation of maximal length sequence3\\
      
  f1=1;f2=1;f3=1;f4=0;f5=1;
m=(2^5)-1;
for j=1:m
    p=xor(f4,f5);
    f5=f4;
    op3(j)=f5;
    f4=f3;
    f3=f2;
    f2=f1;
    f1=p;
    
end
  %disp(op3);
  
                    %//msequence3 into polar form\\
                    
    for i=1:31
        
         if op3(i)==1
             pb3(i)=1;
         else
         pb3(i)=-1;
        end
    end 
    %disp(op3);
    %disp(pb3);
    
     
                     %//generation of maximal length sequence4\\
      
  f1=0;f2=1;f3=1;f4=0;f5=1;
m=(2^5)-1;
for j=1:m
    p=xor(f4,f5);
    f5=f4;
    op4(j)=f5;
    f4=f3;
    f3=f2;
    f2=f1;
    f1=p;
    
end
  %disp(op4);
  
                    %//msequence4 into polar form\\
                    
    for i=1:31
        
         if op4(i)==1
             pb4(i)=1;
         else
         pb4(i)=-1;
        end
    end 
    %disp(op4);
    %disp(pb4);
    
       
                     %//generation of maximal length sequence5\\
      
  f1=1;f2=1;f3=0;f4=0;f5=1;
m=(2^5)-1;
for j=1:m
    p=xor(f4,f5);
    f5=f4;
    op5(j)=f5;
    f4=f3;
    f3=f2;
    f2=f1;
    f1=p;
    
end
  %disp(op5);
  
                    %//msequence5 into polar form\\
                    
    for i=1:31
        
         if op5(i)==1
             pb5(i)=1;
         else
         pb5(i)=-1;
        end
    end 
    %disp(op5);
    %disp(pb5);
    
                     %//generation of maximal length sequence6\\
      
  f1=0;f2=0;f3=1;f4=0;f5=1;
m=(2^5)-1;
for j=1:m
    p=xor(f4,f5);
    f5=f4;
    op6(j)=f5;
    f4=f3;
    f3=f2;
    f2=f1;
    f1=p;
    
end
  %disp(op6);
  
                            %//msequence6 into polar form\\
                    
    for i=1:31
        
         if op6(i)==1
             pb6(i)=1;
         else
         pb6(i)=-1;
        end
    end 
    %disp(op6);
    %disp(pb6);
    
                 %//generation of maximal length sequence7\\
      
  f1=1;f2=1;f3=0;f4=0;f5=1;
m=(2^5)-1;
for j=1:m
    p=xor(f4,f5);
    f5=f4;
    op7(j)=f5;
    f4=f3;
    f3=f2;
    f2=f1;
    f1=p;
    
end
  %disp(op7);
  
                      %//msequence7 into polar form\\
                    
    for i=1:31
        
         if op7(i)==1
             pb7(i)=1;
         else
         pb7(i)=-1;
        end
    end 
    %disp(op7);
    %disp(pb7);
           
     %//generation of maximal length sequence8\\
                  
  f1=1;f2=1;f3=0;f4=1;f5=1;
m=(2^5)-1;
for j=1:m
    p=xor(f2,f5);
    f5=f4;
    op8(j)=f5;
    f4=f3;
    f3=f2;
    f2=f1;
    f1=p;
    
end
  %disp(op8);
  
                    %//msequence8 into polar form\\
                    
    for i=1:31
        
         if op8(i)==1
             pb8(i)=1;
         else
         pb8(i)=-1;
        end
    end 
    %disp(op8);
    %disp(pb8);
    
     %//generation of maximal length sequence9\\
                  
  f1=1;f2=0;f3=0;f4=0;f5=1;
m=(2^5)-1;
for j=1:m
    p=xor(f2,f5);
    f5=f4;
    op9(j)=f5;
    f4=f3;
    f3=f2;
    f2=f1;
    f1=p;
    
end
  %disp(op9);
  
                    %//msequence9 into polar form\\
                    
    for i=1:31
        
         if op9(i)==1
             pb9(i)=1;
         else
         pb9(i)=-1;
        end
    end 
    %disp(op9);
    %disp(pb9);
    
     %//generation of maximal length sequence10\\
                  
  f1=1;f2=1;f3=0;f4=0;f5=0;
m=(2^5)-1;
for j=1:m
    p=xor(f2,f5);
    f5=f4;
    op10(j)=f5;
    f4=f3;
    f3=f2;
    f2=f1;
    f1=p;
    
end
  %disp(op10);
  
                    %//msequence10 into polar form\\
                    
    for i=1:31
        
         if op10(i)==1
             pb10(i)=1;
         else
         pb10(i)=-1;
        end
    end 
    %disp(op10);
    %disp(pb10);
    
     %//generation of maximal length sequence11\\
                  
  f1=1;f2=0;f3=0;f4=0;f5=1;
m=(2^5)-1;
for j=1:m
    p=xor(f2,f5);
    f5=f4;
    op11(j)=f5;
    f4=f3;
    f3=f2;
    f2=f1;
    f1=p;
    
end
  %disp(op11);
  
                    %//msequence11 into polar form\\
                    
    for i=1:31
        
         if op11(i)==1
             pb11(i)=1;
         else
         pb11(i)=-1;
        end
    end 
    %disp(op11);
    %disp(pb11);
    
    
     %//generation of maximal length sequence12\\
                  
  f1=1;f2=1;f3=0;f4=0;f5=1;
m=(2^5)-1;
for j=1:m
    p=xor(f2,f5);
    f5=f4;
    op12(j)=f5;
    f4=f3;
    f3=f2;
    f2=f1;
    f1=p;
    
end
  %disp(op12);
  
                    %//msequence12 into polar form\\
                    
    for i=1:31
        
         if op12(i)==1
             pb12(i)=1;
         else
         pb12(i)=-1;
        end
    end 
    %disp(op12);
    %disp(pb12);
    
    
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

                     %//second transmit bit\\
       
k=1;
for i=1:nb2
    for j=1:31
        tb2(k)=mb2(i)*pb2(j);
        k=k+1;
    end
end
%disp(tb2);
            
                    %//third transmit bit\\
         
k=1;
for i=1:nb3
    for j=1:31
        tb3(k)=mb3(i)*pb3(j);
        k=k+1;
    end
end
%disp(tb3);
      
                %//fourth transmit bit\\
         
k=1;
for i=1:nb4
    for j=1:31
        tb4(k)=mb4(i)*pb4(j);
        k=k+1;
    end
end
%disp(tb4);

             %//fifth transmit bit\\
         
k=1;
for i=1:nb5
    for j=1:31
        tb5(k)=mb5(i)*pb5(j);
        k=k+1;
    end
end
%disp(tb5);

                 %//sixth transmit bit\\
         
k=1;
for i=1:nb6
    for j=1:31
        tb6(k)=mb6(i)*pb6(j);
        k=k+1;
    end
end
%disp(tb6);

                 %//seventh transmit bit\\
         
k=1;
for i=1:nb7
    for j=1:31
        tb7(k)=mb7(i)*pb7(j);
        k=k+1;
    end
end
%disp(tb7);

             %//eigth transmit bit\\
         
k=1;
for i=1:nb8
    for j=1:31
        tb8(k)=mb8(i)*pb8(j);
        k=k+1;
    end
end
%disp(tb8);

             %//nineth transmit bit\\
         
k=1;
for i=1:nb9
    for j=1:31
        tb9(k)=mb9(i)*pb9(j);
        k=k+1;
    end
end
%disp(tb9);

             %//tenth transmit bit\\
         
k=1;
for i=1:nb10
    for j=1:31
        tb10(k)=mb10(i)*pb10(j);
        k=k+1;
    end
end
%disp(tb10);
                  %//leventh transmit bit\\
         
k=1;
for i=1:nb11
    for j=1:31
        tb11(k)=mb11(i)*pb11(j);
        k=k+1;
    end
end
%disp(tb11);
    

        %//twelth transmit bit\\
         
k=1;
for i=1:nb12
    for j=1:31
        tb12(k)=mb12(i)*pb12(j);
        k=k+1;
    end
end
%disp(tb12);

                 %//Addition of seven  signals transmitted in the channel\\
       
n=1;
for i=1:k-1
    tb(n)=tb1(n)+tb2(n)+tb3(n)+tb4(n)+tb5(n)+tb6(n)+tb7(n)+tb8(n)+tb9(n)+tb10(n)+tb11(n)+tb12(n);
    n=n+1;
end
%disp(tb);
chn=awgn(tb,10);

                         %//%receiver side\\
                    %//reconstruction of user2 signal\\
        
s2=0;
t2=1;
for i=0:31:k-32
    for j=1:31
        ob2(t2)=chn(i+j)*pb2(j)+s2;
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
n1=awgn(ob2,10);
 figure(1);
grid on;
subplot(2,2,1);
plot(ob2);
title('Received signal with out noise for SB');
xlabel('Time');
ylabel('Amplitude');
%g=awgn(ob2,10);
%disp(g);
subplot(2,2,2);
plot(chn);
title('Received signal with noise for SB');
xlabel('Time');
ylabel('Amplitude');
     
                    %//reconstruction of received signal from noise\\
            
for i=1:nb2
     if chn(i)>0
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
u1=complex(ob2,l);
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
 subplot(2,2,3);
plot(Wopt1);
title('Received signal with optimum weight for SB');
xlabel('Time');
ylabel('weight');

                    %//beamformer output\\
            
o1=conj(Wopt1)*ob2;
%disp('Beamformer output for SB')
%disp(o1);
 subplot(2,2,4);
plot(o1);
title('Beamformer output  for SB');
xlabel('Time');
ylabel('Beam former output');

                    %//SINR CALCULATION FOR SB CONFIGURATION\\
                 
%s=length(m2);
%q1=input('enter the sequence');
s=randsrc(1,q);
c=complex(ob2,s);             
              
hop1=conj(pb2)';
hob1=conj(c)';
nr3=hop1*hob1';
sum2=nr3'*Wopt1;
%disp('sum2');
%disp(sum2);
cm2=sum2'*sum2;
signal1=mean(cm2);
%disp('cm2');
%disp(cm2);
hop2=conj(pb2)';
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
          
       k1=biterr(m2,g2);
       output=k1;
       disp('biterror rate for Sb configuration');
       disp(k1);
       
                 %//GRAPH FOR NUMBER USERS VERSUS BER\\
            
     figure(5);
     plot(us,k1,'R-*');
     
     title('simulation for NUMBER USERS VERSUS BER SYMBOL BASED) ');
     xlabel('NUMBER OF USERS');
     ylabel('BER');
