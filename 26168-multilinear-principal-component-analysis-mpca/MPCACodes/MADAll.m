function [SeqR1s,SeqR5s]=MADAll(fea_Train,gnd_Train,fea_Test,gnd_Test,testDims,wgts)
%Nearest neighbor classifier with MAD measure and symmetric matching

nTrain = size(fea_Train,1);
nTest = size(fea_Test,1);
nDim=length(testDims);%number of feature dimensions to test
SeqR1s=zeros(nDim,1);%Rank 1 recognition rate based on matching gait sequences
SeqR5s=zeros(nDim,1);%Rank 5 recognition rate based on matching gait sequences

for iDim=1:nDim
    Dim=testDims(iDim);
    feaTrn=fea_Train(:,1:Dim);
    feaTst=fea_Test(:,1:Dim);
    DMat=MAD(feaTrn,feaTst, wgts);%This is the MAD distance matrix
    [SeqR1s(iDim,1),SeqR5s(iDim,1)]=SeqDist(DMat,gnd_Train,gnd_Test);
end

%Calculate matching scores between each training/test sample pair
function D = MAD(feaTrn, feaTst, wgts)
if size(wgts,2)==1, wgts=wgts';end
[numTst,p] = size(feaTst);
numTrn = size(feaTrn,1);
wgts=wgts(1:p);
D = zeros(numTst,numTrn);
for i=1:numTst
    for j=1:numTrn
        A=feaTst(i,:);
        B=feaTrn(j,:);
        % the following two lines calculate the MAD between A and B        
        dist=sum(sum(sum(A.*B./wgts)));
        D(i,j)=-dist/(norm(A(:))*norm(B(:)));    
    end
end

%The recognition rate between two sequences
function [SeqR1,SeqR5]=SeqDist(DMat,gnd_Train,gnd_Test)
trnSeqs=unique(gnd_Train);
numTrnSeq=length(trnSeqs);

tstSeqs=unique(gnd_Test);
numTstSeq=length(tstSeqs);

SeqDMat=zeros(numTstSeq,numTrnSeq);
for i=1:numTstSeq
    idxs_i=find(gnd_Test==tstSeqs(i));
    iMat=DMat(idxs_i,:);
    for j=1:numTrnSeq
        idxs_j=find(gnd_Train==trnSeqs(j));
        jMat=iMat(:,idxs_j);
        SeqDMat(i,j)=mean(min(jMat,[],1))+mean(min(jMat,[],2));
    end
end
[minDs,minIdxs]=min(SeqDMat, [], 2);%Minimum distance implies best match
IDs=trnSeqs(minIdxs);
SeqR1=sum(IDs==tstSeqs)/numTstSeq;%Rank 1

[stDs,stIdxs]=sort(SeqDMat,2);
IDs=trnSeqs(stIdxs(:,1:5));
tstSeqs5=repmat(tstSeqs,1,5);
SeqR5=sum(sum(IDs==tstSeqs5))/numTstSeq;%Rank 5