function h=joint_histogram(x,y)
%
% Takes a pair of images of equal size and returns the 2d joint histogram.
% used for MI calculation
% 
% written by Amir Pasha Mahmoudzadeh
% Wright State University
% Biomedical Imaging Lab



rows=size(x,1);
cols=size(y,2);
N=256;

h=zeros(N,N);

for i=1:rows;   
  for j=1:cols;   
    h(x(i,j)+1,y(i,j)+1)= h(x(i,j)+1,y(i,j)+1)+1;
  end
end

imshow(h)

end


