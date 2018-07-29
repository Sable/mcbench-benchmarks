%% Gaussian Multiplication.
% author: Shuang Wang
% email: shw070@ucsd.edu
% Division of Biomedical Informatics, University of California, San Diego.
function G3 = GaussianMultiply(G1, G2)    
    G1.V_inv = inv_s(G1.V, G1.iV);
    G2.V_inv = inv_s(G2.V, G2.iV);
    G3.iV = G1.V_inv + G2.V_inv;
    if(sum(abs(G1.V_inv(:))) == 0)
        if(~isempty(G2.V))
            G3.V = G2.V;
        else
            G3.V = [];
        end
        G3.mu = G2.mu;
    elseif(sum(abs(G2.V_inv(:))) == 0)
        if(~isempty(G1.V))
            G3.V = G1.V;
        else
            G3.V = [];
        end
        G3.mu = G1.mu;
    else
        G3.V = inv(G3.iV);
        G3.mu = G3.V*(G1.V_inv*G1.mu + G2.V_inv*G2.mu);
    end
end