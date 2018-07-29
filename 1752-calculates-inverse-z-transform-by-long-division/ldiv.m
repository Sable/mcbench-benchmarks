%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function (ldiv) : calculate inverse Z-transform by long division 
% Author : Tamer mohamed samy abdelazim Mellik
% Contact information : 
%Department of Electrical & Computer Engineering,
%University of Calgary,
%2500 University Drive N.W. ,
%Calgary, AB T2N 1N4 ,
%Canada .
% email :abdelasi@enel.ucalgary.ca  
% email : tabdelaz@ucalgary.ca
% Webpage : http://www.enel.ucalgary.ca/~abdelasi/
% Date    : 2-5-2002
% Version : 1.0.0
%Example
% This function like deconv but it help if the numerator less or equal degree of denominator
% if you have this function (It must arranged in terms of minus power of Z):
%              1
% G(z)= -----------------      
%             -1     -2
%      ( 5 - Z  - 3 Z  )
% and you want to calculate long division or inverse Z transform :
% The numerator  is a=[1] and  the denominator is b= [5 -1 -3 ]
% call the function ldiv(a,b) to get the funresult 20 items (default)
% another example :
%                -2     -3 
%       ( 5 - 3 Z  + 4 Z  )
%  G(z)-----------------      
%              -1     -2
%        (5 - Z  - 3 Z )
% a=[5 0 -3 4] , b= [5 -1 -3 ] and you want the funresult 100 terms !
% ldiv(a,b,100) 
% Note : The author doesn't have any responsibility for any harm caused by the use of this file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function funresult=ldiv(a,b,N)
%a numerator
%b denominator
%default order of the filter == 20
funresult=[];
if nargin < 3
    if nargin > 1
            N=20;
    else
            disp('Usage: M = ldiv(a,b,N)')
            disp('a:numerator , b denominator and N is the order of the resultant filter')
            return
    end 
end

if size(a) < 1
    disp('Error: numerator must at least have one element not empty')
    return
end
if size(b) < 1
    disp('Error: denominator must at least have one element not empty')
    return
end

if b(1)==0
    disp('Error: The first element of denominator must have nonzero value')
    return
end
if size(b) < 2
    funresult=a./b;
    for i =length(funresult)+1:N
       funresult(i)=0;
    end
    return
end


for i = length(a)+1:N
    a(i)=0;
end
for i = 1 : N
    funresult(i)=a(1)/b(1);
    if length(a)>1
            for k= 2:length(b)
                if k > length(a)
                    a(k)=0;
                end
                a(k)=a(k)-funresult(length(funresult))*b(k);
            end

        for i = 1:length(a)-1
                a(i)=a(i+1);
        end
        a=a(1:length(a)-1);
    end
end

