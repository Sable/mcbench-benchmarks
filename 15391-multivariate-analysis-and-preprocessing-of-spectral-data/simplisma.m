function [purspec,purint,purity_spec]=simplisma(data,varlist,offset,n,data2);
% function [purspec,purint,purity_spec]=simplisma(data,varlist,offset,n,data2);
%
% It is a short non interactive version of SIMPLISMA taken from Windig's
% article Chemometrics and Intelligent Laboratory Systems, 36, 1997, 3-16. 
%
%   INPUT:
%   data contains the data matrix (spectra in rows)
%   data 2 can be ignored or empty.
%       For second derivative applications data contains the conventional 
%       data and data2 contains the inverted 2nd data.
%       to create data2 use function:
%       data2=invder(data);
%   Varlist contains the variable identifiers 
%   Offset is a correction factor for low intensity variables (1- no
%   offset, 15 - large offset)
%   n is a number of components
% 
%   OUTPUT:
%       purespec contains the pure spectra
%       purint contains the intensities ('concentrations') of the pure
%       spectra in the mixtures
%       purity_spec - spectra containing purity spectra
%
% The programm will plot the purity and standard deviation spectra, where
% the pure variables selected will be marked by a '*'. After each plot,
% any key needs to be pressed to continue.

%INITIALIZE;
if nargin==5;
   temp=data;data=data2;data2=temp;clear temp
end
[nspec,nvar]=size(data); purvarindex=[];
if nargin==4;
   data2=[];
end;

%CACULATE STATISTICS

stddata=std(data)*sqrt(nspec-1)/sqrt(nspec);
meandata=mean(data);
meandataoffset=meandata+((offset/100)*max(meandata));
lengthdata=sqrt((stddata.*stddata+meandataoffset.*meandataoffset)*...
   sqrt(nspec));
lengthmatrix=lengthdata(ones(1,nspec),:);
datalengthscaled=data./lengthmatrix;
puredata=stddata./meandataoffset;

%DETERMINE PURE VARIABLES
purity_spec=0*[1:nvar];
max_index=0;
for i=1:n+1;
   purvar=datalengthscaled(:,purvarindex);
   for j=1:nvar;
      addcolumn=datalengthscaled(:,j);
      purvartest=[purvar addcolumn];
      matrix=purvartest'*purvartest;
      weight(j)=det(matrix);
   end;
   purityspec=weight.*puredata;
	purity_spec=[purity_spec; purityspec];
   maxindex=find(purityspec==max(purityspec));
   maxindex=maxindex(1);
  figure(2)
  subplot(3,2,1); plot(varlist,purityspec,'g',varlist(maxindex),...
     purityspec(maxindex),'g*');
   max_index=[max_index, maxindex];
  axis([sort([varlist(1) varlist(length(varlist))]) 0 1.1*max(purityspec)]);
  if varlist(1)>varlist(2);
     set(gca,'Xdir','reverse');
  end;
  title(['purity spectrum # ', num2str(i)]);
   stdspec=weight.*stddata;
  subplot(3,2,2);plot(varlist,  stdspec,'g',varlist(maxindex),...
     stdspec(maxindex),'g*');
  axis([sort([varlist(1) varlist(length(varlist))]) 0 1.1*max(stdspec)]) ;
  if varlist(1)>varlist(2);
     set(gca,'Xdir','reverse');
  end;
title(['standard deviation spectrum # ', num2str(i)]);
   
  pause
   
   purvarindex=[purvarindex maxindex];
end
close(2)
purvarindex(n+1)=[];

%RESOLVE SPECTRA

purematrix=(data(:,purvarindex));
if isempty(data2)
   purspec=purematrix\data;
else;
   purspec=purematrix\data2;
end;

%RESOLVE INTENSITIES

if isempty(data2);
   purint=data/purspec;
else;
   purint=data2/purspec;
end;

%SCALE

if isempty(data2);
   tsi=sum(data')';
else;
   tsi=sum(data2')';
end;
a=purint\tsi;
purint=purint*diag(a);
purspec=inv(diag(a))*purspec;
H2.Position=[264 188 339 423];
figure(H2)
subplot(2,1,1),plot(varlist,purspec), set(gca,'Xdir','reverse')
title ('pure spectra')
subplot(2,1,2), plot(purint), title ('pure intensity')
H3.Position=[616 190 339 423];
figure(H3)
for i=1:n+1;
   subplot(n+1,1,i), plot(abs(varlist),purity_spec(i+1,:))
   hold on, plot(abs(varlist(max_index(i+1))),purity_spec(max_index(i+1)),'g*');
   set(gca,'Xdir','reverse')
   hold off
end
