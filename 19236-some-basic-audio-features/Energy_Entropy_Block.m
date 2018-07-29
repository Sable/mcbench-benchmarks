function [Entropy] = Energy_Entropy_Block(f,winLength,winStep,numOfShortBlocks)

f = f / max(abs(f));
Eol = sum(f.^2);
L = length(f);

if (winLength==0)
    winLength = floor(L);
    winStep = floor(L);
end


numOfBlocks = (L-winLength)/winStep + 1;
curPos = 1;
for (i=1:numOfBlocks)
    curBlock = f(curPos:curPos+winLength-1);
    for (j=1:numOfShortBlocks)        
        s(j) = sum(curBlock((j-1)*(winLength/numOfShortBlocks)+1:j*(winLength/numOfShortBlocks)).^2)/Eol;
    end
    
    Entropy(i) = -sum(s.*log2(s));
    curPos = curPos + winStep;
end


