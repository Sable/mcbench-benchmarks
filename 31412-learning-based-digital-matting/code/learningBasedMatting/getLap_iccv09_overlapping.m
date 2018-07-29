function L=getLap_iccv09_overlapping(imdata,winsz,mask,lambda)
% L=getLap_iccv09_overlapping(imdata,winsz,mask,lambda) get the laplacian
% matrix based on imdata (image data) and winsz (local window size). See
% equations (6) and (11) in our iccv2009 paper.
% 
% Input arguments:
% imdata: MxNxd matrix. Image size is MxN, and feature number is d. Value
%         range is within [0 255]
% winsz:  vec with 2-components showing size of local window for training
%         local linear models. Values will be obliged to be odd.
% mask:   MxN matrix specifying scribbles, with 1 foreground, -1 background
%         and 0 otherwise
% lambda: para of the regularization in training local linear model
% 
% Output arguments:
% L:     (MxN)X(MxN) sparse matrix
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% @InProceedings{ZhengICCV09,
%   author = {Yuanjie Zheng and Chandra Kambhamettu},
%   title = {Learning Based Digital Matting},
%   booktitle = {The 20th IEEE International Conference on Computer Vision},
%   year = {2009},
%   month = {September--October}
% }
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Copyright Yuanjie Zheng @ PICSL @ UPenn on May 9th, 2011
% zheng.vision@gmail.com
% http://sites.google.com/site/zhengvision/
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

if ~exist('lambda','var')
    lambda=0.00001;
end
if length(winsz)==1
    winsz(2)=winsz(1);
end

% normalize imdata to be within [0 1]
imdata=double(imdata)./255;
imsz=size(imdata); d=size(imdata,3);
pixInds=reshape(1:imsz(1)*imsz(2),imsz(1),imsz(2));

% change winsz to be odd if not
winsz((mod(winsz,2)==0))=winsz((mod(winsz,2)==0))+1;
numPixInWindow=winsz(1)*winsz(2);
halfwinsz=(winsz-1)/2;

% erode scribble mask
scribble_mask=abs(mask)~=0;
scribble_mask=imerode(scribble_mask,ones(max(winsz)));

numPix4Training=sum(sum(1-scribble_mask(halfwinsz+1:end-halfwinsz,halfwinsz+1:end-halfwinsz)));
numNonzeroValue=numPix4Training*numPixInWindow^2;

row_inds=zeros(numNonzeroValue,1);
col_inds=zeros(numNonzeroValue,1);
vals=zeros(numNonzeroValue,1);

% repeat on each legal pixel
len=0;
for j=1+halfwinsz(2):imsz(2)-halfwinsz(2)
    for i=halfwinsz(1)+1:imsz(1)-halfwinsz(1)
        if scribble_mask(i,j)
            continue;
        end
        winData=imdata(i-halfwinsz(1):i+halfwinsz(1),j-halfwinsz(2):j+halfwinsz(2),:);
        winData=reshape(winData,numPixInWindow,d);
        lapcoeff=compLapCoeff(winData,lambda);
      
        win_inds=pixInds(i-halfwinsz(1):i+halfwinsz(1),j-halfwinsz(2):j+halfwinsz(2));

        row_inds(1+len:numPixInWindow^2+len)=reshape(repmat(win_inds(:),1,numPixInWindow),...
                                             numPixInWindow^2,1);

        col_inds(1+len:numPixInWindow^2+len)=reshape(repmat(win_inds(:)',numPixInWindow,1),...
                                             numPixInWindow^2,1);

        vals(1+len:numPixInWindow^2+len)=lapcoeff(:);
        
        len=len+numPixInWindow^2;
    end
end

W=sparse(row_inds,col_inds,vals,imsz(1)*imsz(2),imsz(1)*imsz(2));

L=W;


function lapcoeff=compLapCoeff(winI,lambda)
% 
% winI: nxc matrix where n is the number of pixel, c number of features

if ~exist('lambda','var')
    lambda=0.0000001;
end

Xi=winI;
Xi=[Xi ones(size(Xi,1),1)];
I=eye(size(Xi,1)); I(end,end)=0;

% coefficient, i.e. F
fenmu=(Xi*Xi'+(lambda)*I);
F=(Xi*Xi')/fenmu;
% laplacian coefficnets, i.e. (I-F)*(I-F)'
I_F=eye(size(F,1))-F;
lapcoeff=I_F'*I_F;
