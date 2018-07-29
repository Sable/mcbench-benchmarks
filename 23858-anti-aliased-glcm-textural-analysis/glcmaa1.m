function [mxo,mxro]=glcmaa1(z,ksize,nclasses,region)
% ***************************************************************
% *** Antialiased GLCM texture analysis
% *** G.R.J.Cooper February 2007
% *** gordon.cooper@wits.ac.za
% *** www.wits.ac.za/science/geophysics/gc.htm
% ***************************************************************
% *** Please reference this paper;
% *** Cooper, G.R.J., 2009. The Antialiased Textural Analysis of Aeromagnetic Data. 
% *** Computers & Geosciences v.35, p.586-591.
% *** -if you use this code. Thank you.
% ***************************************************************
% *** Inputs;
% *** z         : Data matrix
% *** ksize     : Window size (should be an odd number>1)
% *** nclasses  : No. classes to use
% *** region    : 'gl' for global classes, 'lo' for local classes
   
ksize=abs(round(ksize)); if ksize<3; ksize=3; end;
k2=floor(ksize/2); 
nclasses=abs(round(nclasses)); if nclasses<2; nclasses=2; end;
zmax=max(z(:));
[nx,ny]=size(z);

if strcmp(region,'gl');
 disp('Global levels.');
 zmin=min(z(:)); 
 zint=(zmax-zmin)/nclasses;
 for Level=1:nclasses; classb(Level)=zmin+(Level-1)*zint; end; 
else 
 disp('Local levels.');
 classb(1:nclasses)=0.0;
end;

classb(nclasses+1)=zmax; 
mx=zeros(nx,ny); mxr=zeros(nx,ny); % Memory management

disp('Processing row;');
for I=k2+1:nx-k2;         
 if (floor(I/20)==I/20); disp(I); end;
 for J=k2+1:ny-k2;
  zr=z(I-k2:I+k2,J-k2:J+k2);
  courr=GLCMn(zr,nclasses,classb,ksize,region);
  courreal=GLCMa(zr,nclasses,classb,ksize,region);
  for K=1:nclasses;
   for L=1:nclasses;
    mx(I,J)=mx(I,J)+courr(K,L)/(0.01+(K-L)*(K-L));    % Inverse difference moment
    mxr(I,J)=mxr(I,J)+courreal(K,L)/(0.01+(K-L)*(K-L));
   end; 
  end;    
 end; 
end; 
mxo=mx(k2+1:nx-k2,k2+1:ny-k2); mxro=mxr(k2+1:nx-k2,k2+1:ny-k2); % Crop border

figure(1); clf;
subplot(1,3,1); imagesc(z); axis equal tight xy; title('Data');
subplot(1,3,2); imagesc(mxo); axis equal tight xy; title('Moment EW'); 
subplot(1,3,3); imagesc(mxro); axis equal tight xy; title('Anti-Aliased Moment'); 
colormap(gray(256));
currfig = get(0,'CurrentFigure'); set(currfig,'numbertitle','off');
set(currfig,'name','GLCM Texture Analysis'); 

%*********************************************************************
function courr=GLCMa(zr,nclasses,classb,ksize,region)

% Define classes locally

if strcmp(region,'lo');
 zmax=max(zr(:)); zmin=min(zr(:));
 zint=(zmax-zmin)/nclasses;
 for Level=1:nclasses; classb(Level)=zmin+(Level-1)*zint; end; 
 classb(nclasses+1)=zmax;
end;

% Divide data into classes

classize=classb(2)-classb(1);
zclass=zeros(ksize); zfract=zeros(ksize);
 for I=1:ksize;
  for J=1:ksize;
   for K=1:nclasses; 
    if (zr(I,J)>=classb(K)) && (zr(I,J)<classb(K+1)); 
     zclass(I,J)=K;
     zmid=mean([classb(K) classb(K+1)]);
     zfract(I,J)=1-abs((zr(I,J)-zmid)/classize);
    end;
    if zr(I,J)==classb(nclasses+1); 
     zclass(I,J)=nclasses; 
     zfract(I,J)=0.5;
    end;  
   end;
  end;
 end;

% Build NclassesxNclasses co-occurrence matrix, using KsizexKsize kernel

courr=zeros(nclasses);
 for I=1:ksize;
  for J=1:ksize-1;
   class1=zclass(I,J);
   class2=zclass(I,J+1);
   courr(class1,class2)=courr(class1,class2)+zfract(I,J)*zfract(I,J+1); % need to check 4 options

   zmid=mean([classb(class1) classb(class1+1)]);
   if zr(I,J)>zmid; class1f=class1+1; else class1f=class1-1; end;
   if class1f<1; class1f=1; end; if class1f>nclasses; class1f=nclasses; end;
   courr(class1f,class2)=courr(class1f,class2)+(1-zfract(I,J))*zfract(I,J+1);

   zmid=mean([classb(class2) classb(class2+1)]);
   if zr(I,J+1)>zmid; class2f=class2+1; else class2f=class2-1; end;
   if class2f<1; class2f=1; end; if class2f>nclasses; class2f=nclasses; end;
   courr(class1,class2f)=courr(class1,class2f)+zfract(I,J)*(1-zfract(I,J+1));

   courr(class1f,class2f)=courr(class1f,class2f)+(1-zfract(I,J))*(1-zfract(I,J+1));
  end;
end;

% Normalisation

courr=courr/(ksize*(ksize-1));

%*********************************************************************
function courr=GLCMn(zr,nclasses,classb,ksize,region)

% Define classes locally

if strcmp(region,'lo');
 zmax=max(zr(:)); zmin=min(zr(:));
 zint=(zmax-zmin)/nclasses;
 for Level=1:nclasses; classb(Level)=zmin+(Level-1)*zint; end; 
 classb(nclasses+1)=zmax;
end;

% Divide data into classes

zclass=zeros(ksize);
 for I=1:ksize;
  for J=1:ksize;
   for K=1:nclasses; 
    if (zr(I,J)>=classb(K)) && (zr(I,J)<classb(K+1)); zclass(I,J)=K; end;
    if zr(I,J)==classb(nclasses+1); zclass(I,J)=nclasses; end;
   end;
  end;
 end;

% Build NclassesxNclasses co-occurrence matrix 

courr=zeros(nclasses);

for I=1:ksize;
 for J=1:ksize-1;
  class1=zclass(I,J);
  class2=zclass(I,J+1);
  courr(class1,class2)=courr(class1,class2)+1;
 end;
end;

% Normalisation

courr=courr/(ksize*(ksize-1));

