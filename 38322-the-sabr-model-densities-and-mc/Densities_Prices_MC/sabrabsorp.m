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

function d0 = sabrabsorp( a,b,r,n,f,t,NTime,NSim)
% Calculate the absorpiton probability by simple MC simulation for 
% the SABR model

    CorrMat = [1 r ;
           r 1 ];

    L = chol(CorrMat)';

    dt = t / NTime;

    N01 = randn(2,NSim,NTime);
    dW = zeros(2,NSim);

    fold = f*ones(1,NSim);
    fnew = zeros(1,NSim);
    aold = a*ones(1,NSim);
    
    for k = 1:NTime
        for i = 1:NSim
            dW(:,i) = sqrt(dt)*L*N01(:,i,k);
        end
        ind = find(fold>0);
        fnew(ind) = fold(ind) + aold(ind) .* fold(ind).^b.*dW(1,ind);
        fnew(~ind) = 0;
        anew = aold + n*aold.*dW(2,:);
        aold = anew;
        fold = fnew;
    end

d0 = 1-sum(fnew>0) / NSim;

end

