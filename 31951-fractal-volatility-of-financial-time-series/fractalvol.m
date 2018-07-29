function [dimension standard_dev] = fractalvol(data)
%[DIMENSION STANDARD_DEV] = fractalvol(DATA) calculates the fractal
%dimension of the 1 dimensional random walk, DATA. DATA is assumed to be a
%function of its indices.
%   Finds fractal volatility by embedding in the unit square and box
%   counting. Y axis will be rescaled values of DATA, x axis is 
%   (1:length(DATA))/length(DATA).
%
%   Uncomment the else construction if you have the parallel computing 
%   toolbox and wish to run the code in parallel (it scales linearly in instances).

if size(data,1) < size(data,2)
    data = data';
end

if size(data,2) == 1
    data = [(1:length(data))' data];
end

max1 = max(data(:,1));
min1 = min(data(:,1));
max2 = max(data(:,2));
min2 = min(data(:,2));

%normalize all to unit square
normdata = data;
normdata(:,1) = normdata(:,1)-min1;
normdata(:,1) = normdata(:,1)./(max1-min1);
normdata(:,2) = normdata(:,2)-min2;
normdata(:,2) = normdata(:,2)./(max2-min2);

%make sure nothing falls through the x axis
minwidth = min(diff(normdata(:,1)));
minwidth = log2(minwidth);
minwidth = abs(ceil(minwidth));
minwidth = minwidth-1;

n = zeros(minwidth,1);

% parallcntrl = matlabpool('size');

% if parallcntrl == 0
    for j = 1:minwidth
        width = 2^-j;
        xaxis_pos = 0;
        boxcount = 0;
        while xaxis_pos<1
            indx = (xaxis_pos <= normdata(:,1) &...
                normdata(:,1)<xaxis_pos+width);
            if 1-xaxis_pos == width
                indx(end) = true;
            end
            
            vertical_column = normdata(indx,2);
            
            if length(vertical_column) == 1
                boxcount = boxcount + 1;
            else
                rawcount = (max(vertical_column)-min(vertical_column))/width;
                rawcount = rawcount + rem(min(vertical_column),width);
                count = ceil(rawcount);
                boxcount = boxcount + count;
            end
            xaxis_pos = xaxis_pos + width; %advance on x axis
        end
        n(j) = boxcount;
    end
% else
%     parfor j = 1:minwidth
%         width = 2^-j;
%         xaxis_pos = 0;
%         boxcount = 0;
%         while xaxis_pos<1
%             indx = (xaxis_pos <= normdata(:,1) &...
%                 normdata(:,1)<xaxis_pos+width);
%             if 1-xaxis_pos == width
%                 indx(end) = true;
%             end
%             
%             vertical_column = normdata(indx,2);
%             
%             if length(vertical_column) == 1
%                 boxcount = boxcount + 1;
%             else
%                 rawcount = (max(vertical_column)-min(vertical_column))/width;
%                 rawcount = rawcount + rem(min(vertical_column),width);
%                 count = ceil(rawcount);
%                 boxcount = boxcount + count;
%             end
%             xaxis_pos = xaxis_pos + width; %advance on x axis
%         end
%         n(j) = boxcount;
%     end
% end

r = 2.^-(1:minwidth);
r = r';

s=-gradient(log(n))./gradient(log(r));
IQR = iqr(s);

indx2 = abs(s-median(s)) > IQR/2;

x2 = log(r);
y2 = log(n);

s(indx2)= [];
x2(indx2) = [];
y2(indx2) = [];

%std is the variance of the slope according to OLS theory

X = [ones(size(x2)) x2];
beta = pinv(X)*y2;
C = pinv(X'*X);
e=y2-X*pinv(X)*y2;
sigma = e'*e*C;
sigma = sqrt(sigma);

dimension = -beta(2);
standard_dev = sigma(2,2);