function P = findpoints(trackpath1,trackpath2,v1x,v1y)
% starting from the points in trackpath1, to find the correspond points in
% trackpath2 accroding to the vector (v1x v1y);
% P is the order for each points of trackpath1 to the correspond points in trackpath2;

[X1,Y1] = order_coordinate(trackpath1);  % find the coordinate (X,Y) in the trackpath in order;
[X2,Y2] = order_coordinate(trackpath2);

%calculate the distance of each point in trackpath1 to trackpath2;
for i = 1:length(X1)
    for j = 1:length(X2)
        a = X1(i) - X2(j);   
        b = Y1(i) - Y2(j);
        d(i,j) = sqrt(a^2 + b^2);            
    end
end

[d,ind_sort] = sort(d,2,'ascend'); 
dt = 10; 

% finding the corresponding point by comparing the max inner product of
% two vectors;

for i = 1:length(X1)
    for j=1:dt                                 % searching within the range of dt;
        aa = X1(i) - X2(ind_sort(i,j));  
        bb = Y1(i) - Y2(ind_sort(i,j)); 
        cc = v1x(X1(i),Y1(i));                 
        dd = v1y(X1(i),Y1(i));
        inner = abs(aa*cc+bb*dd);              % inner product;
        A = sqrt(aa^2+bb^2);                   % length of vecotrs;
        B = sqrt(cc^2+dd^2);                   
        D(j) = inner/(A*B);                    % D = cos(theta) = <(aa,bb),(cc,dd)>/|A||B|,
        [mm,ind]=max(D,[],2);                  % the max D,when (aa,bb)and(cc,dd)nearly the same direction;
        P(i)=ind_sort(i,ind);                  % [X1(i),Y1(i)] according P(i) to find X2(i),Y2(i);
    end                                       
end


function [X,Y] = order_coordinate(im)
% this function orderly finding the coordinate (X,Y) of a trackpath in the image im;

im = double(im);
[m,n] = size(im);
[start_x,start_y] = startpoint(im);            % find the start point of a trackpath;
ind = ord_line_indx(im,start_x,start_y);       % find the trackpath points in sequence;
for i = 1:length(ind)
    [X(i),Y(i)] = ind2sub([m,n],ind(i));       % index->(X,Y);
end
