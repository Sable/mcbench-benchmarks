function [ieq,jeq,Seq] = rkDFun(y,para)
%rkDFun Jacobian of rkFun.
%
%INPUT  vector  y     Solution for the new time, flat vector,
%                     size(y)=[M*N*s,1].
%       struct  para  Internal parameter struct.
%
%OUTPUT vector  ieq   All 3 output values belong together.
%       vector  jeq   They represent a sparse matrix S where
%       vector  Seq   S(ieq(i),jeq(i))=Seq(i).
%
%AUTHOR:  Stefan Schießl
%DATE     07.08.2012

    cEP = para.countEquationsTimesPoints;
    deltat = para.deltat;
    s = para.s;
    A = para.A;
    iD = para.idxFlatDynamic;
    
    [dfI, dfJ, dfS, dgI, dgJ, dgS] = getDFex(y,para);
        
    ieq = zeros(1,s*s*length(dfI(1,:))+s*(length(iD)+length(dgI(1,:))));
    jeq = zeros(1,s*s*length(dfI(1,:))+s*(length(iD)+length(dgI(1,:))));
    Seq = zeros(1,s*s*length(dfI(1,:))+s*(length(iD)+length(dgI(1,:))));
    pointer = 0;
    for i=1:s
        for j=1:s
            idxI = (i-1)*cEP;
            idxJ = (j-1)*cEP;
            
            % Adjust the derivatives of f to fit to the ki update.
            % 0 = ki - u_n - deltat*sum_j=1^s A(i,j) f(ki,li) = rkfun
            % d(rkfun)/d(ki,li)
            it = dfI(i,:);
            jt = dfJ(i,:);
            St = dfS(i,:);
            range = pointer+1:pointer+length(it);
            ieq(range) = idxI+it;
            jeq(range) = idxJ+jt;
            Seq(range) = -St*deltat*A(i,j);
            pointer = pointer+length(range);
            if (i==j)
               range = pointer+1:pointer+length(iD);
               ieq(range) = idxI+iD;
               jeq(range) = idxJ+iD;
               Seq(range) = ones(1,length(iD));
               pointer = pointer+length(range);
            end
            
            % Adjust the derivatives of f to fit to the li update
            % 0 = g(ki, li) = rkfun
            % d(rkfun)/d(ki,li)
            if (i==j)
                % Only shift the index of the derivatives
                % to the s corrected index.
                it = dgI(i,:);
                jt = dgJ(i,:);
                St = dgS(i,:);
                range = pointer+1:pointer+length(it);
                ieq(range) = idxI+it;
                jeq(range) = idxJ+jt;
                if (para.useStabilizerDeltat)
                    St = St*para.deltat;
                end
                Seq(range) = St;
                pointer = pointer+length(range);
            end
        end
    end
    if (length(ieq)~=pointer)
       error('rkDFun:PointerError','Reallocate i,j,S!'); 
    end
    
end

function [dfI, dfJ, dfS, dgI, dgJ, dgS] = getDFex(y,para)
%getDFex Analog to getFex, just for the derivatives.
%
%INPUT  vector  y     Flat solution of the newton algorithm.
%       struct  para  Internal rungekutta parameter.
%
%OUTPUT vector  dfI, dfJ, dfS  Jacobian for f, 
%                              S_i(dfI(i,:),dfI(i,:))=dfS(i,:), S_i is the
%                              derivative of f for ki and li.
%       vector  dgI, dgJ, dgS  Jacobian for g, 
%                              S_i(dfI(i,:),dfI(i,:))=dfS(i,:), S_i is the
%                              derivative of g for ki and li.

    dfex = para.dfex;
    cP = para.countPoints;
    cE = para.countEquations;
    cEP = para.countEquationsTimesPoints;
    s = para.s;
    iD = para.idxFlatDynamic;
    iA = para.idxFlatAlgebraic;
    
    % Precalculate df for every ki, li
    for i=1:s
        kiAndli = y((i-1)*cEP+1:i*cEP);
        %The user function expects a input of size [M,N].
        [ieq, jeq, Seq] = dfex(reshape(kiAndli, cE, cP));
        
        % Which parts are from dynamic variables?
        dynIeq =  ieq(ismember(ieq, iD));
        dynJeq =  jeq(ismember(ieq, iD));
        dynSeq =  Seq(ismember(ieq, iD));
        %The size of the output values is only known after the
        %first evaluation of dfex.
        if (~exist('dfI','var'))
            l = length(dynIeq);
            dfI = zeros(s,l);
            dfJ = zeros(s,l);
            dfS = zeros(s,l);
        end
        dfI(i,:) = dynIeq;
        dfJ(i,:) = dynJeq;
        dfS(i,:) = dynSeq;
        
        % Which parts are algebraic variables?
        algIeq =  ieq(ismember(ieq, iA));
        algJeq =  jeq(ismember(ieq, iA));
        algSeq =  Seq(ismember(ieq, iA));
        if (~exist('dgI','var'))
            l = length(algIeq);
            dgI = zeros(s,l);
            dgJ = zeros(s,l);
            dgS = zeros(s,l);
        end
        dgI(i,:) = algIeq;
        dgJ(i,:) = algJeq;
        dgS(i,:) = algSeq;
    end
    
end

