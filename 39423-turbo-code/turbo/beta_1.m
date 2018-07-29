%This function calculates BETA probabilities at each stage for all states,
%using GAMMA probabilities obtained previously. Uses recursion formula for
%BETA to calculate it for the previous stage. Each column is for states 00,10,01
%and 11 respectively. As we move backward in the block BETA will become very
%small, as the 1st term corresponding to gamma can be very less(of the order 
%of 10^(-15)). Hence BETA will keep on decreasing and  will become very small. 
%After some stages it will become exactly 0. So to avoid that we can
%multiply each BETA by 10^(-20) at a stage where they all become less than 
%10^(-20). As we need BETA in calculation of LAPPR. So scaling wont affect the ratio

function [BETA]=beta_1(GAMMA,N)
    
    BETA=zeros(4,N);
    %Initialization assuming the final stage to be 00
    BETA(1,N)=1;BETA(2,N)=0;BETA(3,N)=0;BETA(4,N)=0;
    
    j=2*N-1;
    for i=N-1:-1:1
       BETA(1,i)=(GAMMA(1,j)*BETA(1,i+1))+(GAMMA(1,j+1)*BETA(2,i+1));
       BETA(2,i)=(GAMMA(2,j)*BETA(3,i+1))+(GAMMA(2,j+1)*BETA(4,i+1));
       BETA(3,i)=(GAMMA(3,j)*BETA(2,i+1))+(GAMMA(3,j+1)*BETA(1,i+1));
       BETA(4,i)=(GAMMA(4,j)*BETA(4,i+1))+(GAMMA(4,j+1)*BETA(3,i+1));
       j=j-2; 
       
       if (BETA(1,i)<10^(-20) && BETA(2,i)<10^(-20) &&...
               BETA(3,i)<10^(-20) && BETA(4,i)<10^(-20) )
           BETA(:,i)=10^(20)*BETA(:,i);         %Scaling beta if became very less      
       end
    end
    
    
end