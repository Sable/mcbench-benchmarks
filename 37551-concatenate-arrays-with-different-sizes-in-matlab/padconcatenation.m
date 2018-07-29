function [catmat]=padconcatenation(a,b,c)
%[catmat]=padconcatenation(a,b,c)
%concatenates arrays with different sizes and pads with NaN.
%a and b are two arrays (one or two-dimensional) to be concatenated, c must be 1 for
%vertical concatenation ([a;b]) and 2 for horizontal concatenation ([a b])
%
% a=rand(3,4)
% b=rand(5,2)
% a =
% 
%     0.8423    0.8809    0.7773    0.3531
%     0.2230    0.9365    0.1575    0.3072
%     0.4320    0.4889    0.1650    0.9846
% b =
% 
%     0.6506    0.8854
%     0.8269    0.0527
%     0.4742    0.3516
%     0.4826    0.2625
%     0.6184    0.5161
%
% PADab=padconcatenation(a,b,1)
% PADab =
% 
%     0.8423    0.8809    0.7773    0.3531
%     0.2230    0.9365    0.1575    0.3072
%     0.4320    0.4889    0.1650    0.9846
%     0.6506    0.8854       NaN       NaN
%     0.8269    0.0527       NaN       NaN
%     0.4742    0.3516       NaN       NaN
%     0.4826    0.2625       NaN       NaN
%     0.6184    0.5161       NaN       NaN
%
% PADab=padconcatenation(a,b,2)
% 
% PADab =
% 
%     0.8423    0.8809    0.7773    0.3531    0.6506    0.8854
%     0.2230    0.9365    0.1575    0.3072    0.8269    0.0527
%     0.4320    0.4889    0.1650    0.9846    0.4742    0.3516
%        NaN       NaN       NaN       NaN    0.4826    0.2625
%        NaN       NaN       NaN       NaN    0.6184    0.5161
%
%Copyright Andres Mauricio Gonzalez, 2012.

sa=size(a);
sb=size(b);

switch c
    case 1
        tempmat=NaN(sa(1)+sb(1),max([sa(2) sb(2)]));
        tempmat(1:sa(1),1:sa(2))=a;
        tempmat(sa(1)+1:end,1:sb(2))=b;
        
    case 2
        tempmat=NaN(max([sa(1) sb(1)]),sa(2)+sb(2));
        tempmat(1:sa(1),1:sa(2))=a;
        tempmat(1:sb(1),sa(2)+1:end)=b;
end

catmat=tempmat;
end