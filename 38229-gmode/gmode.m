function y = gmode(x)
%GMODE Mode(s) of a grouped sample.
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
%  Here, we developed a m-code to calculate the mode(s) of a grouped data.
%  One can input the returns or modified vectors n and xout containing the
%  frequency counts and the bin locations of the hist m-function, in a 
%  column form matrix.
%
%  Mode calculation uses the straight forward formula,
%
%              Mo = L + I*((F1 - F0)/(2*F1 - F0 - F2))
%
%  where:
%  L = lower limit of modal class
%  I = width of the interval containing the mode
%  F0 = frequency of class preceding the modal class
%  F1 = frequency of modal class
%  F2 = frequency of class succeeding the modal class
%  
%  Syntax: function y = gmode(x) 
%      
%  Inputs:
%       x - data matrix (Size of matrix must be n-by-2; absolut frequency=
%           column 1, class mark=column 2) 
%  Outputs:
%       y  - mode(s) of the values in x
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
%  Where we are interested to get the mode value(s).
%
%  Data input:
%  x = [2.8 3;4.1 5;5.4 6;6.7 9;8.0 6;9.3 9;10.6 4;11.9 2];
%
%  Calling on Matlab the function: 
%          y = gmode(x)
%
%  Answer is:
%
%  y = 6.7000    9.1375
%
%  Created by A. Trujillo-Ortiz, R. Hernandez-Walls and C. Simon-Lizcano
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.edu.mx
%
%  Copyright (C)  September 13, 2012.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A., R. Hernandez-Walls and C. Simon-Lizcano. (2012). 
%     gmode:Mode(s) of a grouped sample. [WWW document].
%     URL http://www.mathworks.com/matlabcentral/fileexchange/
%     38229-gmode
%
%  Reference:
%  Jayaraman, K. (1999), A Statistical Manual for Foresty Research. Foresty
%             Research Support Programme for Asia and the Pacific. FAO-
%             Corporate Document Repository. Forestry Statistics and Data
%             Collection. 
%             URL http://www.fao.org/DOCREP/003/X6831E/X6831E00.HTM
%             PDF ftp://ftp.fao.org/docrep/fao/003/X6831E/X6831E00.pdf 
%

c = size(x,2);

if c ~= 2
    error('stats:gmode:BadData','X must have two colums.');
end

mc = x(:,1); %class mark
f = x(:,2); %absolut frequency
fm = max(f); %frequency of modal class(es) 
cl = find(f == fm); %identifying modal class(es)

y = [];
for i = 1:length(cl)
    cl1(i) = cl(i) - 1;
    cl2(i) = cl(i) + 1;
    f1(i) = f(cl1(i)); %frequency of class preceding the modal class
    f2(i) = f(cl2(i)); %frequency of class succeeding the modal class
    a = mc(2) - mc(1); %class interval
    l(i) = mc(cl(i)); 
    L(i) = l(i) - 0.5*a; %lower limit of modal class
    A(i) = fm - f1(i);
    if f1(i) == 0;
        B(i) = 2*fm - f2(i);
    else
        B(i) = 2*fm - f1(i) - f2(i);
    end
    yy = L(i) + A(i)/B(i)*a; %calculation by a linear interpolation
    y = [y yy];
end

if length(y) > 1
    disp('There is more than one mode.')
end

return,