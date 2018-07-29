function res = mmod(x,y,m)
% Modulo function : computes mod(x^y,m) for x and y big

% Done by Michael Neve on Matlab 6 (10-09-2001)

if ( y == 1)
    res = mod(x,m);
else
    y1 = y/2;
    if (ceil(y1) == y/2)
        res = mod((mmod(x,y1,m)).^2,m);
    else
        res = mod(mmod(x,floor(y1),m).*mmod(x,floor(y1)+1,m),m);
    end
end

