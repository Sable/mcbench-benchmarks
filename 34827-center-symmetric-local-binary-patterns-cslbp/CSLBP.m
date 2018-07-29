function h = CSLBP(I)
%% this function takes patch or image as input and return Histogram of
%% CSLBP operator. 
h=zeros(16,1);
[y x]=size(I);
T = 0.1; % threshold given by authors in their paper
for i=2:y-1
    for j=2:x-1
        % keeping I(j,i) as center we compute CSLBP
        % N0 - N4
        a = ((I(i,j+1) - I(i, j-1) > T ) * 2^0 );        
        b = ((I(i+1,j+1) - I(i-1, j-1) > T ) * 2^1 );
        c = ((I(i+1,j) - I(i-1, j) > T ) * 2^2 );
        d = ((I(i+1,j-1) - I(i - 1, j + 1) > T ) * 2^3 );
        
        e=a+b+c+d;
        h(e+1) = h(e+1) + 1;
    end
    
end
