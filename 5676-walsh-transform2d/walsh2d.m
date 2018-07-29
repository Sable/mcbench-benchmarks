%The function implement the 2D Walash Transform which can be used in 
%signal processing,pattern recognition and Genetic algorithms. The Formula of 
%2D Walsh Transform is defined as :

%%               N-1   N-1        q-1
%%              ----  ----         --     
%%          1   \     \           |  |   b[i](m)*b[q-1-i](u)+b[i](n)*b[q-1-i](v) 
%% W(u,v) = --- /     /    f(m,n) |  |(-1)                       
%%          N   ----  ----        |  |
%%               m=0   n=0        i=0
%%  u,v = 0,...,N-1
%% where for instance ,A[i] is the ith indices of A. 

%The definition :

%%% f(m,n) : Two dimentional Image(Sequence) ,m,n = 0,...,N-1; 
%% Input image can belong to UINT8 or DOUBLE class.Also
%% it must be squre!
%        q
%%% N = 2  : where N is the size of Image
%%% W(u,v)   : Walsh Transform;
%%  b[k](u): kth bit(from LSB) in the binary representation of u;
%%  For instance if u = 6 where in binary it becomes 110 then
%%  b[0](6) = 0,b[1](6) = 1 and b[2](6) = 1,
    

%*** You must download 'walsh1d.m' to use this function***% 
%** Example :
%% W = walsh2d(imread('myiage.jpg'));

%%  Author : Ahmad poursaberi
%%  e-mail : a.poursaberi@ece.ut.ac.ir
%%  Control and Intelligent Processing Center of Excellence
%%  Faulty of Engineering, Electrical&Computer Department,
%%  University of Tehran,Iran,August 2004
%% copyright 2004

function W = walsh2d(I)
warning off
if length(size(size(I)))~=2
    I = im2bw(imread(input('Enter Image Name '))) ;
end
siz = max(size(I));
q = log2(siz);
if  sum(ismember(char(cellstr(num2str(q))),'.'))~=0
    disp('           Warning!...               ');
    disp('The size of Vector  must be in the shape of 2^N ..');
    return
end
if isa(I,'double')==1
    I = im2uint8(I);
   end
    
W = I;
len = length(I);


for i = 1:len
   W2(i,:) = walsh1d(double(W(i,:)));
end

W = zeros(len);
for j = 1:len
    W(:,j) = walsh1d(double(W2(:,j)'))';
end

