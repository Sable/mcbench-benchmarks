% this program is designed for optimal substation placement
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SP_main()


clear;clc;
pack;
tic;
display('______________________________________ RESULTS STARTED _____________________________________');

global T L FinalTransPow FinalLoad FinalTransCap TransTypes AuxTransCap AuxTransPow K2 K3 MaxT
global SelCaseRow FinalTrans_x FinalTrans_y FinalLoad_x FinalLoad_x FinalLoad_y BrTransIndex
global AuxFinalTrans_x AuxFinalTrans_y AuxFinalLoad_x AuxFinalLoad_x AuxFinalLoad_y AuxFinalLoad
global FinalTLDistances VarCheckPrg
global finaltranspow finaltranscap
global PowerFactor UtilizationFactor TransformersTypes KWTransformersTypes
global InstallCosts OpenCircuitLosses ShortCircuitLosses
global CurrentTr_x CurrentTr_y
K2 = 0.0035e-3;
K3 = 0.64;
% determination of load centers & the vector of load values
DATA = xlsread('DATA.xls','Loads');
CANDIDATES = xlsread('DATA.xls','Candidates');
CURRENT_TRANSFORMERS = xlsread('DATA.xls','Current_Transformers');
DESIGN_CONSTANTS = xlsread('DATA.xls','Design_Constants');
TRANSFORMERS_TYPES = xlsread('DATA.xls','Transformers_Types');
ExcelLoad_x = DATA(:,1);
ExcelLoad_y = DATA(:,2);
ExcelLoads = DATA(:,3);
ExcelCandidates_x = CANDIDATES(:,1);
ExcelCandidates_y = CANDIDATES(:,2);
PowerFactor = DESIGN_CONSTANTS(1,1);
UtilizationFactor = DESIGN_CONSTANTS(1,2)/100;
TransformersTypes(1,:) = sort(TRANSFORMERS_TYPES(:,1));
KWTransformersTypes = ceil(UtilizationFactor*PowerFactor*TransformersTypes);
InstallCosts(1,:) = sort(TRANSFORMERS_TYPES(:,2));
OpenCircuitLosses(1,:) = sort(TRANSFORMERS_TYPES(:,3));
ShortCircuitLosses(1,:) = sort(TRANSFORMERS_TYPES(:,4));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Loads(1,:) = ExcelLoads(:,1);
Load_x(1,:) = ExcelLoad_x(:,1);
Load_y(1,:) = ExcelLoad_y(:,1);
Candidates_x(1,:) = ExcelCandidates_x(:,1);
Candidates_y(1,:) = ExcelCandidates_y(:,1);
if length(CURRENT_TRANSFORMERS) ~= 0
    CurrentTr_x = CURRENT_TRANSFORMERS(:,1)';
    CurrentTr_y = CURRENT_TRANSFORMERS(:,2)';
    CurrentTrCap = CURRENT_TRANSFORMERS(:,3)';
    CurrentTrPow = ceil(UtilizationFactor*PowerFactor*CurrentTrCap);
else
    CurrentTr_x = [];
    CurrentTr_y = [];
    CurrentTrCap = [];
    CurrentTrPow = [];
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize transformer locations and powers
% one transformer in every load center. initially we assume the first
% transformer for all candidate points.
TransTypes = length(TransformersTypes);
LoadCenters = length(ExcelLoads);
CurrentTrNo = length(CurrentTr_x);
CandidateNo = length(ExcelCandidates_x);
for count1=1:CurrentTrNo,
    if CurrentTrPow(1,count1) >= ceil((400*UtilizationFactor*PowerFactor))
        LimitedCurrentTrPow(1,count1) = KWTransformersTypes(1,6);
    else
        LimitedCurrentTrPow(1,count1) = KWTransformersTypes(1,1);
    end;
end;
Trans_x = [CurrentTr_x Candidates_x]; 
Trans_y = [CurrentTr_y Candidates_y];
TransCap = [LimitedCurrentTrPow (KWTransformersTypes(1,1) + zeros(1,length(ExcelCandidates_x)))];
CandidateCenters = length(TransCap); % current + candidate transformers
TransPow = zeros(1,CandidateCenters);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculation of the distances between transformers
% this is a matrice with dimensions: (LoadCenters)*(CandidateCenters)
Distances = zeros(LoadCenters,CandidateCenters);
for count1=1:LoadCenters,
    for count2=1:CandidateCenters,
        Distances(count1,count2) = sqrt((Load_x(1,count1)-Trans_x(1,count2))^2 + (Load_y(1,count1)-Trans_y(1,count2))^2);
    end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CanDistances = zeros(CandidateCenters);
for count1=1:CandidateCenters,
    for count2=1:count1,
        CanDistances(count1,count2) = sqrt((Trans_x(1,count1)-Trans_x(1,count2))^2 + (Trans_y(1,count1)-Trans_y(1,count2))^2);
        CanDistances(count2,count1) = CanDistances(count1,count2);
    end;
end;        
% the distances are pairly compared with 100, if they are smaller than 100
% the transformer with smaller value of load is detached.
for count1=1:CandidateCenters,
    for count2=1:CandidateCenters,
        if (CanDistances(count1,count2) <= 100) & (count1 ~= count2) & (count1 > CurrentTrNo)
            TransCap(1,count1) = 0;
            TransPow(1,count1) = 0;
        end;
    end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function step-up the transformers size until it can feed the total
% loads connected to it.
% for count1=1:TransTypes,
%     for count2=1:LoadCenters,
%         if (TransCap(1,count2) < Loads(1,count2)) && (TransCap(1,count2) ~= 0)
%             TransCap(1,count2) = SP_stepup(TransCap(1,count2));
%         end;
%     end;
% end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% in this subsection, the coordinations of the final possible transformers
% are saved in FinalTrans_x & FinalTrans_y and their values in
% FinalTransCap. similarly, the coordinations of the loadcenters to be
% attached to transformers are saved in FinalLoad_x & FinalLoad_y and their
% values in FinalLoad.
T = 1; L = LoadCenters;
for count1 = 1:CandidateCenters,
    if (TransCap(1,count1) ~= 0)
        FinalTransCap(1,T) = TransCap(1,count1);
        FinalTransPow(1,T) = 0;
        FinalTrans_x(1,T) = Trans_x(1,count1);
        FinalTrans_y(1,T) = Trans_y(1,count1);
        T = T+1;
    end;
end;
MaxT = T-1;
% MinL = L-1;
% if ((MaxT > 23) & (VarCheckPrg == 1))
%     warndlg('MATLAB unable to solve! Try smaller number of loads',' DSP Warning');
%     display('MATLAB unable to solve! Try smaller number of loads');
%     return;
% end; 
AuxTransCap = FinalTransCap;
AuxTransPow = FinalTransPow;
AuxFinalTrans_x = FinalTrans_x;
AuxFinalTrans_y = FinalTrans_y;
AuxFinalLoad_x = Load_x;
AuxFinalLoad_y = Load_y;
AuxFinalLoad = Loads;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculation of Distances beetween transformers and loads in a (MinL*MaxT) matrice. 
for count1=1:LoadCenters,
    for count2=1:MaxT,
        TLDistances(count1,count2) = sqrt((AuxFinalLoad_x(1,count1)-AuxFinalTrans_x(1,count2))^2 + (AuxFinalLoad_y(1,count1)-AuxFinalTrans_y(1,count2))^2);
    end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HERE, THE OPERATION OF GENETIC ALGORITHM IS STARTED.
TotalLevels = 0;
LowLim = CurrentTrNo;
MaxLim = LowLim + (MaxT-CurrentTrNo);
for count5=LowLim:MaxLim,
    TotalLevels = TotalLevels + ceil(nchoosek(MaxT,count5));
end;
ScalingFactor = ceil(TotalLevels/20);
TotalLevels = ceil(TotalLevels/ScalingFactor);
Index = 0;
TMat = [(CurrentTrNo+1):MaxT];
% if ((TotalLevels < 20) & (VarCheckPrg == 1))
%     warndlg('Try smaller Scaling Factor!',' DSP Warning');
%     display('Try smaller Scaling Factor!');
%     return;
% end;
% if ((TotalLevels > 300) & (VarCheckPrg == 1))
%     warndlg('Try bigger Scaling Factor!',' DSP Warning');
%     display('Try bigger Scaling Factor!');
%     return;
% end;
% if ((VarCheckPrg == 1) & ((TotalLevels <= 300) & (TotalLevels >= 20)))
%     warndlg('No problem in running program. Push "Run DSP"',' DSP Warning');
%     LEVELS = TotalLevels;
%     LEVELS
%     display('No problem in running program. Push "Run DSP"');
%     return;
% end;
close all;
pack;
cfinaltranscap = cell(TotalLevels,1);
cfinaltranspow = cell(TotalLevels,1);
cfinaltrans_x = cell(TotalLevels,1);
cfinaltrans_y = cell(TotalLevels,1);
cfinalload = cell(TotalLevels,1);
cfinalload_x = cell(TotalLevels,1);
cfinalload_y = cell(TotalLevels,1);
pack;
h = waitbar(0,'Please wait...');
for count1=0:(MaxLim-LowLim),   % MAIN for. NOTE: "count1" stands for the number of new trans.
    T = LowLim + count1;        % "LowLim" stands for the number of current transformers.
    numberOfVariables = LoadCenters;
    L = numberOfVariables;
    SelCaseMat = nchoosek(TMat,count1);
    SIZE = size(SelCaseMat);
    RowNumber = SIZE(1,1);
    for count2=1:ScalingFactor:RowNumber,
        Index = Index + 1;
        Level = Index;
        SelCaseRow = [[1:CurrentTrNo] SelCaseMat(count2,:)];  % SelCaseRow should be sent to SP_create.m. It is a selection of transformers
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % modifying FinalTrans_x,y & FinalLoad_x,y & FinalLoad &
        % FinalTransPow & FinalTransCap
        finaltranscap = zeros(1,MaxT) -1;
        finaltranspow = zeros(1,MaxT) -1;
        finaltrans_x = zeros(1,MaxT) -1;
        finaltrans_y = zeros(1,MaxT) -1;
        for count3=1:T,
            finaltranscap(1,SelCaseRow(1,count3)) = AuxTransCap(1,SelCaseRow(1,count3));
            finaltranspow(1,SelCaseRow(1,count3)) = AuxTransPow(1,SelCaseRow(1,count3));
            finaltrans_x(1,SelCaseRow(1,count3)) = AuxFinalTrans_x(1,SelCaseRow(1,count3));
            finaltrans_y(1,SelCaseRow(1,count3)) = AuxFinalTrans_y(1,SelCaseRow(1,count3));
        end;
        FinalTransCap = finaltranscap;
        FinalTransPow = finaltranspow;
        FinalTrans_x = finaltrans_x;
        FinalTrans_y = finaltrans_y;
        cfinaltranscap{Index} = finaltranscap;
        cfinaltranspow{Index} = finaltranspow;
        cfinaltrans_x{Index} = finaltrans_x;
        cfinaltrans_y{Index} = finaltrans_y;
        finalload = Loads;
        finalload_x = Load_x;
        finalload_y = Load_y;
%         Li = 0;
%         for count3=1:LoadCenters,
%             if (size(find(FinalTrans_x==Load_x(1,count3)))==[1 0] | size(find(FinalTrans_y==Load_y(1,count3)))==[1 0])
%                 Li = Li + 1;
%                 finalload(1,Li) = Loads(1,count3);
%                 finalload_x(1,Li) = Load_x(1,count3);
%                 finalload_y(1,Li) = Load_y(1,count3);
%             end;
%         end;
        FinalLoad = finalload;
        FinalLoad_x = finalload_x;
        FinalLoad_y = finalload_y;
        cfinalload{Index} = finalload;
        cfinalload_x{Index} = finalload_x; 
        cfinalload_y{Index} = finalload_y;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % calculation of Distances beetween transformers and loads in a (L*T) matrice. 
        Li = 0;
        FinalTLDistances = 0;
        BrFinalTransPow = zeros(1,T);
        BrFinalTransCap = zeros(1,T);
        BrFinalTrans_x = zeros(1,T);
        BrFinalTrans_y = zeros(1,T);
        BrTransIndex = zeros(1,T);
        for count3=1:MaxT,
            if (FinalTrans_x(1,count3)~=-1)
                Li = Li + 1;
                BrFinalTransPow(1,Li) = FinalTransPow(1,count3);
                BrFinalTransCap(1,Li) = FinalTransCap(1,count3);
                BrFinalTrans_x(1,Li) = FinalTrans_x(1,count3);
                BrFinalTrans_y(1,Li) = FinalTrans_y(1,count3);
                BrTransIndex(1,Li) = count3;
            end;
        end;
        for r=1:L,
            for s=1:T,
                FinalTLDistances(r,s) = sqrt((FinalLoad_x(1,r)-BrFinalTrans_x(1,s))^2 + (FinalLoad_y(1,r)-BrFinalTrans_y(1,s))^2);
            end;
        end;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        FitnessFcn = @(x) SP_fitness(x,FinalTLDistances);
        options = gaoptimset('PopulationType', 'custom','PopInitRange', ...
                     [1;L]);
        options = gaoptimset(options,'CreationFcn',@SP_create, ...
                             'CrossoverFcn',@SP_crossover, ...
                             'MutationFcn',@SP_mutation, ...
                             'Generations',150,'PopulationSize',50, ...
                             'StallGenLimit',20,'StallTimeLimit',inf,'Vectorized','on');

        [x(1,Index),fval(1,Index)] = ga(FitnessFcn,numberOfVariables,options);
        pack;
    end;
    Str1 = num2str(floor((Level*100)/((MaxLim-LowLim)+1)));
    Str2 = '% ';
    Str3 = ' of 100% Completed';
    Message = strcat(Str1,Str2,Str3);
    disp(Message); disp('...');
    waitbar(Level/((MaxLim-LowLim)+1));
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% here, we increase transformers capacities till they could feed 
% their related loads.
close(h);    % closes waiting bar
[BestVal,BestValIndex] = min(fval);
Fitness_Function_Best_Value = BestVal;
X = x{BestValIndex};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% At the end, transformers are stated in terms of their capacities (kVA).
% these are saved in "Transformers" variable. note that the positions of 
% final transformers are saved in FinalTrans_x & FinalTrans_y.
% similarly, final loads and their locations are saved in FinalLoad & 
% FinalLoad_x & FinalLoad_y respectively. Then, every load is connected to
% it's correspounding transformer.
L = length(X);
% T = LoadCenters - L;
FinalTransCap = cfinaltranscap{BestValIndex};
FinalTransPow = cfinaltranspow{BestValIndex};
FinalTrans_x = cfinaltrans_x{BestValIndex};
FinalTrans_y = cfinaltrans_y{BestValIndex};
FinalLoad = cfinalload{BestValIndex};
FinalLoad_x = cfinalload_x{BestValIndex};
FinalLoad_y = cfinalload_y{BestValIndex};
for count1=1:MaxT,
    if (FinalTrans_x(1,count1)~=-1)
        FinalTransPow(1,count1) = AuxTransPow(1,count1);
        FinalTransCap(1,count1) = AuxTransCap(1,count1);
    end;
end;
Li = 0;
BrFinalTransPow = zeros(1,T);
BrFinalTransCap = zeros(1,T);
BrFinalTrans_x = zeros(1,T);
BrFinalTrans_y = zeros(1,T);
for count1=1:L,
    FinalTransPow(1,X(count1,2)) = FinalTransPow(1,X(count1,2)) + FinalLoad(1,X(count1,1));
end;
for count3=1:MaxT,
    if (FinalTrans_x(1,count3) ~= -1)
        Li = Li + 1;
        BrFinalTrans_x(1,Li) = FinalTrans_x(1,count3);
        BrFinalTrans_y(1,Li) = FinalTrans_y(1,count3);
        BrFinalTransPow(1,Li) = FinalTransPow(1,count3);  % last added
        BrFinalTransCap(1,Li) = FinalTransCap(1,count3);  % last added
    end;
end;
% newly added for constant transformers positions
T = Li;
%%%%%%%%%%%%%%%%DELETING ZERO TRANSFORMERS%%%%%%%%%%%%%%%%%%%%%%%%
Lj = 1; %an auxalary variable
for count3=1:MaxT
    if (count3 <= CurrentTrNo)
        DEL_POW(1,Lj) = BrFinalTransPow(1,count3);
        DEL_CAP(1,Lj) = BrFinalTransCap(1,count3);
        DEL_X(1,Lj) = BrFinalTrans_x(1,count3);
        DEL_Y(1,Lj) = BrFinalTrans_y(1,count3);
        Lj = Lj + 1;
    elseif (BrFinalTransPow(1,count3) ~= 0)
        DEL_POW(1,Lj) = BrFinalTransPow(1,count3);
        DEL_CAP(1,Lj) = BrFinalTransCap(1,count3);
        DEL_X(1,Lj) = BrFinalTrans_x(1,count3);
        DEL_Y(1,Lj) = BrFinalTrans_y(1,count3);
        Lj = Lj + 1;
    end
end
BrFinalTransPow = DEL_POW;
BrFinalTransCap = DEL_CAP;
BrFinalTrans_x = DEL_X;
BrFinalTrans_y = DEL_Y;
Lj = Lj -1;
T = Lj;
%%%%%%%%%%%%%%%%ENND OF DELETING ZERO TRANSFORMERS%%%%%%%%%%%%%%%%
% newly added for constant transformers positions
for count1=1:TransTypes,
    for count2=1:T,
        if (BrFinalTransCap(1,count2) < BrFinalTransPow(1,count2))
            BrFinalTransCap(1,count2) = SP_stepup(BrFinalTransCap(1,count2),BrFinalTrans_x(1,count2),BrFinalTrans_y(1,count2));
        end;
    end;
end;
for count1=1:T,
    Transformers(1,count1) = SP_2kva(BrFinalTransCap(1,count1));
end;
% PLOTs
plot(Load_x,Load_y,'bo');
hold on;
for count1=1:T,
    if (count1 <= CurrentTrNo)  % new transformers are RED
        plot(BrFinalTrans_x(1,count1),BrFinalTrans_y(1,count1),'b*');
        hold on;
    else
        plot(BrFinalTrans_x(1,count1),BrFinalTrans_y(1,count1),'r*');
        hold on;
    end;
end;
for count1=1:L,
    TOEXCELCONNECTIONS(count1,1) = count1;
    TOEXCELCONNECTIONS(count1,2) = FinalLoad_x(1,X(count1,1));
    TOEXCELCONNECTIONS(count1,3) = FinalLoad_y(1,X(count1,1));
    TOEXCELCONNECTIONS(count1,4) = FinalTrans_x(1,X(count1,2));
    TOEXCELCONNECTIONS(count1,5) = FinalTrans_y(1,X(count1,2));
    plot([FinalLoad_x(1,X(count1,1)) FinalTrans_x(1,X(count1,2))],[FinalLoad_y(1,X(count1,1)) FinalTrans_y(1,X(count1,2))],'g');
    hold on;
end;
for count1=1:T,
    TextTransformers(1,count1) = {num2str(Transformers(1,count1))};
end;
for count1=1:T,
    text(BrFinalTrans_x(1,count1)-30,BrFinalTrans_y(1,count1)+40,TextTransformers(1,count1),'FontSize',20,'Color','red');
    hold on;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% new
for count1=1:T,
    plot(BrFinalTrans_x(1,count1),BrFinalTrans_y(1,count1),'r*');
    hold on;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% new
for count1=1:LoadCenters,
    TextAllLoads(1,count1) = {num2str(Loads(1,count1))};
end;
for count1=1:LoadCenters,
    text(Load_x(1,count1)-5,Load_y(1,count1)-20,TextAllLoads(1,count1),'FontSize',8);
    hold on;
end;
TransOverLoad = 0;
TransOverLoadCandIndex = find(BrFinalTransCap == KWTransformersTypes(1,TransTypes)); % check for overloaded trans.. compared with a 1600kVA
Size = length(TransOverLoadCandIndex);
for count1=1:Size,
    if BrFinalTransPow(1,TransOverLoadCandIndex(1,count1)) > BrFinalTransCap(1,TransOverLoadCandIndex(1,count1))
        TransOverLoad = 1;
        break;
    end;
end;
if TransOverLoad == 1
    warndlg('OverLoaded transformer(s) found!',' DSP Warning');
end;
grid on;
% OUTPUTS in command window
delete ('RESULT.xls');
BrFinalTrans_x
BrFinalTrans_y 
Transformers
xlswrite('RESULT.xls',Transformers','Trans Capacities (kVA)');
xlswrite('RESULT.xls',BrFinalTransPow','Trans Powers (kW)');
xlswrite('RESULT.xls',BrFinalTrans_x','Ttans X coordinates');
xlswrite('RESULT.xls',BrFinalTrans_y','Ttans Y coordinates');
xlswrite('RESULT.xls',TOEXCELCONNECTIONS,'Load(X,Y)-Trans(X,Y) Links');
toc;
display('_______________________________________ RESULTS TERMINATED _________________________________');
