function h=sgsf_2d(x,y,px,py,flag_coupling)
%Function:
%       2-D Savitzky-Golay smoothing filter (i.e., the polynomial smoothing
%       filter, or the least-squares smoothing filter)
%       See Ref. [1] for details on the 1-D Savitzky-Golay smoothing filter. 
%       One can also refer to the following URL where a program of
%       1-D Savitzky-Golay smoothing (and differentiation) filter is given:
%       http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=4038&objectType=file
%       See Ref. [2] and [3] for details on the 2-D Savitzky-Golay smoothing filter. 
%Usage:
%       h=sgsf_2d(x,y,px,py,flag_coupling)
%       x    = x data point, e.g., -3:3
%       y    = y data point, e.g., -2:2 
%       px    =x polynomial order       default=1              
%       py    =y polynomial order       default=1
%       flag_coupling  = with or without the consideration of the coupling terms, between x and y. default=0
%Example:
%       sgsf_2d(-3:3,-3:3,2,2)
%       sgsf_2d(-3:3,-3:3,2,2,1)      
%Author:
%       Jianwen Luo <luojw@bme.tsinghua.edu.cn, luojw@ieee.org> 2003-12-15
%       Department of Biomedical Engineering, Department of Electrical Engineering
%       Tsinghua University, Beijing 100084, P. R. China  
%Reference
%[1]A. Savitzky and M. J. E. Golay, "Smoothing and Differentiation of Data by Simplified Least Squares Procedures," 
%   Analytical Chemistry, vol. 36, pp. 1627-1639, 1964.
%[2]K. L. Ratzlaff and J. T. Johnson, "Computation of Two-Dimensional Polynomial Least-Squares Convolution Smoothing Integers," 
%   Analytical Chemistry, vol. 61, pp. 1303-1305, 1989.
%[3]J. E. Kuo, H. Wang, and S. Pickup, "Multidimensional Least-Squares Smoothing Using Orthogonal Polynomials," 
%   Analytical Chemistry, vol. 63, pp. 630-635, 1991.

if nargin<5
    flag_coupling=0;
end

if nargin<4
    py=1;
end

if nargin<3
    px=1;
end


[x,y]=meshgrid(x,y);
[ly,lx]=size(x);

x=x(:);
y=y(:);

A=[];

if flag_coupling
    for kx=px:-1:0
        for ky=py:-1:0
            A=[A x.^kx.*y.^ky];
        end
    end     
else
    for k=px:-1:1
        A=[A x.^k];
    end
    for k=py:-1:0
        A=[A y.^k];
    end  
end

h=inv(A'*A)*A';
h=h(size(h,1),:);
h=reshape(h,ly,lx);

