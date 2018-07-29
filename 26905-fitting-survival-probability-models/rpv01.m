function RPV01 = rpv01(Term,Settle,RPV_Dates,Basis,LIBOR,probfun,b)
%RPV01 Computes the "Risky PV01", ie, the expected present value of the
% premium leg at 1 bp

RPV_Time = yearfrac(Settle,RPV_Dates,Basis);
PaymentTimes = [RPV_Time(1);diff(RPV_Time)];

RPVQ = probfun(RPV_Time,b);
RPVDF = LIBOR.getDiscountFactors(RPV_Dates);

RPV01 = zeros(size(Term));
for spreadidx=1:length(Term)
    
    RPVtmpidx = RPV_Time < Term(spreadidx);
    
    PaymentTimestmp = PaymentTimes(RPVtmpidx);
    RPVDFtmp = RPVDF(RPVtmpidx);
    RPVQtmp = RPVQ(RPVtmpidx);
    
    RPV01(spreadidx) = sum(PaymentTimestmp.*RPVDFtmp.*(RPVQtmp + ...
        1/2*(([1;RPVQtmp(1:end-1)]) - RPVQtmp)));
end