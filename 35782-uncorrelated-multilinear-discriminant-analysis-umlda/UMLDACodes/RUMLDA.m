function [Us] = RUMLDA(TX,gndTX,numP,gamma,MaxSWLmds,iInit)
% UMLDA:     Uncorrelated Multilinear Discriminant Analysis
% R-UMLDA:   Regularized UMLDA
% R-UMLDA-A: R-UMLDA with Aggregation
%
% %[Prototype]%
% function [Us] = RUMLDA(TX,gndTX,numP,gamma,MaxSWLmds,iInit)
%
% %[Author Notes]%
% Author: Haiping LU
% Email : hplu@ieee.org   or   eehplu@gmail.com
% Release date: March 21, 2012 (Version 1.0)
% Please email me if you have any problem, question or suggestion
%
% %[Algorithm]%:
% This function implements the Uncorrelated Multilinear Principal Component
% Analysis (UMPCA) algorithm presented in the follwing paper:
%    Haiping Lu, K.N. Plataniotis, and A.N. Venetsanopoulos,
%    "Uncorrelated Multilinear Discriminant Analysis with Regularization and Aggregation for Tensor Object Recognition",
%    IEEE Transactions on Neural Networks,
%    Vol. 20, No. 1, Page: 103-123, Jan. 2009.
% Please reference this paper when reporting work done using this code.
%
% %[Toolbox needed]%:
% Matlab Tensor Toolbox (included in this package)
% source: http://csmr.ca.sandia.gov/~tgkolda/TensorToolbox/
%
% %[Syntax]%: [Us] = RUMLDA(TX,gndTX,numP,gamma,MaxSWLmds,iInit)
%
% %[Inputs]%:
%    TX: the ZERO-MEAN input training data in tensorial representation, the last mode
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
%    numP: the dimension of the projected vector, denoted as P in the
%          paper. It is the number of elementary multilinear projections 
%          (EMPs) in tensor-to-vector projection (TVP).
%
%    gamma: the regularization parameter.
%
%    MaxSWLmds: \lambda_{max} in the paper, the maximum eigenvalue of the
%          the within-class scatter matrix for the $n$-mode vectors of the
%          training samples, used for regularization.
%
%    iInit: the index of R-UMLDA to be aggregated, "a=1,...,A" in the paper.
%
% %[Outputs]%:
%    Us: the multilinear projection, consiting of numP (P in the paper) 
%        elementary multilinear projections (EMPs), each EMP is consisted
%        of N vectors, one in each mode 
%
%
% %[Supported tensor order]%
% This function supports N=2,3,4, for other order N, please modify the
% codes accordingly or email hplu@ieee.org or eehplu@gmail.com for help
%
% %[Examples]%
% Please see "demoR-UMLDA-Aggr.m" on how to aggregate R-UMLDAs
%%%%%%%%%%%%%%%%%%%%%%%%%%Example on 2D face data%%%%%%%%%%%%%%%%%%%%%%%%%%
%       load FERETC80A45S6/FERETC80A45S6_32x32%each sample is a second-order tensor of size 32x32
%       N=ndims(fea2D)-1;%Order of the tensor sample
%       Is=size(fea2D);%80x80x721
%       numSpl=Is(3);%There are 721 face samples
%       numP=80;
%       load('FERETC70A15S8/3Train/1');%load partition for 3 samples per class
%       fea2D_Train = fea2D(:,:,trainIdx);
%       [Us,TXmean,odrIdx]  = UMPCA(fea2D,numP);
%       fea2D=fea2D-repmat(TXmean,[ones(1,N), numSpl]);%Centering
%       numP=length(odrIdx);
%       newfea = zeros(numSpl,numP);
%       for iP=1:numP
%           projFtr=ttv(tensor(fea2D),Us(:,iP),[1 2]);
%           newfea(:,iP)=projFtr.data;
%       end
%       newfea = newfea(:,odrIdx);%newfea is the final feature vector to be 
%       %fed into a standard classifier (e.g., nearest neighbor classifier)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% %[Notes]%:
% A. Developed using Matlab R2006a & Matlab Tensor Toolbox 2.1
% B. Revision history:
%       Version 1.0 released on March 21, 2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%TX: (N+1)-dimensional tensor Tensor Sample Dimension x NumSamples
N=ndims(TX)-1;%The order of samples.
IsTX=size(TX);
Is=IsTX(1:N);%The dimensions of the tensor

splNum=IsTX(N+1);%Number of samples
classLabel = unique(gndTX);
nClass = length(classLabel);%Number of classes
ClsIdxs=cell(nClass,1);Ns=zeros(nClass,1);
for i=1:nClass
    ClsIdxs{i}=find(gndTX==classLabel(i));
    Ns(i)=length(ClsIdxs{i});%number of samples in each class
end

%%%%%%%%%%%%%%%RUMLDA parameters%%%%%%%%%%%%%%%%
maxK=10; %maximum number of iterations, you can change this number
kappa=1e-3;%\kappa in the paper
Us=cell(N,numP);%the TVP to be solved
Us0=cell(N,1);
for iP=1:numP
    %Initialization
    for n=1:N
        if iP==1
            if mod(iInit,4)==1 
                Un=ones(Is(n),1); %uniform initialization
            else
                Un=rand(Is(n),1)-0.5;%random initialization
            end
            Un=Un/norm(Un);
            Us0{n}=Un;
        end
        Us{n,iP}=Us0{n};
    end
    %End Initialization
    %Start iterations
    for k=1:maxK
        for n=1:N            
            switch N
                case 2
                    switch n
                        case 1
                            Ypn=ttv(tensor(TX),Us(2,iP),2);
                        case 2
                            Ypn=ttv(tensor(TX),Us(1,iP),1);
                    end
                case 3
                    switch n
                        case 1
                            Ypn=ttv(tensor(TX),Us(2:3,iP),[2 3]);
                        case 2
                            Ypn=ttv(tensor(TX),Us(1:2:3,iP),[1 3]);
                        case 3
                            Ypn=ttv(tensor(TX),Us(1:2,iP),[1 2]);
                    end
                case 4
                    switch n
                        case 1
                            Ypn=ttv(tensor(TX),Us(2:4,iP),[2 3 4]);
                        case 2
                            Ypn=ttv(tensor(TX),Us([1,3,4],iP),[1 3 4]);
                        case 3
                            Ypn=ttv(tensor(TX),Us([1,2,4],iP),[1 2 4]);
                        case 4
                            Ypn=ttv(tensor(TX),Us(1:3,iP),[1 2 3]);
                    end
                otherwise
                    error('Order N not supported. Please modify the code here or email hplu@ieee.org for help.')
            end            
            Ypn=Ypn.data;
            SW=zeros(Is(n));SB=zeros(Is(n));
            for i=1:nClass
                Yts=Ypn(:,ClsIdxs{i});
                TYCMeans=mean(Yts,2);
                for j=1:Ns(i)
                    YDiff=Yts(:,j)-TYCMeans;
                    SW=SW+YDiff*YDiff'; %Within-class Scatter
                end
                SB=SB+Ns(i)*(TYCMeans*TYCMeans'); %Between-class scatter
            end
            SW=SW+gamma*MaxSWLmds(n)*eye(Is(n));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            option=struct('disp',0);
            if iP>1
                invSW=inv(SW);
                invGYYG=inv(Gps'*Ypn'*invSW*Ypn*Gps+kappa*eye(iP-1));
                RSB=(eye(Is(n))-Ypn*Gps*invGYYG*Gps'*Ypn'*invSW);%equation (13) in the paper
                SB=RSB*SB;
                [Un,Lmdn]=eigs(SB,SW,1,'lm',option);
            else
                [Un,Lmdn]=eigs(SB,SW,1,'la',option);
            end
            Un=Un/norm(Un);
            Us{n,iP}=Un;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %%%%%%%%%%%%%%%%%%%%%%%Projection%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gp=ttv(tensor(TX),Us(:,iP),1:N);
    gp=gp.data;
    if iP==1
        Gps=gp;
    else
        Gps=[Gps gp];
    end
    %%%%%%%%%%%%%%%%%%%%%%%End Projection%%%%%%%%%%%%%%%%%%%%%%%%%%%
end