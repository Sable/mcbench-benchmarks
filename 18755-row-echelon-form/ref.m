function m = ref(a)
% Script for Row-Echelon Form
% ----written by----------------------------
% Muhammad Rafiullah Arain
% Department of Mathematics
% COMSATS Institute of Information technology - Lahore
% Pakistan.
% ------------------------------------------
% ref(a) defination and use
% ------------------------------------------
% a is nxn matrix
% Example
% >> a=[1 2 3 5; 2 4 5 6; 7 3 7 2; 2 4 1 8]
% >> ref(a)
% result show a row-echelon-form

if length(a(1,:)) ~= length(a(:,1))
    error('Matrix is not square nxn or wrong number of input arguments')
end
n=length(a(1,:));
j=1;
    for i = 1:n-1 
           if (i==j)
                if (a(i,j)==0) 
                    c = a(i,:); a(i,:)= a(i+1,:); a(i+1,:) = c;
                end
                a(i,:)= (1/a(i,j))* a(i,:);
                for k=i+1:n
                    a(k,:)=(-a(k,j)* a(i,:)) + a(k,:);
                end
           end
        j=j+1;        
    end
 a(n,:)= (1/a(n,n))* a(n,:);
 m=a;
end