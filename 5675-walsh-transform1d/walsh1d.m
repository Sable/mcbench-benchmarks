%The function implement the 1D Walash Transform which can be used in 
%signal processing,pattern recognition and Genetic algorithms. The Formula of 
%1D Walsh Transform is defined as :

%%              N-1      q-1
%%             ----      --     
%%          1  \        |  |      b[i](m)*b[q-1-i](u) 
%%  W(u) = --- /    f(m)|  |  (-1)                        ,u = 0,...,N-1
%%          N  ----     |  |
%%             m=0       i=0

%% where for instance ,A[i] is the ith indices of A. 

%The definition :

%%% f(m) : One dimentional Image(Sequence) ,m = 0,...,N-1; 
%        q
%%% N = 2  : where N is the size of Image
%%% W(u)   : Walsh Transform;
%%  b[k](u): kth bit(from LSB) in the binary representation of u;
%%  For instance if u = 6 where in binary it becomes 110 then
%%  b[0](6) = 0,b[1](6) = 1 and b[2](6) = 1,
    


%** Example :
%% W = walsh1d([1 2 1 1]);

%%  Author : Ahmad poursaberi
%%  e-mail : a.poursaberi@ece.ut.ac.ir
%%  Control and Intelligent Processing Center of Excellence
%%  Faulty of Engineering, Electrical&Computer Department,
%%  University of Tehran,Iran,August 2004
%% copyright 2004

function W = walsh1d(I);
warning off
siz = size(I);
siz = siz(2);
q = log2(siz);
if  sum(ismember(char(cellstr(num2str(q))),'.'))~=0
    disp('           Warning!...               ');
    disp('The size of Vector  must be in the shape of 2^N ..');
    return
else
for u = 1:siz
    binu = dec2bin(u-1,q);
    binsize = size(binu);
    binsize = binsize(2);
    Wtemp = 0;
    %%Inner Loop
    for m = 1:siz
        binm = dec2bin(m-1,q);
        binsize = size(binm);
        binsize = binsize(2);

        temp = 1;
        for i = 1:q
            temp = temp * (-1)^(binm(q+1-i)*binu(i));
        end
        Wtemp = I(m)*temp + Wtemp;
    end
    W(u) = inv(siz)*Wtemp;
end
%%End of Loop
end