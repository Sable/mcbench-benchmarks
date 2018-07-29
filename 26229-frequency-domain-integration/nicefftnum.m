function nfft = nicefftnum(n)
% Find a highly composite even number >= n
%
%  C. Wilson 10 October 1999 

testvalues =[1,3,5,9,15,25,27];
nt=2.^max(1,ceil(log2(n./testvalues))).*testvalues;
nfft=min(nt);
return