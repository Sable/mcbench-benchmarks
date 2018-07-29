function [M,MList]=GenOrthogComps(nTreats,NormFlag)
%function [M,MList]=GenOrthogComps(nTreats,NormFlag)
%
%This will generate coefficients corresponding to one particular set of
%orthogonal copmarisons for a set of variables, given an input degrees of
%freedom for each variable. 
%
%This is used for multiple comparisons following anova's as well as in the
%huynh-feldt corrections for repeated measures anovas
%
% Inputs:
%   df          - a vector of variable length denoting the degrees of freedom
%              (as in num treatments-1) for each factor. The length of dfs
%              is the number of factors
%   NormFlag    - set to 1 or 0 to determine wether or not you want to
%               normalize the output coefficients. normalization happens so
%               that the sum of the squares of each row of each output
%               matrix sum to 1. Defaults to 1.
%
% Outputs:
%   Mout   -    this is a cell array of a matrix of coefficients
%               corresponding to the matrices M in the Huynh article from
%               1978 that correspond to each main effect and each interaction.
%
%               For example, if nTreats= [3], meaning one factor with 3
%               different levels, the ouput will be: M= [1   -1   0;
%                                                        1/2 1/2 -1]
%               which corresponds to the first comparison of u1-u2 and a
%               second orthogonal copmarison of 1/2*u1 + 1/2*u2 -u3
%
%               Main effects are presented in the first Mout, followed by
%               interactions, starting with 2 way interactions of the first
%               two factors, then 3 way interactions after all the 2-way
%               interactions, etc.
%
%   MList       This is a cell array of a text list of the effects for the
%               corresponding matrices in M. for example 'A' means main
%               effect for the first factor, 'AB' means a 2way interaction
%               for the first two factors, etc.
%
%           To get the matrices needed for the Huynh-Feldt correction, only
%           input the nTreats for all of the within subject factors in your
%           design.
%
% Note this outputs one (relatively easy) way to get orthogonal
% copmarisons, but be aware that tere are infinite different ways to come
% up with a set of orthogonal copmarisons.
%
% For exapmle, running GenOrthogComps([3 3]) give identical outputs to the
% M matrices of table 1 in Huynh H. (1978) "Some approximate tests for repeated
% measurement designs", Psychometrika
%
% written on 090131 by Matthew Nelson

if nargin<2 || isempty(NormFlag);    NormFlag=1;         end
alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ'; %used for MList. If you have more than 26 factors this will result in an error, but if your expeirmental design has more than 26 factors, you may need to stop and rethink a whole number of things

dfs=nTreats-1;
nFacs=length(nTreats);
nCombs=prod(nTreats);

%first do comps for main effects
M=cell(1,nFacs);
for iFac=1:nFacs
    M{iFac}=repmat(0,dfs(iFac),nCombs);
    
    if iFac==nFacs;    nLowCombs=1;
    else        nLowCombs=prod(nTreats(iFac+1:end));
    end
    
    if iFac==1;    nUpCombs=1;
    else        nUpCombs=prod(nTreats(1:iFac-1));
    end
    
    for idf=1:dfs(iFac)
        tmpComps=repmat( 0,1,nLowCombs*nTreats(iFac) );
        tmpComps( 1:nLowCombs*idf )=1/idf;
        tmpComps( nLowCombs*idf+1:nLowCombs*(idf+1) )=-1;
        tmpComps=repmat(tmpComps,1,nUpCombs);
        
        M{iFac}(idf, : )=tmpComps;
        MList{iFac}=alphabet(iFac);
    end       
end

%Now do comps for any interactions as products of the main effect comps ...
%I believe this requires recursion
if nFacs>1        
    for curnFacs=2:nFacs     %start with 2 way interactions and go up to nFacs-way interactions
        for initFac=1:nFacs-(curnFacs-1)                       
            [M MList]=RLoop(curnFacs,initFac,repmat(1,1,nCombs), length(M)+1, '', M,MList,dfs,alphabet); 
        end
    end
end

%optionally normalize coefficients
if NormFlag
    for im=1:length(M)
        for ir=1:size(M{im},1)
            M{im}(ir,:)=M{im}(ir,:)/ sqrt((sum(M{im}(ir,:).^2)));
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [M MList]=RLoop(FacRem,curFac,curRow,curMNum, nextList, M,MList,dfs,alphabet) 
%given the initial inputs, and the initial curFac, this should calc all the
%downstream M vals for that initial curFac...

FacRem=FacRem-1;
for idf=1:dfs(curFac)
    if FacRem==0
        if curMNum>length(M);       
            M{curMNum}=[];      
            MList{curMNum}=[nextList alphabet(curFac)];
        end
        M{curMNum}(end+1,:)=curRow.*M{curFac}(idf,:);
    else
        nextRow=curRow.*M{curFac}(idf,:);
        nextList(end+1)=alphabet(curFac);
        baseFacNum=curFac+1;     %this is needed for the numbering of the outputs...
        for iNextFac=curFac+1:length(dfs)-FacRem+1
            [M MList]=RLoop( FacRem,iNextFac,nextRow,curMNum+(iNextFac-baseFacNum), nextList, M,MList,dfs,alphabet );
        end
    end
end

