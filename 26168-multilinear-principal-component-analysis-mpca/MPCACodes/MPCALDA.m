function [tUs,odrIdx,TXmean,Wgt,LDAU] = MPCALDA(TX,gndTX,MPCADADim,testQ,maxK)
% MPCA+LDA: Multilinear Principle Component Analysis plus Linear
% Discriminant Analysis
%
% %[Prototype]%
% function [tUs,odrIdx,TXmean,Wgt,LDAU]=MPCALDA(TX,gndTX,MPCADADim,testQ,maxK)
%
% %[Author Notes]%
% Author: Haiping LU
% Email : hplu@ieee.org   or   eehplu@gmail.com
% Affiliation: Department of Electrical and Computer Engineering
%              University of Toronto
% Release date: June 24, 2008 (Version 1.1)
% Please email me if you have any problem, question, or suggestion
%
% %[Algorithm]%:
% This function implements the Multilinear Principal Component Analysis
% plus Linear Discriminant Analysis (MPCA+LDA) algorithm presented in the 
% follwing paper:
%    Haiping Lu, K.N. Plataniotis, and A.N. Venetsanopoulos,
%    "MPCA: Multilinear Principal Component Analysis of Tensor Objects",
%    IEEE Transactions on Neural Networks,
%    Vol. 19, No. 1, Page: 18-39, January 2008.
% Please reference this paper when reporting work done using this code.
%
% %[Toolbox needed]%:
% This function needs the tensor toolbox available at
% http://csmr.ca.sandia.gov/~tgkolda/TensorToolbox/
%
% %[Syntax]%:
%    [tUs,odrIdx,TXmean,Wgt,LDAU] = MPCALDA(TX,gndTX,MPCADADim,testQ,maxK)
%
% %[Inputs]%:
%    TX: the input training data in tensorial representation, the last mode
%        is the sample mode. For Nth-order tensor data, TX is of
%        (N+1)th-order with the (N+1)-mode to be the sample mode.
%        E.g., 30x20x10x100 for 100 samples of size 30x20x10
%        If your training data is too big, resulting in the "out of memory"
%        error, you could work around this problem by reading samples one 
%        by one from the harddisk, or you could email me for help.
%
%    gndTX: the ground truth class labels (1,2,3,...) for the training data
%           E.g., a 100x1 vector if there are 100 samples
%
%    MPCADADim: the number of MPCA features to be fed into LDA. 
%               This parameter could have a significant effect on the 
%               recognition performance, as in PCA+LDA. It is strongly 
%               suggested that you should test different numbers of 
%               MPCADADim to get the best performance.
%
%    testQ: the percentage of variation kept in each mode, suggested value
%           is 97, and you can try other values, e.g., from 95 to 100, to
%           see whether better performance can be obtained.
%
%    maxK: the maximum number of iterations, suggested value is 1, and you
%          can try a larger value if computational time is not a concern.
%
% %[Outputs]%:
%    tUs: the multilinear projection, consiting of N
%         projection matrices, one for each mode
%
%    odrIdx: the ordering index of projected features in decreasing 
%            discriminality for vectorizing the projected tensorial 
%            features
%
%    TXmean: the mean of the input training samples TX
%
%    Wgt: the weight vector for use in modified distance measures. Please
%         refer to Section IV.C of the paper.
%
%    LDAU: the standard LDA projection matrix
%
% %[Supported tensor order]%
% This function supports N=2,3,4, for other order N, please modify the
% codes accordingly or email hplu@ieee.org or eehplu@gmail.com for help
%
% %[Examples]%
%%%%%%%%%%%%%%%%%%%%%%%%%%Example on 2D face data%%%%%%%%%%%%%%%%%%%%%%%%%%
%       load FERETC80A45%each sample is a second-order tensor of size 32x32
%       N=ndims(fea2D)-1;%Order of the tensor sample
%       Is=size(fea2D);%32x32x320
%       numSpl=Is(3);%There are 320 face samples
%       MPCADADim=80;%80 most discriminative MPCA features for LDA
%       testQ=97;%Keep 97% variation in each mode
%       maxK=1;%One iteration only
%       [tUs,odrIdx,TXmean,Wgt,LDAU] = MPCALDA(fea2D,gnd,MPCADADim,testQ,maxK);
%       fea2Dctr=fea2D-repmat(TXmean,[ones(1,N), numSpl]);%Centering
%       newfea=ttm(tensor(fea2Dctr),tUs,1:N);%MPCA projection
%       %Vectorization of the tensorial feature
%       newfeaDim=size(newfea,1)*size(newfea,2);
%       newfea=reshape(newfea.data,newfeaDim,numSpl)';%Note: Transposed
%       selfea = newfea(:,odrIdx);%Take only the first MPCADADim ones.
%       %Note that the length of odrIdx is already "MPCADADim"
%       LDAfea=selfea*LDAU;%LDA projection
%       %LDAfea is the MPCA+LDA feature vector for input to classical 
%       %classifiers (e.g., nearest neighbor classifier).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%Example on 3D gait data%%%%%%%%%%%%%%%%%%%%%%%%%%
%       load USF17Gal %each sample is a third-order tensor of size 32x22x10
%       N=ndims(fea3D)-1;%Order of the tensor sample
%       Is=size(fea3D);%32x22x10x731
%       numSpl=Is(4);%There are 731 gait samples
%       MPCADADim=200;%200 most discriminative MPCA features for LDA
%       testQ=97;%Keep 97% variation in each mode
%       maxK=1;%One iteration only
%       [tUs,odrIdx,TXmean,Wgt,LDAU] = MPCALDA(fea3D,gnd,MPCADADim,testQ,maxK);
%       fea3Dctr=fea3D-repmat(TXmean,[ones(1,N), numSpl]);%Centering
%       newfea=ttm(tensor(fea3Dctr),tUs,1:N);%MPCA projection
%       %Vectorization of the tensorial feature
%       newfeaDim=size(newfea,1)*size(newfea,2)*size(newfea,3);
%       newfea=reshape(newfea.data,newfeaDim,numSpl)';%Note: Transposed
%       selfea = newfea(:,odrIdx);%Take only the first MPCADADim ones.
%       %Note that the length of odrIdx is already "MPCADADim"
%       LDAfea=selfea*LDAU;%LDA projection
%       %LDAfea is the MPCA+LDA feature vector for input to classical 
%       %classifiers (e.g., nearest neighbor classifier).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% %[Notes]%:
% A. Developed using Matlab R2006a
% B. Revision history:
%       Version 1.0 released on March 1, 2008
%       Version 1.1 released on June 24, 2008
%           ---Example usage on 2D data is included
%           ---Recommendation on parameter MPCADADim is updated
%       Version 1.2 released on March 12, 2011
%           ---Insertion of line 275
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%TX: (N+1)-dimensional tensor of Tensor Sample Dimension x NumSamples
N=ndims(TX)-1;%The order of samples.
IsTX=size(TX);
Is=IsTX(1:N);%The dimensions of the tensor
numSpl=IsTX(N+1);%Number of samples

%%%%%%%%%%%%%Zero-Mean%%%%%%%%%%
TXmean=mean(TX,N+1);%The mean
TX=TX-repmat(TXmean,[ones(1,N), numSpl]);%Centering

%The full projection for initialization
Qs=ones(N,1)*testQ;
Us=cell(N,1);
tUs=cell(N,1);
Lmds=cell(N,1);
for n=1:N
    In=Is(n);Phi=zeros(In,In);
    for m=1:numSpl
        switch N
            case 2
                Xm=TX(:,:,m);
            case 3
                Xm=TX(:,:,:,m);
            case 4
                Xm=TX(:,:,:,:,m);
            otherwise
                error('Order N not supported. Please modify the code here or email hplu@ieee.org for help.')
        end
        tX=tensor(Xm);
        tXn=tenmat(tX,n);
        Xn=tXn.data;
        Phi=Phi+Xn*Xn';
    end
    [Un,Lmdn]=eig(Phi);
    Lmd=diag(Lmdn);
    [stLmd,stIdx]=sort(Lmd,'descend');
    Us{n}=Un(:,stIdx);
    tUs{n}=Us{n}';
    Lmds{n}=Lmd(stIdx);
end

%Cumulative distribution of eigenvalues
cums=cell(N,1);
for n=1:N
    In=length(Lmds{n});
    cumLmds=zeros(In,1);
    Lmd=Lmds{n};
    cumLmds(1)=Lmd(1);
    for in=2:In
        cumLmds(in)=cumLmds(in-1)+Lmd(in);
    end
    cumLmds=cumLmds./sum(Lmd);
    cums{n}=cumLmds;
end

%MPCA Iterations
if maxK>0
    tPs=cell(N,1);
    pUs=cell(N,1);
    %%%%%%%%%%%%%Determine Rn, the dimension of projected space%%%%
    for n=1:N
        cum=cums{n};
        idxs=find(cum>=Qs(n)/100);
        Ps(n)=idxs(1);
        tUn=tUs{n};
        tPn=tUn(1:Ps(n),:);
        tPs{n}=tPn;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for iK=1:maxK
        for n=1:N
            In=Is(n);
            Phi=double(zeros(In,In));
            for m=1:numSpl
                switch N
                    case 2
                        Xm=TX(:,:,m);
                    case 3
                        Xm=TX(:,:,:,m);
                    case 4
                        Xm=TX(:,:,:,:,m);
                    otherwise
                        error('Order N not supported. Please modify the code here or email hplu@ieee.org for help.')
                end
                tX=ttm(tensor(Xm),tPs,-n);
                tXn=tenmat(tX,n);
                Xn=tXn.data;
                Phi=Phi+Xn*Xn';
            end
            Pn=Ps(n);
            Phi=double(Phi);
            if Pn<In
                option=struct('disp',0);
                [pUs{n},pLmdn]=eigs(Phi,Pn,'lm',option);
                pLmds{n}=diag(pLmdn);
            else
                [pUn,pLmdn]=eig(Phi);
                pLmd=diag(pLmdn);
                [stLmd,stIdx]=sort(pLmd,'descend');
                pUs{n}=pUn(:,stIdx(1:Pn));
                pLmds{n}=pLmd(stIdx(1:Pn));
            end
            tPs{n}=pUs{n}';
        end
    end
    Us=pUs;
    tUs=tPs;
    Lmds=pLmds;
    Is=Ps;
else
    if testQ<100
        error('At least one iteration is needed');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Yps=ttm(tensor(TX),tUs,1:N);%MPCA projections of samples TX
vecDim=1;
for n=1:N, vecDim=vecDim*Is(n); end
vecYps=reshape(Yps.data,vecDim,numSpl); %vectorization of Yps
%%%%%%%%%%%%%%Now vecYps contains the feature vectors for training data

%%%%%%%%%%%%%%%Sort according to Fisher's discriminality%%%%%%%%%%%%%%%
classLabel = unique(gndTX);
nClass = length(classLabel);%Number of classes
ClsIdxs=cell(nClass);
Ns=zeros(nClass,1);
for i=1:nClass
    ClsIdxs{i}=find(gndTX==classLabel(i));
    Ns(i)=length(ClsIdxs{i});
end
Ymean=mean(vecYps,2);
TSW=zeros(vecDim,1);
TSB=zeros(vecDim,1);
for i=1:nClass
    clsYp=vecYps(:,ClsIdxs{i});
    clsMean=mean(clsYp,2);
    FtrDiff=clsYp-repmat(clsMean,1,Ns(i));
    TSW=TSW+sum(FtrDiff.*FtrDiff,2);
    meanDiff=clsMean-Ymean;
    TSB=TSB+Ns(i)*meanDiff.*meanDiff;
end
FisherRatio=TSB./TSW;
[stRatio,odrIdx]=sort(FisherRatio,'descend');

%%%%%%%%%%%%%%%%%%%%%%%%%%LDA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if length(odrIdx)<MPCADADim, MPCADADim=length(odrIdx);end
odrIdx=odrIdx(1:MPCADADim);%Take only the first a few
vecYps=vecYps(odrIdx,:);%Input to LDA
Ymean = mean(vecYps,2);%should be  zero
SB = zeros(MPCADADim);
for i = 1:nClass
    clsYp=vecYps(:,ClsIdxs{i});
    clsMean=mean(clsYp,2)-Ymean;
    SB = SB + Ns(i)*clsMean*clsMean';
end   
SW = vecYps*vecYps' - SB;
if rank(SW)<MPCADADim
    SW=SW+1e-6*eye(MPCADADim); 
end
option=struct('disp',0);
[LDAU, LDAV] = eigs(inv(SW)*SB,nClass-1,'lm',option);
%Calculate the weight 
LDAV=diag(LDAV);
Wgt=sqrt(LDAV);