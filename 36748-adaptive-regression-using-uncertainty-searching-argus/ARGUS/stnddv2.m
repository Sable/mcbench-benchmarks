function stapx = stnddv2(XYdata,numpnts,reps,dis)
%This function approximates the standard deviation by using neighboring
%values

%This provides a limit on the number of total replicates to consider on
% neighboring points.
maxval= 15;
x= reshape([XYdata.x],length(XYdata(1).x),[])';
n = size(x,1);

if ~exist('dis','var') || isempty(dis)
    dis = pdist2(x,x);
end
%Ensure there are enough points available
if numpnts>n, numpnts=n;end
stapx=zeros(n,1);
parfor i=1:n %parfor
    %Finds the closest n points
    [~,pntsloc] = sort(dis(i,:));
    pntsloc=pntsloc(1:numpnts);
    y=[];
    leny = length(y); %this has to be done to remove a warning 
    for j=1:numpnts
        %Grab y values
        y=[y XYdata(pntsloc(j)).y];
        leny = length(y);
        %If the sampling has many replicates only use close samples
        if leny>maxval
            %Only give the limit of points
            if j~=1, leny=maxval;y=y(1:maxval);end 
            break;
        end  
    end
    stsamps = zeros(reps,1);
    for j=1:reps
        %Calculate the standard deviation - std func is not used because 
        % the mean has already been removed 
        samps = randi(leny,leny,1);
        stsamps(j)=std(y(samps));
    end
    %Find the mean standard deviation
    stapx(i)=mean(stsamps);
end

end