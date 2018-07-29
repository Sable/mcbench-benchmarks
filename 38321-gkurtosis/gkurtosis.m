function y = gkurtosis(x,n)
%GKURTOSIS Kurtosis of a grouped sample.
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
%  Here, we developed a m-code to calculate the kurtosis and excess of 
%  kurtosis of a grouped data.
%  One can input the returns or modified vectors n and xout containing the
%  frequency counts and the bin locations of the hist m-function, in a 
%  column form matrix.
%  GKURTOSIS(X,0) adjusts the kurtosis for bias (correction by small sample
%  size). GKURTOSIS(X,1) is the same as GKURTOSIS(X), and does not adjust
%  for bias.
%
%  Kurtosis calculation uses the formula,
%                    
%           g2 =  m4/m2^2, do not adjusted for bias
%           g2 = g2 - 3, excess kurtosis do not adjusted for bias
%
% G2 = ((N+1)*g2 - 3*(N-1))*(N-1)/((N-2)*(N-3)) + 3, adjusted for bias
% G2 = ((N+1)*g2 - 3*(N-1))*(N-1)/((N-2)*(N-3)), excess kurtosis adjusted 
%                                                for bias
%
%  where:
%  m2 = second moment of the sample about its mean
%  m4 = fourth moment of the sample about its mean
%  N  = sample size
%  
%  Syntax: function y = gkurtosis(x,n) 
%      
%  Inputs:
%       x - data matrix (Size of matrix must be n-by-2; absolut frequency=
%           column 1, class mark=column 2) 
%       n - adjusted for bias = 0 (default), do not adjust for bias = 1 
%  Outputs:
%       y  - kurtosis and excess of kurtosis values in x
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
%  Where we are interested to get the kurtosis value adjusted for bias.
%
%  Data input:
%  x=[61 5;64 18;67 42;70 27;73 8];
%
%  Calling on Matlab the function: 
%          y = gkurtosis(x,0)
%
%  Answer is:
%
%  y = -0.1098
%
%  Created by A. Trujillo-Ortiz, R. Hernandez-Walls and D. Bernot-Simon
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
%  Trujillo-Ortiz, A., R. Hernandez-Walls and D. Bernot-Simon. (2012). 
%     gkurtosis:Kurtosis of a grouped sample. [WWW document].
%     URL http://www.mathworks.com/matlabcentral/fileexchange/
%     38321-gkurtosis
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
    error('stats:gkurtosis:BadData','X must have two colums.');
end

mc = x(:,1); %class mark
f = x(:,2); %absolut frequency
s = sum(f.*mc);
m1 = s/sum(f);
m2 = sum(f.*(mc - m1).^2)/sum(f); %second moment of the sample about its 
                                  %mean
m4 = sum(f.*(mc - m1).^4)/sum(f); %fourth moment of the sample about its
                                  %mean
g21 = m4/m2^2; %kurtosis value
g22 = g21 - 3; %excess kurtosis value

if n == 0;
    G21 = ((sum(f)+1).*g21 - 3.*(sum(f)-1)).*(sum(f)-1)./((sum(f)-2).*...
        (sum(f)-3)) + 3;
    G22 = ((sum(f)+1).*g21 - 3.*(sum(f)-1)).*(sum(f)-1)./((sum(f)-2).*...
        (sum(f)-3)); %kurtosis and excess kurtosis adjusted for bias
    y = [G21 G22]; 
else n = 1; %default
    y = [g21 g22]; %kurtosis and excess kurtosis not adjusted for bias
end

return,

