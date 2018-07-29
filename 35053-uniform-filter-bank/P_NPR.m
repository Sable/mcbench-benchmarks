

function P=P_NPR(M,m,m1)


B1=1;

w11=(pi/M)-0.08*(pi/M);
w12=pi;


N=2*(m*M+m1);

syms w

    for k=0:m*M+m1-1
        k
        for l=0:m*M+m1-1
            P(k+1,l+1)=2*B1*int([cos(w*(k-l))+cos(w*(N-1-k-l))],w,w11,w12);
        end
    end
    
    
P=double(P);


