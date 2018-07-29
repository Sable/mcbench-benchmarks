function [gammas,Lambda,joints2D]=FindDGAnyMarginal(pmfs,Sigma,supports)
%
% [gammas,Lambda,joints2D] = FindDGAnyMarginal(pmfs,Sigma,supports)
%   Finds the paramters of a Multivariate Discretized Gaussian with specified marginal
%   distributions and covariance matrix
%
%   Inputs:
%     pmfs: the probability mass functions of the marginal distribution of the
%       input-random variables. Must be a cell-array with n elements, each of
%       which is a vector which sums to one
%     Sigma: The covariance matrix of the input-random variable. The function
%       does not check for admissability, i.e. results might be wrong if there
%       exists no random variable which has the specified marginals and
%       covariance.
%     supports: The support of each dimension of the input random variable.
%       Must be a cell-array with n elements, each of whcih is a vector with
%       increasing entries giving the possible values of each random variable,
%       e.g. if the first dimension of the rv is 1 with probability .2, 3 with
%       prob .8, then pmfs{1}=[.2,.8], supports{1}=[1,3]; If no support is
%       specified, then each is taken to be [0:numel(pdfs{k}-1];
%
%   Outputs:
%     gammas: the discretization thresholds, as described in the paper. When
%       sampling. The k-th dimension of the output random variable is f if e.g.
%       supports{k}(1)=f and gammas{k}(f) <= U(k) <= gammas{k}(f+1)
%     Lambda: the covariance matrix of the latent Gaussian random variable U
%     joints2D: An n by n cell array, where each entry contains the 2
%       dimensional joint distribution of  a pair of dimensions of the DG.
%
%   Important:
%     This function currently needs both the statistics toolbox and the optimization
%     toolbox, but could easily be rewritten to get rid of the functions from
%     the toolboxes which are used. In addition, the optimization is currently
%     very inefficient, the function could be sped up considerably.
%
% Code from the paper: 'Generating spike-trains with specified
% correlations', Macke et al., submitted to Neural Computation
%
% www.kyb.mpg.de/bethgegroup/code/efficientsampling

%desired accuracy for optimization:
acc=1e-5;

%keyboard
numdims=numel(pmfs);
for k=1:numdims
    %take default supports if only one argument is specified
    if nargin==2 || isempty(supports) || numel(supports)<k
        supports{k}=[0:numel(pmfs{k})-1];
    end
    supports{k}=supports{k}(:);
    pmfs{k}=pmfs{k}(:);
    cmfs{k}=[cumsum(pmfs{k})];
    mu(k)=supports{k}'*pmfs{k};
    assert(all(pmfs{k}>=0) & all(pmfs{k}<=1) & abs(sum(pmfs{k})-1)<acc,'input pmfs must consist of probability vectors')
    assert(issorted(supports{k}),'input values must be sorted')
    gammas{k}=norminv(cmfs{k});
    if Sigma(k,k)<=0 || isnan(Sigma(k,k));
        Sigma(k,k)=(supports{k}.^2)'*pmfs{k}-mu(k).^2;
    end
end


%numerics for finding the off-diagonal entries. Very inefficient
%and use of the optimization toolbox is really an overkill for finding the
%zero-crossing of a one-dimensional funcition on a compact interval

ops=optimset('TolX',10^(-5),'maxiter',50,'display','off','LargeScale','off');
Lambda = NaN(numdims);


for i=1:numdims
    Lambda(i,i)=1;
    joints2D{i,i}=pmfs{i};
    for j = i+1:numdims
        fprintf('Finding Lambda(%d %d)\n',i,j)
        moment=Sigma(i,j)+mu(i)*mu(j);
        %take the correlation coefficient between the two dimensions as
        %starting point
        x0=Sigma(i,j)/sqrt(Sigma(i,i))/sqrt(Sigma(j,j));
        [mX,vval] = fminbnd(@(x) MiniDiff(x,moment,gammas{i},gammas{j},supports{i},supports{j}),-1,1,ops);
        Lambda(i,j)=mX;
        Lambda(j,i) = Lambda(i,j);
        [KK,joints2D{i,j}]=DGSecondMoment(mX,gammas{i},gammas{j},supports{i},supports{j});
        joints2D{j,i}=joints2D{i,j}';
    end
end




%% subfunction MiniDiff
function [Mini]=MiniDiff(lambda,speccov, gamma1,gamma2,support1,support2)
%minimized squared difference between the specified covariance speccov and the
%covariance of the DG
%not optimized for speed yet, in fact, it is terrible for speed. For
%example, one really easy thing would be to evalulate the cholesky of the
%covariance (in the bivariate gaussian cdf) only once, and not multiple
%time

if lambda<=-1
    lambda=-1+.0000000001;
end

if lambda>=1
    lambda=1-.0000000001;
end

[Mini]=DGSecondMoment(lambda,gamma1,gamma2,support1,support2);

Mini=(Mini-speccov)^2;




%% subfunction DGSecondMoment: Calculate second Moment of the DG
%for a given correlation lambda
function [secmom,joint]=DGSecondMoment(lambda,gamma1,gamma2,support1,support2)
%a very, very inefficient function for calculating the second moments of a
%DG with specified gammas and supports and correlation lambda
sig=[1,lambda;lambda,1];
[x,y]=meshgrid(support2,support1);
xy=x.*y;
momentterms=0*xy';

Ps=0*xy;
Ps2=0*xy;

for k=1:numel(support1);
    for kk=1:numel(support2);
        Ps(k,kk)=mvncdf([gamma1(k),gamma2(kk)],0,sig);
    end
end

Ps2=Ps;
for k=1:numel(support1);
    for kk=1:numel(support2);

        if k>1 && kk>1
            Ps2(k,kk)=Ps(k,kk)+Ps(k-1,kk-1)-Ps(k-1,kk)-Ps(k,kk-1);


        elseif kk>1 && k==1
            Ps2(k,kk)=Ps(k,kk)-Ps(k,kk-1);


        elseif k>1 && kk==1
            Ps2(k,kk)=Ps(k,kk)-Ps(k-1,kk);


        elseif k==1 && kk==1
            Ps2(k,kk)=Ps(k,kk);


        end

    end
end

Ps2=max(Ps2,0);

joint=Ps2;
Ps2=Ps2.*xy;

secmom=sum(vec(Ps2));







