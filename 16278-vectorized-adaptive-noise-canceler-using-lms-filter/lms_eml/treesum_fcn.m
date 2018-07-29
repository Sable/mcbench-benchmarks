function y = treesum_fcn(u)
%Implement the 'sum' function without a for-loop
%  y = sum(u);

%  The loop based implemntation of 'sum' function is not ideal for 
%  HDL generation and results in a longer critical path. 
%  A tree is more efficient as it results in
%  delay of log2(N) instead of a delay of N delay

%  This implementation shows how to explicitly implement the vector sum in 
%  a tree shape to enable hardware optimizations.

%  The ideal way to code this generically for any length of 'u' is to use 
%  recursion but it is not currently supported by Embedded MATLAB


% NOTE: To instruct Embedded MATLAB to compile an external function, 
% add the following compilation directive or pragma to the function code
%#eml


% Please note that this implementation is hardwired for a 40tap filter.

%20
level1 = vsum(u);

%10
level2 = vsum(level1);

%5
level3 = vsum(level2);

%3
level4 = vsum(level3);

%2
level5 = vsum(level4);

%1
level6 = vsum(level5);


y = level6;



function output = vsum(input)

nt = numerictype(input);
fm = fimath(input);

nd = numel(input)/2;
vt = input(1:2:end);
    
for i = int32(1:nd)
    k = int32(i*2);
    vt(i) = fi(vt(i) + input(k), nt, fm);
end

output = vt;

