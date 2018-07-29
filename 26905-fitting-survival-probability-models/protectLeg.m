function protLeg = protectLeg(Term,Settle,PL_Date,Basis,LIBOR,Recovery,probfun,b)
%protectLeg Computes the market value of protection leg

PL_Time = yearfrac(Settle,PL_Date,Basis);
PLQ = probfun(PL_Time,b);

PLDF = LIBOR.getDiscountFactors(PL_Date);

protLeg = zeros(size(Term));
for spreadidx=1:length(Term)
    
    PLtmpidx = PL_Time < Term(spreadidx);
    
    PLDFtmp = PLDF(PLtmpidx);
    PLQtmp = PLQ(PLtmpidx);
    
    protLeg(spreadidx) = (1 - Recovery)*sum(-PLDFtmp.*diff([1 PLQtmp]'));
end