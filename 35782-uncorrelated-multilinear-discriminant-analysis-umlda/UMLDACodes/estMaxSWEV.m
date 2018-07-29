function MaxSWLmds=estMaxSWEV(TX,gndTX)
%To estimate \lambda_{max} in the paper, the maximum eigenvalue of the
%the within-class scatter matrix for the $n$-mode vectors of the training
%samples, used for regularization in R-UMLDA.
%
% %[Prototype]%
% function MaxSWLmds=estMaxSWEV(TX,gndTX)

%TX: (N+1)-dimensional tensor Tensor Sample Dimension x NumSamples
N=ndims(TX)-1;%The order of samples.
IsTX=size(TX);
Is=IsTX(1:N);%The dimensions of the tensor
splNum=IsTX(N+1);%Number of samples

classLabel = unique(gndTX);
nClass = length(classLabel);%Number of classes
MaxSWLmds=zeros(N,1);
for n=1:N
    SW=zeros(Is(n));SB=zeros(Is(n));
    for i=1:nClass
        index=find(gndTX==classLabel(i));
        switch N
            case 2
                clsTX=TX(:,:,index);
            case 3
                clsTX=TX(:,:,:,index);
            case 4
                clsTX=TX(:,:,:,:,index);
            otherwise
                error('Order N not supported. Please modify the code here or email hplu@ieee.org for help.')
        end
        TXClsMeans=mean(clsTX,N+1);
        XDiff=double(tenmat(tensor(TXClsMeans),n));
        SB=SB+length(index)*(XDiff*XDiff');
        for j=1:length(index)
            switch N
                case 2
                    XDiff=double(tenmat(tensor(clsTX(:,:,j)),n))-double(tenmat(tensor(TXClsMeans),n));
                case 3
                    XDiff=double(tenmat(tensor(clsTX(:,:,:,j)),n))-double(tenmat(tensor(TXClsMeans),n));
                case 4
                    XDiff=double(tenmat(tensor(clsTX(:,:,:,:,j)),n))-double(tenmat(tensor(TXClsMeans),n));
                otherwise
                    error('Order N not supported. Please modify the code here or email hplu@ieee.org for help.')
            end            
            SW=SW+XDiff*XDiff';
        end
    end    
    option=struct('disp',0);
    [Un,MaxSWLmds(n)]=eigs(SW,1,'la',option);    
end