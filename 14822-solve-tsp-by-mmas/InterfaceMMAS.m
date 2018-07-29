function [AlgOption,TSP] = InterfaceMMAS(TSPfile,AntNum,alpha,beta,rho,MaxITime)
%:Get the input parameters for MMAS
%Read in tsp data
[Dimension,Nodes,Weights,Name] = GetTSPData(TSPfile);
fprintf('Data of problem-%s have been read in!\n',Name);
%Set TSP datas
TSP = InitProblem(Dimension,Nodes,Weights,Name);
%Set parameters for MMAS algorithm
AlgOption = InitParameter(Dimension,AntNum,alpha,beta,rho,MaxITime);
% AlgOption = InitParameter(Dimension,Dimension,alpha,beta,rho,MaxITime);

%% --------------------------------------------------------------
function AlgorithmParas = InitParameter(Dimension,AntNum,alpha,beta,rho,MaxITime)
AlgorithmParas.n = Dimension; % nodes number in TSP
AlgorithmParas.m = AntNum; % ants number
AlgorithmParas.alpha = alpha; % pheromeno exponential
AlgorithmParas.beta = beta; % heuristic exponential
AlgorithmParas.rho = rho; % vapor parameter
AlgorithmParas.MaxITime = MaxITime; % Maximum Iterative Time
AlgorithmParas.delta = 0.05; % Parameter of Pheromone Trail Smoothing(PTS): (0,1) Turn Off By Setting 0
AlgorithmParas.lambda = 0; % coefficient of Average Node Branching: (0,1) Turn Off By Setting 0
AlgorithmParas.ANBmin = 2; % coefficient of minimum ANB
AlgorithmParas.DispInterval = 5; % Display Interval: Turn Off Display By Setting 0
AlgorithmParas.ReStartCount = 50; % Restart while no improvment for 50 iterations
%% --------------------------------------------------------------
function Problem = InitProblem(Dimension,Nodes,NodeWeight,Name)
n = Dimension;
MatrixTau = ones(n,n)-eye(n,n);
Problem.nodes = Nodes;
Problem.weights = NodeWeight;
Problem.tau = MatrixTau;
Problem.name = Name;