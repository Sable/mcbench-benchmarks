function [vector] = createUnitVector(vector)
% Normalize a [1xn] or [nx1] vector
%Description: This function will simplify the process of creating a unit
%vector in one direction by dividing a vector by its length.
%Use: [vectorOut] = fcn_createUnitVector(vectorIn[1xn])
%  or [vectorOut] = fcn_createUnitVector(vectorIn[mx1])

%Author: Jim West
%Date: 7/12/2010
%Updated 8/31/2010
%Made a heavy revision to this script based on feedback from John D'Errico
[r c] = size(vector);

%Convert the vector to columns
if (r > c && c == 1); 
    vector = vector';
elseif (r < c && r==1); 
    %do Nothing
else
    error('Input vector must be [mx1] or [1xn]');
end

%Process the unit transform
vector = vector./norm(vector);

%Check if the result is illogical, or has an error
if not(sqrt(sum(vector.^2)) < 1.00001) && not(sqrt(sum(vector.^2)) > 0.99999)
    error(['There has been a calculation error, because the square root of the sum of the squares does not equal 1']);
end
    
%Check if the result is NaN
if sum(isnan(vector)) >= 1
    error(['The vector is ill-conditioned or dividing by zero with a result of ', num2str(vector)]);
end

%If originally in rows, convert back.
if r > c; vector = vector'; end