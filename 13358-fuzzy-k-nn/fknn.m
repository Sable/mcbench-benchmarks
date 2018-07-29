function [predicted,memberships, numhits] = fknn(data, labels, test, ...
	    testlabels, k_values, info, fuzzy)
% FKNN Fuzzy k-nearest neighbor classification algorithm.
% 	Y = FKNN(DATA, LABELS, TEST, TESTLABELS, K, INFO) Runs fuzzy
% 	k-nearest neighbors on the given data. DATA is a N-by-D data matrix
% 	consisting of N patterns each of which is D-dimensional. LABELS is a
% 	N-vector containing the class labels (1,2,...,C) for each pattern.
%	TEST is a M-by-D matrix consisting of M test patterns. TESTLABELS 
%	is an optional M-vector for the true class labels of the given test
%	data. If you don't have true labels, just give an empty matrix for this
%	TESTLABELS.
%	K is the number of nearest neighbors to look at. 
%	The algorithm will print an information line at every INFO test
%	patterns, if INFO>0. If INFO is zero, nothing will be printed. 
%	Y is a M-vector containing the predicted class labels for the given test
%	patterns.
%
% 	[Y,MEMS,HITS] = FKNN(DATA, LABELS, TEST, TESTLABELS, K, INFO) returns
% 	the fuzzy class-memberships values in MEMS, for each test pattern. It is
% 	a M-by-C matrix, C being the number of classes. 
%	HITS is the number of correctly predicted test patterns. Note that HITS
%	is meaningless if TESTLABELS is not provided. 
%
% 	[Y,MEMS,HITS] = FKNN(DATA, LABELS, TEST, TESTLABELS, K, INFO, FUZZY) If
% 	you don't want to do "fuzzy" k-nn, then give FUZZY as 'false'.
%
%	This m-file is capable of testing several k-values simultaneously. If
%	you pass a vector of k-values, rather than a single scalar, in K, then
%	each output variable is populated accordingly. So, if you give K as 
%	[5 10 15], then Y becomes M-by-3, MEMS M-by-C-by-3 and HITS  3-by-1.
%
%	References:
%	J. M. Keller, M. R. Gray, and J. A. Givens, Jr.,
%	"A Fuzzy K-Nearest Neighbor Algorithm",
%	IEEE Transactions on Systems, Man, and Cybernetics,
%	Vol. 15, No. 4, pp. 580-585.  
%
% TODO: Generalize this m-file to Lp norm
%
% Emre Akbas [eakbas2 @ uiuc.edu]  Dec 2006.
%

if nargin<7
    fuzzy = true;
end

num_train = size(data,1);
num_test  = size(test,1);

% scaling factor for fuzzy weights. see [1] for details
m = 2;

% convert class labels to unary membership vectors (of 1s and 0s)
max_class = max(labels);
temp = zeros(length(labels),max_class);
for i=1:num_train
    temp(i,:) = [zeros(1, labels(i)-1) 1 zeros(1,max_class - labels(i))];
end
labels = temp;
clear temp;

% allocate space for storing predicted labels 
predicted = zeros(num_test, length(k_values));

% allocate space for 'numhits'. This will only be used if 'testlabels' is
% provided
numhits = zeros(length(k_values),1);

% will the memberships be stored? if yes, allocate space
store_memberships = false;
if nargout > 1,
    store_memberships=true;
    memberships = zeros(num_test, max_class, length(k_values));
end

%% BEGIN kNN
% for each test point, do:
t0=clock;
tstart = t0;
for i=1:num_test
    distances = (repmat(test(i,:), num_train,1) - data).^2;
    % for efficiency, no need to take sqrt since it is a non-decreasing function
    distances = sum(distances,2)';

    % sort the distances
    [junk, indeces] = sort(distances);

    for k=1:length(k_values)
	neighbor_index = indeces(1:k_values(k));
	weight = ones(1,length(neighbor_index));
	if fuzzy, 
 	    % originally, this weight calculation should be: 
 	    % weight = distances(neighbor_index).^(-2/(m-1));
 	    % but since we didn't take sqrt above and the inverse 2th power
 	    % the weights are: 
 	    % weight = sqrt(distances(neighbor_index)).^(-2/(m-1));
	    % which is equaliavent to:
 	    weight = distances(neighbor_index).^(-1/(m-1));
 
 	    % set the Inf (infite) weights, if there are any, to  1.
 	    if max(isinf(weight))
 		warning(['Some of the weights are Inf for sample: ' ...
			num2str(i) '. These weights are set to 1.']);
 		weight(isinf(weight))=1;
 	    end
	end
	test_out = weight*labels(neighbor_index,:)/(sum(weight));

	if store_memberships, memberships(i,:,k) = test_out; end;

	% find predicted class (the one with the max. fuzzy vote)
	[junk, index_of_max] = max(test_out');

	predicted(i,k) = index_of_max;

	% compute current hit rate, if test labels are given
	if ~isempty(testlabels) && predicted(i,k)==testlabels(i)
	    numhits(k) = numhits(k)+1;
	end
    end

    % print info
    if mod(i,info)==0
	elapsed = etime(clock, t0);
	fprintf(1,['%dth sample done.  Elapsed (from previous info): %.2f' ...
	    ' sn.  Estimated left: %.2f sn.\n\tHit rate(s) so far:   '], ...
	    i, elapsed, etime(clock, tstart)*((num_test-i)/i) );
	for k=1:length(k_values)
	    fprintf(1,'%3d: %.3f\t',k_values(k), 100*numhits(k)/i);
	end
	fprintf(1,'\n');

	t0=clock; % start timer again
    end
end
