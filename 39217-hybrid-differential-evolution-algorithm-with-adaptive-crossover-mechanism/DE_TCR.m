%% DE_TCRparam
% Runs the DE_TCR optimization algorithm.
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
%% Overall Description
% This code implements a modified version of the single-objective 
% optimization algorithm described at:
%
% G. Reynoso; J. Sanchis; X. Blasco; Juan M. Herrero. Hybrid DE Algorithm 
% With Adaptive Crossover Operator For Solving Real-World Numerical 
% Optimization Problems. In IEEE Congress on Evolutionary Computation. 
% CEC 2011. (ISBN 978-1-4244-7833-0). New Orleans (USA). June 2011.
%
%%

function OUT=DE_TCR(DE_TCRDat)

%% Reading parameters from DE_TCRDat

% Problem to solve

Generations  = DE_TCRDat.MAXGEN;    % Generations.
Nvar         = DE_TCRDat.NVAR;      % Number of decision variables.
Bounds       = DE_TCRDat.FieldD;    % Optimization Bounds.
Initial      = DE_TCRDat.Initial;   % (Re)Initialization Bounds.
sop          = DE_TCRDat.sop;       % Cost function.

% Local Search

RateLS       = DE_TCRDat.RateLS;    % Probability for Local Search.

% Adaptive Mechanism

MaxCr = DE_TCRDat.TCR(1,3);         % Maximum Crossover rate.
MedCr = DE_TCRDat.TCR(1,2);         % Median Crossover rate.
MinCr = DE_TCRDat.TCR(1,1);         % Minimum Crossover rate.
MaxF  = DE_TCRDat.TF(1,3);          % Maximum Scaling Factor.
MedF  = DE_TCRDat.TF(1,2);          % Median Scaling Factor.
MinF  = DE_TCRDat.TF(1,1);          % Minimum Scaling Factor.

recombination = DE_TCRDat.Recomb;   % Linear recombination factor.
CRsuccess = DE_TCRDat.CRsuccess;    % Threshold for CR successes.

% Population Management

Xpop        = DE_TCRDat.Xpop;       % Population Size.
GammaVar    = DE_TCRDat.GammaVar;   % Interquartil difference for refresh.
minVarPop   = DE_TCRDat.minVarPop;  % Minimum diversity in population.
XpopRefresh = DE_TCRDat.XpopRefresh;% Population Refresh size.

%% Initialization of variables

% Adaptive Mechanism

ParamEVO = ...
    zeros(DE_TCRDat.CRsuccess,1);   % To record successful values on CR.
SuccessEvoCr = 0;                   % To recor successes on CR.

% Population

Child=zeros(Xpop,Nvar);             % Child population
Parent=zeros(Xpop,Nvar);            % Parent Population
Mutant=zeros(Xpop,Nvar);            % Mutant Population
JxParent=zeros(Xpop,1);             % Fitness of Parento Population.

%% Population for evolutionary process

PopParent=zeros(Xpop,Nvar);         % Population initialization

for xpop=1:Xpop                     % Uniform distribution
    for nvar=1:Nvar
        PopParent(xpop,nvar) = Initial(nvar,1) + ...
            (Initial(nvar,2) - Initial(nvar,1))*rand();
    end
end

JxPopParent = sop(PopParent,DE_TCRDat);
FES = Xpop;

%% Evolution process

for n=1:Generations
    
    DE_TCRDat.CounterGEN=n;
    OUT.JxPopParent=JxPopParent;
    OUT.JxParent=JxParent;
    OUT.Param=DE_TCRDat;
    OUT.TCR=[MinCr MedCr MaxCr]; 
    
    [OUT DE_TCRDat]=PrinterDisplay(OUT,DE_TCRDat); % To display results.

    
    %% Population Refreshment Mechanism
    VarPop=iqr(PopParent); % Measuring the interquartile range difference.
    
    if VarPop<=((Initial(:,2)-Initial(:,1))')/GammaVar %We need a refresh.
        LookingBest=sortrows([JxPopParent PopParent]);
        if VarPop<minVarPop
            Initial(:,1) = (median(PopParent))' - minVarPop';
            Initial(:,2) = (median(PopParent))' + minVarPop';
        else
            Initial(:,1) = (median(PopParent))' - ...
                (Initial(:,2)-Initial(:,1))/GammaVar;
            Initial(:,2) = (median(PopParent))' + ...
                (Initial(:,2)-Initial(:,1))/GammaVar;
        end
        for nvar=1:Nvar % Checking bounds
            if Initial(nvar,1) < Bounds(nvar,1)
                Initial(nvar,1) = Bounds(nvar,1);
            end
            if Initial(nvar,2) > Bounds(nvar,2)
                Initial(nvar,2) = Bounds(nvar,2);
            end
        end
        
        VVrefresh=zeros(Xpop-DE_TCRDat.XpopRefresh,Nvar);
        
        for xpop=1:Xpop-DE_TCRDat.XpopRefresh % New individuals.
            for nvar=1:Nvar
                VVrefresh(xpop,nvar) = Initial(nvar,1) + ...
                    (Initial(nvar,2) - Initial(nvar,1))*rand();
            end
        end
        
        FES=FES+Xpop;
        
        PopParent=[VVrefresh;
            LookingBest(1:XpopRefresh,2:end)];
        %We keep the best individuals + New individuals
        
        JxPopParent = sop(PopParent,DE_TCRDat); %Evaluate New Individuals.
    end
    
    ParamEvo=zeros(Xpop,4); % Parameter matrix initialization.
    
    %% Adaptive Mechanism
    
    for xpop=1:Xpop % Calculating DE parameters for each individual.
        % Scaling Factor.
        randU=rand;
        if randU<(MedF-MinF)*(2/(MaxF-MinF))*0.5
            ParamEvo(xpop,1) = ...
                MinF+sqrt(randU*(MaxF-MinF)*(MedF-MinF));
        else
            ParamEvo(xpop,1) = ...
                MaxF-sqrt((1-randU)*(MaxF-MinF)*(MaxF-MedF));
        end
        
        % CrossOver Rate.
        randU=rand;
        if randU<(MedCr-MinCr)*(2/(MaxCr-MinCr))*0.5
            ParamEvo(xpop,2) = ...
                MinCr+sqrt(randU*(MaxCr-MinCr)*(MedCr-MinCr));
        else
            ParamEvo(xpop,2) = ...
                MaxCr-sqrt((1-randU)*(MaxCr-MinCr)*(MaxCr-MedCr));
        end
    end
    
    Parent=PopParent;
    JxParent=JxPopParent;
    
    %% DE ALGORITHM
    
    for xpop=1:Xpop
        
        rev=randperm(Xpop);
        ScalingFactor=ParamEvo(xpop,1);
        
        % Mutant vector calculation.
        Mutant(xpop,:)= Parent(rev(1,1),:)+ScalingFactor*...
            (Parent(rev(1,2),:)-Parent(rev(1,3),:));
        
        for nvar=1:Nvar % Bounds are always verified.
            if Mutant(xpop,nvar)<Bounds(nvar,1)
                Mutant(xpop,nvar) = Bounds(nvar,1);
            elseif Mutant(xpop,nvar)>Bounds(nvar,2)
                Mutant(xpop,nvar)=Bounds(nvar,2);
            end
        end
        
        % Child calculation.
        
        FlagCr=0;  % Counter for ¿Child=Mutant?
        FlagCr2=0; % Counter for ¿Child=Paretn?
        CRrate=ParamEvo(xpop,2);
        if Nvar > 1
            for nvar=1:Nvar
                if CRrate>=0.95 % We try a Lineal Recombination.
                    Child(xpop,:)=Parent(xpop,:) + ...
                        recombination.*(Mutant(xpop,:)-Parent(xpop,:));
                    FlagCr=1;
                else % We try a binomial recombination.
                    if rand() > CRrate
                        Child(xpop,nvar) = Parent(xpop,nvar);
                        FlagCr=1;
                        FlagCr2=FlagCr2+1;
                    else
                        Child(xpop,nvar) = Mutant(xpop,nvar);
                    end
                end
            end
        end
        
        
        % If Child==Mutant, with a low CRrate,
        % we keep at least one decision variable from the Parent.
        if FlagCr==0 && CRrate<0.5
            j=randperm(Nvar);
            Child(xpop,j(1,1))=Parent(xpop,j(1,1));
        end
        
        % If Child==Mutant, with a high CRrate,
        % we force a lineal recombination.
        if FlagCr==0 && CRrate>=0.5 && CRrate<0.95
            Child(xpop,:)=Parent(xpop,:) + ...
                recombination.*(Mutant(xpop,:)-Parent(xpop,:));
        end
        
        % if Child==Parent,
        % we keep at least one decision variable from the Mutant.
        if FlagCr2==Nvar
            j=randperm(Nvar);
            Child(xpop,j(1,1))=Mutant(xpop,j(1,1));
        end
        
        for nvar=1:Nvar % Bounds are always verified.
            if Child(xpop,nvar) < Bounds(nvar,1)
                Child(xpop,nvar) = Bounds(nvar,1);
            elseif Child(xpop,nvar) > Bounds(nvar,2)
                Child(xpop,nvar) = Bounds(nvar,2);
            end
        end
        
        %% Local Search
        
        if rand>RateLS % We decide to perform a Local Search.
            [Child(xpop,:),~,FVAL] = ...
                DE_TCRDat.sopLS(Child(xpop,:),DE_TCRDat);
            FES=FES+FVAL;
            if FES>DE_TCRDat.MAXFUNEVALS || n>DE_TCRDat.MAXGEN
                disp('Optimization terminated.')
                break;
            end
        end
        
    end
    %% Selection process
    
    JxChild = sop(Child,DE_TCRDat);
    FES=FES+Xpop;
    
    if FES>DE_TCRDat.MAXFUNEVALS || n>DE_TCRDat.MAXGEN
        disp('Optimization terminated.')
        break;
    end
    
    for xpop=1:Xpop
        if JxChild(xpop,:) <= JxParent(xpop,:)
            ParamEvo(xpop,4)=1;
            SuccessEvoCr=SuccessEvoCr+1;
            ParamEVO(SuccessEvoCr,1) = ...
                ParamEvo(xpop,2); % We keep record of a success.
            Parent(xpop,:) = Child(xpop,:);
            JxParent(xpop,:) = JxChild(xpop,:);
        end
    end
        
    OUT.JxPopParent=JxPopParent;
    OUT.JxParent=JxParent;
    OUT.Param=DE_TCRDat;
    PopParent=Parent;
    JxPopParent=JxParent;
    
    DE_TCRDat.CounterFES=FES;
    
    [OUT DE_TCRDat]=PrinterDisplay(OUT,DE_TCRDat);
    
    if FES>DE_TCRDat.MAXFUNEVALS || n>DE_TCRDat.MAXGEN
        disp('Optimization terminated.')
        break;
    end
    
    %% Adaptive Mechanism: Adapting Triangular distribution for CR rate.
    
    if SuccessEvoCr>=CRsuccess
        SuccessEvoCr=0;
        DataCR=sortrows(ParamEVO,1);
        
        MaxCr=DataCR(end,1);
        MinCr=DataCR(1,1);
        MedCr=median(DataCR);
        
        if abs(MedCr-MaxCr)<0.1
            MaxCr=min(MedCr+0.1,1.0);
        end
        
        if abs(MedCr-MinCr)<0.1
            MinCr=max(MedCr-0.1,0.2);
        end
    end
end

PopParent=Parent;
JxPopParent=JxParent;
OUT.PopParent=PopParent;
OUT.JxPopParent=JxPopParent;
OUT.Param=DE_TCRDat;

if strcmp(DE_TCRDat.SaveResults,'yes')
    save(['OUT_DE_TCR_' datestr(now,30)],'OUT'); % Results are saved.
end

disp('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')
if strcmp(DE_TCRDat.SaveResults,'yes')
    disp(['Check out OUT_DE_TCR' datestr(now,30) ...
        ' variable on folder for results.'])
end
disp('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')


function [OUT Dat]=PrinterDisplay(OUT,Dat)

if strcmp(Dat.SeeProgress,'yes')
    disp('------------------------------------------------')
    disp(['Generation: ' num2str(Dat.CounterGEN)]);
    disp(['Evaluations: ' num2str(Dat.CounterFES)]);
    disp(['Minimum: ' num2str(min(OUT.JxPopParent))]);
    disp(num2str(OUT.TCR))
    disp('------------------------------------------------')
end

if strcmp(Dat.Plotter,'yes')
    figure(123);
    plot(Dat.CounterGEN,(min(OUT.JxPopParent(:,1))),'*r'); ...
    grid on; hold on;
end

%%
%% Release and bug report:
%
% November 2012: Initial release
% 19th. April 2013: Bug in Re-Initialization ranges was fixed