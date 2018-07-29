function mb_iGMM1D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2011 by Mark Bangert markbangert@gmail.com
% inference with an infinite Gaussian mixture model
% http://www.gatsby.ucl.ac.uk/~edward/pub/inf.mix.nips.99.pdf

% this routine may be called without input data. 
% a test data set is produced from a mixture of Gaussians

numOfIterations = 1000;
numOfBurnInIter =  300;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% produce data
numOfDataPoints = 1000; % number of data points

% true values of the generating parameters
true_numOfClasses = 10;
true_alpha        = 0.5;
true_lambda       = 180;
true_r            = 0.008;
true_beta         = 3;
true_w            = 100;

% generate weights of the clusters, their means and their variances
true_mus          = randn(1,true_numOfClasses)/true_r + true_lambda;
true_precs        = gamrnd(true_beta,1/true_w,1,true_numOfClasses);
tmp               = gamrnd(true_alpha,1,1,true_numOfClasses);
true_weights      = tmp/sum(tmp); clear tmp;

% generate samples
missingData       = mb_mvrnd(true_weights,numOfDataPoints);
data              = randn(1,numOfDataPoints)./(true_precs(missingData)).^.5 + true_mus(missingData);

        % visualize data and ground truth
        scrsz = get(0,'ScreenSize');

        clusterFigHandle = figure('Position',[1 scrsz(2) scrsz(3)/2 scrsz(4)],'Name','Clustering');

        colorMx = colormap(jet);
        colorMx = colorMx(randperm(64),:);

        hold on
        [counts,bins] = hist(data,floor(numOfDataPoints/10));
        counts = counts/(sum(counts)*(bins(2)-bins(1))); % normalization of histograms
        bar(bins,counts,'EdgeColor','none');
        for i = 1:true_numOfClasses
            y = (true_precs(i)/2/pi)^.5 * exp(-(bins-true_mus(i)).^2*true_precs(i)/2); % normalized gaussian
            plot(bins,y*true_weights(i),'k--','LineWidth',2); % normalize according to weights
        end
        currIgmmVisHandle = [];
        currSolution = 0*y;
        currSolutionVisHandle = [];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% start inference

tic

dataMean           = mean(data);
dataVar            = var(data);
numOfPointsInClass = numOfDataPoints;


% start the markov chain with one class
alphaProbDensity   = @(x)x^(-3/2)*exp(-1/2/x); % eq 14
alpha              = mb_sliceSampling(alphaProbDensity,rand,1);
lam                = randn*dataVar^.5 + dataMean; % eq 3
r                  = gamrnd(1/2,2/dataVar,1,1); % eq 3
betaProbDensity    = @(x)x^(-3/2)*exp(-1/2/x); % eq 7
beta               = mb_sliceSampling(betaProbDensity,rand,1);
w                  = gamrnd(1/2,2*dataVar,1,1); % eq 7
mus                = randn/r^.5 +lam; % eq 2
precs              = gamrnd(beta/2,2/w/beta,1,1); % eq 6
cs                 = ones(1,numOfDataPoints);
numOfClasses       = 1;
            
% perform a large number of MCMC sampling steps
iter = 0;
while iter < numOfIterations
    
    iter = iter + 1;
    
            % visualization
            figure(clusterFigHandle);
            delete(currIgmmVisHandle);
            currIgmmVisHandle = [];
            
            for i = 1:numOfClasses
                
                currIgmmVisHandle = [currIgmmVisHandle plot(bins,(precs(i)/2/pi)^.5*numOfPointsInClass(i)/numOfDataPoints* ...
                    exp(-(bins-mus(i)).^2*precs(i)/2),'Color',colorMx(mod(i-1,size(colorMx,1))+1,:),'LineWidth',2)];

            end
            
    % collapsed gibbs sampling
    for i = 1:numOfClasses
        
        numOfDataPointsInCurrClass = numOfPointsInClass(i);
        dataOfCurrClass            = data(cs==i);
        meanOfCurrClass            = mean(dataOfCurrClass);
        precOfCurrClass            = precs(i);

        % for mu - eq 4
        newLoc   = (meanOfCurrClass*numOfDataPointsInCurrClass*precOfCurrClass + lam*r) / (numOfDataPointsInCurrClass*precOfCurrClass + r);
        newScale = 1/(numOfDataPointsInCurrClass*precOfCurrClass + r);
        mus(i)   = randn*newScale^.5 + newLoc;
        
        % for s - eq 8
        newLoc   = (beta + numOfDataPointsInCurrClass)/2;
        newScale = 2/(w*beta + sum((dataOfCurrClass-mus(i)).^2));
        precs(i) = gamrnd(newLoc,newScale,1,1);
        
    end

    % for lambda - eq 5
    newLoc   = (dataMean/dataVar + r*sum(mus)) / (1/dataVar + numOfClasses*r);
    newScale = 1 / (1/dataVar + numOfClasses*r);
    lam      = randn*newScale^.5 + newLoc;

    % for r - eq 5
    newLoc   = (1 + numOfClasses)/2;
    newScale = 2/(dataVar + sum((mus-lam).^2));
    r        = gamrnd(newLoc,newScale,1,1);

    % for w - eq 9
    newLoc   = (numOfClasses*beta + 1)/2;
    newScale = 2/(1/dataVar + beta*sum(precs));
    w        = gamrnd(newLoc,newScale,1,1);

    % for beta - eq 9 - stay in log space for a long time
    betaProbDensity = @(x)exp(-numOfClasses*gammaln(x/2) - 1/2/x - .5*(numOfClasses*x-3)*log(x/2) + sum( (x/2)*log(precs*w) - x*w*precs/2 ));
    beta = mb_sliceSampling(betaProbDensity,beta,1);
    
    % for alpha - eq 15 - stay in logspace for a long time (gammaln(numOfDataPoints) for numerical stability)
    alphaProbDensity = @(x)exp( (numOfClasses-3/2)*log(x) - .5/x + gammaln(x) - gammaln(x+numOfDataPoints) + gammaln(numOfDataPoints));
    alpha = mb_sliceSampling(alphaProbDensity,alpha,1);
    
    % assign classes to data with precomputed randomnumbers (faster)
    normRandVar = randn(1,numOfDataPoints)/r^.5 + lam;
    gamRandVar  = gamrnd(beta/2,2/w/beta,1,numOfDataPoints);
    randVar     = rand(1,numOfDataPoints);
    
    for i = 1:numOfDataPoints

        prob = NaN*zeros(1,numOfClasses+1);
        
        % calculate probability for membership in existing classes
        for j = 1:numOfClasses

            if cs(i) == j; % if data point member of this class
                nij               = numOfPointsInClass(j) - 1;
            else
                nij               = numOfPointsInClass(j);
            end

            if nij > 0
                prob(j) = nij/(numOfDataPoints-1+alpha)*(precs(j))^.5 * exp(-precs(j)/2 * (data(i)-mus(j))^2);
            else % if data point the only member in this class
                prob(j) = alpha/(numOfDataPoints-1+alpha)*(precs(j))^.5 * exp(-precs(j)/2 * (data(i)-mus(j))^2);
            end

        end

        % probability for membership in new class - eq 17
        % sample paramters for this class from priors
        mu_new    = normRandVar(i);
        s_new     = gamRandVar(i);
        prob(end) = alpha/(numOfDataPoints-1+alpha)*s_new^.5*exp(-s_new/2 * (data(i)-mu_new)^2);
        
        cdf       = cumsum(prob);
        rndNum    = randVar(i)*cdf(end);
        
        % assign data point to class according to probability
        for j = 1:numOfClasses + 1
           if cdf(j) >= rndNum % bingo this data point will be assigned to class j
               numOfPointsInClass(cs(i)) = numOfPointsInClass(cs(i)) - 1;
               if numOfPointsInClass(cs(i)) < 1
                    fprintf(['Removing class # ' num2str(cs(i)) '\n']);
                    % remove parameters
                    mus(cs(i))                = [];
                    precs(cs(i))              = [];
                    numOfPointsInClass(cs(i)) = [];
                    numOfClasses              = numOfClasses - 1;
                    j(j>cs(i))                = j - 1;
                    % rename all higher classes
                    cs(cs>cs(i))              = cs(cs>cs(i)) - 1;                
               end
               cs(i) = j;
               break;
           end
        end
        
        if j == numOfClasses + 1
            fprintf(['Adding new class # ' num2str(j) '\n']);
            % add parameters
            mus                   = [mus mu_new];
            precs                 = [precs s_new];
            numOfPointsInClass(j) = 1;
            numOfClasses          = numOfClasses + 1;
        else
            numOfPointsInClass(j) = numOfPointsInClass(j) + 1;
        end
        
    end
    
            % visualization of final solution - start after burn in
            if iter >= numOfBurnInIter
                delete(currSolutionVisHandle);
                contributionOfCurrentSample2Solution = 0*bins;            
                for i = 1:numel(mus)

                    contributionOfCurrentSample2Solution = contributionOfCurrentSample2Solution + ...
                        (precs(i)/2/pi)^.5*numOfPointsInClass(i)/numOfDataPoints*exp(-(bins-mus(i)).^2*precs(i)/2);

                end

                currSolution = (iter-numOfBurnInIter)/(iter-numOfBurnInIter+1)*currSolution + ...
                    1/(iter-numOfBurnInIter+1)*contributionOfCurrentSample2Solution;

                currSolutionVisHandle = plot(bins,currSolution,'c','LineWidth',4);
            end
            drawnow;

end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% helper functions

function rndVar = mb_mvrnd(p,n)
    
r      = rand(1,n);
p      = cumsum(p);
if p(end)~=1
    p = p/p(end);
end

rndVar = ones(1,n);
for i = 1:n
    rndVar(i) = find(r(i)<=p,1,'first');
end

end

function randNumbers = mb_sliceSampling(customFunc,xStart,numOfRandNumbers)
% slice sampling implementation according to section 29.7 from
% http://www.inference.phy.cam.ac.uk/itprnn/book.pdf

tic

if nargin < 2
    xStart = rand;
end
if nargin < 3
    numOfRandNumbers = 1;
end

randNumbers = NaN*ones(1,numOfRandNumbers);

for i = 1:numOfRandNumbers

    yStart     = customFunc(xStart);

    randStart  = rand*yStart;

    randStep   = rand;
    stepLength = .1;

    xLeft      = xStart - randStep*stepLength;
    xRight     = xStart + (1-randStep)*stepLength;

    counter = 0;
    while customFunc(xLeft) > randStart
        xLeft = xLeft - stepLength*2^counter;
        counter = counter + 1;
    end
    counter = 0;
    while customFunc(xRight) > randStart
        xRight = xRight + stepLength*2^counter;
        counter = counter + 1;
    end

    while 1
        randNumber = rand*(xRight-xLeft) + xLeft;
        randNumberFuncVal = customFunc(randNumber);
        if randNumberFuncVal > randStart && imag(randNumberFuncVal) == 0
            break;
        else
            if randNumber > xStart
                xRight = randNumber;
            else
                xLeft = randNumber;
            end
        end
        
        elTime = toc;
        if elTime > 10
            randNumbers = NaN;
            return;
        end
        
    end
    
    randNumbers(i) = randNumber;
    xStart = randNumber;

end

end

