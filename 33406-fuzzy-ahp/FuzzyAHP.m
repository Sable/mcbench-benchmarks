function [ weights CompMat fuzzyTFN ] = FuzzyAHP( CompMat )
%FUZZYAHP Fuzzy AHP
%   Fuzzy AHP selection algorithm
%
% AUTHOR:
%           F. Ozgur CATAK
% CREATED:
%           October, 2011

% fuzzy tfn and inverse fuzzy tfn constants
fuzzyTFN = {[1     1     1  ] 	[1      1    1  ]
            [1/2   3/4   1  ] 	[1      4/3  2  ]
            [2/3   1     3/2] 	[2/3    1    3/2]
            [1     3/2   2  ] 	[1/2    2/3  1  ]
            [3/2   2     5/2] 	[2/5    1/2  2/3]
            [2     5/2   3  ] 	[1/3    2/5  1/2]
            [5/2   3     7/2] 	[2/7    1/3  2/5]
            [3     7/2   4  ] 	[1/4    2/7  1/3]
            [7/2   4     9/2] 	[2/9    1/4  2/7]};

fuzzyCompMatCell={};

%%
% convert ordinal numbers to
% triangular fuzzy number using fuzzyTFN matrix
[m n] = size(CompMat);

for i=1:m
    for j=i+1:m
       CompMat(j,i) = 1 / CompMat(i,j); 
    end
end

for i=1:m
    for j=1:n
        criteria = CompMat(i,j);
        if criteria >= 1
           fuzzyCompMatCell{i,j} = fuzzyTFN{ criteria ,1 };
        else
           fuzzyCompMatCell{i,j} = fuzzyTFN{ round(criteria^-1) ,2 };
        end
    end
end

%%
% find sum of every l,m,u values for triangular fuzzy number
for i=1:m
    vec = [fuzzyCompMatCell{i,:}];
    mExtendAnalysis{1,i} = sum(reshape(vec,3,[])');
end

vec = [mExtendAnalysis{1,:}];
mExtendAnalysisSum = sum(reshape(vec,3,[])');

for i=1:m
    vec = [mExtendAnalysis{1,i}];
    for j=1:3
        val = mExtendAnalysisSum(1,j);
        %valSum(1,j) = val*vec(1,j);
        valSum(1,j) = (vec(1,j))*(1/val);
    end
    mExtendAnalysis{1,i} = valSum;
end

%%
% degree of possibility calculation
%              /---
%              | 1    if m2>=m1
%              |
%              | 0    if l1>=l2
% V(M2>=M1) = <
%              |     l1-u2
%              | --------------- otherwise
%              | (m1-u2)-(m1-l1)
%              \---
degreeOfPossibility = zeros(m*(m-1),3);
rowIndex = 1;
for i=1:m
    for j=1:m
        if i~=j
            degreeOfPossibility(rowIndex,[1 2]) = [i j];
            M1 = mExtendAnalysis{1,i};
            M2 = mExtendAnalysis{1,j};
            if M1(1,2) >= M2(1,2)
                degreeOfPossibility(rowIndex,3) = 1;
            elseif M2(1,1) >= M1(1,3)
                degreeOfPossibility(rowIndex,3) = 0;
            else
                degreeOfPossibility(rowIndex,3) = (M2(1,1)-M1(1,3))/((M1(1,2)-M1(1,3))-(M2(1,2)-M2(1,1)));
            end
            rowIndex = rowIndex + 1;
        end
    end
end
%%
% normalized weight calculation
weights = zeros(1,m);
for i=1:m,
    weights(1,i) = min(degreeOfPossibility([find(degreeOfPossibility(:,1) == i)], [3]));
end
weights = weights/sum(weights);

end