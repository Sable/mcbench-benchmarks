function [S,C]=allsums(varargin)
% ALLSUMS Distribution of unique sums among all combinations of vectors.
%   [S,C]=ALLSUMS(IN) depending on input IN, will do one of two different
%   procedures for calculating all unique combinations of sums.
%
%   The output vectors, S and C, are respectively the list of unique
%   sums, and the count distribution for those sums among all combinations.
%
%
%   SINGLE INPUT: 
%
%   [S,C]=ALLSUMS(VEC) for a single input vector of length N, returns the
%   distribution of unique sums among the (2^N)-1 combinations of
%   non-empty subsets of elements within VEC.
%
%    EXAMPLE:
%      Number of ways to have a total of 250 using only the odd numbers
%      from 1 to 100.
%      [S,C]=allsums(1:2:100);
%      num=C(S==250)
%
%
%   MULTIPLE INPUTS:
%
%   [S,C]=ALLSUMS(VEC,K) with vector VEC of length N, assumes the
%   equivalent scenario of rolling a N-sided die, with values VEC, 
%   K times and returns the distributions of unique sums among all
%   N^K combinations of values.
%
%   [S,C]=ALLSUMS(VEC1,K1,VEC2,K2,...) with vectors of length N1, N2, ...
%   assumes the equivalent scenario of rolling a N1-sided die, with
%   values VEC1, K1 times; then rolling a N2-sided dice, with values VEC2,
%   K2 times; etc. and returns the distribution of unique sums among
%   all (N1^K1)*(N2^K2)*... combinations of values
%
%    SINGLE VECTOR, REPEATED
%      Probability distribution of rolling a regular 6-sided die 100 times
%      [S,C]=allsums(1:6,100);
%      plot(S,C./sum(C)), grid on
%
%    MULTIPLE VECTORS, REPEATED
%      Probability of the total yielding exactly zero when rolling a
%      A) six-sided die with values [-5:0] ten times, and then a
%      B) ten-sided die with values [-4:5] twenty times.
%      [S,C]=allsums([-5:0],10,[-4:5],20);
%      prob=C(S==0)/sum(C)
%

%   Mike Sheppard
%   Last Modified: 27-Oct-2011



%ERROR CHECKING
ninputs=numel(varargin);
switch ninputs
    case 0
        error('allsums:Inputs','Requires at least one input');
    case 1
        VEC=varargin{1}; %Input vector
        if any(~isfinite(VEC))
            error('allsums:Inputs','Requires input vector to be numeric');
        end
    otherwise
        num=ninputs/2;
        if mod(ninputs,2)~=0
            error('allsums:Inputs','Requires inputs to be in [Vector],[Number] order');
        end
        for k=1:num
            ALLVEC{k}=varargin{2*k-1}; ALLNUMR{k}=varargin{2*k}; numr=ALLNUMR{k};
            if any(~isfinite(ALLVEC{k}))
                error('allsums:Inputs','Requires all input vectors to be numeric');
            end
            if any([~isfinite(numr) ~isscalar(numr) numr~=round(numr) numr<=0])
                error('allsums:Inputs','Requires number of repetitions to be a positive scalar integer');
            end
        end
end



%ALGORITHM
switch ninputs
    case 1
       % Distribution of unique sums among the (2^N)-1 combinations of
       % non-empty subsets of elements within VEC.
        S=[]; C=[];
        for k=1:numel(VEC)
            [S,ign,indx]=unique([S VEC(k) S+VEC(k)]);
            C=accumarray(indx',[C 1 C])';
        end
        S=S(:); C=C(:);
    otherwise
        % Distribution of unique sums among all (N1^K1)*(N2^K2)*... 
        % combinations of vectors of length N_k repeated K_k times,
        % with values VEC_k each.
        S=0; C=1;
        for k=1:num
            VEC=ALLVEC{k}; VEC=VEC(:); numr=ALLNUMR{k};
            for n=1:numr
                tempv=bsxfun(@plus,S',VEC);
                tempc=repmat(C',length(VEC),1);
                [S,ign,indx]=unique(tempv(:));
                C=accumarray(indx,tempc(:));
            end
        end
end



end