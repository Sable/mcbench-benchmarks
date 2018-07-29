function [sequence] = PNSeq (noofBits,ChipGenMethod)
% Generates a PN sequence Using Linear Feedback Shift Register Method
% (ChipGenMethod = 0), Walsh Code(ChipGenMethod=1) or
% Gold Code (ChipGenMethod=2)


    n=log(noofBits+1)/log(2);
    if (n~=round(n)),
        error('noofBits must be of format 2^n - 1')
    end

    sequence=zeros(noofBits,1);
    initialseed=round(rand(n,1));
    for rpt=1:noofBits
        lstbit = initialseed(n);
        Sndlst = initialseed(n-1);
        remaining =initialseed(1:n-1,1);
        initialseed = [xor(Sndlst,lstbit),remaining']';
        sequence(rpt) =lstbit;
    end

    for rpt=1:noofBits
        if (sequence(rpt)==0)
            sequence(rpt)=-1;
        end
    end