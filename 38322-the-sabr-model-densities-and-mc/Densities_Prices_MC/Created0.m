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

% Creates a Matlab array d0 for the absorbtion probability in the SABR
% model. It uses a csv file which can be downloaded via P. Dousts page
% mentioned in his RISK article "No-Arbitrage SABR" 

n1 = length(sabrVol);
n2 = length(sabrbeta);
n3 = length(sabrrho);
n4 = length(sabrnu);
n5 = length(sabrtau);

d0 = zeros(n1,n2,n3,n4,n5);
xindex = 1;
for j2=1:n2
    for j4 = 1:n4
        for j3=1:n3
            for j1=1:n1
                for j5 = 1:n5
                    value = data(xindex,4 + j5);
                    d0(j1,j2,j3,j4,j5) =  value;    
                end
                xindex = xindex+1;
            end
        end
    end
end

d0 = d0/2500000;