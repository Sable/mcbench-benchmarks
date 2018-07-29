% Program No:6
% Write an M-function for performing local histogram equalization

function localhist(x)
f=imread(x);
f=im2double(f);
w=input('\nEnter the Neighborhood or Window size : ');
k=input('\nEnter the value of the constant k (value should be between 0 and 1) : ');
M=mean2(f);
z=colfilt(f,[w w],'sliding',@std);
m=colfilt(f,[w w],'sliding',@mean);
A=k*M./z;
g=A.*(f-m)+m;
imshow(f), figure, imshow(g);
end