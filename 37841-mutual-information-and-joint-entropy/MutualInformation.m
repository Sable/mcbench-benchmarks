function Mutual_Information=MutualInformation(x,y)

% Compute Mutual Information and Joint entropy of two images
% Takes two images and returns the mutual information and  joint 
% entropy. For implementing this function also download function
% joint_histogram.m in my file exchange.
% 
% written by Amir Pasha Mahmoudzadeh
% Wright State University
% Biomedical Imaging Lab

h=joint_histogram(x,y); % Joint histogram for 2D
[m,n] = size(h);
J= h./(m*n); % normalized joint histogram
y_summ=sum(J); %sum of the rows of normalized joint histogram
x_summ=sum(J);%sum of columns of normalized joint histogran

sy=0;
for s=1:n;    %  column 
      if( y_summ(s)==0 )
       
      else
         sy = sy + -(y_summ(s)*(log2(y_summ(s)))); %marginal entropy for image 1
      end
   end
   
sx=0;
for s=1:m;    %rows
   if( x_summ(s)==0 )
     
      else
         sx = sx + -(x_summ(s)*(log2(x_summ(s)))); %marginal entropy for image 2
      end   
   end
joint_entropy = -sum(sum(J.*(log2(J+(J==0))))) % joint entropy
Mutual_Information = sx + sy - joint_entropy; % Mutual information
end
