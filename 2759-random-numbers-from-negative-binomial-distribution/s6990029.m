%function f = s6990029.m
%This function was completed on Tuesday, 16 November 2002
%as a part of a course, in order to form a good-interfaced program 
%for producing random variables from the negative binomial distribution.
%
%Made by P.B.(6990029)
function s6990029

fprintf('In a few seconds a pop-up screen will prompt you to choose from one\nof 4 methods, in order to generate random variables from the Negative Binomial Distribution.');
fprintf('\n\nLOADING('),
for j=1:30
fprintf('---')
pause(0.06990029)
end
fprintf(')')
fprintf('\n')


K=menu('Choose a method for generating n random variables from the Neg.Binomial :','1) Inverse transform Method','2) Convolution Method (using Bernoulli D.)','3) Convolution Method (using Geometrical D.)','4) Acceptance Rejection Method','**************************Which is faster=better***********************','Exit');


%Method 1


if (K==1)
    
disp('You have selected the Inverse Transform method. Please wait...');
pause(2);
clc;clear;
N = input('Please give me the size of the sample : ');
R = input('Type the value of the parameter of successes R : ');
P = input('Now give the probability of success P : ');
disp('Please standby...');

%set up the storage space and the clock
tic
X = zeros(1,N);
x =1:N;

for x =1:N
pr(x)  = NBINCDF(x,R,P);
end

pr(N)=1;    %epeidh en vgainei panta 1 to teleutaio stoixeio tou pinaka ths a8roistikhs ...kammia fora... dhmiourgei provlhmata!!!

for i=1:N
 s=1;
u= rand;
while u > pr(s)
    s=s+1;
end
X(i) = s;
end

%stop the clock 
t=toc;  
fp=fopen('c:\data1.txt','w');
fprintf(fp,' %3.0f \n',X);
fclose(fp);
disp('Your sample has been saved in data1.txt');
fprintf('The time needed, depending on your machine'' speed \n and the complexity of the algorithm, was: ');disp(t)
pause(2);

load handel;
sound(y,Fs);


%the empirical histogram

[n,h]= hist(X,10);
n=n/(h(2)-h(1))/N;
bar(h,n,1,'w')
hold on

%theoritical curve

for x =1:N
pr(x)  = NBINPDF(x,R,P);
end
x =1:N;
plot(x,pr,'k');
hold off
title('Empirical & Theoritical pdf of the Neg. Binomial Distribution');
xlabel('X');
ylabel('P(X)');

%Method 2


elseif (K==2)
    
fprintf('You have selected the Convolution method \n(using as a prime several Bernoulli variables). \n\nPlease wait...');
pause(4);
clc;clear;
N = input('Please give me the size of the sample : ');
R = input('Type the value of the parameter of successes R : ');
P = input('Now give the probability of the bernoulli trials P : ');
disp('Please standby...');

%set up the storage space and the clock
tic

X = zeros(1,N);
for j=1:N
h=0;
i=0;
while h < R
u=rand;
i=i+1;
if  u <= P
h = h+1;
end
end
X(j)=i-R;               % duskolo shmeio...orismos:...o arithmos twn dokimwn mexri R epituxies!             
end

t=toc;  
fp=fopen('c:\data2.txt','w');
fprintf(fp,' %3.0f \n',X);
fclose(fp);
disp('Your sample has been saved in data2.txt');
fprintf('The time needed, depending on your machine'' speed \n and the complexity of the algorithm, was: ');disp(t)
pause(2);

load handel;
sound(y,Fs);


%the empirical histogram

[n,h]= hist(X,10);
n=n/(h(2)-h(1))/N;
bar(h,n,1,'w')
hold on

%theoritical curve

for x =1:N
pr(x)  = NBINPDF(x,R,P);
end
x =1:N;
plot(x,pr,'k');
hold off
title('Empirical & Theoritical pdf of the Neg. Binomial Distribution');
xlabel('X');
ylabel('P(X)');



%METHOD 3


elseif (K==3)
    
fprintf('You have selected the Convolution method \n(using as a prime several Geometrical variables). \n\nPlease wait...');
pause(4);
clc;clear;
N = input('Please give me the size of the sample : ');
R = input('Type the value of the parameter of successes R : ');
P = input('Now give the probability of the bernoulli trials P : ');
disp('Please standby...');

%set up the storage space and the clock
tic

X = zeros(1,N);

G=geornd(P,N,R);

X=G*ones(R,1);

%stop the clock 
t=toc;  
fp=fopen('c:\data3.txt','w');
fprintf(fp,' %3.0f \n',X);
fclose(fp);
disp('Your sample has been saved in data3.txt');
fprintf('The time needed, depending on your machine'' speed \n and the complexity of the algorithm, was: ');disp(t)
pause(2);

load handel;
sound(y,Fs);


%the empirical histogram

[n,h]= hist(X,10);
n=n/(h(2)-h(1))/N;
bar(h,n,1,'w')
hold on

%theoritical curve

for x =1:N
pr(x)  = NBINPDF(x,R,P);
end
x =1:N;
plot(x,pr,'k');
hold off
title('Empirical & Theoritical pdf of the Neg. Binomial Distribution');
xlabel('X');
ylabel('P(X)');
  
    
 
%METHOD 4

elseif (K==4)
    
fprintf('You have selected the Acceptance-Rejection method). \n\nPlease wait...');
pause(4);
clc;clear;
N = input('Please give me the size of the sample : ');
R = input('Type the value of the parameter of successes R : ');
P = input('Now give the probability of the bernoulli trials P : ');
disp('Please standby...');

%set up the storage space and the clock
tic
 
for x =1:N
pr(x)  = NBINPDF(x,R,P);
end

c=max(pr)*N;

irv=1;
while irv<=N
    y = unidrnd(N);
    u = rand(1);
    if u <= (pr(y))/c ;
        X(irv) =  y;
        irv = irv +1;
    end
end



%stop the clock 
t=toc;  
%save to disk
fp=fopen('c:\data4.txt','w');
fprintf(fp,' %3.0f \n',X);
fclose(fp);
disp('Your sample has been saved in data4.txt');
fprintf('The time needed, depending on your machine'' speed \n and the complexity of the algorithm, was: ');disp(t)
pause(2);

load handel;
sound(y,Fs);


%the empirical histogram

[n,h]= hist(X,10);
n=n/(h(2)-h(1))/N;
bar(h,n,1,'w')
hold on

%theoritical curve

for x =1:N
pr(x)  = NBINPDF(x,R,P);
end
x =1:N;
plot(x,pr,'k');
hold off
title('Empirical & Theoritical pdf of the Neg. Binomial Distribution');
xlabel('X');
ylabel('P(X)');
      

%Test for overall performance within the range of the two parameters (R,P)

%#########################################################################################

elseif (K==5)
    
    clc;
    fprintf('You have selected to test between the three first  methods.\nFor the 4th one the envelope function selected was rather unsuitable since it was\nthe discrete uniform.\nWith an other function as an envelope it would be very hard to test\nthrough a wide range of (R,P)\nsince the Neg. Binomial''s shape would change.\n\nPlease wait. It will take some time ...\n');
pause(5);

clear;
N = input('Please give me the size of the sample. It would be most preferable to choose sample bigger than 10000! : ');

fprintf('Please go drink a coffee...\n')

    q=1;
    
    for R=10:N    
    for P=0.3:0.2:0.7
        %1st
tic
X = zeros(1,N);
x =1:N;

for x =1:N
pr(x)  = NBINCDF(x,R,P);
end

pr(N)=1;    %epeidh en vgainei panta 1 to teleutaio stoixeio tou pinaka ths a8roistikhs ...kammia fora... dhmiourgei provlhmata!!!

for i=1:N
 s=1;
u= rand;
while u> pr(s)
    s=s+1;
end
    X(i) = s;
end
%stop the clock 
t1=toc;  

%2nd

tic

X = zeros(1,N);
for j=1:N
h=0;
i=0;
while h < R
u=rand;
i=i+1;
if  u <= P
h = h+1;
end
end
X(j)=i-R;               % duskolo shmeio...orismos:...o arithmos twn dokimwn mexri R epituxies!             
end

t2=toc;  


%3rd


tic

X = zeros(1,N);

G=geornd(P,N,R);

X=G*ones(R,1);

%stop the clock 
t3=toc;  

q=q+1;

T(q,:)=[t1 t2 t3];

end
end

boxplot(T);
anova1(T);

fprintf('\n\n\n\n\nOne would choose the method which uses the sum of the geometrical variables\nsince the Anova table also recommends this method!\nHave a nice day.')

else
 disp('Have a nice Day!!!');

%break

end
