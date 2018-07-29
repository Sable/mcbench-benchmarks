%demo.m
%extract number only from any text file
% Using Alex's readtext file.
% P WANG verified on test1.txt nov 2007

%s=input('Enter file name=','s');%SR = INPUT('What is your name','s')
display('this prog extarcts number, numbers need to be separated from letter')

[data,results]= readtext('test1.txt', '[,\s\t]', '', '','numeric');
%[a,b]= readtext('test1.txt', 't', '#', '"', 'numeric')
isf=isfinite(data);  % This means not Inf, -Inf or NaN

data=data.';
isf=isf.';
datacol=data(:);
isfcol=isf(:);

colleng=length(isfcol);

L=0; 
for k=1:colleng,
    if isfcol(k)==1,
        L=L+1;
        datafinal(L)=datacol(k);
    end,
end,
datafinal.'
display('Deciphering completed')

