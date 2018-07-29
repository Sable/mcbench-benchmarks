function [newpoints hist] = ARGUS(XYdata,numsamp,hist)
%Adaptive ReGression using Unreplicated Smoothing is a DoE method intended
% for SoS design spaces or any space which exhibits features of similar
% interest (discrete changes and locally high regions of variance).
%XYdata is a structure with n elements of .x and .y. n is the number of
% design points tested. .x is a 1xd where d is the number of dimensions. .y
% is 1xr where r is the number of replicates for the design point.
%numsamp is the number of samples to be added for the iteration. If numsamp
% is 1, only exploration simulations will be used. If 2, equal split of
% repetitions and exploration will be used
%hist is a structure which contains information from previous iterations
% .stdfun is the function handle for the standard deviation. .stErrfun is
% the handle for standard error. .mufun is the function handle for the the 
% learned mean 
% hist can be left empty the first iteration.
 
x = reshape([XYdata.x],length(XYdata(1).x),[])';
%This is the default number of neighbor points to include when 
% investigating the variance
nghbr=10;
%Learn mean, standard deviation and standard error using bootstrapping
% Literature identifies 100 replications are sufficient. Increasing this
% number adds litter to the fidelity.
[mufun stErrfun stdfun] = Btsrpprs(XYdata, 100,nghbr); 

%Is this the first iteration?
if (~exist('hist','var') || isempty(hist))
    %The first iteration explores the standard deviation and mean function
    %equally. Tests have shown this is a good ratio initially. 
    hist = struct;
    hist.ratio =.50;
    hist.itt=1;
else
    %Determine the ratio of repetitions to exploration
    % Build vector for traking - also use in single points simulations
    hist.ratio = [hist.ratio detrmrto(mufun,stdfun,numsamp,hist)];
    hist.itt=hist.itt+1;
end

%Distrubutes repitptions - use floor to prevent only repetitions
[xreps numreps] = ...
    distbReps(XYdata,floor(numsamp*hist.ratio(end)),stdfun);

%Distribute exploration points
xexp = distbNewPnt(XYdata,ceil(numsamp-numsamp*hist.ratio(end)),stErrfun);

%Record the locations explored with replications. This is used in future 
% iterations
hist.x.loc=[x(numreps>0,:);xexp];
%Record the number of repetitions per location
hist.x.reps = [numreps(numreps>0);zeros(size(xexp,1),1)];
hist.mufun=mufun;
hist.stErrfun=stErrfun;
hist.stdfun=stdfun;
%Return the points simulate
newpoints = [xreps;xexp];
end


function [newpnt]=distbNewPnt(XYdata,numAddPnts,stErrfun)
%This function distributes points for exploration 
%XYdata is a structure with n elements of .x and .y. n is the number of
% design points tested. .x is a 1xd where d is the number of dimensions. .y
% is 1xr where r is the number of replicates for the design point.
%numpnts is the number of points to add distributed over the design space
%stErrfun is a function handle for the standard error
 disp('Finding new candidate points...')
xloc = reshape([XYdata.x],length(XYdata(1).x),[])';
m = size(xloc,2);

%Find locations for each point - scales by m because more points are
% needed as the dimension increases
%It might be better to find locations based how many points are already
%in the space versus dimensions
numAdd = max(numAddPnts*2,size(xloc,1));
testpnts = MCInterProjTh(numAdd,xloc);

%Score each point for regions
scr = feval(stErrfun,testpnts);
%Find top values
[~,I] = sort(scr,1,'descend');
%Return the top scoring values
newpnt = testpnts(I(1:numAddPnts),:);

end

function [x newreps]=distbReps(XYdata,numAddPnts,stdfun)
%This function determines the number of replications for each of the design 
% points tested. The function proportions the number of total replications 
% to regions that have the highest standard error. 
%XYdata is a structure with n elements of .x and .y. n is the number of
% design points tested. .x is a 1xd where d is the number of dimensions. .y
% is 1xr where r is the number of replicates for the design point.
%numpnts is the number of replication points to distributed over the design
% space
%stErrfun is a function handle for the approximate standard Error

%If no repetitions are to be added, return
if numAddPnts==0, x=[];newreps=[]; return;end
%Allocate
n = length(XYdata);
m = length(XYdata(1).x);
reps = zeros(n,1);
sigs = zeros(n,1);

%Find the number of repetitions and approximate standard error for each 
% point
for i=1:n
    %A repetition is anything greater than 1 sample
    reps(i) = length(XYdata(i).y)-1;
    sigs(i) = feval(stdfun,XYdata(i).x);
end

%Calculate the total standard error and number of points over the space
Tsig = sum(sigs);
Treps = sum(reps)+numAddPnts;

%Maps the ratio of points to regions that have high standard error
% only keep points that are considered to need more points <0 means with
% the current exploration, too many points are at the location
newreps = max(0,sigs./Tsig*Treps-reps); 

%Determine the total points which should be added 
Tnewreps = sum(newreps); 
%Sort the locations which need the most points
[temp I]= sort(numAddPnts*newreps./Tnewreps,1,'descend');
%Add integer replications until the allocated number of replicates are
% added
for i=1:length(temp)
    %Round the number of replications to integers
    temp(i) = ceil(temp(i));
    %Determine the number replications added thus far
    Tpnts=sum(temp(1:i));
    %Exit if enough points have been added
    if(Tpnts>=numAddPnts)
        %Check if too many point have been added
        if(Tpnts>numAddPnts), temp(i)=numAddPnts-sum(temp(1:i-1)); end
        %Everything else has zero replications
        temp(i+1:end) = 0;
        break;
    end
end
%Update order to be identical to the x locations
newreps(I) = temp;
%Check if there is any variance
if 0==sum(sigs)
    %Randomly place points based on what has the smallest reps
    for i=1:numAddPnts
        [~,I]=min(reps);
        reps(I)=reps(I)+1; %updates so points are distributed
        if isnan(newreps(I))
            newreps(I)=1;
        else
            newreps(I)=newreps(I)+1;
        end
    end
    newreps(isnan(newreps))=0;
end
%TODO: There should be a faster way
%Add the number of replications for each of the x locations
x=zeros(nansum(temp),m);
elm=1;
for i=1:length(newreps)
    for j=1:newreps(i)
        x(elm,:) = XYdata(i).x;
        elm=elm+1;
    end
end

end

function [ovrrto murto sigrto] =detrmrto(mufun, stdfun,numpnt,hist) 
%This function determines the ratio of repetitions to exploratory 
%experiments
%mufun is the most up-to-date mean function handle
%sigmafun is the most up-to-date standard deviation function handle
%numpnt is the total number of points to be added in the simulation
%hist is a structure which contains information from the previous
% iteration
%hist.mufun is the mean function handle from the previous iteration
%hist.sigmafun is the sigma function handle from the previous iteration
%hist.x.loc are the last iteration of x locations tested 
%hist.x.rep is the number or repetition test per location on the last

%If no repetitions are to be added, return
if numpnt==1, ovrrto=0;murto=0;sigrto=0; return;end

%Find the square improvment for both the mean and standard deviation
sqmudifs = (feval(mufun,hist.x.loc)-feval(hist.mufun,hist.x.loc)).^2;
sqsigdifs = (feval(stdfun,hist.x.loc)-feval(hist.stdfun,hist.x.loc)).^2;
%Only look at the points which had a repetitions on the last run
repOrEx = hist.x.reps>0;

%Find the change caused be exploration simulations
Emuchg = mean(sqmudifs(~repOrEx));
Esigchg = mean(sqsigdifs(~repOrEx));
Rmuchg=sum(sqmudifs(repOrEx).*hist.x.reps(repOrEx))/sum(hist.x.reps);
Rsigchg=sum(sqsigdifs(repOrEx).*hist.x.reps(repOrEx))/sum(hist.x.reps);

%Find the average change for repetitions to total average change
% This normalizes both changes 
murto=Rmuchg/(Rmuchg+Emuchg);
sigrto=Rsigchg/(Rsigchg+Esigchg);

ovrrto = (murto+sigrto)/2;
ovrrto = (ovrrto+hist.ratio(end))/2; %Prevent over correction

%Prevent the ratio from only exploring one or the other
if(ovrrto> (numpnt-1)/numpnt)
    ovrrto = (numpnt-1)/numpnt;
elseif(ovrrto<1/numpnt || isnan(ovrrto))%Incase no improvement, search only
    ovrrto = 1/numpnt;
end

end


