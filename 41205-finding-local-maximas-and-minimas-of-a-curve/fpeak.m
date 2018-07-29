function output = fpeak(x,y,s,Range)
%output = fpeak(x,y,s,range)
%       x and y are the data
%       s: is a scallar and determines the sensitivity of the function, the
%       default (minimum) value is 1.
%       Range: is the interval to find local maxima and minima and is 
%       optional, it has four elements: [x_min x_max y_min y_max]
%       output: is the xy position of local maxima's and minima's
% SEE ALSO findpeaks
%-----------------------------------------------------------------------
%       Author: Geng Jun, Dec 09, 2003
%       Email: dr.gengjun@126.com
%       Editted by: Farhad VISHKAEE, 23 May, 2010
%       Email: f.vishkaee@gmail.com
%       LinkedIn: http://www.linkedin.com/pub/farhad-vishkaee/33/191/40a
%-----------------------------------------------------------------------

rx = size(x,1);
ry = size(y,1);
if  rx==1
    x = x';
    rx = length(x);
end
if  ry==1;
    y = y';
    ry = length(y);
end
if  rx~=ry
    fprintf('%s','Vector element must agree!');
    return
end
s(2) = 0;
if ~s(1)
    s(1) = 1;
end
s(2) = [];
numP = 1;
Data = sortrows([x,y]);
for i=1:rx
    isP = getPeak(Data,i,s);
    if  sum(isnan(isP))==0
        output(numP,:) = isP; %#ok
        numP = numP + 1;
    end
end
if nargin == 4
    index_ = output(:,1)>=Range(1) & output(:,1)<=Range(2);
    output = output(index_,:);
    clear index_
    index_ = output(:,2)>=Range(3) & output(:,2)<=Range(4);
    output = output(index_,:);
end

%-------------------------------------------
function p = getPeak(Data,i,s)
%English: Select points by sensitivity
if i-s<1
    top = 1;
else
    top = i-s;
end
y = Data(:,2);
if i+s>length(y)
    bottom = length(y);
else
    bottom = i + s;
end

tP = (sum(y(top:bottom)>=y(i))==1);
bP = (sum(y(top:bottom)<=y(i))==1);
if tP==1 || bP==1
    p = Data(i,:);
else
    p = [nan,nan];
end
% End of the mfile