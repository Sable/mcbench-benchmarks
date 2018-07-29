function [ idxD idxA ] = getIdxFlatY( para )
%getIdxFlatY Think of the solution y ([M,N]=size(y)) as a flat vector.
% It indicates which variable is dynamic or algebraic.
% (length(iD)+length(iA)=M*N)
%
%INPUT para     struct  Internal rungekutta parameter.
%
%OUTPUT vector idxD  Indices of the dynamic variables.
%       vector idxA  Indices of the algebraic variables.
%
%AUTHOR Stefan Schießl
%DATE   13.08.2012

    dynPoints = para.dynPoints;
    idxDynamicEquations = para.idxDynamicEquations;
    idxAlgebraicEquations = para.idxAlgebraicEquations;
    cE = para.countEquations;
    cP = para.countPoints;

    idxD = [];
    idxA = [];
    for i=1:cP
        % If the point is not dynamic, just set everything to 
        % algebraic
        if (ismember(i, dynPoints) == 1)
            idxD = [idxD (i-1)*cE+idxDynamicEquations];    
            idxA = [idxA (i-1)*cE+idxAlgebraicEquations];    
        else 
            idxA = [idxA ((i-1)*cE+1):i*cE];    
        end
    end
end