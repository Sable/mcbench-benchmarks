function [steep] = steep(B,V,C,s,o,d)
%Steepest ascent/descent is a simple and efficient optimization method based on
% statistical design of experiments.
%  In order to optimize a response with respect to a set of quantitative variables,
%  often by using sequential experimentation, we use polynomial models to approximate
%  the response surface. The process often begins by using a 2^p factorial design with
%  additional center points, then fitting a first-order model. If curvature is detected
%  (lack of fit to the first-order model), then we conclude that we are near the optimum
%  and add points to obtain a second-order design. If curvature is not detected, we are
%  far from the optimum and use the method of steepest ascent/descent to get points 
%  headed (hopefully) toward to optimum. As we recognize that we are near the optimum, 
%  we use a second-order design. 
%  If there is no lack-of-fit then the linear model seems to approximate the response 
%  surface in this region, which means we are far from an optimum. In this case we want
%  to obtain additional responses (design points) that go closer to the optimum. To do
%  this we use the method of steepest ascent/descent, which just means that future design
%  points should increase/decrease the levels of IV's (factors) in proportion to b's until
%  we are near the optimum response (maximum or minimum).
%  We know that to maximize/minimize a response, the movement of the design center must 
%  be in the direction of the directional derivatives of the response function, that is,
%  in the direction of
%
%            df/dx = df/dx_1, . . .,df/dx_p .
%
%  We then multiply by a constant A so that
%
%            Dx = A*df/dx,
%  where
%
%            A = R/sqrt(Sum(df/dx_i)^2) .
%
%  Thus,
%
%            Sum(Dx_i^2) = R^2 .
%
%  For a first order model,
%
%            df/dx_i = b_i .
%
%  So,
%
%            Dx_i = A*b_i    and     A = R/sqrt(Sum(b_i^2)) .
%
%  From this we see that the movement of x_i up the path of steepest ascent/descent 
%  is proportional to b_i. Since this is the case it is easier not to pick particular 
%  values of R but rather fix a value of b_i and make the other changes proportional
%  to it. 
%
%                               Gradient vector
%                  |                ^
%                  |    \    \    \/   O
%                  |\    \    \   /\ New\
%                  | \    \    \ /  O trials
%              x_2 |  \    \    /    \    \
%                  |   \ O--\----\O   \    \
%                  |    \| Start  |    \    \
%                  |     | design |\    \    \
%                  |     O\----\--O \    \    \
%                  |_ _ _ _\_ _ \_ _ \_ _ \_ _ \_ _ 
%                                 x_1
%          
%      First-order response surface and path of steepest ascent.           
%
%  Thus, the goal is to optimize the response variable Y. It is assumed that the
%  factors are continuous and controllable by the experimenter with negligible error.
%  If b_1, b_2,...,b_p are the parameters and observed response is Y then the parameter
%  of the polynomial is estimated by method of least squares.
%  The method of steepest ascent/descent is followed to reach the optimun point where
%  best surface is obtained. That is direction of the maximum increase/minimum decrease
%  of the response in the case of surface finish cosiderations. Direction of steep Y is 
%  increasing/decreasing. Experiments are conducted along the path of steepest 
%  ascent/descent until no further decrease in response is observed. Then a new 
%  first-order model may be fit, a new path of steepest ascent/descent determined the
%  procedure continues. Eventually the vicinity of optimum is arrived. 
% 
%  Syntax: steep(B,V,C,s,o,d) 
%      
%  Inputs:
%       B - vector of regression coefficients (parameters) of the fitted linear equation
%           (first order): [intercept (1), linear (p)]. It must to be enter in that 
%           strictly order.
%       V - vector of the factor values at starting point (current factor setting).
%       C - vector of units increment chosen between the low and medium levels and 
%           between the medium and high levels for each parameter.
%       s - number of interested steps.
%       o - change relative to one unit change regarding to the maximum absolute 
%           parameter [o = 1 (default)] or parameter choice by experimenter (o = 2).
%       d - steepest ascent [d = 1 (default)] or descent (d = 2) procedure. 
%
%  Outputs:
%       A complete summary of the estimation of the selected direction of the
%       selected steepest method.
%
%  To see the procedure consider the following example taken from Montgomery DOX 5E 
%  (Example 11-1, pg. 431). Based on the fitted first-order model,
%                     y = 40.44 + 0.775*x1 + 0.325*x2
%  with actual factor-values on the origin of 35 and 155 for time-reaction (min) and
%  temperature (oF) and step size of 5 and 5, respectively. We are interested to obtain
%  the predicted response by the steepest ascent metod for 12 steps.
%
%  Input data must be:
%  B=[40.44 0.775 0.325];
%  V=[35 155];
%  C=[5 2];
%  s = 12;
%  o = 1;
%  d = 1;
%
%  Calling on Matlab the function: 
%             steep(B,V,C,s,o,d)
%
%  Answer is:
%
%  Estimation of the selected direction of steepest ascent.
%  The interested steps were 12
%  Leading from the center of the design region the operating point for the IV, 2
%  --------------------------------------------------------------------------------------------------------------
%   Run          Operating point        Predicted response 
%  --------------------------------------------------------------------------------------------------------------
%     0        35.000      155.000            40.440
%     1        40.000      157.097            41.351
%     2        45.000      159.194            42.263
%     3        50.000      161.290            43.174
%     4        55.000      163.387            44.085
%     5        60.000      165.484            44.996
%     6        65.000      167.581            45.908
%     7        70.000      169.677            46.819
%     8        75.000      171.774            47.730
%     9        80.000      173.871            48.642
%    10        85.000      175.968            49.553
%    11        90.000      178.065            50.464
%    12        95.000      180.161            51.375
%  --------------------------------------------------------------------------------------------------------------
%
%  Created by A. Trujillo-Ortiz, R. Hernandez-Walls, A. Castro-Perez and
%             F.J. Marquez-Rocha
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%             And the special collaboration of the post-graduate students of the 2005:1
%             Multivariate Statistics Course: Cesar Orlando Chavira-Ortega, Alfredo Frias-Velasco,
%             and Herlinda Gomez-Villa.
%  Copyright (C) May 20, 2005.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A., R. Hernandez-Walls, A. Castro-Perez, F.J Marquez-Rocha,
%    C.O. Chavira-Ortega, A. Frias-Velasco and H. Gomez-Villa. (2005). steep:
%    Steepest ascent/descent as a simple and efficient optimization method based
%    on statistical design of experiments. A MATLAB file. [WWW document]. URL 
%    http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=7737
%
%  References:
% 
%  Box, G. E. P. and Draper, N. R. (1987), Empirical Model-Building and Response Surfaces. 
%          John Wiley & Sons: New York.
%  Box, G. E. P. and Wilson, K. B. (1951), On the Experimental Attainment of Optimum
%          Conditions. J. Royal Stat. Soc. Ser. B., 13:1-45.
%  Montgomery, D. C. (2001), Design and Analysis of Experiments, 5th Ed., John Wiley & Sons: New York.
%  Myers, R. H. and Montgomery, D. C. (2002),  Response Surface Methodology: Process and
%          Product Optimization Using Designed Experiments. 2nd. Ed., John Wiley & Sons: New York.
%

if nargin < 6,
   d = 1 %(deafault);
end;

if nargin < 5,
   o = 1 %(deafault);
end;

b = B(2:end);
b = b(:);  %vector of  from coded regression model
V = V(:);  %base level (center point)
C = C(:);  %unit change
s = s;     %
v = length(B)-1; %number of independent variables

if o == 1,
   f = max(abs(b));
else (o == 2),
   l = input('Give me the interested factor: ');
   f = b(l);
end;

S = [];
for i = 0:s,
    if d == 1;      %steepest ascent
        x = [V + i*diag(b./f*C')];
    else (d == 2);  %steepest descent
        x = [V - i*diag(b./f*C')];
    end;
    S = [S x];
end;

S = S';
V = V';
[m n] = size(S);
O  = (S - repmat(V,m,1))./repmat(C',m,1);

Y = B(1)+O*b;

T = [];
for i = 0:s,
   T = [T;i];
end;

if d == 1;
    d = 'ascent.';
else (d == 2);
    d = 'descent.';
end;
    
[nul,fs] = size(S);
form = ['%12.3f '];
form2 = [' Run '];
form3 = [' Predicted response '];
for k = 2:fs,
    form = [form '%12.3f '];
    form2 = [form2 '       '];
    form3 = ['      ' form3];
end;
RR = [T S Y];

disp(' ')
fprintf('Estimation of the selected direction of steepest %s\n',d);
fprintf('The interested steps were %i\n',s);
fprintf('Leading from the center of the design region the operating point for the IV, %i\n',v);
fprintf('--------------------------------------------------------------------------------------------------------------\n');
disp([form2 '  Operating point '  form3])
fprintf('--------------------------------------------------------------------------------------------------------------\n');
ffa=['%4i  ' form  ' %16.3f\n'];
fprintf(ffa,RR');
fprintf('--------------------------------------------------------------------------------------------------------------\n');
disp(' ')

return,