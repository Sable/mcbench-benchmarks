function ITERsave_hist(Problem,Constraints,Objectives,Spec,methodstr)
global CURRENT_PROJECT

try
    ITERIND = 1 + max(xlsread('History.xls',CURRENT_PROJECT,'A1:IV1'));
catch
    ITERIND = 1;
end

labelcolumn = [{'Iteration number'
    'Date'
    'Time'
    'Note'
    'Iteration Method'
    'Feasible?'
    'Composite Score'
    ' '};
    {'AUM (kg)'
    'OWE/AUM'
    'Fuel weight (kg)'
    ' '};
    {'Power (hp)'
    ' '};
    {'Main Rotor:'
    'Radius (m)'
    'Tip speed (m/s)'
    'Blades'
    'Blade chord (m)'
    'Blade twist (deg)'
    'Diameter (m)'
    'Speed (rpm)'
    'Disc area (m2)'
    'Blade aspect ratio'
    'Blade area (m2)'
    'Solidity'
    ' '};
    {'Tail Rotor:'
    'Tip speed (m/s)'
    'Radius (m)'
    'Disc area (m2)'
    'Solidity'
    'Blades'
    'Blade chord (m)'
    'Speed (rpm)'
    'Distance from MR hub (m)'
    'Blade area (m2)'
    ' '};
    {'Design Variables:'};
    Problem.XLabels;
    {' '
    'Margins on Constraints (%):'};
    Constraints.conLabels;
    {' '
    'Objective Values:'};
    Objectives.ObjLabels;
    {' '
    ' '};
    {'Design Variables Active/Fixed:'};
    Problem.XLabels;
    {' '
    'Constraints Active/Inactive:'};
    Constraints.conLabels;
    {' '
    'Constraint Analysis Method:'};
    Constraints.conLabels(1:Spec.nPPrequirements);
    {' '
    'Constraint Buffers (%):'};
    Constraints.conLabels;
    {' '
    'Composite Objective Weightings:'};
    Objectives.ObjLabels];
try
    xlswrite('History.xls',labelcolumn,CURRENT_PROJECT,'A1');
catch
    disp('Could not write to History.xls')
    return
end


V{1} = ITERIND;
V{2} = datestr(now,29);
V{3} = datestr(now,13);
V{4} = input('Iteration notes: ','s');
V{5} = methodstr;

AC=ACbuilder(Problem.x0, Spec);

V{9} = AC.W.AUM;
V{10} = (AC.W.AUM*(1-AC.Vars.FuelFrac)-AC.Vars.Wpayload*1000)/AC.W.AUM;
V{11} = AC.W.AUM*AC.Vars.FuelFrac;

V{13} = AC.Power.P*0.001341022; %conversion

jnk = struct2cell(AC.Rotor);
jnk{3} = round(jnk{3});
jnk{5} = jnk{5}*180/pi; %deg
jnk{7} = jnk{7}*30/pi; %rpm
V{15}=[];
V = [V(:);jnk(:)];

jnk = struct2cell(AC.TRotor);
jnk{7} = jnk{7}*30/pi; %rpm
V{28}=[];
V = [V(:);jnk(:)];

jnk = num2cell(Problem.x0);
V{end+2}=[];
V = [V(:);jnk(:)];


activeX = Problem.activeX;
active_cons = Constraints.active_cons;
conmargins = Constraints.margins;
weightings = Objectives.weightings;
useBEA = Constraints.useBEA;

% eval everything
Constraints.active_cons(:) = true;
Objectives.weightings(:) = 1;

[C,~, SingleObjectiveValues]=ITERevaluate_X0...
    (Problem,Constraints,Spec,Objectives,false,false);

% feasible
V{6} = all(C(active_cons)<=0);

% constraints
jnk = num2cell(-100*C);
V{end+2}=[];
V = [V(:);jnk(:)];

% objectives
jnk = num2cell(SingleObjectiveValues);
V{end+2}=[];
V = [V(:);jnk(:)];

% composite objective
V{7} = sum(weightings.*SingleObjectiveValues);

% active
jnk = num2cell(activeX);
V{end+3}=[];
V = [V(:);jnk(:)];

% constraints active/inactive
jnk = num2cell(active_cons);
V{end+2}=[];
V = [V(:);jnk(:)];

% constraint analysis method
jnk = num2cell(useBEA);
jnk(useBEA) = {'BEA'};
jnk(~useBEA) = {'Mom.'};
V{end+2}=[];
V = [V(:);jnk(:)];

% buffers
jnk = num2cell(conmargins*100);
V{end+2}=[];
V = [V(:);jnk(:)];

% weightings
jnk = num2cell(weightings);
V{end+2}=[];
V = [V(:);jnk(:)];

V = V(:);

try
    xlswrite('History.xls',V,CURRENT_PROJECT,[idx2A1(ITERIND+1) '1'])
catch
    disp('Could not write to History.xls')
end
end

function a1String = idx2A1(idx)

alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

if idx < 27
    a1String = alphabet(idx);
else
    idx2 = rem(idx,26);
    if idx2 == 0
        a1String = [alphabet(floor(idx/26)-1),'Z'];
    else
        a1String = [alphabet(floor(idx/26)),alphabet(idx2)];
    end
end
end