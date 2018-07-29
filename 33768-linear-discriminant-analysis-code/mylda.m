function [sLDA WLDA M WPCA]=mylda(data,class,n)
% [sLDA WLDA M WPCA]=mylda(data,class,n)
% this function written by muhammet balcilar
% yildiz technical university computer engineering department
% istanbul turkiye 2011

% this function convert data from its original space to LDA space
% if number of data samples is less than number of diamension, PCA is
% implemented for reducing number of diamension to #samples-1. 
% after PCA, LDA is implemented for reducing diamention to n.

% data is consist of M rows(sample size), N cols(dimensions)
% class is consist of M rows(sample size), 1 cols , each element of class 
% is shows class number of each data sample 
% (class number must be integer 1 to classsize)
% n is the number of outputs data diamensions.(optionally)
% sLDA is consist of M rows(sample size) n cols(new dimensions)
% WPCA is translate matrix which convert to original space to PCA space
% M is the mean vector of training set
% WLDA is the translate matrix which convert to original space to LDA space
% exaple: there are 4 samples which have 5 diamensions.first two samples
% are member of class 1 others are member of class 2.
% Train= [5.6,5.7,5.5,5.7 5.6;
%     5.7,5.3,5.1,5.0 5.2;
%     10.6,9.9,10.4,10.7 10.2;
%     10.7,9.8,9.9,10 10];
% Class=[1;1;2;2];
% [sLDA WLDA M WPCA]=mylda(Train,Class)
% Test= [4.9 5.5 4.8 5.7 5];
% LDATEST = (Test-M)*WPCA*WLDA

usinif=unique(class);
if nargin==2
    n=length(usinif)-1;
end

if size(data,2)>=size(data,1)
    % PCA start
    O=data';
    m=(mean(O'))';
    for i=1:size(O,2)
        mO(:,i)=O(:,i)-m;
    end
    CV=mO*mO';
    [v u]=eig(CV);
    D=v(:,end-size(data,1)+2:end); 
    yO=(mO'*D)';
    M=m';
    WPCA=D;
    % PCA finished
else
    yO=data';
    M=zeros(1,size(data,2));
    WPCA=1;    
end


% LDA start
mU=(mean(yO'))';
mK=[];
for i=1:length(usinif)
    I=find(class==i);
    ort=(mean(yO(:,I)'))';
    mK=[mK ort];
    for j=1:length(I)
        UU(:,I(j))=yO(:,I(j))-ort;
    end
end
for i=1:length(usinif)
    I=find(class==i);
    S{i}= UU(:,I)*UU(:,I)';
end
SW=S{1};
for i=2:length(usinif)
    SW=SW+S{i};
end

for i=1:length(usinif)
    mmK(:,i)=mK(:,i)-mU;
end
SB=2*mmK*mmK';
[w u]=eig(SB,SW);
u=abs(diag(u));
u=[u [1:length(u)]'];
u=sortrows(u,1);
WLDA=w(:,u(end-n+1:end,2)); 
sLDA=(yO'*WLDA)';