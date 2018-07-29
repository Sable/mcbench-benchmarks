function Iout=scorfilt(I)
% SPATIAL CORRELATION FILTER
% 
% IN
% I:        Image to filter, (RGB color or grayscale)
% %
% OUT
% Iout:     Filtered image (double)
%
% EXAMPLE:
%
% %read image
% imfile = fullfile(matlabroot,...
%          'toolbox','images','imdemos','greens.jpg');
% Io=im2double(imread(imfile));
% %add noise
% sigma_n=20; %noise std. dev.
% randn('seed', 0);
% I=Io+sigma_n/255*randn(size(Io));
% figure('Name', 'input'), imshow(I);
% %filter image
% Iout = scorfilt(I);
% figure('Name', 'output'), imshow(Iout);
%
% Author:   Carlos Estrada
% Date:     May 25, 2012
% Version   1.0
%
%% Configuration
r_max=5;    %max. half-size window
c=1/5;      %c 'neighborhood' constant default value

%% labels
I=im2double(I);
[m n ch]=size(I);
   
if ch==1           %gray scale
   maxI=max(I(:));
   minI=min(I(:));
   bins=255;   %quantization bins   
   Ieq=uint8((bins-1)*histeq((I-minI)./(maxI-minI), bins))+1;

   labels=zeros(m,n,'uint8');
   N=0;
   bin_mark=zeros(bins,1,'uint8');

   for i=1:m   
       for j=1:n       
          id=Ieq(i,j);
         if bin_mark(id)==0
            N=N+1;
            labels(i,j)=N;
            bin_mark(id)=N;
         else
            labels(i,j)=bin_mark(id);
         end
       end
   end

elseif ch==3       %color
%    maxI=max(I(:));
%    minI=min(I(:));
%    Ifit=(I-minI)/(maxI-minI);
   bins=255;   %quantization bins
   [labels, centers] = rgb2ind(I,bins,'nodither');
   N=size(centers,1);
   labels=labels+1;
end

%% adjacency matrix
Acum=zeros(N,'uint32');
for i=1:m
    for j=1:n
       a=labels(i,j);
       if i>1
         e=labels(i-1,j);
         Acum(a,e)=Acum(a,e)+1;
       end
       if j>1
         e=labels(i,j-1);
         Acum(a,e)=Acum(a,e)+1;
       end
    end
end
A=double(Acum+Acum');

h4=sum(A,2);
P=A./repmat(h4,1,N); %transition matrix
Q=((P+P')./2)^2;
%% neighborhood size
teta=diag(P)'*h4./sum(h4);
w=sqrt((1-teta)/teta);
sigma_d=c*w;
r=max(1,min(r_max,round(sigma_d*2.5)));
%fprintf('\tN: %d\tw: %.4f\tsigma_d: %.4f', N,w,sigma_d);
%% compute Iout
Iout=zeros(m,n,ch);
[x,y] = meshgrid(-r:r,-r:r);
F=exp(-(x.^2 + y.^2)./(2*sigma_d^2));

for i=1:m   
    iMin = max(i-r,1);
    iMax = min(i+r,m);
    di=iMin:iMax;
    for j=1:n       
       jMin = max(j-r,1);
       jMax = min(j+r,n);
       dj=jMin:jMax;
       
       a=labels(i,j);
       l = labels(di,dj);
       f=F(di-i+r+1,dj-j+r+1);
       
       w=Q(l(:),a).*f(:);
       w=w./sum(w);
       
       y=I(di,dj,:);
       
       for cc=1:ch
         yc=y(:,:,cc);
         Iout(i,j,cc)=w'*yc(:);
       end
    end
end
