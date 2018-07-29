function x = pcond(a,b,c)
%PCOND   Conditional probability.
% Conditional probability is the probability of some event A, given the
% occurrence of some other event B. Conditional probability is written 
% P(A|B), and is read 'the probability of A, given B'.
%
% It is calculated as,
%
%                  P(AB)
%        P(A|B) = --------
%                   P(B)
%
% P(AB) is the probability of the intersection of the events.
%
% Syntax: function x = pcond(a,b,c) 
%      
% Inputs:
% a - Event A data vector (option=1) or probability of event A (option~=1)
% b - Event B data vector (option=1) or probability of event B (option~=1)
% c - Option 1=data vectors (default), option ~1=probability values
%
% Output:
%   - Ask you if you are interested to know if the events(sets) are
%     independent or not
%   - Conditional probability
%
% Example 1: Given A=[2 4 6] and B=[1 2 3 4]. We are interested to calculate
%            the conditional probability associated and to know if the
%            events are independent.
%
% Calling on Matlab the function: 
%             pcond(A,B)
%
% Answer is:
%
% NOTE:The conditional probability it is computed as p(A|B)
% [event A given (conditioned by) B].
%
% Give me the sample space size: 6
% Do you want to know if the events (sets) are independent? (y/n): y
% The events (sets) are independent.
%
% ans =
%
%     0.5000
%
% Example 2: Given p(A)=0.35 and p(B)=0.63. We are interested to calculate
%            the conditional probability associated.
%
% Calling on Matlab the function: 
%             pcond(0.35,0.63,2)
%
% Answer is:
%
% NOTE:The conditional probability it is computed as p(A|B)
% [event A given (conditioned by) B].
% 
% Give me the probability of the intersection: 0.32
% Do you want to know if the events (sets) are independent? (y/n): n
%
% ans =
%
%    0.5079
%
% Created by A. Trujillo-Ortiz, R. Hernandez-Walls, F.A. Trujillo-Perez
%            and N. Castro-Castro
%            Facultad de Ciencias Marinas
%            Universidad Autonoma de Baja California
%            Apdo. Postal 453
%            Ensenada, Baja California
%            Mexico.
%            atrujo@uabc.mx
% Copyright. August 28, 2009.
%
% To cite this file, this would be an appropriate format:
% Trujillo-Ortiz, A., R. Hernandez-Walls, F.A. Trujillo-Perez and 
%   N. Castro-Castro (2009). pcond:Conditional probability. A MATLAB file.
%   [WWW document]. URL http://www.mathworks.com/matlabcentral/
%   fileexchange/25184
%

if nargin < 3
    c = 1; %by default it use both sets a and b
end

disp('NOTE:The conditional probability it is computed as p(A|B)');
disp('[event A given (conditioned by) B].');
disp(' ');

if c == 1
    if (length(a) == 1 | length(b) == 1)
        error('condprob:InputSetSize',...
               'Sets A and B must have at least two elements.');
    end
    n = input('Give me the sample space size: ');
    pa = length(a)/n; %probability of event A
    pb = length(b)/n; %probability of event B
    i = intersect(a,b); %set intersection
    pi = length(i)/n; %probability of the set intersection
else
    if (numel(a) ~= 1 | numel(b) ~= 1)
        error('condprob:InputSetSize',...
            'Each A and B must be a scalar.');
    end
    
    if (0 >= a && a >= 1) || (0 >= b && b >= 1)
        error('stats:pcond:BadValue','A and B must be a scalar between 0 and 1.');
    end
    pa = a;
    pb = b;
    pi = input('Give me the probability of the intersection: ');
end
    
x = pi/pb; %conditional probability

i = input('Do you want to know if the events (sets) are independent? (y/n): ','s');
if i == 'y'
    if pa == x
        disp('The events (sets) are independent.');
    else
        disp('The events (sets) are not independent.');
    end         
else
end

return,