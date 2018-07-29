function pairs(X, varargin)

%This function is analagous to pairs() in R, where it plots a matrix of
%scatter plots comparing different variables(vectors). It also plots
%histograms in the diagonal spots. The input is:
%     X:    (nxp) matrix, where n is the number of data points, and p is
%           the number of variables. Each column is a vector of n values.
%     varagin:  this is optional, and is a cell array containing names of
%               variables. Calling pairs(X) will require you to enter the
%               variable names. Calling pairs(X,0) will not require you
%               to enter the variable names, but the axes will be unlabeled.
%
% example: X = [randn(100,1) rand(100,1)]; 
%          names = {'name1' 'name2'};
%          pairs(X, names);
%
%10/28/12 TJB



% only want 1 optional inputs
if  length(varargin) > 1
    error('TooManyInputs: requires at most 1 optional inputs');
elseif isempty(varargin) %if no name input was given
    for k = 1:size(X,2)
        prompt{k} = 'Input variable names, in order';
    end
    names = inputdlg(prompt); %GUI for inputing variable names
elseif ~iscell(varargin{1})
    names = {};
else
    names = varargin{1};
end

n_var = size(X, 2);
pt_size = 3; %size of scatter plot points

%create scatter plot matrix
if isempty(names) %no names included
    for i = 1:n_var
        subplot(n_var,n_var, sub2ind([n_var, n_var], i, i));
         hist(X(:,i), log2(length(X(:,i))+1)); %Sturges' formula for nbins
        for j = 1:n_var
            if j == i
                continue
            end
            subplot(n_var, n_var, sub2ind([n_var, n_var], i, j)); 
            scatter(X(:,i), X(:,j), pt_size);
        end
    end

else %when names are included
     for i = 1:n_var
        subplot(n_var,n_var, sub2ind([n_var, n_var], i, i)); 
        hist(X(:,i), log2(length(X(:,i))+1)); title([names{i}]);
        for j = 1:n_var
            if j == i
                continue
            end
            subplot(n_var, n_var, sub2ind([n_var, n_var], i, j)); 
            scatter(X(:,i), X(:,j), pt_size); xlabel([names{i}]); ylabel([names{j}]);
        end
     end

end

