function [Weights,Ne_s,R_2_s,m_s,s_s]=MeanTCEntropyFrontier(S,Mu,w_b,w_0,Constr)

% compute conditional principal portfolios
[E,L,G]=GenPCBasis(S,[]);

% compute frontier extrema
w_MaxExp=linprog(-Mu,Constr.A,Constr.b,Constr.Aeq,Constr.beq);
MaxExp=Mu'*(w_MaxExp-w_b);

w_MaxNe = MaxEntropy(G,w_b,w_0,Constr);
ExpMaxNe=Mu'*(w_MaxNe-w_b);

% slice efficient frontier in NumPortf equally thick horizontal sections
NumPortf=10;
Grid_L=.0;
Grid_H=.9;
Grid=[Grid_L : (Grid_H-Grid_L)/(NumPortf-1) : Grid_H];
TargetExp= ExpMaxNe + Grid*(MaxExp-ExpMaxNe);


% compute diversification distribution
Weights=[];
R_2_s=[];
Ne_s=[];
m_s=[];
s_s=[];

for k=1:NumPortf
    ConstR=Constr;
    ConstR.Aeq=[Constr.Aeq
        Mu'];
    ConstR.beq=[Constr.beq
        TargetExp(k)+Mu'*w_b];

    w = MaxEntropy(G,w_b,w_0,ConstR);
    
    m=Mu'*(w-w_b);
    
    s=sqrt((w-w_b)'*S*(w-w_b));
    
    v_=G*(w-w_b);
    TE_contr=v_.*v_/s;

    R_2=max(10^(-10),TE_contr/sum(TE_contr));
    Ne=exp(-R_2'*log(R_2));
    
    Weights=[Weights w];
    m_s=[m_s m];
    s_s=[s_s s];
    R_2_s=[R_2_s R_2];
    Ne_s=[Ne_s Ne];
end