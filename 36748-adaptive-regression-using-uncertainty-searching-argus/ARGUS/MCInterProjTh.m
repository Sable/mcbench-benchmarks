function newDoE = MCInterProjTh(numpnts,oldDoE)
%This function finds new DoE locations to sample frun
% numpnts is the number of points to return
% oldDoE are the old DoE points
%This algoirhtm is based off of Crombecq et al. 2011
%"Efficient space-filling and non-collapsing sequential design strategies
%for simulation-based modeling"%
%It develops a "best" set of numpnts that approximate an optimized LHS
%design using an existing DoE

m = size(oldDoE,2);
%Increase the number of search points - the paper allows for 15mins of run 
% time. If possible, this multiplier should be increased if time allows.
mult = 2; 
%Alpha is always .5 as specified by the paper
alp=.5;
%Bound the old DoE to allow it to expand upto [0 1]
lbm=zeros(1,m);
ubm=ones(1,m);
oldDoE=[ubm;oldDoE;lbm]; 
%Create intial deisgn of points

newDoE=lhsdesign(mult*numpnts,m);
fval=zeros(mult*numpnts,1);
%Add one point at a time
for i=1:mult*numpnts
    %Update points in array to adapt on points already alocated
    pnts = [oldDoE;newDoE(1:i-1,:)];
    [n m] = size(pnts);
    %Calculate the minimum distance
    dmin = alp/size(pnts,1);
    
    %TODO ther must be a better way - what if the point is placed on the
    % edge?
    %Sort points to find the neighboring points
    [~, I]= sort([pnts;newDoE(i,:)]);
    nrstpnt=zeros(2,m);
    %Select neighboring points
    for j=1:m
        indx = find(I(:,j)==n+1);
        nrstpnt(1,j)=pnts(I(indx-1,j),j);
        nrstpnt(2,j)=pnts(I(indx+1,j),j);
    end
    %Place point at the center of the interval 
    cntpnt=(nrstpnt(2,:)+nrstpnt(1,:))/2;
    %Calculate the adjusted interval
    intr = (nrstpnt(2,:)-nrstpnt(1,:))-2*dmin;
    
    %Set objective function
    optfun = @(x) 1/(1+min(pdist2(x,pnts)));
    
    %This turns off a common warning message received by this algorithm. The
    % convergence of a single point to within approximated boundaries will not
    % affect the overall performance of the algorithm
    %If the interval is smaller than dmin, or the smalles step, don't optimize
    lrg=intr<(2e-08)*2; %this is the minimum distance for a 32 bit machine
    if all(lrg)
        newDoE(i,:)=cntpnt;
        %Find intersite distance
        fval(i) = feval(optfun,cntpnt);
    else
        %Set bounds - allow optimization along any line that is larger than
        % the minimum distance
        bnd = intr.*~lrg/2;
        lb = cntpnt-bnd; %split interval on either side
        ub = cntpnt+bnd; 
        options=optimset('Algorithm','sqp','Display','off','FunValCheck','off');
        %Optimize
        [newDoE(i,:) fval(i)]= fmincon(optfun,cntpnt,[],[],[],[],lb,ub,[],options);
    end
    if mod(i,30)==0, fprintf('Candidates found: %i...\n',i);end
end
%Return the points with the smallest intersite distances
[~,I]=sort(fval);
newDoE=newDoE(I(1:numpnts),:);
end