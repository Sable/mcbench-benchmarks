function p_ = EntropyProg(p,A,b,Aeq,beq)
% This function computes the entropy-pooling change of measure, see
% "A. Meucci - Fully Flexible Views: Theory and Practice -
% The Risk Magazine, October 2008, p 97-102"
% available at www.symmys.com > Research > Working Papers

% Code by A. Meucci, November 2008
% Last version available at www.symmys.com > Teaching > MATLAB

K_=size(A,1);
K=size(Aeq,1);
A_=A';
b_=b';
Aeq_=Aeq';
beq_=beq';
x0=zeros(K_+K,1);
InqMat=-eye(K_+K); InqMat(K_+1:end,:)=[];
InqVec=zeros(K_,1);

options = optimset('GradObj','on','Hessian','on');
if ~K_
    v=fminunc(@nestedfunU,x0,options);
    p_=exp(log(p)-1-Aeq_*v);
else
    lv=fmincon(@nestedfunC,x0,InqMat,InqVec,[],[],[],[],[],options);
    l=lv(1:K_);
    v=lv(K_+1:end);
    p_=exp(log(p)-1-A_*l-Aeq_*v);
end

    function [mL g H] = nestedfunU(v)
    
        x=exp( log(p)-1-Aeq_*v );
        x=max(x,10^(-32));
        L=x'*(log(x)-log(p)+Aeq_*v)-beq_*v;
        mL=-L;    
        
        g = [beq-Aeq*x];    
        H = [Aeq*((x*ones(1,K)).*Aeq_)];  % Hessian computed by Chen Qing, Lin Daimin, Meng Yanyan, Wang Weijun 
    end

    function [mL g H] = nestedfunC(lv)

        l=lv(1:K_);
        v=lv(K_+1:end);
        x=exp( log(p)-1-A_*l-Aeq_*v );
        x=max(x,10^(-32));
        L=x'*(log(x)-log(p))+l'*(A*x-b)+v'*(Aeq*x-beq);
        mL=-L;
    
        g = [b-A*x; beq-Aeq*x];    
        H = [A*((x*ones(1,K_)).*A_)  A*((x*ones(1,K)).*Aeq_) % Hessian computed by Chen Qing, Lin Daimin, Meng Yanyan, Wang Weijun 
            Aeq*((x*ones(1,K_)).*A_)   Aeq*((x*ones(1,K)).*Aeq_)];  
    end
end
