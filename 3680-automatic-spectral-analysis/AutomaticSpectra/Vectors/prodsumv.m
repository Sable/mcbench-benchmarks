function sv = prodsumv(a,b);
%function sv = prodsumv(a,b);
%
%performs the following summation:
%A(1)*B(1)+A(2)*B(2)+..
%
% Notation as in filterv
%
% Used in FILTERV, CONVV and TIMESV.

%Stijn variant
%len = kingsize(b,3);
%sv = 0;
%for i = 1:len,
%	sv = sv+a(:,:,i)*b(:,:,i);
%end	%for ar = 1:a_len-1,

%Mischa variant
c=zeros(size(a,1),size(b,2),size(a,3));
for tel=1:size(a,1)
    a2=repmat(reshape(a(tel,:,:),[size(a,2) 1 size(a,3)]),[1 size(b,2) 1]);
    c(tel,:,:)=sum(a2.*b,1);
end
sv = sum(c,3);