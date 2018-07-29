function data_der=invder(data)
% data_der=invder(data)
% inverse 2nd derivative for making data2 matrix for simplisma

% written by K.Artyushkova
%7/7/1999

[n,m]=size(data);
[data2,cm] = savgol(data,17,3,2);
data_der=(-1)*data2;
for i=1:n
   for j=1:m
      if data_der(i,j)<=0,
         data_der(i,j)=0;
      end
   end
end
