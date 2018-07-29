% here, the fitness function is created. the sum of distances from loads to
% present transformers are calculated and the set which minimizes this sum
% is achieved by MATLAB ga function.
% x is an individual
% f1= substation installation cost
% f2= LV network cost (for conductors loss)
% f3= transformers loss cost
function scores = SP_fitness(x,FinalTLDistances)

global T L FinalTransPow FinalLoad FinalTransCap TransTypes AuxTransCap AuxTransPow K2 K3 MaxT
global SelCaseRow FinalTrans_x FinalTrans_y FinalLoad_x FinalLoad_x FinalLoad_y BrTransIndex
global AuxFinalTrans_x AuxFinalTrans_y AuxFinalLoad_x AuxFinalLoad_x AuxFinalLoad_y AuxFinalLoad
global finaltranspow finaltranscap

scores = zeros(size(x,1),1);
for u = 1:size(x,1)
p = x{u};
VoltageDropWarn = 0;
FinalTransPow = finaltranspow; % reset FinalTransPow for every individual
FinalTransCap = finaltranscap; % reset FinalTransCap for every individual
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for count1=1:L,
    FinalTransPow(1,p(count1,2)) = FinalTransPow(1,p(count1,2)) + FinalLoad(1,p(count1,1));
end;
for count1=1:TransTypes,
    for count2=1:MaxT,
        if (FinalTransPow(1,count2) ~= -1)
            if (FinalTransCap(1,count2) < FinalTransPow(1,count2))
                FinalTransCap(1,count2) = SP_stepup(FinalTransCap(1,count2),FinalTrans_x(1,count2),FinalTrans_y(1,count2));
            end;
        end;
    end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1 = 0;
for count1=1:MaxT,
    if (FinalTransCap(1,count1) ~= -1)
        f1 = f1 + SP_instcost(FinalTransCap(1,count1));
    end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f2 = 0;
for count1=1:L,        % L=NVARS size of final loads
    c1 = p(count1,1);
    c2 = p(count1,2);
    Temp = find(BrTransIndex == c2);
    f2 = f2 + (1400*K2*(FinalTLDistances(c1,Temp)*(FinalLoad(1,c1)^2)));
    % check for undervoltage occurence
    if ((FinalLoad(1,c1)*FinalTLDistances(c1,Temp)) > 7500)
        VoltageDropWarn = 1;
    end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f3 = 0;
% for count1=1:L,
%     c1 = p(count1,2);
%     f3 = f3 + (1400*(K3*SP_tlosscost2(FinalTransCap(1,c1)) + SP_tlosscost1(FinalTransCap(1,c1))));
% end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (VoltageDropWarn == 0)
    scores(u) = f1 + f2 + f3;
else
    scores(u) = f1 + f2 + f3 + (1e9);
end;
end;
