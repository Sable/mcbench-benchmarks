% AVGHANKEL - Averages the elements along the antidiagonals.
% GMR 2005
function Av = avgHankel(A)

Av = A;

% antidagonals starting on the top row
r = 1;
for c = 1:1:size(A,2)
    
    % this is the value
    val = mean(antidiag(A, r, c));

    % do the assignment
    if r+c-1 > size(A,1)
        lim = size(A,1) - r;
    else
        lim = c - 1;
    end

    for d = 0:1:lim
        Av(r+d, c-d) = val;
    end
    
    
end
    
% antidiagonals beginning on a row other than the top
c = size(A,2);
for r = 2:1:size(A,1)

    % this is the value
    val = mean(antidiag(A, r, c));

    % do the assignment
    if r+c-1 > size(A,1)
        lim = size(A,1) - r;
    else
        lim = c - 1;
    end

    for d = 0:1:lim
        Av(r+d, c-d) = val;
    end
end
    