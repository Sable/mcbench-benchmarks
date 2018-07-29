%This code implements the training method for MLP neural networks, Support 
%Vector Neural Network (SVNN), proposed in the work: O. Ludwig; “Study on 
%Non-parametric Methods for Fast Pattern Recognition with Emphasis on 
%Neural Networks and Cascade Classifiers;” PhD Thesis, University of 
%Coimbra, Coimbra, 2012. The input arguments are a matrix, X, whose columns
%are input vectors, a row vector, y, whose elements are the respective
%target classes, which should be -1 or 1, and the number of hidden neurons,
%nneu. Similarly to SVMs, the SVNN has a punishing parameter, C, which can 
%be set in the line 17 of the code. This code was developed by Oswaldo
%Ludwig, in case of publication, cite the above PhD thesis.

function [W1,W2,b1,b2]=SVNN(X,y,nneu)

%########################################################
%Setting parameters
%########################################################
C=70;%set the punishing parameter (similarly to SVMs)
max_indiv=1500;%set the initial population
pressao=5;%set selective pressure [1 - 8]
elitism=1;%set elitism (1-yes, 0-no)
max_resol=12;
iter_max = 10;%set how many generations per resolution
%########################################################

[L,namost]=size(X);
%separating examples by their classes:
positives=[];
negatives=[];
for k=1:namost
    if y(k)==1
       positives=[positives,k];
    else
       negatives=[negatives,k];
    end
end
sp=max(size(positives));
sn=max(size(negatives));
maxim=max(max(X));
minem=min(min(X));
inter=maxim-minem;
indiv=max_indiv;
%generating population:
pop_W1=10*(rand(nneu,L,indiv)-.5)/inter/L;
pop_b1=10*(rand(nneu,indiv)-.5)/inter;
pop_W2=10*(nneu)^.5*(rand(indiv,nneu)-.5);
pop_b2=10*(rand(indiv,1)-.5);
%**************************************************************************
%Loop over generations
%**************************************************************************
cont=1;
meanfit(cont)=0.5;
minfit(cont)=0.5;  
matlabpool(4) % Opening parallel processing  
for resolution=1:max_resol
    minfit(cont)=meanfit(cont)-0.105;
    algo=1;
    while and(algo<=round(iter_max),abs(meanfit(cont)-minfit(cont))>0.01)
        algo=algo+1;
        %Ranking individuals:
        percent=zeros(1,indiv);  
        tic
        parfor n=1:indiv %Parallel loop
        %for n=1:indiv  
            percent(n)=0;
            W1=pop_W1(:,:,n);
            b1=pop_b1(:,n);
            W2=pop_W2(n,:);
            b2=pop_b2(n);    
            %evaluating the examples to generate error:    
            e=0;
            if sn>3*sp
                %reducing negative training set to deal with unbalanced datasets:
                indeces=round((sn-1)*rand(1,3*sp))+1;
                ni=3*sp;
            else
                indeces=1:sn;
                ni=sn;
            end
            %testing negative examples:
            for exemplo=1:ni         
                ye1=W2*logsig(W1*X(:,negatives(indeces(exemplo)))+b1)+b2; 
                e=e+max(0,1+ye1);
            end   
            %testing positive examples: 
            indeces=positives;
            for exemplo=1:sp     
                ye=W2*logsig(W1*X(:,indeces(exemplo))+b1)+b2; 
                e=e+max(0,1-ye);
            end  
            ei=eig(W1*W1')/(nneu^2);
            eimax=max(ei);
            eimin=min(ei);
            e=eimax+eimin+C*e/namost;
            fitness(n)=e;
        end
        toc
        cont=cont+1;
        meanfit(cont)=mean(fitness(1:indiv));
        minfit(cont)=min(fitness(1:indiv));
        ['mean population fitness=',num2str(meanfit(cont))];
        ['minimum population fitness=',num2str(minfit(cont))];
        hold off
        semilogy(meanfit(2:end))
        hold
        semilogy(minfit(2:end),'r')
        legend('averaged fitness', 'best individual');
        title(['Training by GA: ', 'resolution ', num2str(resolution),'/',num2str(max_resol),' generation ', num2str(algo),'/',num2str(round(iter_max+1))])
        xlabel(['iteration=',num2str(cont-1)])
        ylabel(['fitness=',num2str(minfit(cont))])
        pause(0.01)   
        %Ranking population by fitness:
        pop_rearranged_W1=pop_W1;
        pop_rearranged_W2=pop_W2;
        pop_rearranged_b1=pop_b1;
        pop_rearranged_b2=pop_b2;
        for k=1:indiv
            [m,pos]=min(fitness);
            pop_rearranged_W1(:,:,k)=pop_W1(:,:,pos);
            pop_rearranged_b1(:,k)=pop_b1(:,pos);
            pop_rearranged_W2(k,:)=pop_W2(pos,:);
            pop_rearranged_b2(k,:)=pop_b2(pos);
            fitness(pos)=300000000000;
        end
        W1=[pop_rearranged_W1(:,:,1);pop_rearranged_W1(:,:,2);pop_rearranged_W1(:,:,3);pop_rearranged_W1(:,:,4);pop_rearranged_W1(:,:,5)];
        W2=[pop_rearranged_W2(1,:),pop_rearranged_W2(2,:),pop_rearranged_W2(3,:),pop_rearranged_W2(4,:),pop_rearranged_W2(5,:)]/5;
        b1=[pop_rearranged_b1(:,1);pop_rearranged_b1(:,2);pop_rearranged_b1(:,3);pop_rearranged_b1(:,4);pop_rearranged_b1(:,5)];
        b2=(pop_rearranged_b2(1)+pop_rearranged_b2(2)+pop_rearranged_b2(3)+pop_rearranged_b2(4)+pop_rearranged_b2(5))/5;
        %Crossover:
        for k=1:indiv
            r=rand;
            pai=round((indiv-1)*(exp(pressao*r)-1)/(exp(pressao)-1))+1;
            r=rand;
            mae=round((indiv-1)*(exp(pressao*r)-1)/(exp(pressao)-1))+1;
            r=rand(nneu,L);
            pop_W1(:,:,k)=(1+0.6*(rand-0.5))*(pop_rearranged_W1(:,:,pai).*r+pop_rearranged_W1(:,:,mae).*(1-r));
            r=rand(nneu,1);
            pop_b1(:,k)=(1+0.6*(rand-0.5))*(pop_rearranged_b1(:,pai).*r+pop_rearranged_b1(:,mae).*(1-r));
            r=rand(1,nneu);
            pop_W2(k,:)=(1+0.6*(rand-0.5))*(pop_rearranged_W2(pai,:).*r+pop_rearranged_W2(mae,:).*(1-r));
            r=rand;
            pop_b2(k)=(1+0.6*(rand-0.5))*(pop_rearranged_b2(pai).*r+pop_rearranged_b2(mae).*(1-r));
        end
        if elitism==1
            pop_W1(:,:,1:3)=pop_rearranged_W1(:,:,1:3);
            pop_b1(:,1:3)=pop_rearranged_b1(:,1:3);
            pop_W2(1:3,:)=pop_rearranged_W2(1:3,:);
            pop_b2(1:3)=pop_rearranged_b2(1:3); 
        end
        indiv=round(indiv/1.01);
    end
    pop_W1(:,:,1:indiv)=pop_W1(:,:,1:indiv)+500*(rand(nneu,L,indiv)-.5)/inter/L/(2^((resolution+3)/3));
    pop_b1(:,1:indiv)=pop_b1(:,1:indiv)+100*(rand(nneu,indiv)-.5)/inter/(2^((resolution+3)/3));
    pop_W2(1:indiv,:)=pop_W2(1:indiv,:)+100*(rand(indiv,nneu)-.5)/(2^((resolution+3)/3));
    pop_b2(1:indiv)=pop_b2(1:indiv)+100*(rand(indiv,1)-.5)/(2^((resolution+3)/3));
    if elitism==1
        pop_W1(:,:,1)=pop_rearranged_W1(:,:,1);
        pop_b1(:,1)=pop_rearranged_b1(:,1);
        pop_W2(1,:)=pop_rearranged_W2(1,:);
        pop_b2(1)=pop_rearranged_b2(1);
    end

end
matlabpool close %Closing the parallel processing
