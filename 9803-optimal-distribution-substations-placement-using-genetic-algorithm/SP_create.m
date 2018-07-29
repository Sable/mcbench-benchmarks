% this function creates the first population used by Genetic Algorithm

function pop = SP_create(NVARS,FitnessFcn,options)

global T L FinalTransPow FinalLoad FinalTransCap TransTypes AuxTransCap AuxTransPow K2 K3
global SelCaseRow FinalTrans_x FinalTrans_y FinalLoad_x FinalLoad_x FinalLoad_y
global AuxFinalTrans_x AuxFinalTrans_y AuxFinalLoad_x AuxFinalLoad_x AuxFinalLoad_y AuxFinalLoad
global FinalTLDistances

totalPopulationSize = sum(options.PopulationSize);
pop = cell(totalPopulationSize,1);
for counter=1:NVARS,
    SelDistance = FinalTLDistances(counter,:);
    [SelTr,SelectedTrIndex] = min(SelDistance);
    firstpop(counter,1) = counter;
    firstpop(counter,2) = SelCaseRow(1,SelectedTrIndex);
end;
pop{1} = firstpop;
for j=2:totalPopulationSize,
    for count1=1:NVARS,         % NVARS=L the number of final loads and also the number of variables.
        TIndex = randperm(length(SelCaseRow));
        popindividual(count1,1) = count1;
        popindividual(count1,2) = SelCaseRow(1,TIndex(1,1));
    end;
    pop{j} = popindividual;
end;
