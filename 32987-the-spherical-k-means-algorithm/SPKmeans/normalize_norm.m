%The spherical K-means algorithm
%(C) 2007-2011 Nguyen Xuan Vinh  
%Contact: vinh.nguyenx at gmail.com   or vinh.nguyen at monash.edu
%Reference: 
%   [1] Xuan Vinh Nguyen: Gene Clustering on the Unit Hypersphere with the 
%       Spherical K-Means Algorithm: Coping with Extremely Large Number of Local Optima. BIOCOMP 2008: 226-233
%Usage: Normalize the data set to have unit norm

function b=normalize_norm(a)
[n dim]=size(a);
for i=1:n
    a(i,:)=a(i,:)/norm(a(i,:));
end
b=a;