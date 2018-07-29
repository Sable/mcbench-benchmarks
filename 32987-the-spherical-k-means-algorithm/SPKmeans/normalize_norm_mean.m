%The spherical K-means algorithm
%(C) 2007-2011 Nguyen Xuan Vinh  
%Contact: vinh.nguyenx at gmail.com   or vinh.nguyen at monash.edu
%Reference: 
%   [1] Xuan Vinh Nguyen: Gene Clustering on the Unit Hypersphere with the 
%       Spherical K-Means Algorithm: Coping with Extremely Large Number of Local Optima. BIOCOMP 2008: 226-233
%Usage: Normalize the data set to have mean zero and unit norm

function b=normalize_norm_mean(a)
[n dim]=size(a);
for i=1:n
    a(i,:)=(a(i,:)-mean(a(i,:)))/norm(a(i,:)-mean(a(i,:)),2);
end
b=a;