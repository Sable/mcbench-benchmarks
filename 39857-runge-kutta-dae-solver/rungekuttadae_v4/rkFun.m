function fun = rkFun(y,yold,para)
%rkFun Function for newton iterations to calculate ki and li.
% @see rungekutta description.
%
%INPUT  vector  y     Solution for the new time, flat vector,
%                     size(y)=[M*N*s,1].
%       vector  yold  Solution of the old time.
%       struct  para  Internal parameter struct.
%
%OUTPUT vector  fun  Evaluation of f and g according to the runge kutta
%                    scheme.
%
%AUTHOR:  Stefan Schießl
%DATE     07.08.2012

    cEP = para.countEquationsTimesPoints;
    A = para.A;
    deltat = para.deltat;
    s = para.s;
    iD = para.idxFlatDynamic;
    iA = para.idxFlatAlgebraic;
    
    fAndg = getFex(y,para);
    
    fun = zeros(s*cEP,1);
    for i=1:s
        if (~isempty(iD))
            ki = y((i-1)*cEP+iD);
            fun((i-1)*cEP + iD) = ki - yold(iD) - fAndg(:,iD)'*A(i,:)'*deltat;
        end
        gi = fAndg(i,iA);
        if (para.useStabilizerDeltat)
            gi = gi*para.deltat;
        end
        fun((i-1)*cEP + iA) = gi;     
    end

end