function y = gskewness(x,n)
%GSKEWNESS Skewness of a grouped sample.
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
%  Here, we developed a m-code to calculate the skewness of a grouped data.
%  One can input the returns or modified vectors n and xout containing the
%  frequency counts and the bin locations of the hist m-function, in a 
%  column form matrix.
%  GSKEWNESS(X,0) adjusts the skewness for bias (correction by small sample
%  size). GSKEWNESS(X,1) is the same as GSKEWNESS(X), and does not adjust
%  for bias.
%  If skewness = 0, the data are perfectly symmetrical. But a skewness of 
%  exactly zero is quite unlikely for real-world data. Here, we use the 
%  Bulmers' rule of thumb criterium (1979), about how we can to
%  interpret the skewness number:
%  - Less than ?1 or greater than +1, the distribution is highly skewed
%  - Between ?1 and ?0.5 or between +0.5 and +1, the distribution is 
%    moderately skewed
%  - Between ?0.5 and +0.5, the distribution is approximately symmetric
%
%  Skewness calculation uses the formula,
%                    
%           g1 =  m3/m2^1.5, do not adjusted for bias
%
%           G1 = SQRT(N*(N - 1))/(N - 2) * g1, adjusted for bias
%
%  where:
%  m2 = second moment of the sample about its mean
%  m3 = third moment of the sample about its mean
%  N  = sample size
%  
%  Syntax: function y = gskewness(x,n) 
%      
%  Inputs:
%       x - data matrix (Size of matrix must be n-by-2; absolut frequency=
%           column 1, class mark=column 2) 
%       n - adjusted for bias = 0 (default), do not adjust for bias = 1 
%  Outputs:
%       y  - skewness of the values in x
%
%  Example: Suppose we have the next frequency table:
%
%                     ----------------
%                       MC         F
%                     ----------------
%                       61         5
%                       64        18
%                       67        42
%                       70        27
%                       73         8 
%                     ----------------
%
%  Taken from: http://www.tc3.edu/instruct/sbrown/stat/shape.htm
%
%  Where we are interested to get the skewness value adjusted for bias.
%
%  Data input:
%  x=[61 5;64 18;67 42;70 27;73 8];
%
%  Calling on Matlab the function: 
%          y = gskewness(x,0)
%
%  Answer is:
%
%  y = -0.1098
%
%  Created by A. Trujillo-Ortiz, R. Hernandez-Walls and 
%             C.M. Espinosa-Lagunes
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.edu.mx
%
%  Copyright (C)  September 24, 2012.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A., R. Hernandez-Walls and C.M. Espinosa-Lagunes. (2012). 
%     gskewness:Skewness of a grouped sample. [WWW document].
%     URL http://www.mathworks.com/matlabcentral/fileexchange/
%     38319-gskewness
%
%  References: 
%  Bulmer, M. G. (1979), Principles of Statistics. NY:Dover Books on
%             Mathematics.  
%  Jayaraman, K. (1999), A Statistical Manual for Foresty Research. Foresty
%             Research Support Programme for Asia and the Pacific. FAO-
%             Corporate Document Repository. Forestry Statistics and Data
%             Collection. 
%             URL http://www.fao.org/DOCREP/003/X6831E/X6831E00.HTM
%             PDF ftp://ftp.fao.org/docrep/fao/003/X6831E/X6831E00.pdf 
%

if  nargin < 2,
    n = 1; %default
end

c = size(x,2);

if c ~= 2
    error('stats:gskewness:BadData','X must have two colums.');
end

mc = x(:,1); %class mark
f = x(:,2); %absolut frequency
s = sum(f.*mc);
m1 = s/sum(f);
m2 = sum(f.*(mc - m1).^2)/sum(f);
m3 = sum(f.*(mc - m1).^3)/sum(f);
g1 = m3/m2^1.5;

if n == 0;
    y = sqrt(sum(f)*(sum(f) - 1))/(sum(f) - 2) * g1; %skewness adjusted for
                                                     %bias
else n = 1; %default
    y = g1; %skewness not adjusted for bias
end

return,

