function out = addrulex(fis, rule)
% ADDRULEX Add a rule to a FIS.
%
%   a = addrulex(a, ruleList)
%
%   It is almost clone of MATALAB's addrule
%   with some modifications, so it's compatible 
%   with extendent fuzzy rule structure.
% 
%   Compare also lines 44-49 of this function
%   with lines 41-46 of the original addrule.
% 
%   addrulex has two arguments. The first argument is the FIS name. 
%   The second argument for addrulex is a cell matrix of one or more rows, 
%   each of which represents a given rule. There must be exactly 4 
%   columns to the rule list. 
%   The first column refer to the inputs of the system. The column contains
%   2xn matrices. The first row of this matrix refers to the numbers of
%   input variables. The second row refers to the indicies of the
%   membership functions for that variable. Each input can appear in
%   antecendent part of rule several times, so n is an arbitrary integer
%   and depends only on rule complexity. 
%   The next column of rule list contains matrices with m columns that
%   refer to the m outputs of the system. Each column contains a number
%   that refers to the index of the membership function for that variable.
%   The third column of rule list contains the weight that is to be applied
%   to the rule. The weight must be a number between zero and one, and is
%   generally left as one.
%   The last column of rule list contains a 1 if the fuzzy operator for the
%   rule's antecedent is AND. It contains a 2 if the fuzzy operator is OR.
% 
%   Example:
%   ruleList = {
%   	[1, 1; 1, 3],         [1], [1], [1],
%   	[1, 1, 2; 1, -3, -2], [2], [1], [1]};
%   a = addrulex(a, ruleList); 
%   If the above system a has two inputs and one output, the first rule can
%   be interpreted as: "If input 1 is MF 1 and input 1 is MF 3, then output
%   1 is MF 1", the second rule: "If input 1 is MF 1 and input 1 is not 
%   MF 3 and input 2 is not MF 2, then output 1 is MF 2."

%   Per Konstantin A. Sidelnikov, 2009.

oldRuleList = getfisx(fis, 'rulelist');
newRuleList = [oldRuleList; rule];

fis = setfisx(fis, 'rulelist', newRuleList);

out = fis;