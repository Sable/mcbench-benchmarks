function [K]=samev(varargin)
%==>samev(vector)
%these function  test the input vector
%if all array of input vector is same then output is 1 else is 0
%==>samev(vector,number)
%these function test the input vector
%if all array of input vector is equal with input number then output is 1
%else is 0
A=varargin{1,1};
if nargin==1
    m=1;
    cte=A(1);
    for i=2:length(A)
        if A(i)==cte
            c=1;
        else
            c=0;
        end
        m=m*c;
    end
end

if nargin==2
    n=varargin{1,2};
    m=1;
    for i=1:length(A)
        if A(i)==n
            c=1;
        else
            c=0;
        end
        m=m*c;
    end
end

if m==1
    K=true;
elseif m==0
    K=false;
end