function r=controlling(NR)
%CONTROLLING determine the array of indices of Bounding boxes of interest.
%   R=CONTROLLING(NR) outputs the row vector R containing the indices of
%   the bounding boxes of interest from the matrix NR. NR is the matrix of
%   order numberofregionsx4. Numberofregions are the total number of
%   regions extracted from the function regionprops with the property
%   'BoundingBox'. To ensure the order cat(1,...) function could be used.
%   The code for this function emphasize on obtaining the indices of
%   Bounding boxes whose width along the y-dimension is nearly same. If
%   the approach of y-width doesn't work then Bounding Boxes with nearly
%   same y-coordinates are obtained.

[Q,W]=hist(NR(:,4)); % Histogram of the y-dimension widths of all boxes.
ind=find(Q==6); % Find indices from Q corresponding to frequency '6'.
% Since the number plates of cars in Karachi have six characters so
% find(Q==6) is used. If the code is to be implemented for some other plates
% the argument to the function 'find' has to be changed accordingly.
% Q is a row vector of frequency and W is the row vector of all the mid
% points of bins. Hist automatically selects the range of W from its input
% argument.

for k=1:length(NR)            % Taking the advantage of uniqueness of y-co
    C_5(k)=NR(k,2) * NR(k,4); % ordinate and y-width.
end
NR2=cat(2,NR,C_5');           % Appending new coloumn in NR.
[E,R]=hist(NR2(:,5),20);
Y=find(E==6);                 % Searching for six characters.
if length(ind)==1 % If six boxes of interest are succesfully found record
    MP=W(ind);    %  the midpoint of corresponding bin.
    binsize=W(2)-W(1); % Calculate the container size.
    container=[MP-(binsize/2) MP+(binsize/2)]; % Calculating the complete container size.
    r=takeboxes(NR,container,2);
elseif length(Y)==1
    MP=R(Y);
    binsize=R(2)-R(1);
    container=[MP-(binsize/2) MP+(binsize/2)]; % Calculating the complete container size.
    r=takeboxes(NR2,container,2.5); % Call to function takeboxes.    
elseif isempty(ind) || length(ind)>1 % If there is no vlaue of '6' in the Q vector.
    [A,B]=hist(NR(:,2),20); % Use y-coordinate approach only.
    ind2=find(A==6);
    if length(ind2)==1
        MP=B(ind2);
        binsize=B(2)-B(1);
        container=[MP-(binsize/2) MP+(binsize/2)]; % Calculating the complete container size.
        r=takeboxes(NR,container,1);
    else
        container=guessthesix(A,B,(B(2)-B(1))); % Call of function guessthesix.
        if ~isempty(container) % If guessthesix works succesfully.
            r=takeboxes(NR,container,1); % Call the function takeboxes.
        elseif isempty(container)
            container2=guessthesix(E,R,(R(2)-R(1)));
            if ~isempty(container2)
                r=takeboxes(NR2,container2,2.5);
            else
                r=[]; % Otherwise assign an empty matrix to 'r'.
            end
        end
    end
end
end