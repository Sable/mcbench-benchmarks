%% CostFunction.m 
% J  [OUT] : The objective Vector. J is a matrix with as many rows as
%            trial vectors in X.
% X   [IN] : Decision Variable Vector. X is a matrix with as many rows as
%            trial vector and as many columns as decision variables.
% Dat [IN] : Parameters defined in DE_TCRparam.m
% 
%%
%% Beta version 
% Copyright 2006 - 2012 - CPOH  
%
% Predictive Control and Heuristic Optimization Research Group
%      http://cpoh.upv.es
%
% ai2 Institute
%      http://www.ai2.upv.es
%
% Universitat Politècnica de València - Spain.
%      http://www.upv.es
%
%%
%% Author
% Gilberto Reynoso Meza
% gilreyme@upv.es
% http://cpoh.upv.es/en/gilberto-reynoso-meza.html
% http://www.mathworks.es/matlabcentral/fileexchange/authors/289050
%%
%% For new releases and bug fixing of this Tool Set please visit:
% 1) http://cpoh.upv.es/en/research/software.html
% 2) Matlab Central File Exchange
%%

%% Main call
function J=CostFunction(X,Dat)

if strcmp(Dat.CostProblem,'Rastrigin')
    J=Rastrigin(X,Dat);
elseif strcmp(Dat.CostProblem,'YourProblem')
    % Here comes the call for a cost function of your own problem. 
end

%% Calling Rastrigin function from matlab library.
function J=Rastrigin(X,~)

Xpop=size(X,1);
J=zeros(Xpop,1);

for xpop=1:Xpop
    J(xpop,1)=rastriginsfcn(X(xpop,:));
end
%
%% Write your own cost function here....


%% Release and bug report:
%
% November 2012: Initial release