function out = trapezoidal_rule_double_integral(x, y, mat)
%  
% Calculates a double integral using the trapezoidal rule.
% 
%
% By: Mohammed S. Al-Rawi
% IEETA, University of Aveiro
% Portugal
% March, 4, 2013 
%
% Please send feedback if you have any issue with this function to
%  rawi707@yahoo.com
%
% -- mat is a 2D matrix that contains the function values, e.g. f(x,y),
% size of f is [M N]
% -- x and --y are the vectors to be used with the function to generate mat
% size of x is M, and size of y is N
%
%
% see the examples below for more illustration
%
% Example:

%  double_integral(e^(y-x)) x=0 to .5, y= 0 to .5
% % 
%  x=0:.01:.5; 
%  y=0:.02:.5;
%  [xx,yy] = meshgrid(x,y);
%  z=yy-xx;
%  mat = exp(z)'; % the transpose is needed since meshgrid returns the
%  values transposed
%  out = trapezoidal_rule_double_integral(x, y, mat)
% 
% %  out =
% 
%     0.255262565920498

%   Comparing to the function quad2d:
%  fun = @(x,y) exp(y-x); Q = quad2d(fun, 0,.5,0,.5)
% 
% Q =
% 
%    0.255251930412767
% 
%
% here is another more complex Example 
% fun = @(x,y) exp(sin(y)-x.^2); Q = quad2d(fun, 0,.5,0,.5)
% 
% Q =
% 
%    0.297471075439585
% 
% x=sort(rand(100,1)/2); %non-uniform sampling
% y=0:.01:.5;
% [xx,yy] = meshgrid(x,y);
%  z=yy-xx;
% mat= exp(sin(yy)-xx.^2)';
% out = trapezoidal_rule_double_integral(x, y, mat)
% 
% out =
% 
%    0.292243052795743
%
%
%
% But, why would one wanna use this function, having the accurate quad2d?  
% The reason is that quad2d only works with functions, with an upper and a  
%  lower limit while this function accepts as input the vectors x and y. 
% BTW, x and/or y could be non-uniformly spaced. So, this function could be 
% used to implement fast integration in some applications where the
% computation of f is extremely expensive. Of course the accuracy is  much
% lower than that of quad2d, but as I said, you may find it useful in some
% situations that require high speed, and you already have the vectors
%  x, y, and mat. As a better example, consider integrating empirical data.
%  To apply quad2d for empirical data, you will have to write a function
%  that interpoltes from mat(x,y) and pass it to quad2d, but, for
%  trpz...2d, this is not needed.

% N=length(y);
% tmp=zeros(N,1);
% for i=1:N
%     tmp(i)= trapz(x,mat(:,i));
% end
% out =trapz(y,tmp);
% 

% simple, ain't it? Enjoy khafla.


% Well, there is a simpler statement that uses only one line, suggested by 
% Richard Crozier http://www.mathworks.com/matlabcentral/fileexchange/authors/34660
% 
 out = trapz(y,trapz(x,mat,1),2);
 
 % Now it is even simpler thanks to Richard :)



