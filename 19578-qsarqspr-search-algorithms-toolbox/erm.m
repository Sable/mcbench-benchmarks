function [VecTot, TOT, time] = erm(P, Vec, Mat)

%erm returns a matrix containing the best models for all the paths of the Enhanced Replacement Method.
%TOT contains all the relative results of each step showing the evolution of the method.
%
%           
%	   Input: 
%             P             Property vector
%             Vec           Initial descriptors vector
%             Mat           Descriptors matrix with descriptors pool
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
% Created: 12 Nov 2007



   
TOT=[];
VecTot=[];
time=cputime;
warning off
[k_v,n_v]=size(Vec);

for k=1:n_v;


Sr=rms(P,Vec,Mat);
TOT(k).A(1,:)=[Sr,Vec];


VecA=rmsr(P, Vec, Mat, k);
Po(1)=k;
VecI=VecA;
if n_v==1
    VecTot=[1,VecI];
    TOT=VecI;
    time=cputime-time
    return
end
VecI(1)=[];
COEF=rmder(P,VecI,Mat);
COER=COEF;
COER(Po)=[];
pos=find(COEF==max(COER));
Po(2)=pos;
TOT(k).A(2,:)=VecA;
for i=2:n_v;
    VecA=rmsr(P, VecI, Mat, pos);
    VecI=VecA;
    TOT(k).A(i+1,:)=VecA;
    VecI(1)=[];
    COEF=rmder(P,VecI,Mat);
    if i==n_v
        Po=[];
        break
    end
    COER=COEF;
    COER(Po)=[];
    pos=find(COEF==max(COER));
    Po(i+1)=pos;
end    

for j=1:3;
COER=COEF;
COER(Po)=[];
pos=find(COEF==max(COER));
Po(1)=pos;
for i=1:n_v;
    VecA=rmsr(P, VecI, Mat, pos);
    VecI=VecA;
    TOT(k).A(i+(j*n_v),:)=VecA;
    VecI(1)=[];
    COEF=rmder(P,VecI,Mat);
    if i==n_v
        Po=[];
        break
    end
    COER=COEF;
    COER(Po)=[];
    pos=find(COEF==max(COER));
    Po(i+1)=pos;
end    
end

for j=4:100;
COER=COEF;
COER(Po)=[];
pos=find(COEF==max(COER));
Po(1)=pos;
    for i=1:n_v;
    VecA=rmsr(P, VecI, Mat, pos);
    VecI=VecA;
    TOT(k).A(i+(j*n_v),:)=VecA;
    VecI(1)=[];
    COEF=rmder(P,VecI,Mat);
    if i==n_v 
        Po=[];
        break
    end
    COER=COEF;
    COER(Po)=[];
    pos=find(COEF==max(COER));
    Po(i+1)=pos;
    end  
   if TOT(k).A(i+(j*n_v),:)==TOT(k).A(i+(j*n_v)-(2*n_v),:)
      break
   end

end

jj=j;
for j=jj:jj+100;
COER=COEF;
COER(Po)=[];
pos=find(COEF==max(COER));
Po(1)=pos;
    for i=1:n_v;
    VecA=rma2(P, VecI, Mat, pos);
    VecI=VecA;
    TOT(k).A(i+(j*n_v),:)=VecA;
    VecI(1)=[];
    COEF=rmder(P,VecI,Mat);
    if i==n_v 
        Po=[];
        break
    end
    COER=COEF;
    COER(Po)=[];
    pos=find(COEF==max(COER));
    Po(i+1)=pos;
    end  
   if TOT(k).A(i+(j*n_v),:)==TOT(k).A(i+(j*n_v)-(4*n_v),:)
        Po=[];
        break
   end
end
VecQ=find(TOT(k).A==min(TOT(k).A(:,1)));
VecI=[TOT(k).A(VecQ(1),:)];
VecI(1)=[];
jjj=j;
for j=jjj:jjj+100;
COER=COEF;
COER(Po)=[];
pos=find(COEF==max(COER));
Po(1)=pos;
    for i=1:n_v;
    VecA=rmsr(P, VecI, Mat, pos);
    VecI=VecA;
    TOT(k).A(i+(j*n_v),:)=VecA;
    VecI(1)=[];
    COEF=rmder(P,VecI,Mat);
    if i==n_v 
        Po=[];
        break
    end
    COER=COEF;
    COER(Po)=[];
    pos=find(COEF==max(COER));
    Po(i+1)=pos;
    end  
   if TOT(k).A(i+(j*n_v),:)==TOT(k).A(i+(j*n_v)-(2*n_v),:)
        Po=[];
        break
   end
end


VecP=find(TOT(k).A==min(TOT(k).A(:,1)));
VecTot(k,:)=[k,TOT(k).A(VecP(1),:)];
VecTot=sortrows(VecTot,2);
end
warning on
time=cputime-time
% end