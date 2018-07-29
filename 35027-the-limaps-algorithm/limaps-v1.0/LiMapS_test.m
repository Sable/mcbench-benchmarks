function [ alpha ] = LiMapS_test(n, m, k)

%% --  INITIALIZATION  --

[D DINV true_alpha s] = CreateDict(n,m,k,1,'Real','Gaussian');

alpha = DINV*s;
lambda = 1/norm(s);

epsilon=1e-5;                    % stopping criteria
alpha_min=1e-4;

close all;
f=figure(1);

maxIter=1000;
gamma=1.01;

snrs=[];
errs=[];  

I=[];
Ita=[];

%% --  CORE  --
for i=1:maxIter
    
    alphaold=alpha;

    % apply sparsity constraction mapping: increase sparsity
    beta = alpha.*(1-exp(-lambda.*abs(alpha)));
    
    % apply the orthogonal projection
    alpha = beta-DINV*(D*beta-s);
    
    % threshold the noise coefficients 
    alpha(abs(alpha)<alpha_min) = 0;
    
    % -- plotting
    if ishandle(1)
        clf(1)
    else
        figure(1);
    end
    
    subplot(2,2,1);
    title('Coefficients');
    hold on
    id_true_alpha = true_alpha~=0;
    stem(find(id_true_alpha),true_alpha(id_true_alpha),':r*')
    plot(1:numel(alpha), 1/lambda*ones(numel(alpha),1),'g');
    plot(1:numel(alpha), -1/lambda*ones(numel(alpha),1),'g');
    id_alpha = alpha~=0;
    stem(find(id_alpha),alpha(id_alpha),'bo');
    hold off

    I=[I sum(1-exp(-lambda*abs(alpha)))];
    Ita=[Ita sum(1-exp(-lambda*abs(true_alpha)))];
    subplot(2,2,2);
    title('I');
    hold on
    grid on
    plot(I);
    plot(Ita,'r');
    hold off

    err = EstimateERR(alpha, true_alpha);
    errs=[errs err];
    
    subplot(2,2,3);
    title('Error');
    grid on
    hold on
    plot(errs);
    hold off;
    
    snr = EstimateSNR(alpha, true_alpha);
    snrs=[snrs snr];
    
    subplot(2,2,4);
    title('SNR');
    grid on
    hold on
    plot(snrs);
    hold off;
    
    pause(0.01)
    
    % update the lambda coefficient
    lambda = lambda*gamma;
    
    % check the stopping criteria
    if (norm(alpha-alphaold)<epsilon)
        break;
    end
   
end

%% -- REFINEMENT --

% final refinements of the solution
for i=1:size(alpha,2);
    alpha_ind = alpha(:,i)~=0;
    D1 = D(:,alpha_ind);
    alpha(alpha_ind,i) = alpha(alpha_ind,i) - pinv(D1)*(D1*alpha(alpha_ind,i)-s(:,i));
end

end

function [ err ] = EstimateERR ( alpha, true_alpha )

    err = norm(alpha-true_alpha)^2;

end

function snr = EstimateSNR(alpha, true_alpha)
    err = true_alpha - alpha;
    snr = 10*log10(sum(abs(true_alpha).^2)/sum(abs(err).^2));
end
