function XYdata = add2XYdata(XYdata,newx,newy)
%This function takes points that have been simulated and adds them to the
%existing data structure
%XYdata is a structure with n elements of .x and .y. n is the number of
% design points tested. .x is a 1xd where d is the number of dimensions. .y
% is 1xr where r is the number of replicates for the design point.

n= size(newx,1);

%If the structure does not exist, create it
if (isempty(XYdata))
    XYdata.x = [];
    XYdata.y = [];
end

%Convert structure to a matrix of points
x = reshape([XYdata.x],length(XYdata(1).x),[])';

%Loop through all of the points to be added
for i=1:n
    %Does the points exist already in the array?
    %TODO this can be searched all at once.
    I = find(ismember(x,newx(i,:),'rows')==1);
    %If the point exists, add the response
    if (I>0)
        XYdata(I).y=[XYdata(I).y,newy(i)];
    %else if the point does not exist, add it
    else
        %Add the points to a temp structure 
        temp.x = newx(i,:);
        temp.y = newy(i);
        %Add the point in case there is a future point with the same
        % location. 
        x=[x;newx(i,:)];
        
        %If the first array is empty, add point to the first location
        if (isempty(XYdata(1).x))
            XYdata(1) = temp;
        else
            %else, build the array
            XYdata = [XYdata temp];
        end
    end
end