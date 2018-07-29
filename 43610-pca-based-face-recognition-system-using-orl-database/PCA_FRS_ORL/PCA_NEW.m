% PCA Assignment
% clc
% clear all;
% close all;
function [recp,rectime,TDS,DS]= PCA_NEW(TrNum);

TsNum=10-TrNum; % Remained Number of Images for training, out of 400

[Tr,irow,icol,DS]=CDTr(TrNum);
[Ts,irow,icol,TDS]=CDTs(TrNum);

Tr=double(Tr);
Ts=double(Ts);
M=mean(Tr,2);
A=Tr-repmat(M,1,size(Tr,2));

 L=cov(A); % surogate Matrix of mean subtracted 
 [U D]=eig(L);% Eigen Vectors of Surogate Matrix
 
 L_eig_vec = [];
 for i = 1 : size(U,2) 
        if( D(i,i)>4500 )
         L_eig_vec = [L_eig_vec U(:,i)];
        end
 end
 
Eigenfaces = A * L_eig_vec;% Eigenvectors of Mean Subtracted Matrix

%%%%%%%%%%%%%%%%%%%%
ProjectedImages = [];
Train_Number = size(Tr,2);
for i = 1 : Train_Number
    temp = Eigenfaces'*A(:,i); % Projection of centered images into facespace
    ProjectedImages = [ProjectedImages temp]; 
end
ProjectedTestImages=[];
rec=[];

for j=1:size(Ts,2)
Difference = Ts(:,j)-M; % Centered test image
ProjectedTestImages = [ProjectedTestImages Eigenfaces'*Difference]; % Test image feature vector
end
%%%%%%%%%%%%%%%%%%%%%%%% Calculating Euclidean distances 
% Euclidean distances between the projected test image and the projection
% of all centered training images are calculated. Test image is
% supposed to have minimum distance with its corresponding image in the
% training database.
%tic

tic
for j=1:size(Ts,2)
Euc_dist = [];
for i = 1 : Train_Number
    %q = ProjectedImages(:,i);
    temp = ( norm( ProjectedTestImages(:,j) - ProjectedImages(:,i) ) )^2;
    Euc_dist = [Euc_dist temp];
end
%toc
%stem(Euc_dist);

[Euc_dist_min , Recognized_index] = min(Euc_dist);
rec=[rec Recognized_index];
end
rectime=toc;
recd=ceil(rec/TrNum);
%%%

 outd=[];
 for i = 1:DS/TrNum
     for j=1:TsNum
         outd=[outd i];
     end
 end

recp=1-(size(find((recd-outd)>0),2)/size(Ts,2));
sprintf('Recognition Percentage %1.2f%%  and recognition time is %1.3f sec for %d out of %d number of images',recp*100,rectime,TDS,DS)
end