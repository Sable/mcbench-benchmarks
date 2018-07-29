function [O] = forwardcomp(X,W,L)
%FORWARD COMPUTATION.
%	
%	Syntax
%     [O] = forwardcomp(X,W,L)
%
%	Description
%
%	  FORWARDCOMP computes the outputs for a multiple perceptron Neural Network 
%	  from its net input.
%
%	  FORWARDCOMP(X,W,L) takes:
%	    X - matrix of input patterns including one row of bias = 1.
%	    W - matrix of weights of the Network (cell vectors).
%	    L - vector of hidden layers and neurons per layer [m1 m2...mL].
%	  and returns 
%       O - The output of the network
%
%   
% Paul Acquatella, 08-02-2009
% Revised 08-02-2009
% Copyright Paul Acquatella
% $Revision: 1.1.6.2 $  $Date: 2009/08/02 18:21:07 $

%Calcular Numero de Salidas y de Capas Ocultas
Q = size(W{end},1);         %Numero de Salidas
H = size(L,2);              %Numero de Capas Ocultas "Depth"

%Inicializar los campos locales inducidos 'v'
v = cell(1,H+1);            
v{end} = zeros(Q,1);
for i=1:H;
    v{i} = zeros(L(:,i),1); 
end

%Inicializar las salidas 'y' de cada capa 
y = cell(1,H+1);            
y{end} = zeros(Q,1);
for i=1:H;
    y{i} = [zeros(L(:,i),1); 1]; 
end

for j = 1:(H+1)
    if j == 1
        v{j} = W{j}*X;                  %Compute the induced local field
        y{j}(1:end-1) = logsig(v{j});   %Compute the layer output
    elseif j == (H+1)
        v{j} = W{j}*y{j-1};             %Compute the induced local field
        y{j} = logsig(v{j});            %Compute the layer output
        O = y{j};                  
    else
        v{j} = W{j}*y{j-1};             %Compute the induced local field
        y{j}(1:end-1) = logsig(v{j});   %Compute the layer output
    end
end
