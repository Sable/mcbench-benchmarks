function [mufun stErrfun stdfun] = Btsrpprs(XYdata, reps,nghbr)
%This function conducts a pairs bootstrap to determine the unbiased mean
% estimator regression function
%XYdata is a structure with n elements of .x and .y. n is the number of
% design points tested. .x is a 1xd where d is the number of dimensions. .y
% is 1xr where r is the number of replicates for the design point.
%reps is the number of bootstrap samples. Literature suggests this value
% should be between 50-200. The methods is not very sensitive to the number

disp('Bootstrapping space...')
%Restrucutre x to a matrix
x = reshape([XYdata.x],length(XYdata(1).x),[])';

%Specify the function handle for spline method
psifun = @psifunc;

%Determine the total number of points in the space including replications
[n m] = size(x);
len=zeros(n,1);
ytemp=zeros(n,1);
for j=1:n
    len(j) = length(XYdata(j).y); 
    ytemp(j)= mean(XYdata(j).y);
end
sampsz=sum(len);

%Only calculate the distance matrix only once and remove objects for speed
dis = pdist2(x,x);
%Allocate space for bootstrapping data
btdata = zeros(n,reps);
%Conduct bootstrap sampling
parfor i=1:reps % parfor does not have consistent random numbers
    %Create a sampling from the population weighted to number of
    % replications
    sampT=randsample(n,sampsz,true,len);
    %Only select the unique samples to make the regression
    samp= unique(sampT); 
    %Number of replications for each sample
    sampreps = histc(sampT,samp);
    xsamp=x(samp,:);
    ysamp=zeros(length(samp),1);
    for j=1:length(samp)
        %Randomly sample the values 
        ysamp(j)=mean(XYdata(samp(j)).y(randi(len(samp(j)),sampreps(j),1)));
    end
    %Keep only the samples used in the distance matrix
    distemp=dis(samp,:); %TODO there must be a faster way
    distemp=distemp(:,samp); %this may be a source of issue later order needs to be maintaned
    %Fit a polyharmonic spline. Provide function handle for spline order
    funHndl =tpapsn(xsamp,ysamp,psifun,distemp,false); %I need to check this 
    btdata(:,i)=feval(funHndl,x);
    if mod(i,20)==0, fprintf('Done with %i samples\n',i);end
end

%Remove any NaNs from the array - this can happen if the spline
% solution is singular or two few points
nans = (sum(isnan(btdata))>1);
btdata(:,nans)=[];

%Find the unbiased approximation 
%Mean
mu = mean(btdata,2);
%Standard error
stErr = std(btdata,[],2);

%For easy evaluation, fit interpolation method to the unbiased mean,
% standard error and standard deviation- otherwise all function handles 
% would have to be stored
mufun = tpapsn(x,ytemp,psifun,dis,false);
stErrfun = tpapsn(x,stErr,psifun,dis,false);
%Find the standard deviation over the space using the convariance
% Calculate this here because the dis has already been calculated
% There are few samples to bootstrap, meaning sample reps are sufficient
st = stnddv2(XYdata,nghbr,reps,dis);
%Fit regression to the standard deviation
stdfun = tpapsn(x,st,psifun,dis,false);

end