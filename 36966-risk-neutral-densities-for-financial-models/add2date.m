% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



% ADD2DATE Add a yearfraction quantity V to a Date D
%   R = ADD2DATE(D,V) will add a double valued quantity V to
%   a date string or serial date number D, and return the new date string R
%
%   INPUT PARAMETERS:
%   D:  string or serial number, defining the date value
%   V:  double scalar, defining the quantity to add to D
%
%   RETURN PARAMETERS:
%   R:  returning the new date number R

%   ASSUMPTIONS:   
%       V is given in terms of yearfractions
%       1 year equals 12 month
%       1 month equals 30 days
%       yearfractions < 1/30 are rounded to plus infinity

function R = add2date(D,V)

if ischar(D)
    dateval = datenum(D);
else
    dateval = D;
end

nr_month = floor(V*12);
nr_days = ceil((V*12-nr_month)*30);

tmpVec = zeros(size(V));
for i = 1:length(V)
   tmpVec(i) = addtodate(dateval,nr_month(i),'month');
end
R = daysadd(tmpVec,nr_days);

end