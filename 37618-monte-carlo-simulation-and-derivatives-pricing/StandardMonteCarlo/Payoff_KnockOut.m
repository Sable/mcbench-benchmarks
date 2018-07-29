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



function PayVec = Payoff_KnockOut(S,K,dt,Lvec,Uvec,TS)

N = length(Lvec);

if N == length(Uvec) && N == length(TS)-1
    
    ind = 1;
    for k=1:N
        steps = floor((TS(k+1)-TS(k))/dt);
        for p = 1:steps
            ind = ind + 1;
            A = (S(ind,:) > Lvec(k)) + (S(ind,:) < Uvec(k)) == 2;
            S(:,~A) = 0;
        end
    end
        
    PayVec = max(exp(S(end,:))-K,0);

else
    warning('Dimension mismatch')
    return   
end