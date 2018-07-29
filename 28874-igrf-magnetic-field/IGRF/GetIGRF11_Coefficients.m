function [gh,date]=GetIGRF11_Coefficients(varargin)
%Get IGRF11 Coefficients from Excel file
OutputMATfile=[];
if ~isempty(varargin)
    OutputMATfile=varargin{1};
end

ff='igrf11coeffs.xls';
if exist(ff,'file')~=2
    ff=pickfile('*.xls','Get igrf11 coefficients');
end
num = xlsread(ff);
num=num';   
dd=num(3:end,1); 
ndate=length(dd);
date=cell(1,ndate);
for n=1:ndate-1
    date{n}=num2str(dd(n));
end
date{ndate}='2010-15';

num=num(3:end,2:end);
gh = NaN(1,3255);
for n=1:19
    n1=(n-1)*120+1; n2=n*120;
    gh(n1:n2)=num(n,1:120);
end
for n=20:24
    n11=n2+(n-20)*195+1; n22=n2+(n-19)*195;
    gh(n11:n22)=num(n,1:195);
end
if ~isempty(OutputMATfile)
    save GHcoefficients gh
end
return