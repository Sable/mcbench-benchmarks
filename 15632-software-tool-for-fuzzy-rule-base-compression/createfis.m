function createfis(systemName,system,rulelist)
%   This function creates a new mamdani system
%
%   
%
%   Neelamugilan Gobalakrishnan
%   2006
%   $Revision:1.0 $ $Date: 15/03/2006 $

% Call build in newfis function to creates a new Mamdani-style FIS structure
newSystem = newfis(systemName);

for i=1:size(system.input, 2)
    newSystem.input(i).name = system.input(i).name;
    newSystem.input(i).range = system.input(i).range;
    for j=1:size(system.input(i).mf, 2)
        newSystem.input(i).mf(j).name = system.input(i).mf(j).name;
        newSystem.input(i).mf(j).type = system.input(i).mf(j).type;
        newSystem.input(i).mf(j).params = system.input(i).mf(j).params;
    end
end

for i=1:size(system.output, 2)
    newSystem.output(i).name = system.output(i).name;
    newSystem.output(i).range = system.output(i).range;
    for j=1:size(system.output(i).mf, 2)
        newSystem.output(i).mf(j).name = system.output(i).mf(j).name;
        newSystem.output(i).mf(j).type = system.output(i).mf(j).type;
        newSystem.output(i).mf(j).params = system.output(i).mf(j).params;
    end
end

for i=1:size(rulelist,1)
    newSystem.rule(i).antecedent = [rulelist(i,1:1:end-size(system.output, 2))];
    newSystem.rule(i).consequent = [rulelist(i,size(system.input, 2)+1:1:end)];
    newSystem.rule(i).weight = 1;
    newSystem.rule(i).connection = 1;
end

% Call built-in writefis function to save this structure
writefis(newSystem,systemName);