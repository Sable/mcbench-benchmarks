%This function calculates ALPHA probabilities at each stage for all states,
%using GAMMA probabilities obtained previously. Uses recursion formula for
%ALPHA to calculate it for the next stage. Each column is for states 00,10,01
%and 11 respectively. As we move forward in the block ALPHA will become very
%less, as the 1st term corresponding to gamma can be very less(of the order 
%of 10^(-15)). Hence ALPHA will keep on decreasing and  will become very small. 
%After some stages it will become exactly 0. So to avoid that we can
%multiply each ALPHA by 10^(-20) at a stage where they all become less than 
%10^(-20). As we need APLHA in calculation of LAPPR. So scaling wont affect the ratio

function [ALPHA]=alpha_1(GAMMA,N)

    ALPHA=zeros(4,N);

    %Initialization of alpha assuming first state to be 00
    ALPHA(1,1)=1;ALPHA(2,1)=0;ALPHA(3,1)=0;ALPHA(4,1)=0;
    
    j=1;
    for i=2:N
        ALPHA(1,i)=((GAMMA(1,j)*ALPHA(1,i-1))+(GAMMA(3,j+1)*ALPHA(3,i-1)));
        ALPHA(2,i)=((GAMMA(3,j)*ALPHA(3,i-1))+(GAMMA(1,j+1)*ALPHA(1,i-1)));
        ALPHA(3,i)=((GAMMA(2,j)*ALPHA(2,i-1))+(GAMMA(4,j+1)*ALPHA(4,i-1)));
        ALPHA(4,i)=((GAMMA(4,j)*ALPHA(4,i-1))+(GAMMA(2,j+1)*ALPHA(2,i-1)));
        j=j+2;
        
        if (ALPHA(1,i)<10^(-20) && ALPHA(2,i)<10^(-20) &&...
                ALPHA(3,i)<10^(-20) && ALPHA(4,i)<10^(-20) )
            ALPHA(:,i)=10^(20)*ALPHA(:,i);   %Scaling Alpha if became very less  
        end    
    end

end