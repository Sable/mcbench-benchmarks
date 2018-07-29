function [Ac] = cofactors(A)
% This function computes the co-factors of an n x n matrix
% [C]=COFACTORS(A) produces the cofactors C, of the n x n
% matrix A

% PROGRAMMER:   Gordon Nana Kwesi Amoako
%               kwesiamoako@gmail.com
% DATE: Sept 09, 2010                

% INPUT:  A - n x n matrix
% OUTPUT: Ac -n x n matrix of minors

[r,c]=size(A);
Ac=zeros(r,c);

for i=1:r
    temp=A;
    for j=1:c
        
        % Obtaining Minors of the corresponding entry
        temp(i,:)=[];
        temp(:,j)=[];
        
        % computing the determinant for the entries
        Ac(i,j)=(-1)^(i+j)*det(temp);
        temp=A;
    end
end
