function net = train(data, labels, net, debug)
% TRAIN Trains the given SFAM network on the given labeled data. 
%	TNET = TRAIN(DATA, LABELS, NET, DEBUG) traines the given SFAM network NET on DATA with
%	labels LABELS. DATA is M-by-D matrix where M is the number of samples and D is the size of
%	the feature space. LABELS is a M-vector containing the labels for each data. NET can be an
%	untrained or previously trained SFAM network.
%	DEBUG is a scalar to control the verbosity of the program during training. If 0, nothing will
%	be printed, otherwise every DEBUG iterations an informatory line will be printed. 
%	
%	TNET is the trained NET.
%
% Emre Akbas, May 2006
%

%dbstop in train at 18

for e=1:net.epochs
    network_changed = false;

    tic;
    for s=1:size(data,1)

	if mod(s,debug)==0
	    elapsed = toc;
	    fprintf(1,'Training on %dth sample, in %dth epoch.\5# of prototypes=%4d\tElapsed seconds: %f\n',s,e,length(net.weights),elapsed);
	    tic;
	end

	input = data(s,:);
	input_label = labels(s);

	% Complement code input
	input = [input 1-input];

	% Set vigilance
	ro = net.vigilance;

	% By default, create_new_prototype=true. Only if 'I' resonates with
	% one of the existing prototypes, a new prot. will not be created
	create_new_prototype = true;

	% Compute the activation values for each prototype.
	activation = ones(1,length(net.weights));
	for i=1:length(net.weights)
	    activation(i)  = sum(min(input,net.weights{i}))/...
			(net.alpha + sum(net.weights{i}));
	end

	% Sort activation values 
	[sortedActivations, sortedIndices] = sort(activation,'descend');

	% Iterate over the prototypes with decreasing activation-value
	for p=sortedIndices
	    % Compute match of the current candidate prototype 
	    match = sum(min(input,net.weights{p}))/net.D;	% see note [1]

	    % Check resonance
	    if match>=ro
		% Check labels
		if input_label==net.labels(p)
		    % update the prototype
		    net.weights{p} = net.beta*(min(input,net.weights{p})) + ...
				(1-net.beta)*net.weights{p};
		    network_changed = true;
		    create_new_prototype = false;
		    break;
		else
		    % Match-tracking begins. Increase vigilance
		    ro = sum(min(input,net.weights{p}))/net.D + net.epsilon;
		end
	    end
	end


	if create_new_prototype
	    new_index = length(net.weights)+1;
	    if net.singlePrecision
		net.weights{new_index} = ones(1,2*net.D,'single');
	    else
		net.weights{new_index} = ones(1,2*net.D);
	    end

	    net.weights{new_index} = net.beta*(min(input,net.weights{new_index})) + ...
			    (1-net.beta)*net.weights{new_index};
	    
	    net.labels(new_index)  = input_label;
	    network_changed = true;
	end
    end % samples loop

    if ~network_changed
	fprintf(1,'Network trained in %d epochs.\n',e);
	break
    end
end % epochs loop


%
% NOTES:
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% [1] 'net.D' is written insyead of |input|. These values are equal.
%
