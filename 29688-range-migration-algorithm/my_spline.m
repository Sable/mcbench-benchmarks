function [ yy ] = my_spline( X,Y,xx )
%MY_SPLINE does spline of Y to interolate @ xx. X is
%original data position
%   Detailed explanation goes here

xx_row = size(xx,1);

if xx_row == 1, %xx is transposed vector
    xx=xx.';X=X.';Y=Y.';
end

Y_col=size(Y,2); %number of columns
yy=zeros(length(xx),Y_col);

for i=1:Y_col
    yy(:,i)=spline( X(:,i),Y(:,i),xx );
end

if xx_row == 1, %xx is transposed vector
    yy=yy.';
end

end

