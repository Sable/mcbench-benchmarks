function out = RotateSeq(InSeq)
temp = InSeq(length(InSeq));
out = [temp,InSeq(1:length(InSeq)-1)']';