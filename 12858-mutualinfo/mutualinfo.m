function MI = mutualinfo(objMat,pVect,varargin)
%MUTUALINFO Multiple mutual information (interaction information).
%   MUTUALINFO(X,P,idx) returns the multiple mutual information (interaction
%   information) for the joint distribution provided by object matrix X and 
%   probability vector P.  Each row of MxN matrix X is an N-dimensional object 
%   (N-tuple), and P is a length-M vector of the corresponding probabilities.  
%   Thus, the probability of object X(i,:) is P(i).  
%   
%   If X contains duplicate rows, these are assumed to be occurrences of the 
%   same object, and the corresponding probabilities are added.  Matrix X 
%   need NOT be an exhaustive list of all possible objects -- objects/tuples 
%   that do not appear are assumed to have zero probability. The elements of 
%   probability vector P must sum to 1 +/- .00001.
%
%   The last argument (idx) will let you specify the partition on the matrix, 
%   i.e., idx = [1 1 1 2 2 3] means that columns 1-3 represent variable 1, 
%   columns 4-5 represent variable 2, and column 6 represents variable 3. (When 
%   idx contains only two *unique* values, it is the traditional mutual information 
%   which is being computed.) In a multi-column variable, each unique tuple is 
%   just a *label* for a constructed variable value.  Recall that information-
%   theoretic measures of dependence do not rely on actual variable *values*, 
%   but only on the *probabilities* of variable-value co-occurrence.  For 
%   example, let object matrix X be given by
%
%       [1 3 0 1 0 0
%        2 1 0 2 1 0
%        2 2 2 2 0 2
%        2 1 1 1 0 1
%        2 1 1 2 1 2
%        3 3 1 0 0 2
%        1 1 2 1 0 0
%        0 2 2 0 0 0]
%       
%   This object matrix contains 8 rows/objects and 6 columns/variables. (Some 
%   of these variables are binary, some ternary, and some quaternary.)  We 
%   assume that a suitable (i.e., sum-to-one) vector P is provided.  
%   MUTUALINFO(X,P) with no index argument computes the interaction information 
%   among the 6 variables. MUTUALINFO(X,P,idx), where, for example argument idx 
%   is [1 1 1 2 2 3], computes the interaction information among 3 "constructed" 
%   variables; the first constructed variable being defined as the union of the 
%   1st, 2nd, and 3rd original variables, the second constructed variable being 
%   defined as the union of the 4th and 5th original variables, and the third 
%   constructed variable being defined as the 6th original variable.  Thus, with 
%   idx given by [1 1 1 2 2 3], the interaction information computed is the same 
%   as for the following object matrix, where original variables {1,2,3} have been 
%   recoded into a single variable, and original variables {4,5} have been 
%   recoded into a single variable.
%
%       [1 1 0
%        2 2 0
%        3 3 2
%        4 1 1
%        4 2 2
%        5 0 2
%        6 1 0
%        7 0 0]
%
%   Again, recall that the actual variable values do not matter here, and we 
%   end up with three constructed variables, the first having cardinality 7, 
%   the second having cardinality 4, and the third being the original 6th variable
%   with cardinality 3.  In case you are wondering, the usefulness of using the 
%   index vector input to "lump together" variables is to look at the mutual 
%   information or interaction information between *sets* of variables.  For 
%   example, if you have one set of variables representing experimental inputs 
%   and another set of variables representing experimental outputs, you may wish 
%   to see what the mutual information is existing between the two *sets*.  The 
%   index vector provides an easy way to do this, I think.
%
%   Multiple mutual informations can be positive (synergy) or negative (redundancy).  
%   Be aware.
%
%   This function is not efficient because it iterates over the power set of 
%   distinct variables, i.e., over the power set of V, where V = unique(idx).  
%   To compute interaction information for N variables requires computing (2^N)-1 
%   entropies.  I do not know whether there is a more efficient method.  Also, 
%   I make no other claims for correctness of this function, although it has seemed 
%   to work for me.  You would be wise to check it on a few test cases for which 
%   you know the answer.  [To get a little speed-up, you can at least turn
%   off the error-checking.  Just comment it out.]
%
%   REFERENCES:  The classic source for multiple mutual information is 
%   (McGill, 1954).  Aleks Jakulin and Ivan Bratko have done a lot of recent
%   work on the topic (e.g., Jakulin and Bratko, 2003), and their various papers 
%   provide a very comprehensive review of previous research.  Another nice
%   introduction with applications in physics is (Matsuda, 2000).
%
%   * <a href="matlab:web('http://en.wikipedia.org/wiki/Interaction_information','-browser')">Interaction information</a>. Wikipedia, The Free Encyclopedia. 
%   * McGill, W. J. (1954). Multivariate information transmission. Psychometrika, 19:97-116. 
%   * Jakulin, A. and Bratko, I. (2003). <a href="matlab:web('http://arxiv.org/abs/cs/0308002v3','-browser')">Quantifying and visualizing attribute interactions</a>.
%   * Matsuda, H. (2000). Physical nature of higher-order mutual information:
%     Intrinsic correlations and frustration. Physical Review E, 62:3096-3102.
%
%   See also TCORR.

%% Set up variable partition
if ~isempty(varargin),
    partitionVect = varargin{1};
    if ~isvector(partitionVect) || ~isequal(length(partitionVect),size(objMat,2)),
        error('Last input (partition) must be a vector with length = size(X,2).')
    end    
else
    partitionVect = 1:size(objMat,2);
end

idxVect = unique(partitionVect);

%% Error checks 
allVarStr = [];
for i = idxVect, 
    varName = ['X' num2str(i)];
    allVarStr = [allVarStr varName ' '];
    eval([varName '= objMat(:,find(partitionVect==i));']);  
end

if ~isequal(eval(['sortrows([' allVarStr ']'')']),sortrows(objMat')),
    error('Internal error: Partitioning problem.')
end


%% The Main Show 
runningEntSum = 0;
for i = 2:2^length(idxVect),  
    
    % Get binary representation:
    binaryString = dec2bin(i-1,length(idxVect)); 
    selectVect = str2num(binaryString(:))';
    thisSign = (-1)^(length(idxVect)-sum(selectVect));
    
    varSet = idxVect(find(selectVect));
    varColumnIx = [];
    subPartition = [];
    for j = 1:length(varSet),
        thisVarColumnIx = find(partitionVect==varSet(j));
        varColumnIx = [varColumnIx thisVarColumnIx];
    end
    
    if ~isequal(length(unique(varColumnIx)),length(varColumnIx)),
        error('Internal error: Why are there duplicates here?')
    end
    
    subObjMat = objMat(:,varColumnIx);
    thisEntropy = entropy(subObjMat,pVect);
    runningEntSum = runningEntSum + thisSign*thisEntropy;
end

MI = -runningEntSum;



