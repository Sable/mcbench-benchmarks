%Calculates LAPPR at each stage using ALPHA, BETA and GAMMA
%probabilities. Returns P(X(k)=0), P(X(k)=1) and LAPPR(k) for all k's

function [p_x0,p_x1,lappr_1]=lappr(ALPHA,BETA,GAMMA,N)
    p_x0=zeros(1,N);
    p_x1=zeros(1,N);
    lappr_1=zeros(1,N);
    
    for i=1:N
        p_x1(i)=(ALPHA(1,i)*GAMMA(1,2*i)*BETA(2,i))+(ALPHA(2,i)*GAMMA(2,2*i)*BETA(4,i))+...
            (ALPHA(3,i)*GAMMA(3,2*i)*BETA(1,i))+(ALPHA(4,i)*GAMMA(4,2*i)*BETA(3,i));
        
        p_x0(i)=(ALPHA(1,i)*GAMMA(1,2*i-1)*BETA(1,i))+(ALPHA(2,i)*GAMMA(2,2*i-1)*BETA(3,i))+...
            (ALPHA(3,i)*GAMMA(3,2*i-1)*BETA(2,i))+(ALPHA(4,i)*GAMMA(4,2*i-1)*BETA(4,i));
        
        lappr_1(i)=log(p_x1(i)/p_x0(i));
        
    end

end