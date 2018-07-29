function IESMnew = IESMwithNewFlippedStateQPOTTS(IESM,Q)

IESMnew = IESM;

for count=1:100000000
    IESMnew(2,2)=floor(1+Q*rand);
    if IESMnew(2,2)~=IESM(2,2)
        break
    end
end