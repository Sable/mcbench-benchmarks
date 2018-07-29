function x = MaxEntropy(G,w_b,w_0,Constr)

x = fmincon(@nestedfun,w_0,Constr.A,Constr.b,Constr.Aeq,Constr.beq);
% Nested function that computes fitness
    function Minus_Ent = nestedfun(x)
        v_=G*(x-w_b);
        p=v_.*v_;
        R_2=max(10^(-10),p/sum(p));
        Minus_Ent=R_2'*log(R_2);
    end
end