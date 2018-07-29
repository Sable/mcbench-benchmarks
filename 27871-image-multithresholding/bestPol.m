% Obtain the best LMS polynomial for fitting
% The order of polynomial must be between 3 and 10
function LMS = bestPol(x,y)
min = 10^8;
min_ind = 2;
for i=3:10
    p = polyfit(x,y,i);
    LMS = polyval(p,x);
    dist = sqrt(sum((LMS-y).^2));
    if (dist<min)
        min = dist;
        min_ind = i;
    end
end
p = polyfit(x,y,min_ind);
LMS = polyval(p,x);

    
