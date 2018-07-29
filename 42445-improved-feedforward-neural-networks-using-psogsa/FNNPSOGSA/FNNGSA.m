%% ----------------------------------------------------------------------------
% PSOGSA source codes version 1.0.
% Author: Seyedali Mirjalili (ali.mirjalili@gmail.com)

% Main paper:
% S. Mirjalili, S. Z. Mohd Hashim, and H. Moradian Sardroudi, "Training 
%feedforward neural networks using hybrid particle swarm optimization and 
%gravitational search algorithm," Applied Mathematics and Computation, 
%vol. 218, pp. 11125-11137, 2012.

%The paper of the PSOGSA algorithm utilized as the trainer:
%S. Mirjalili and S. Z. Mohd Hashim, "A New Hybrid PSOGSA Algorithm for 
%Function Optimization," in International Conference on Computer and Information 
%Application?ICCIA 2010), 2010, pp. 374-377.
%% -----------------------------------------------------------------------------

clc
clear all
close all

%% ////////////////////////////////////////////////////Data set preparation/////////////////////////////////////////////
 load iris.txt
 x=sortrows(iris,2);
 H2=x(1:150,1);
 H3=x(1:150,2);
 H4=x(1:150,3);
 H5=x(1:150,4);
 T=x(1:150,5);
 H2=H2';
 [xf,PS] = mapminmax(H2);
 I2(:,1)=xf;
 
 H3=H3';
 [xf,PS2] = mapminmax(H3);
 I2(:,2)=xf;
 
 H4=H4';
 [xf,PS3] = mapminmax(H4);
 I2(:,3)=xf;
 
 H5=H5';
 [xf,PS4] = mapminmax(H5);
 I2(:,4)=xf;
 Thelp=T;
 T=T';
 [yf,PS5]= mapminmax(T);
 T=yf;
 T=T';

 %% /////////////////////////////////////////////FNN initial parameters//////////////////////////////////////
HiddenNodes=15;       %Number of hidden codes
Dim=8*HiddenNodes+3;  %Dimension of masses in GSA
TrainingNO=150;       %Number of training samples

%% ////////////////////////////////////////////////////////GSA/////////////////////////////////////////////

%Configurations and initializations

noP = 30;             %Number of masses
Max_iteration  = 500; %Maximum number of iteration

CurrentFitness =zeros(noP,1);

G0=1; %Gravitational constant
CurrentPosition = rand(noP,Dim); %Postition vector
velocity = .3*randn(noP,Dim) ; %Velocity vector
acceleration=zeros(noP,Dim); %Acceleration vector
mass(noP)=0; %Mass vector
force=zeros(noP,Dim);%Force vector

%Vectores for saving the location and MSE of the best mass
BestMSE=inf;
BestMass=zeros(1,Dim);

ConvergenceCurve=zeros(1,Max_iteration); %Convergence vector

%Main loop
Iteration = 0 ;
while  ( Iteration < Max_iteration )
    Iteration = Iteration + 1;
    G=G0*exp(-20*Iteration/Max_iteration);
    force=zeros(noP,Dim);
    mass(noP)=0;
    acceleration=zeros(noP,Dim);

%Calculate MSEs

    for i = 1:noP
        for ww=1:(7*HiddenNodes)
            Weights(ww)=CurrentPosition(i,ww);
        end
        for bb=7*HiddenNodes+1:Dim
            Biases(bb-(7*HiddenNodes))=CurrentPosition(i,bb);
        end
        fitness=0;
        for pp=1:TrainingNO
            actualvalue=My_FNN(4,HiddenNodes,3,Weights,Biases,I2(pp,1),I2(pp,2), I2(pp,3),I2(pp,4));
            if(T(pp)==-1)
                fitness=fitness+(1-actualvalue(1))^2;
                fitness=fitness+(0-actualvalue(2))^2;
                fitness=fitness+(0-actualvalue(3))^2;
            end
            if(T(pp)==0)
                fitness=fitness+(0-actualvalue(1))^2;
                fitness=fitness+(1-actualvalue(2))^2;
                fitness=fitness+(0-actualvalue(3))^2;   
            end
            if(T(pp)==1)
                fitness=fitness+(0-actualvalue(1))^2;
                fitness=fitness+(0-actualvalue(2))^2;
                fitness=fitness+(1-actualvalue(3))^2;              
            end
        end
        fitness=fitness/TrainingNO;
        CurrentFitness(i) = fitness;
    end
    best=min(CurrentFitness);
    worst=max(CurrentFitness);
    
    
    if(BestMSE>best)
        BestMSE=best;
        BestMass=CurrentPosition(i,:);            
    end
    
    for i=1:noP
        mass(i)=(CurrentFitness(i)-0.99*worst)/(best-worst);    
    end
    
    for i=1:noP
        mass(i)=mass(i)*5/sum(mass);    
    end

%Calculate froces

for i=1:noP
    for j=1:Dim
        for k=1:noP
            if(CurrentPosition(k,j)~=CurrentPosition(i,j))
                force(i,j)=force(i,j)+ rand()*G*mass(k)*mass(i)*(CurrentPosition(k,j)-CurrentPosition(i,j))/abs(CurrentPosition(k,j)-CurrentPosition(i,j));
                
            end
        end
    end
end

%Calculate a

for i=1:noP
       for j=1:Dim
            if(mass(i)~=0)
                acceleration(i,j)=force(i,j)/mass(i);
            end
       end
end   

%Calculate V

for i=1:noP
        for j=1:Dim
            velocity(i,j)=rand()*velocity(i,j)+acceleration(i,j);
        end
end

%Calculate X                                             
            
 CurrentPosition = CurrentPosition + velocity ;
 
 ConvergenceCurve(1,Iteration)=BestMSE; 
 disp(['GSA is training FNN (Iteration = ', num2str(Iteration),' ,MSE = ', num2str(BestMSE),')'])        
 
 end

%% ///////////////////////Calculate the classification//////////////////////
        Rrate=0;
        Weights=BestMass(1:7*HiddenNodes);
        Biases=BestMass(7*HiddenNodes+1:Dim);
         for pp=1:TrainingNO
            actualvalue=My_FNN(4,HiddenNodes,3,Weights,Biases,I2(pp,1),I2(pp,2), I2(pp,3),I2(pp,4));
            if(T(pp)==-1)
                if (round(actualvalue(1))==1 && round(actualvalue(2))==0 && round(actualvalue(3))==0)
                    Rrate=Rrate+1;
                end
            end
            if(T(pp)==0)
                if (round(actualvalue(1))==0 && round(actualvalue(2))==1 && round(actualvalue(3))==0)
                    Rrate=Rrate+1;
                end  
            end
            if(T(pp)==1)
                if (round(actualvalue(1))==0 && round(actualvalue(2))==0 && round(actualvalue(3))==1)
                    Rrate=Rrate+1;
                end              
            end
        end
        
ClassificationRate=(Rrate/TrainingNO)*100;
disp(['Classification rate = ', num2str(ClassificationRate)]);

%% Draw the convergence curve
hold on;      
semilogy(ConvergenceCurve);
title(['Classification rate : ', num2str(ClassificationRate), '%']); 
xlabel('Iteration');
ylabel('MSE');
box on
grid on
axis tight
hold off;