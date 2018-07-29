function [VecTot, TOT, time] = rmt_inv(P, Vec, Mat)
%rmt_inv returns a matrix containing the best models for all the paths of the Replacement Method used to maximize S (Inverse RM).
%TOT contains all the relative results showing the evolution of the method.
%
%           
%	   Input: 
%             P        Property vector
%             Vec      Initial descriptors vector
%             Mat      Descriptors matrix with descriptors pool
%             
%
%     Returns:
%          
%            VecTot           vector containing the best model for all the
%                               paths of the Replacement Method
%            TOT               contains all the relative results
%                               showing the evolution of the method. 
%           
% Andrew G. Mercader, Pablo R. Duchowicz
% INIFTA, La Plata, Argentina
% Created: 5 March 2007


TOT=[];
VecTot=[];
time=cputime;
warning off

[k_v,n_v]=size(Vec);

for k=1:n_v

Sr=rms_inv(P,Vec,Mat);
TOT(k).A(1,:)=[Sr,Vec];

VecA=rmsr_inv(P, Vec, Mat, k);
Po(1)=k;
VecI=VecA;
if n_v==1
    VecTot=[1,VecI];
    TOT=VecI;
    time=cputime-time
    return
end
VecI(1)=[];
COEF=rmder_inv(P,VecI,Mat);
COER=COEF;
COER(Po)=[];
pos=find(COEF==min(COER));
Po(2)=pos;
TOT(k).A(2,:)=VecA;
for i=2:n_v;
    VecA=rmsr_inv(P, VecI, Mat, pos);
    VecI=VecA;
    TOT(k).A(i+1,:)=VecA;
    VecI(1)=[];
    COEF=rmder_inv(P,VecI,Mat);
    if i==n_v
        Po=[];
        break
    end
    COER=COEF;
    COER(Po)=[];
    pos=find(COEF==min(COER));
    Po(i+1)=pos;
end    

for j=1:2;
COER=COEF;
COER(Po)=[];
pos=find(COEF==min(COER));
Po(1)=pos;
for i=1:n_v;
    VecA=rmsr_inv(P, VecI, Mat, pos);
    VecI=VecA;
    TOT(k).A(i+(j*n_v),:)=VecA;
    VecI(1)=[];
    COEF=rmder_inv(P,VecI,Mat);
    if i==n_v
        Po=[];
        break
    end
    COER=COEF;
    COER(Po)=[];
    pos=find(COEF==min(COER));
    Po(i+1)=pos;
end    
end

for j=3:100;
COER=COEF;
COER(Po)=[];
pos=find(COEF==min(COER));
Po(1)=pos;
    for i=1:n_v;
    VecA=rmsr_inv(P, VecI, Mat, pos);
    VecI=VecA;
    TOT(k).A(i+(j*n_v),:)=VecA;
    VecI(1)=[];
    COEF=rmder_inv(P,VecI,Mat);
    if i==n_v 
        Po=[];
        break
    end
    COER=COEF;
    COER(Po)=[];
    pos=find(COEF==min(COER));
    pos=pos(1);
    Po(i+1)=pos;
    end  
   if TOT(k).A(i+(j*n_v),:)==TOT(k).A(i+(j*n_v)-(2*n_v),:)
        Po=[];
        break
   end

end
VecP=find(TOT(k).A==max(TOT(k).A(:,1)));
VecTot(k,:)=[k,TOT(k).A(VecP(1),:)];
VecTot=sortrows(VecTot,2);
end
time=cputime-time
warning on

% % End of RM
% 