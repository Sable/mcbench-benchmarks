%   Function Usage out_put = btc_image01(in_put,block_size)
%   The function does Image Compession based On BLOCK TRUNCATION CODING
%   out_put     :   Output Image
%   in_put      :   Input Image
%   block_size  :   Block Size for processing(2x2,4x4,8x8 so on)
%   This function supports only Square Images whose height and width
%   are a multiple of 2(TWO)
%   DATE    07/04/2004
%   TIME    11:05 AM    
%   MULTIMEDIA COMMUNICATION LAB
%   VALLABHA VASANT HAMPIHOLI
function out_put = btc_image(in_put,block_size)
X=imread(in_put);
Y=imfinfo(in_put);
K=block_size;
X1=double(X);
y1=size(X);
n=y1(1);
m=y1(2);
k=1;l=1;


if (Y.ColorType=='grayscale')

%                      IMAGE ENCODING

%
%                  FOR GRAY SCALE IMAGES 
%
subplot(131),imshow(X),title('ORIGINAL');
for i=1:K:n
    for j=1:K:m
        tmp([1:K],[1:K])=X1([i:i+(K-1)],[j:j+(K-1)]);
        mn=mean(mean(tmp));
        tmp1([i:i+(K-1)],[j:j+(K-1)])=tmp>mn;
        Lsmat=(tmp<mn);
        Mrmat=(tmp>=mn);
        Lsmn=sum(sum(Lsmat));
        Mrmn=sum(sum(Mrmat));
        Mu(k)=sum(sum(Lsmat.*tmp))/(Lsmn+.5);k=k+1;
        Mi(l)=sum(sum(Mrmat.*tmp))/Mrmn;l=l+1;
    end
end
subplot(132),imshow(tmp1);title('ENCODED');

%                     IMAGE DECODING

k=1;l=1;
for i=1:K:n
    for j=1:K:m
        tmp21([1:K],[1:K])=tmp1([i:i+(K-1)],[j:j+(K-1)]);
        tmp22=(tmp21*round(Mu(k)));k=k+1;
        tmp21=((tmp21==0)*round(Mi(l)));l=l+1;
        tmp21=tmp21+tmp22;
        out_put([i:i+(K-1)],[j:j+(K-1)])=tmp21;
    end
end
subplot(133),imshow(uint8(out_put));title('DECODED');

%
%                   FOR COLORED IMAGES
%

elseif (Y.ColorType=='truecolor')
    R=X(:,:,1);
    G=X(:,:,2);
    B=X(:,:,3);
    %                   IMAGE ENCODING
subplot(131),imshow(X),title('ORIGINAL');
for b=1:3
    for i=1:K:n
            for j=1:K:m
                tmp([1:K],[1:K])=X1([i:i+(K-1)],[j:j+(K-1)],b);
                mn=mean(mean(tmp));
                tmp1([i:i+(K-1)],[j:j+(K-1)],b)=tmp>mn;
                Lsmat=(tmp<mn);
                Mrmat=(tmp>=mn);
                Lsmn=sum(sum(Lsmat));
                Mrmn=sum(sum(Mrmat));
                Mu(b,k)=sum(sum(Lsmat.*tmp))/(Lsmn+.5);k=k+1;
                Mi(b,l)=sum(sum(Mrmat.*tmp))/Mrmn;l=l+1;
            end
    end
end
subplot(132),imshow(tmp1);title('ENCODED');

%                   IMAGE DECODING

k=1;l=1;
for b=1:3
    for i=1:K:n
            for j=1:K:m
                tmp21([1:K],[1:K])=tmp1([i:i+(K-1)],[j:j+(K-1)]);
                tmp22=(tmp21*round(Mu(b,k)));k=k+1;
                tmp21=((tmp21==0)*round(Mi(b,l)));l=l+1;
                tmp21=tmp21+tmp22;
                out_put([i:i+(K-1)],[j:j+(K-1)],b)=tmp21;
            end
    end
end

subplot(133),imshow(uint8(out_put));title('DECODED');


else
     
    errordlg('IMAGE TYPE NOT SUPPORTED');
    
end
