function [Mean_accuracy, Variance,p1,m1,Means,Vars,Maxsf,Minsf]=simo2(data,v,c, measure, p, m, N,rn,pl)
%Inputs:
% data: put your data file in matrix form, rows indicates samples and
% columns features of the data.
% v:   how many columns of features you are using e.g. [1:4] means you will
% use first four columns as features of your data.
% c: column where you class labels are. They should be in numerical form.
% measure: Which quantifier in OWA operators you want to use. 
% 1=Basic RIM quantifier
% 2=Quadratic quantifier
% 3=Exponential quantifier
% 4=Trigonometric quantifier
% 5=O'Hagans method.
% p: parameter in generalized Lukasiewics similarity, can be studied as a range of
% parameter values and then given as a vector i.e. p=[0.1:0.1:5].
% alpha: Alpha value in owa operators
% Can be given as vector i.e. m=[0.1:0.1:5].
% N: how many times data is divided randomly into testing set and learning
% set.
% rn: portion of data which is used in learning set. default rn=1/2 (data
% is divided in half; half is used in testing set and half in learning set.
%pl: do you want to plot how the parameter changes in p and m changes the
% mean classification accuracies and variances.
%
%OUTPUTS:
% Mean_accuracy: Mean classification accuracy with best parameter values in
% p and m:
% p1 and m1: best parameter values w.r.t. mean classification accuracy.
% Variance: Variances with best parameter values


sv_name = 'results2'; % mat file where results are stored ('' = "no storing")

[data, lc, cs] = init_data(data,v,c); % data initialization

w_opt = 0; % Do we use weight optimization. Not implemented in this version.

%Initializations
fitness = zeros(1,N);
fitness_id = zeros(1,N);
fitness_dif = zeros(1,N);
Means = zeros(length(p),length(m),length(rn));
Vars = zeros(length(p),length(m),length(rn)); 
Maxsf = zeros(length(p),length(m),length(rn));
Minsf = zeros(length(p),length(m),length(rn));

Means_fit_dif = zeros(length(p),length(m),length(rn));
Vars_fit_dir = zeros(length(p),length(m),length(rn)); 
Ideal_var = zeros(length(p),length(m), length(lc),length(rn));

for n = 1 : length(rn)
    rn_ideal = ones(1,length(lc))*rn(n); 
    for j = 1:length(m) 
        for i = 1:length(p)  
            y = [p(i), m(j),measure]; % p and m values and similarity measure          
            for k = 1 : N 
                ideal_ind = [];
                for l = 1 :length(lc) 
                    temp = randperm(lc(l))-1;                
                    ideal_ind = [ideal_ind, cs(l)+temp(1:floor(lc(l)*rn_ideal(l)))]; % learning set indexes
                    data_ind = setxor([1:size(data,1)], ideal_ind); % testing set indexes
                end
                ideals(:,:,k) = idealvectors(data(ideal_ind,:), y); % idealvectors     
                if w_opt == 0  
                    [fitness(k), class, Simil] = calcfit(data(data_ind,:), ideals(:,:,k), y);
                end
            end
            Means(i,j,n) = mean(fitness);
            Vars(i,j,n) = var(fitness);
            Maxsf(i,j,n) = max(fitness);
            Minsf(i,j,n) = min(fitness);
            fitness=[];
        end    
    end
    tmp=max(max(Means));
    [p1,m1]=find(tmp==Means);
    Mean_accuracy=Means(p1,m1);
    Variance=Vars(p1,m1);
    if pl==1
    [X,Y] = meshgrid(m,p);
    figure
    subplot(2,2,2);
    surfc(X,Y,Vars(:,:,n))
    title('Variances','FontSize',15)
    xlabel('\alpha-values')
    ylabel('p-values')
    zlabel('Variance')
    subplot(2,2,1)
    surfc(X,Y,Means(:,:,n))
    title('Mean classification accuracies','FontSize',15)
    xlabel('\alpha-values')
    ylabel('p-values')
    zlabel('Classification accuracy')
     subplot(2,2,3)
     surfc(X,Y,Maxsf(:,:,n))
     title('Maximum accuracies','FontSize',15)
     xlabel('\alpha-values')
     ylabel('p-values')
     zlabel('Classification accuracy')
     subplot(2,2,4)
     surfc(X,Y,Minsf(:,:,n))
     title('Minimum accuracies','FontSize',15)
     xlabel('\alpha-values')
     ylabel('p-values')
     zlabel('Classification accuracy')
    end
    clear Y
end
if length(sv_name) ~= 0
    save(sv_name)
end