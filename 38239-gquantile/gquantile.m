function y = gquantile(x,p)
%GQUANTILE Quantiles of a grouped sample.
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
%  Here, we developed a m-code to calculate the quantile(s) of a grouped
%  data. One can input the returns or modified vectors n and xout 
%  containing the frequency counts and the bin locations of the hist 
%  m-function, in a column form matrix.
%
%  Quantile calculation uses the straight forward formula,
%
%                  R = L + I*(N*Q - C)/F
%
%  where:
%  L = lower limit of the interval containing the quantile 
%  I = width of the interval containing the quantile 
%  N = total number of data 
%  Q = interested quantile
%  C = cumulative frequency corresponding to the previous quantile class 
%  F = number of cases in the interval containing the quantile
%  
%  --In orden to run it you must first download the m-file gprctile at:
%  http://www.mathworks.com/matlabcentral/fileexchange/38228-gprctile
%
%  Syntax: function y = gquantile(x,p) 
%      
%  Inputs:
%       x - data matrix (Size of matrix must be n-by-2; absolut frequency=
%           column 1, class mark=column 2) 
%       p - scalar or a vector of cumulative probability values
%  Outputs:
%       y  - quantile(s) of the values in x
%
%  Example: From the example given at
%  http://www.emathzone.com/tutorials/basic-statistics/frequency-distributi
%  on-of-discrete-data.html
%  We are interested to get the quantile values 0.25 and 0.75.
%
%  Data: 2,4,6,1,3,5,3,7,8,6,4,7,4,4,2,1,3,6,4,2,5,7,9,1,2,10,1,8,9,2,3,1,
%  2,3,4,4,4,6,6,5,5,4,5,8,5,4,3,3,2,5,0,5,9,9,8,10,0,4,10,10,1,1,2,2,1,8,
%  6,9,10
%
%  Using [A,B] = histo(x,11)
%
%  x = [B' A']; p = [0.25,0.75];
%
%                     ----------------
%                        MC       F
%                     ----------------
%                      0.4545     2
%                      1.3636     8
%                      2.2727     9
%                      3.1818     7
%                      4.0909    11
%                      5.0000     8
%                      5.9091     6
%                      6.8182     3
%                      7.7273     5
%                      8.6364     5
%                      9.5455     5
%                     ----------------
%
%  Calling on Matlab the function: 
%          y = gquantile(x,p)
%
%  Answer is:
%
%  y = 2.5505    6.5909
%
%  Created by A. Trujillo-Ortiz, R. Hernandez-Walls and
%             A.K. Hernandez-Garcia
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.edu.mx
%
%  Copyright (C)  September 15, 2012.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A., R. Hernandez-Walls and A.K. Hernandez-Garcia. (2012). 
%     gquantile:Quantile(s) of a grouped sample. [WWW document].
%     URL http://www.mathworks.com/matlabcentral/fileexchange/
%     38239-gquantile
%
%  Reference:
%  Cann, A. J. (2003), Maths from Scratch for Biologists. John Willey &
%              Sons Ltd. Chichester:England.
%

c = size(x,2);

if c ~= 2
    error('stats:gquantile:BadData','X must have two colums.');
end

if ~isvector(p) || numel(p) == 0
    error('stats:gquantile:BadProbs', ...
          'P must be a scalar or a non-empty vector.');
elseif any(p < 0 | p > 1) || ~isreal(p)
    error('stats:gquantile:BadPercents', ...
          'P must take real values between 0.0 and 1.0');
end

y = gprctile(x,100.*p);

return,
