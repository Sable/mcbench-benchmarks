function results = classify(data, net, labels, debug);
% CLASSIFY Classifies the given data using the given trained SFAM.
% RESULTS = CLASSIFY(DATA, NET, LABELS, DEBUG) 
%	DATA is an M-by-D matrix where M is the number of samples and D is the size of the feature
%	space. NET is a previously trained SFAM network. LABELS is a M-vector containing the correct
%	labels for the data. If you don't have them, give it as an empty-vector []. 
%	DEBUG is a scalar to control the verbosity of the program during training. If 0, nothing will
%	be printed, otherwise every DEBUG iterations an informatory line will be printed. 
%
% Emre Akbas, May 2006
%

results = [];
hits=0;

tic;
for s=1:size(data,1)
    input = data(s,:);

    % Complement code input
    input = [input 1-input];

    % Compute the activation values for each prototype.
    activation = ones(1,length(net.weights));
    for i=1:length(net.weights)
	activation(i)  = sum(min(input,net.weights{i}))/...
		    (net.alpha + sum(net.weights{i}));
    end

    % Sort activation values 
    [sortedActivations, sortedIndices] = sort(activation,'descend');

    % Iterate over the prototypes with decreasing activation-value
    results(s)=-1;
    for p=sortedIndices
	% Compute match of the current candidate prototype 
	match = sum(min(input,net.weights{p}))/net.D;

	% Check resonance
	if match>=net.vigilance
	    results(s) = net.labels(p);

	    if ~isempty(labels)
		if labels(s)==results(s), hits = hits + 1; end;
	    end

	    break;
	end
    end

    if mod(s,debug)==0
	elapsed = toc;
	fprintf(1,'Tested %4dth sample. Hits so far: %3d which is %.3f%%.\tElapsed %.2f seconds.\n',s,hits,100*hits/s,elapsed);
	tic;
    end
end % samples loop
