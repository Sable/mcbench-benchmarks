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



function optval = Price_ArithmeticCliquet(S,LF,LC,GF,GC,r,T)
    R = S(:,2:end)./S(:,1:end-1)-1;      % calc returns
    Ar_Cl_U = min(max(R,LF),LC);         % local floor@LF / cap@LC

    optval = mean(min(max(...
        sum(Ar_Cl_U,2),GF),GC))*exp(-r*T);% global floor@FG/cap@GC
end