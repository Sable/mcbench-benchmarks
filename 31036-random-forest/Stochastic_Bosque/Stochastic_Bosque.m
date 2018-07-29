function Random_Forest = Stochastic_Bosque(Data,Labels,varargin)

%Random_Forest = Stochastic_Bosque(Data,Labels,varargin)
%
%   Creates an ensemble of CARTrees using Data(samplesXfeatures).
%   The following parameters can be set :
%
%       ntrees       : number of trees in the ensemble (default 50)
%
%       oobe         : out-of-bag error calculation, 
%                      values ('y'/'n' -> yes/no) (default 'n')
%
%       nsamtosample : number of randomly selected (with
%                      replacement) samples to use to grow
%                      each tree (default num_samples)
%
%
%   Furthermore the following parameters can be set regarding the
%   trees themselves :
%
%       method       : the criterion used for splitting the nodes
%                           'g' : gini impurity index (classification)
%                           'c' : information gain (classification)
%                           'r' : squared error (regression)
%
%       minparent    : the minimum amount of samples in an impure node
%                      for it to be considered for splitting
%
%       minleaf      : the minimum amount of samples in a leaf
%
%       weights      : a vector of values which weigh the samples 
%                      when considering a split
%
%       nvartosample : the number of (randomly selected) variables 
%                      to consider at each node 

okargs =   {'minparent' 'minleaf' 'nvartosample' 'ntrees' 'nsamtosample' 'method' 'oobe' 'weights'};
defaults = {2 1 round(sqrt(size(Data,2))) 50 numel(Labels) 'c' 'n' []};
[eid,emsg,minparent,minleaf,m,nTrees,n,method,oobe,W] = getargs(okargs,defaults,varargin{:});

for i = 1 : nTrees
     
    TDindx = round(numel(Labels)*rand(n,1)+.5);
%    TDindx = unique(TDindx);
%     TDindx = randsample(numel(Labels),n,true);
%     TDindx = unique(TDindx);
    
    Random_ForestT = cartree(Data(TDindx,:),Labels(TDindx), ...
        'minparent',minparent,'minleaf',minleaf,'method',method,'nvartosample',m,'weights',W);
    
    Random_ForestT.method = method;

    Random_ForestT.oobe = 1;
    if strcmpi(oobe,'y')        
        NTD = setdiff(1:numel(Labels),TDindx);
        tree_output = eval_cartree(Data(NTD,:),Random_ForestT)';
        
        switch lower(method)        
            case {'c','g'}                
                Random_ForestT.oobe = numel(find(tree_output-Labels(NTD)==0))/numel(NTD);
            case 'r'
                Random_ForestT.oobe = sum((tree_output-Label(NTD)).^2);
        end        
    end
    
    Random_Forest(i) = Random_ForestT;
end