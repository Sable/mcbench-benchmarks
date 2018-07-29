%linearencode.m
function out=linearencode(sig,genmat)
%Sig is vector of uint8 values
%genmat is the generator matrix for the linear block code - a 4 by 7 matirx
%of 0's and 1's
%out a matrix of seven columns and twice as many rows as sig has...it is
%a matrix of 0's and 1's. Each row corresponds to a codeword.
%


%Author: Brhanemedhn Tegegne
%

    r=length(sig);
    out=zeros(2*r,7);
    for i=1:r
       messages=SplitintoTwo(sig(i));
       out(2*i-1,:)=Mod2MatMul(messages(1,:),genmat);
       out(2*i,:)=Mod2MatMul(messages(2,:),genmat);
    end
end
function out=SplitintoTwo(intval)
%splits an integer value into two 4-bit binary numbers
    out=zeros(2,4);
    for i=8:-1:1
        if i>4
            if (intval >= 2^(i-1))
                out(1,8-i+1)=1;
                intval=intval-2^(i-1);
            end
         else
             if (intval >= 2^(i-1))
                  out(2,4-i+1)=1;
                  intval=intval-2^(i-1);
             end
        end
    end
end
