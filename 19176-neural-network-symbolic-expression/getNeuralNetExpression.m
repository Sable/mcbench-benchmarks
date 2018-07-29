function s = getNeuralNetExpression(net, outputIndex)

% getNeuralNetExpression (SUMO)
%     Originally part of the Surrogate Modeling Toolbox ("SUMO Toolbox")
%     Contact : sumo@intec.ugent.be - www.sumo.intec.ugent.be
%     This code is released under the GPL version 2 or later
%
% Description:
%     Return the symbolic expression for the given Matlab Neural Network
%     Note: only standard feed forward networks (created through newff) are supported
%        so no delays or combination functions other than netsum are supported.

if(~exist('outputIndex'))
	outputIndex = 1;
end

% Get the expression for the given output neuron
% The final expression is recursively built up
s = expressionForNeuron(net,net.numLayers,outputIndex,'');

	% calculate the expression for neuron number 'neuron' in layer 'layer'
	function s = expressionForNeuron(net,layer,neuron,s)
		% should the transfer function names be replaced by their equations
		flattenTfunc = 1;
		% precision for the weights and biases
		precision = '%0.6d';
		
		% base case of the recursion, the input layer
		if(layer == 1)
			% each input is denoted by xi
			str = '';
			% get the matrix of weights from the input layer to the inputs
			L = net.IW{layer,1};
			% NOTE: we only consider the netsum function (neuron activation is a weighted sum of inputs)
			for i=1:net.inputs{layer}.size;
				w = L(neuron,i);
				input = [ 'x' num2str(i)];
				str = [str input '*'  sprintf(precision,w) ' + '];
				%str = [str input '*'  num2str(w) ' + '];
			end
			% dont forget to add the bias
			biases = net.b{layer};
			bias = biases(neuron);
			str = [str sprintf(precision,bias)];
			%str = [str num2str(bias)];
			if(flattenTfunc)
				str = ['(' expressionForTfunc(net.layers{layer}.transferFcn,str) ')'];
			else
				str = [net.layers{layer}.transferFcn '(' str ')'];
			end
			s = str;
			%disp(sprintf('Input neuron %i: %s',neuron,s));
		else
			% calculate the expression for one of the hidden or output neurons
			fanIn = net.layers{layer-1}.size;
			L = net.LW{layer,layer-1};
			s = '';
			% again we only consider a weighted sum of inputs
			for i=1:fanIn
				w = L(neuron,i);
				% recurively call the function for each neuron in the fan-in
				input = expressionForNeuron(net,layer-1,i,s);
				s = [s input '*'  sprintf(precision,w) ' + '];
				%s = [s input '*'  num2str(w) ' + '];
			end
			% dont forget to add the bias
			biases = net.b{layer};
			bias = biases(neuron);
			s = [s sprintf(precision,bias)];
			%s = [s num2str(bias)];
			if(flattenTfunc)
				s = ['(' expressionForTfunc(net.layers{layer}.transferFcn,s) ')'];
			else
				s = [net.layers{layer}.transferFcn '(' s ')'];
			end
			%disp(sprintf('Layer %i neuron %i: %s',layer,neuron,s));
		end
	end

	% given a name of a matlab neural network transfer function, return the mathematical expression
	% applied to the given input argument s
	function expr = expressionForTfunc(tfunc,s)
		if(strcmp(tfunc,'tansig'))
			% definition: a = tansig(n) = 2/(1+exp(-2*n))-1
			expr = ['2/(1+exp(-2*(' s ')))-1'];
		elseif(strcmp(tfunc,'logsig'))
			% definition: logsig(n) = 1 / (1 + exp(-n))
			expr = ['1/(1+exp(-(' s ')))'];
		elseif(strcmp(tfunc,'radbas'))
			% definition: exp(-n^2)
			expr = ['exp(-(' s ')^2)'];
		elseif(strcmp(tfunc,'purelin'))
			expr = ['(' s ')'];
		else
			error('Unsupported transfer function');
		end
	end

end

% Information from the Mathworks website
%  Weight and Bias Values
%  
%  These properties define the network's adjustable parameters: its weight matrices and bias vectors.
%  
%  net.IW
%  
%  This property defines the weight matrices of weights going to layers from network inputs. It is always an Nl x Ni cell array, where Nl is the number of network layers (net.numLayers), and Ni is the number of network inputs (net.numInputs).
%  
%  The weight matrix for the weight going to the ith layer from the jth input (or a null matrix []) is located at net.IW{i,j} if net.inputConnect(i,j) is 1 (or 0).
%  
%  The weight matrix has as many rows as the size of the layer it goes to (net.layers{i}.size). It has as many columns as the product of the input size with the number of delays associated with the weight.
%  
%      *
%  
%        net.inputs{j}.size * length(net.inputWeights{i,j}.delays)
%  
%  These dimensions can also be obtained from the input weight properties.
%  
%      *
%  
%        net.inputWeights{i,j}.size
%  
%  net.LW
%  
%  This property defines the weight matrices of weights going to layers from other layers. It is always an Nl x Nl cell array, where Nl is the number of network layers (net.numLayers).
%  
%  The weight matrix for the weight going to the ith layer from the jth layer (or a null matrix []) is located at net.LW{i,j} if net.layerConnect(i,j) is 1 (or 0).
%  
%  The weight matrix has as many rows as the size of the layer it goes to (net.layers{i}.size). It has as many columns as the product of the size of the layer it comes from with the number of delays associated with the weight.
%  
%      *
%  
%        net.layers{j}.size * length(net.layerWeights{i,j}.delays)
%  
%  These dimensions can also be obtained from the layer weight properties.
%  
%      *
%  
%        net.layerWeights{i,j}.size
%  
%  net.b
%  
%  This property defines the bias vectors for each layer with a bias. It is always an Nl x 1 cell array, where Nl is the number of network layers (net.numLayers).
%  
%  The bias vector for the ith layer (or a null matrix []) is located at net.b{i} if net.biasConnect(i) is 1 (or 0).
%  
%  The number of elements in the bias vector is always equal to the size of the layer it is associated with (net.layers{i}.size).
%  
%  This dimension can also be obtained from the bias properties.
%  
%      *
%  
%        net.biases{i}.size

