function y = gmean(x)
%GMEAN Mean of a grouped sample.
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
%  Here, we developed a m-code to calculate the mean of a grouped data.
%  One can input the returns or modified vectors n and xout containing the
%  frequency counts and the bin locations of the hist m-function, in a 
%  column form matrix.
%
%  Mean calculation uses the formula,
%
%                      
%                      M =  Sum(F*MC)/N 
%
%  where:
%  F  = class frequency
%  MC = class mark
%  N  = sample size [=sum(F)]
%  
%  Syntax: function y = gmean(x) 
%      
%  Inputs:
%       x - data matrix (Size of matrix must be n-by-2; absolut frequency=
%           column 1, class mark=column 2) 
%  Outputs:
%       y  - mean of the values in x
%
%  Example: Suppose we have the next frequency table:
%
%                     ----------------
%                       MC         F
%                     ----------------
%                       2.8        3
%                       4.1        5
%                       5.4        6
%                       6.7        9
%                       8.0        6
%                       9.3        9
%                      10.6        4
%                      11.9        2
%                     ----------------
%
%  Where we are interested to get the mean value.
%
%  Data input:
%  x = [2.8 3;4.1 5;5.4 6;6.7 9;8.0 6;9.3 9;10.6 4;11.9 2];
%
%  Calling on Matlab the function: 
%          y = gmean(x)
%
%  Answer is:
%
%  y = 7.2614
%
%  Created by A. Trujillo-Ortiz, R. Hernandez-Walls and E.L. Cuevas-Luna
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.edu.mx
%
%  Copyright (C)  September 18, 2012.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A., R. Hernandez-Walls and E.L. Cuevas-Luna. (2012). 
%     gmean:Mean of a grouped sample. [WWW document].
%     URL http://www.mathworks.com/matlabcentral/fileexchange/
%     38280-gmean
%
%  Referrences:
%  Cann, A. J. (2003), Maths from Scratch for Biologists. John Willey &
%             Sons Ltd. Chichester:England.
%  Jayaraman, K. (1999), A Statistical Manual for Foresty Research. Foresty
%             Research Support Programme for Asia and the Pacific. FAO-
%             Corporate Document Repository. Forestry Statistics and Data
%             Collection. 
%             URL http://www.fao.org/DOCREP/003/X6831E/X6831E00.HTM
%             PDF ftp://ftp.fao.org/docrep/fao/003/X6831E/X6831E00.pdf 
%

c = size(x,2);

if c ~= 2
    error('stats:gmean:BadData','X must have two colums.');
end

mc = x(:,1); %class mark
f = x(:,2); %absolut frequency
s = sum(f.*mc);
n = sum(f);
y = s/n;

return,

