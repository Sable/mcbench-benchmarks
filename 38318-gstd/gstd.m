function y = gstd(x,n)
%GSTD Standard deviation of a grouped sample.
%  In some scientific works, once the data have been gathered from a 
%  population of interest, it is often difficult to get a sense of what 
%  the data indicate when they are presented in an unorganized fashion. 
%  Assembling the raw data into a meaningful form, such as a frequency 
%  distribution, makes the data easier to understand and interpret. It is
%  in the context of frequency distributions that the importance of 
%  conveying in a succinct way numerical information contained in the data
%  is encountered.
%  So, grouped data is data that has been organized into groups known as
%  classes.  The raw dataset can be organized by constructing a table 
%  showing the frequency distribution of the variable (whose values are 
%  given in the raw dataset). Such a frequency table is often referred to
%  as grouped data.
%  Here, we developed a m-code to calculate the standard deviation of a 
%  grouped data.
%  One can input the returns or modified vectors n and xout containing the
%  frequency counts and the bin locations of the hist m-function, in a 
%  column form matrix.
%  Normalizes Y by (N-1), where N is the sample size.  This is an unbiased
%  estimator of the standard deviation of the population from which X is 
%  drawn.
%  Y = STD(X,1) normalizes by N and produces the square root of the second 
%  moment of the sample about its mean.  STD(X,0) is the same as STD(X).  
%
%  Variance calculation uses the formula,
%
%                      
%              S =  SQRT(Sum(F*(MC - M)^2)/D) 
%
%  where:
%  F  = class frequency
%  MC = mark class
%  M = grouped mean
%  D = N - 1 or N, whether normalizes by n-1 or by n
%  N = sample size [=sum(F)]
%  
%  --In orden to run it you must first download the m-file gvar at:
%  http://www.mathworks.com/matlabcentral/fileexchange/xxxxx-gvar
%
%  Syntax: function y = gstd(x,n) 
%      
%  Inputs:
%       x - data matrix (Size of matrix must be n-by-2; absolut frequency=
%           column 1, class mark=column 2) 
%       n - [normalized by n-1] = 0 (default), [normalized by n] = 1 
%  Outputs:
%       y  - standard deviation of the values in x
%
%  Example: Suppose we have the next frequency table:
%
%                     ----------------
%                       MC         F
%                     ----------------
%                        5         6
%                       15        16
%                       25        24
%                       35        25
%                       45        17
%                     ----------------
%
%  Taken from:
%  http://mlsc.lboro.ac.uk/resources/statistics/var_stand_deviat_group.pdf
%
%  Where we are interested to get the standard deviation value normalized 
%  by n.
%
%  Data input:
%  x=[5 6;15 16;25 24;35 25;45 17];
%
%  Calling on Matlab the function: 
%          y = gstd(x,1)
%
%  Answer is:
%
%  y = 11.7782
%
%  Created by A. Trujillo-Ortiz and R. Hernandez-Walls
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.edu.mx
%
%  Copyright (C)  September 20, 2012.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A., and R. Hernandez-Walls. (2012). 
%     gstd:Standard deviation of a grouped sample. [WWW document].
%     URL http://www.mathworks.com/matlabcentral/fileexchange/
%     38318-gstd
%
%  Reference:
%  Jayaraman, K. (1999), A Statistical Manual for Foresty Research. Foresty
%             Research Support Programme for Asia and the Pacific. FAO-
%             Corporate Document Repository. Forestry Statistics and Data
%             Collection. 
%             URL http://www.fao.org/DOCREP/003/X6831E/X6831E00.HTM
%             PDF ftp://ftp.fao.org/docrep/fao/003/X6831E/X6831E00.pdf 
%

if  nargin < 2,
    n = 0; %default
end

c = size(x,2);

if c ~= 2
    error('stats:gstd:BadData','X must have two colums.');
end

y = sqrt(gvar(x,n));

return,

