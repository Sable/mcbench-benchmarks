function W=RegCsp(EEGdata,gnd,genSs,genMs,beta,gamma)
% RCSP: Regularized Common Spatial Pattern
%
% %[Prototype]%
% function W=RegCsp(EEGdata,gnd,genSs,genMs,beta,gamma)
%
% %[Author Notes]%
% Author: Haiping LU
% Email : hplu@ieee.org   or   eehplu@gmail.com
% Release date: March 20, 2012 (Version 1.0)
% Please email me if you have any problem, question or suggestion
%
% %[Algorithm]%:
% This function implements the Regularized Common Spatial Pattern
% (R-CSP) algorithm presented in the follwing paper:
%    Haiping Lu, How-Lung Eng, Cuntai Guan, K.N. Plataniotis, and A.N. Venetsanopoulos,
%    "Regularized Common Spatial Pattern With Aggregation for EEG Classification in Small-Sample Setting",
%    IEEE Trans. on Biomedical Engineering, Vol. 57, No. 12, Pages
%    2936-2946, Dec. 2010.
% Please reference this paper when reporting work done using this code.
%
% The following is an earlier conference version
%    Haiping Lu, K.N. Plataniotis, and A.N. Venetsanopoulos,
%    "Regularized Common Spatial Patterns with Generic Learning for EEG Signal Classification",
%    in Proceedings of the 31st Annual International Conference of the 
%    IEEE Engineering in Medicine and Biology Society (EMBC), Sep., 2009.
%
% %[Syntax]%: W=RegCsp(EEGdata,gnd,genSs,genMs,beta,gamma)
%
% %[Inputs]%:
%    EEGdata: the input EEG data for training, a 3D array with size [numT,numCh,nTrl]
%       numT is the number of samples in each channle (T in the paper)
%       numCh is the number of channels (N in the paper)
%       nTrl is the number of trails for training (2*M in the paper)
%
%    gnd: the ground truth class labels for the nTrl trials, size nTrl x 1
%
%    genSs: size numCh x numCh x 2, the sum of generic covariance matrices 
%       from generic training trials for two classes, equation (6) in the paper
%
%    genMs: size 2 x 1, the number of generic training trials for two classes
%   
%    beta,gamma: the reguarlizatio parameters in the paper, setting both to
%       zero gives the conventional CSP
%
% %[Outputs]%:
%    W: \hat{W} in the paper, the projection matrix, we often use only the 
%         first 6 columns from W
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %[Notes]%:
% A. Developed using Matlab R2006a
% B. Revision history:
%       Version 1.0 released on March 20, 2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%
[numT,numCh,nTrl] = size(EEGdata);%Input data, see documentation
Ns=zeros(2,1);
Sigma2=cell(2,1);%Two average spatial covariance matrices, one for each class
%%%%%%%%%%%%%%%%%%%
for i=1:2%for each class
    Idxs=find(gnd==i);
    EEG=EEGdata(:,:,Idxs);
    Ns(i)=length(Idxs);
    C=zeros(numCh,numCh,Ns(i));%Sample covariance matrix, equation (1) in the paper
    for trial=1:Ns(i)
        E=EEG(:,:,trial)'; 
        tmpC = (E*E');        
        C(:,:,trial) = tmpC./trace(tmpC);%normalization
    end 
    Csum=sum(C,3);
    %Reguarlization, see equations (3) and (4) in the paper
    Sigma1=((1-beta)*Csum+beta*genSs(:,:,i))/((1-beta)*Ns(i)+beta*genMs(i));
    Sigma2{i}=(1-gamma)*Sigma1+gamma*trace(Sigma1)*eye(numCh)/numCh;
end

%Equation (7) in the paper
SigmaComps=Sigma2{1}+Sigma2{2}; 
[Ucomps,lmds] = eig(SigmaComps);
[lmds,Idxs] = sort(diag(lmds),'descend');
Ucomps = Ucomps(:,Idxs);

%Note equations (8) to (12) in the conference version is now condensed in
%one equation (8) in the journal version
%Equation (8) in the CONFERENCE paper
P=sqrt(inv(diag(lmds)))*Ucomps';

%Equation (9) in CONFERENCE the paper
Sgm1=P*Sigma2{1}*P';

%Equation (11) in the CONFERENCE paper
[B,D] = eig(Sgm1);
[D,Idxs] = sort(diag(D),'descend'); 
B = B(:,Idxs);

%Equation (12) in the CONFERENCE paper
%Equation (8) in the JOURNAL paper
W=(B'*P); 
%Normalize the projrection matrix
for i=1:length(Idxs), W(i,:)=W(i,:)./norm(W(i,:)); end

%Sort columns, take first and last columns first, etc
W0=W;
W=zeros(size(W));
i=0;
for d=1:numCh
    if (mod(d,2)==0)
        W(d,:)=W0(numCh-i,:);
        i=i+1;
    else
        W(d,:)=W0(1+i,:);
    end
end