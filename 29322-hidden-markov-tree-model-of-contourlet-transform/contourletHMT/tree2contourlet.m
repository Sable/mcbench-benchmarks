% tree2contourlet.m
% written by: Duncan Po
% Date: August 24, 2002
% convert the contourlet coefficients from tree structure to subband structure
% Usage: coef = tree2contourlet(tree, dir, levndir, nrow, ncol)
% Inputs:   tree        - contourlet coefficients in tree structure
%           dir         - the directional coefficients to be processed
%           levndir     - the number of subbands in each level
%           nrow        - the number of rows in the root subband
%           ncol        - the number of columns in the root subband
% Output:   coef        - contourlet coefficients in subband structure

function coef = tree2contourlet(tree, dir, levndir, nrow, ncol) 

nlevel = length(tree);
M = 2.^levndir(1);

for r = 1:(length(levndir)-1)
    if levndir(r+1)==levndir(r)
        split(r) = 0;
    elseif levndir(r+1)-levndir(r)==1
        split(r) = 1;
    else
        return;
    end;
end;

denoiseddata{1} = reshape(tree{1}, nrow, ncol);
nrow = nrow*2;
ncol = ncol*2;
for lev = 2:nlevel
    denoiseddata{lev} = [];
    for temp = 1:2*nrow:length(tree{lev})        
        buffer = reshape(tree{lev}(temp:temp+2*nrow-1), 2, nrow);
        buffer = buffer.';
        denoiseddata{lev} = [denoiseddata{lev} buffer];
    end;
    nrow = nrow*2; ncol = ncol*2;
end;
clear buffer;

for lev = 1:nlevel
    nump = levndir(lev)-levndir(1); %number of times need to be processed
    buffer{1} = denoiseddata{lev};
    for yy = 1:(nump-1)
        for zz = 2^yy:-2:2
            [buffer{zz-1},buffer{zz}] = type4detransform(buffer{zz/2});
        end;
    end;
    if nump ~= 0
        if (lev~=1) & (split(lev-1)==1)
            for zz = 2^nump:-2:2
                [buffer{zz-1},buffer{zz}] = type3detransform(buffer{zz/2});
            end;
        else
            for zz = 2^nump:-2:2
                [buffer{zz-1},buffer{zz}] = type4detransform(buffer{zz/2});
            end;
        end;
    end;
    for zz = 1:2^(levndir(lev)-levndir(1))
        coef{lev}{zz}= buffer{zz};
    end;
    if (dir>M/2) %& (lev>2)
        for yy = 1:2^(levndir(lev)-levndir(1))
            coef{lev}{yy} = coef{lev}{yy}.';
        end;
    end;
    clear buffer;
end;


