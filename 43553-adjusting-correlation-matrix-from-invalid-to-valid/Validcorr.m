function [R_new,p,B]=Validcorr(R_org,adj)
%   ValidCorr is a function for adjusting the correlation matrix form.
%   invalid to valid. There are 2 input: R_org is the original correlation 
%   matrix and adj is the adjustment factor, which need to be higher than 
%   or equal to zero.
%   In this algorithm, the correlation efficient is adjusted back to its
%   boundaries sequentially.
%   Writen by Kawee Numpacharoen, Ph.D., CFA, FRM (as of Sep 27, 2013)

%   Reference: 
%   Pornputtapong, N., Atsawarungruangkit, A., and Numpacharoen, K.,
%   Adjusting an Invalid Correlation Matrix with Applications to 
%   High-Dimensional Biological Data (September 27, 2013). 
%   Available at SSRN: http://ssrn.com/abstract=


%   check the in put
[m,n]=size(R_org); %extract dimension
if m ~= n,error('Correlation matrix is not a square matrix!!'),end
if adj<0,error('Adjustment factor must not be negative!!'),end
if adj>0.5,error('Adjustment factor must be not be higher than 0.5!!'),end
p=min(eig(R_org)); %check eigenvalue
if p >= 0,error('Correlation matrix is already valid'),end

%   start timer (optional)
tic 

%	Define variables
C=tril(R_org,-1);
B=tril(ones(n),0);

%Step 1: create the first column of B Matrix
for i= 2:n
    if C(i,1)>=1,C(i,1)=1-adj*2;elseif C(i,1)<=-1,C(i,1)=-1+adj*2;end 
    B(i,2:i)=sqrt(1-C(i,1)^2);
end
B(2:n,1)=C(2:n,1);


%Step 2: calculate the rest of correlation coefficients
for i=3:n
    %i
    for j= 2:i-1        
        B1=B(j,1:j-1)*B(i,1:j-1)';
        B2=B(j,j)*B(i,j);
        Z=B1+B2;
        Y=B1-B2;
        if C(i,j)>=Z,C(i,j)=Z-adj*(Z-Y);
        elseif C(i,j)<=Y,C(i,j)=Y+adj*(Z-Y);end
        %[i, j, Z, C(i,j), Y];
        cosinv=(C(i,j)-B1)/B2;
        
        if isfinite(cosinv)==false 
            % Cases when cosinv = -Inf, Inf or NaN
            B(i,j+1:n)=0;
        elseif cosinv >1 
            B(i,j)=B(i,j);
            B(i,j+1:n)=0;
        elseif cosinv <-1
            B(i,j)=-B(i,j);
            B(i,j+1:n)=0;
        else
            B(i,j)=B(i,j)*cosinv;
            sinTheta=sqrt(1-cosinv^2);
            for k=j+1:n
                B(i,k)=B(i,k)*sinTheta;
            end
        end
    end
end

%Step 3: Calculate Output
R_new=C+C'+eye(n); % Adjusted Correlation Matrix
p=min(eig(R_new));% Eigenvalue of R
B;%Factorization of R
toc
end
