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
Dim=8*HiddenNodes+3;  %Dimension of particles in PSO
TrainingNO=150;       %Number of training samples

%% ////////////////////////////////////////////////////////PSO/////////////////////////////////////////////
%Initial Parameters for PSO
noP=30;           %Number of particles
Max_iteration=500;%Maximum number of iterations
w=2;              %Inirtia weight
wMax=0.9;         %Max inirtia weight
wMin=0.5;         %Min inirtia weight
c1=2;
c2=2;
dt=0.8;

vel=zeros(noP,Dim); %Velocity vector
pos=zeros(noP,Dim); %Position vector

%////////Cognitive component///////// 
pBestScore=zeros(noP);
pBest=zeros(noP,Dim);
%////////////////////////////////////

%////////Social component///////////
gBestScore=inf;
gBest=zeros(1,Dim);
%///////////////////////////////////

ConvergenceCurve=zeros(1,Max_iteration); %Convergence vector

%Initialization
for i=1:size(pos,1) % For each Particle
    for j=1:size(pos,2) % For each dimension
           pos(i,j)=rand();
        vel(i,j)=0.3*rand();
    end
end

 %initialize gBestScore for min
 gBestScore=inf;
     
    
for Iteration=1:Max_iteration
    %Calculate MSE
    for i=1:size(pos,1)  
        for ww=1:(7*HiddenNodes)
            Weights(ww)=pos(i,ww);
        end
        for bb=7*HiddenNodes+1:Dim
            Biases(bb-(7*HiddenNodes))=pos(i,bb);
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

        if Iteration==1
            pBestScore(i)=fitness;
        end
        
        if(pBestScore(i)>fitness)
            pBestScore(i)=fitness;
            pBest(i,:)=pos(i,:);
        end
        
        if(gBestScore>fitness)
            gBestScore=fitness;
            gBest=pos(i,:);
        end
        
        if(gBestScore==1)
            break;
        end
    end

    %Update the w of PSO
    w=wMin-Iteration*(wMax-wMin)/Max_iteration;
    
    %Update the velocity and position of particles
    for i=1:size(pos,1)
        for j=1:size(pos,2)       
            vel(i,j)=w*vel(i,j)+c1*rand()*(pBest(i,j)-pos(i,j))+c2*rand()*(gBest(j)-pos(i,j));
            pos(i,j)=pos(i,j)+dt*vel(i,j);
        end
    end
    ConvergenceCurve(1,Iteration)=gBestScore;
    
    disp(['PSO is training FNN (Iteration = ', num2str(Iteration),' ,MSE = ', num2str(gBestScore),')'])        
end

%% ///////////////////////Calculate the classification//////////////////////
        Rrate=0;
        Weights=gBest(1:7*HiddenNodes);
        Biases=gBest(7*HiddenNodes+1:Dim);
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
