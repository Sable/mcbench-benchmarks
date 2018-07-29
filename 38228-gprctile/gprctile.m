function y = gprctile(x,p)
%GPRCTILE Percentile(s) of a grouped sample.
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
%  Here, we developed a m-code to calculate the percentile(s) of a grouped
%  data. One can input the returns or modified vectors n and xout 
%  containing the frequency counts and the bin locations of the hist 
%  m-function, in a column form matrix.
%
%  Percentile calculation uses the straight forward formula,
%
%                  P = L + I*(N*P/100 - C)/F
%
%  where:
%  L = lower limit of the interval containing the percentile 
%  I = width of the interval containing the percentile 
%  N = total number of data 
%  P = interested percentile
%  C = cumulative frequency corresponding to the previous percentile class 
%  F = number of cases in the interval containing the percentile
%  
%  Syntax: function y = gprctile(x,p) 
%      
%  Inputs:
%       x - data matrix (Size of matrix must be n-by-2; absolut frequency=
%           column 1, class mark=column 2) 
%       p - is a scalar or a vector of percent values
%  Outputs:
%       y  - percentile(s) of the values in x
%
%  Example: From the example given at
%  http://www.emathzone.com/tutorials/basic-statistics/frequency-distributi
%  on-of-discrete-data.html
%  We are interested to get the percentile values 15,30,60,80.
%
%  Data: 2,4,6,1,3,5,3,7,8,6,4,7,4,4,2,1,3,6,4,2,5,7,9,1,2,10,1,8,9,2,3,1,
%  2,3,4,4,4,6,6,5,5,4,5,8,5,4,3,3,2,5,0,5,9,9,8,10,0,4,10,10,1,1,2,2,1,8,
%  6,9,10
%
%  Using [A,B] = hist(x,11)
%
%  x = [B' A']; p = [15,30,60,80];
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
%          y = gprctile(x,p)
%
%  Answer is:
%
%  y = 1.8535    2.9481    5.0455    7.4909
%
%  Created by A. Trujillo-Ortiz, R. Hernandez-Walls and R. Preciado-Perez
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
%  Trujillo-Ortiz, A., R. Hernandez-Walls and R. Preciado-Perez. (2012). 
%     gprctile:Percentile(s) of a grouped sample. [WWW document].
%     URL http://www.mathworks.com/matlabcentral/fileexchange/
%     38228-gprctile
%
%  Reference:
%  Cann, A. J. (2003), Maths from Scratch for Biologists. John Willey &
%              Sons Ltd. Chichester:England.
%

c = size(x,2);

if c ~= 2
    error('stats:gprctile:BadData','X must have two colums.');
end

if ~isvector(p) || numel(p) == 0
    error('stats:gprctile:BadProbs', ...
          'P must be a scalar or a non-empty vector.');
elseif any(p < 0 | p > 100) || ~isreal(p)
    error('stats:gprctile:BadPercents', ...
          'P must take real values between 0 and 100');
end

mc = x(:,1); %class mark
f = x(:,2); %absolut frequency
a = mc(2) - mc(1); %class interval
fa = cumsum(f); %cumulative absolut frequency
n = fa(end); %sample size

y = [];
for i = 1:length(p)
    r(i) = n*p(i)/100; %interested ordened data (iod)
    cl(i) = min(find(fa > r(i))); %class where the iod are
    l(i) = mc(cl(i));
    L(i) = l(i) - 0.5*a; %lower class boundary
    A(i) =(a/f(cl(i)));
    if (cl(i) - 1) == 0;
        B(i) = r(i);
    else
        B(i) = (r(i) - fa(cl(i) - 1));
    end
    
    yy = L(i) + A(i)*B(i); %calculation by a linear interpolation
    y = [y yy];
end

return,
