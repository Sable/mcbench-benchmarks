% The script demonstrates how to aggregate several R-CSPs to achieve good
% performance. You need to customize the code accordingly and write some
% functions yourself. 
%
% %[Author Notes]%
% Author: Haiping LU
% Email : hplu@ieee.org   or   eehplu@gmail.com
% Release date: March 20, 2012 (Version 1.0)
% Please email me if you have any problem, question or suggestion
%
% %[Algorithm]%:
% This script demonstrates how to aggregate the regularized CSPs as 
% detailed  in the follwing paper:
%    Haiping Lu, How-Lung Eng, Cuntai Guan, K.N. Plataniotis, and A.N. Venetsanopoulos,
%    "Regularized Common Spatial Pattern With Aggregation for EEG Classification in Small-Sample Setting",
%    IEEE Trans. on Biomedical Engineering, Vol. 57, No. 12, Pages
%    2936-2946, Dec. 2010.
% Please reference this paper when reporting work done using this code.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %[Notes]%:
% A. Developed using Matlab R2006a
% B. Revision history:
%       Version 1.0 released on March 20, 2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc,clear all,close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
selCh=6;%number of selected channels/columns
numCls=2;%two classes only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%Regularization parameter used in the paper
betas=[ 0,1e-2,1e-1,2e-1,4e-1,6e-1];
gammas=[0,1e-3,1e-2,1e-1,2e-1];
numBeta=length(betas);
numGamma=length(gammas);
numRegs=numBeta*numGamma;
regParas=zeros(numRegs,2);
iReg=0;
for ibeta=1:numBeta
    beta=betas(ibeta);
    for igamma=1:numGamma
        gamma=gammas(igamma);
        iReg=iReg+1;
        regParas(iReg,1)=beta;
        regParas(iReg,2)=gamma;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Calculate the generic covariance matrices from generic training trials for
%two classes, equation (6) in the paper
[genSs,genMs]=genericCov();%implement, please refer to line 65-79 of RegCsp.m

%Load data
SubDir=[];%please specify the directory of EEG data (plus groundtruth) for a subject here
load([EEGdatafilename]);%please specify EEGdatafilename, it should contain "EEG" for the data and "gnd" for the ground truth
numTrn=[]; %please specify number of training samples
[numT,numCh,nTrl] = size(EEG);%suppose data is loaded to variable "EEG"
trainIdx=1:numTrn;%take the first numTrn samples for training
testIdx=(numTrn+1):length(gnd);%the rest for testing
fea2D_Train = EEG(:,:,trainIdx);gnd_Train = gnd(trainIdx);
fea2D = EEG;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%Multiple R-CSPs%%%%%%%%%%%
allNewFtrs=zeros(selCh,nTrl,numRegs);%Projected Features for R-CSP
for iReg=1:numRegs
    regPara=regParas(iReg,:);
    %=================RegCSP==========================%     
    %Prototype: W=RegCsp(EEGdata,gnd,genSs,genMs,beta,gamma)
    prjW= RegCsp(fea2D_Train,gnd_Train,genSs,genMs,regPara(1),regPara(2));
    %=================Finished Training==========================
    prjW=prjW(1:selCh,:);%Select columns 
    newfea=zeros(selCh,nTrl);
    for iCh=1:selCh
        for iTr=1:nTrl
            infea=fea2D(:,:,iTr)';
            prjfea=prjW(iCh,:)*infea;
            newfea(iCh,iTr)=log(var(prjfea));
        end
    end
    allNewFtrs(:,:,iReg)=newfea;
end
%%%%%%%%%%%%%%%%%%%%%
%Apply FDA
allFDAFtrs=zeros(nTrl,numRegs);%Features after FDA
for iReg=1:numRegs
    newfea=allNewFtrs(1:selCh,:,iReg);
    FDAU=FDA(newfea(:,trainIdx),gnd_Train);
    newfea=LDAU'*newfea;
    newfea=newfea';
    allFDAFtrs(:,iReg)=newfea;
end
%%%%%%%%%R-CSP-A%%%%%%%%%%%

%%%Aggregation
%please implement the following function with reference to Step 2 in Fig. 4
%of the paper, and equations (13) to (15) in the paper
calcR1(allFDAFtrs,gnd,trainIdx,testIdx);
%%%%%%%%%R-CSP-A%%%%%%%%%%%