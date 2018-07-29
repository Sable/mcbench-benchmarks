function [f_output f_votes]= eval_Stochastic_Bosque(Data,Random_Forest,varargin)

%Returns the output of the ensemble (f_output) as well
%as a [num_treesXnum_samples] matrix (f_votes) containing
%the outputs of the individual trees. 
%
%The 'oobe' flag allows the out-of-bag error to be used to 
%weight the final response (only for classification).

okargs =   {'oobe'};
defaults = {0};
[eid,emsg,oobe_flag] = internal.stats.getargs(okargs,defaults,varargin{:});

f_votes = zeros(numel(Random_Forest),size(Data,1));
oobe = zeros(numel(Random_Forest),1);

for i = 1 : numel(Random_Forest)
    f_votes(i,:) = eval_cartree(Data,Random_Forest(i));
    oobe(i) = Random_Forest(i).oobe;
end

switch lower(Random_Forest(1).method)
    case {'c','g'}           
        [unique_labels,~,f_votes]= unique(f_votes);
        f_votes = reshape(f_votes,numel(Random_Forest),size(Data,1));
        [~, f_output] = max(weighted_hist(f_votes,~oobe_flag+oobe_flag*oobe,numel(unique_labels)),[],1); %#ok<ASGLU>
        f_output = unique_labels(f_output);
    case 'r'
        f_output = mean(f_votes,1);
    otherwise
        error('No idea how to evaluate this method');
end
