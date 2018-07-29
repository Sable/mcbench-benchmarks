function [R]=even(N)
%these function check input number; if even then output is true logical
%else is false logical(input is odd)
for i=0:2:N
end
if i==N
    R=true;
else
    R=false;
end
