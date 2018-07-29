function [X,Y,varargout]=digisn(alfa,varargin);
%Path tracing of spots' borders (simply connected 
%black  pixels sets), computing various data for each
%spot and for the whole image.
%[X Y]=digisn(alfa) - alfa - string, name of the image
%file with spots or 2D-array, or 3D-array (color).
%X,Y - matrices of curves (borders of spots)
%coordinates; 
%[X,Y,C]=digisn(...) - C - matrix (n+1)x15;
%n - a number of spots (which is detected during
%computation);
%     For a spot number i, i = 1, 2, ..., n:
%C(i,1:2) - mass center coordinates of a curve,
%C(i,3:4) - mass center coordinates of a spot,
%C(i,5)- a number of  border pixels, 
%C(i,6) - a number of spot pixels, 
%C(i,7:8) - X(C(i,7)),Y(C(i,7)),X(C(i,8)),Y(C(i,8)) - 
%  coordinates of the most remote points,
%C(i,9) - a distance between them,
%C(i,10:13) - coordinates of minimal rectangle
%  diagonal ends that contains a spot
%  (sides of rectangle are parallel to axes),
%C(i,14) - perimeter (a number of external edges 
%  of  spots' border),
%C(i,15) - perimeter (length of line connected 
%centers of border pixels),
%C(n+1,1:2) - coordinates of center of mass of all curves,
%C(n+1,3:4) - coordinates of center of mass of all spots,
%C(n+1,5) - a number  of all borders' pixels, 
%C(n+1,6) - a number  of all spots' pixels, 
%C(n+1,7:10) - coordinates of the most remote black 
%  points in the image,
%C(n+1,11) - a distance between them,
%C(n+1,11) - zeros,
%C(n+1,14) - perimeter (a number of external  
%  edges of all border pixels),
%C(n+1,15) - perimeter (the total length of  
%  lines connecting centers of border pixels),
%digisn(alfa,a0), a0 = 1 - to place each spot into a separate
%  image file of "bmp" format and the default name 
%  "specimen<# of spot>" where <# of spot> is a spot number.
%  If a0=k<0 then the application removes spots #1,...,k and
%  saves the rest of the source picture as file 
%  "RestAfterRemoving<k1>.bmp", where k1 equals -k. All spots
%  are placed as files with default names.
%  If a0 is a vector then spots #a0(1) - #a0(2) are saved as
%  image file "Keep_<a0(1)> <a0(2)>.bmp".
%  If a0 is a string, DIGISN assumes that this string is the name
%  of series of spots and intended for use instead of "specimen".
%digisn(alfa,a0,a1), a1 = 1 - to use clean procedure,
%digisn(alfa,a0,a1,a2) - a2 - a threshold for 
%  binarization, default is a mean intensity value,
%digisn(alfa,a0,a1,a2,a3), a3 - is the maximal number 
%  of iterations for each spot, default is 10000.
%E x a m p l e
%ax=zeros(100);ax(20:end,50:end)=1;ax(25:45,55:65)=0;
%[A B C]=digisn(ax);subplot(1,2,1);c=size(C,1);
%zx=plot(A,B,'.',C(c,1),C(c,2),'+',C(c,3),C(c,4),'*');
%subplot(1,2,2); imshow(ax');axis xy;

a1='     It is impossible to complete path tracing.';
a2=' Include ray deletion option and try once more.' ;
a3=' The problem might be connected with spot # ';
qint=[];    qnn=0;  J=alfa'; qnt=40; thre=[];
varargout(1)={0}; spcmn=[];
X=0;Y=0;
if ischar(alfa)
  J=imread(alfa)';
end
if isvector(J)  
  error('Input data set is neither 2D nor 3D array');
end
lensj=length(size(J));
I=J;
if lensj==3
  I=double(J(:,:,1))*0.298936+double(J(:,:,2))*0.587043...
    +double(J(:,:,3))*0.114021;   
end
switch nargin
  case 1
  case 2
    spcmn=varargin{1};
  case 3  
    spcmn=varargin{1};  qnn=varargin{2};
  case 4
    spcmn=varargin{1};  qnn=varargin{2};  
    thre=varargin{3};
  case 5
    spcmn=varargin{1};  qnn=varargin{2};
    thre=varargin{3};   qint=varargin{4};
  otherwise
    error('invalid input')
end
if isempty(thre)
  thre=mean(mean(I));
end
if isempty(qint)
  qint=10000;
end
I(I<thre)=0;    I=logical(I);
if qnn~=0
    disp('Cleaning')
    I=cleanrays(I);
    disp('Cleaning completed')
end
J3=I;   keep1=I;
for rr=1:intmax('int16')
  J2=I;   
  x=[];   y=[];   [si,sj]=size(I);  
  v=0;    q=0;    per=0; 
  dk1=0;  dk2=0;  dg1=1;
  k=1;    kt=k;   v1=1;   pr=0; 
  if sum(sum(~I))==0&rr==1
    error('No spot detected')
  end
  if sum(sum(~I))==0&rr>1
    disp([num2str(rr-1),' spots detected'])
    break
  end
%first black search
  sma=0;
  while 1
    [i,i]=max((max(I'==0)));
    [j j]=max(I(i,:)'==0);
    iuii=i;i=j;j=iuii;
    if i==1|j==1|i==si|j==sj
      break
    end
    sma=sum(sum(I(j-1:j+1,i-1:i+1)));
    if sma<8
      break
    end
    I(j,i)=1;
    J2(j,i)=1;
  end
  if sum(sum(~I))==0&rr==1
    disp([num2str(rr-1),' spots detected'])
    break
  end
  x=[x j];    y=[y i];
  xb=x;       yb=y;   
  v0130; 
  v0300;
  v0430;
  while 1
    dg1=dg1+1; 
    if dg1>qint    
    sss=['Maximal number of iterations ',num2str(qint),' is exceeded.'];
    if (x(k)~=xb)&(y(k)~=yb)
      ssss='End point is not coincided with the starting one.';
      sss={sss,ssss};
    end
    warndlg(sss);
    break
  end 
  v3=0;
  while v==1  
    v1030;       
    if (x(k)==xb)&(y(k)==yb)|v>1,break,end
    v0130;
    if v>1,break, end
    v0300;
    if v>1,break, end
    v0430;
    if v>1,break, end
    v0730;
    if (x(k)==xb)&(y(k)==yb)|v>1,break,end
    v0900;
    if (x(k)==xb)&(y(k)==yb)|v3>qnt,break,end 
    v3=v3+1;
  end 
  if (x(k)==xb)&(y(k)==yb)|v3>qnt,break,end
  while v==2 
    v1200; 
    if (x(k)==xb)&(y(k)==yb)|v~=2,break,end
    v0300;
    if v~=2,break,end    
    v0430;
    if v~=2,break,end
    v0600;    
    if v~=2,break,end
    v0900;
    if (x(k)==xb)&(y(k)==yb)|v~=2,,break,end
    v1030;
    if v3>qnt, break, end
    v3=v3+1;
  end 
  if (x(k)==xb)&(y(k)==yb)|v3>qnt,break,end
  while v==3
    v0130;
    if v~=3,break,end
    v0430;
    if v~=3,break,end  
    v0600;
    if v~=3,break,end
    v0730;
    if (x(k)==xb)&(y(k)==yb)|v~=3,,break,end
    v1030;
    if v~=3,break,end
    v1200;    
    if (x(k)==xb)&(y(k)==yb)|v3>qnt,break,end
    v3=v3+1;
  end  
  if (x(k)==xb)&(y(k)==yb)|v3>qnt,break,end
  while v==4
    v0300;
    if v~=4,break,end
    v0600;
    if v~=4,break,end
    v0730;    
    if (x(k)==xb)&(y(k)==yb)|v~=4,break,end
    v0900;
    if (x(k)==xb)&(y(k)==yb)|v~=4,break,end   
    v1200;
    if (x(k)==xb)&(y(k)==yb)|v~=4,break,end
    v0130;
    if v3>qnt, break, end
    v3=v3+1;
  end 
  if (x(k)==xb)&(y(k)==yb)|v3>qnt,break,end
  while v==5
    v0430;
    if v~=5,break,end  
    v0730;
    if (x(k)==xb)&(y(k)==yb)|v~=5,break,end
    v0900;
    if (x(k)==xb)&(y(k)==yb)|v~=5,break,end
    v1030;
    if v~=5,break,end
    v0130;
    if v~=5,break,end
    v0300;
    if v3>qnt,break,end
    v3=v3+1;
  end %%5
  if (x(k)==xb)&(y(k)==yb)|v3>qnt,break,end
  while v==6
    v0600;%'v==6'  
    if (x(k)==xb)&(y(k)==yb)|v~=6,break,end
    v0900;
    if (x(k)==xb)&(y(k)==yb)|v~=6,break,end
    v1030;
   if v~=6,break,end
   v1200;
   if (x(k)==xb)&(y(k)==yb)|v~=6,break,end
   v0300;
   if v~=6,break,end
   v0430;
   if v3>qnt,break,end
   v3=v3+1;
  end 
  if (x(k)==xb)&(y(k)==yb)|v3>qnt,break,end
  while v==7   
    v0730;  
    if (x(k)==xb)&(y(k)==yb)|v~=7,break,end
    v1030;
    if (x(k)==xb)&(y(k)==yb)|v~=7,break,end
    v1200;
    if v~=7,break,end
    v0130;
    if v~=7,break,end
    v0430;
    if v~=7,break,end
    v0600;   
    if v3>qnt,break,end
    v3=v3+1;
  end
  if (x(k)==xb)&(y(k)==yb)|v3>qnt,break,end
  while v==8  
    v0900;
    if (x(k)==xb)&(y(k)==yb)|v~=8,break,end
    v1200; 
    if (x(k)==xb)&(y(k)==yb)|v~=8,break,end
    v0130;
    if v~=8,break,end
    v0300;
    if v~=8,break,end
    v0600;
    if v~=8,break,end
    v0730;
    if (x(k)==xb)&(y(k)==yb)|v3>qnt,break,end
    v3=v3+1;
  end 
  if (x(k)==xb)&(y(k)==yb)|v3>qnt,break,end 
  dk=k-kt;
  if dk==dk1
    dk2=dk2+1;
  else
    dk2=0;
  end
  if (dk==dk1)&(dk2>qnt)
    wd=warndlg('Infinite looping','Computing is over');
    set(wd,'Color', [0.831373 0.815686 0])
    'Infinite looping'
    break
  end
  dk1=dk;   kt=k;
  end 
  if v3>qnt  
    warndlg({a1;a2;[a3 num2str(rr) ','];...
      ' or some spots are multiple connected.'},'Computing is over')
    break
  end
  if dg1>qint
    break
  end   
  cmssn; 
  if nargin>1  
    nsrr=[num2str(rr)];
    if ~isempty(spcmn)&isnumeric(spcmn)
      if spcmn>0
        namp=['specimen' nsrr '.bmp'];
        imwrite(I(mnx:mxx,mny:mxy),namp);
        if numel(spcmn)>1
          if spcmn(1)>rr|rr>spcmn(2)      
            keep1=~xor(I,keep1);          
          end
        end
      end
      if spcmn<0&rr==-spcmn+1      
        imwrite(rot90(J2),['RestAfterRemoving' num2str(rr-1) '.bmp']);
        break
      end
    end
    if ischar(spcmn)
      namp=[spcmn nsrr '.bmp'];
      imwrite(rot90(I(mnx:mxx,mny:mxy)),namp);  
    end
  end
  I=~xor(J2,I);
  X(length(x),rr)=0;      Y(length(y),rr)=0;
  X(1:length(x),rr)=x;    Y(1:length(y),rr)=y;
  XC(rr,:)=[xc yc xcc ycc length(x)-1 mss ...
    uz kz2 kz1 mnx mny mxx mxy per pr];
end
if dg1<=qint&v3<=qnt   
  X0=X(X>0);
  Y0=Y(Y>0);
  if nargout==3
    cmssnn
    XC(rr,15)=0;
    XC(rr,:)=[xc,yc,xcc,ycc,sum(XC(1:rr-1,5)),...
      sum(XC(1:rr-1,6)),X0(uz),Y0(uz),X0(kz2),...
      Y0(kz2),kz1,0,0,sum(XC(1:rr-1,14)),sum(XC(1:rr-1,15))];
  end
  varargout(1)={XC};
end
if isnumeric(spcmn)&numel(spcmn)>1
  imwrite(rot90(keep1),['Keep' ...
    num2str(spcmn(1)) '_' num2str(spcmn(2)) '.bmp']);
end
