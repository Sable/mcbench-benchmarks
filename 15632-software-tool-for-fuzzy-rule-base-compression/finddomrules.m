function compressRules = finddomrules(system,intTable,outNum,initialVal,displayOpt)

%   Finding Dominant rule for given rules
%
%
%
%   Neelamugilan Gobalakrishnan
%   2006
%   $Revision:1.0 $ $Date: 14/03/2006 $

clear compressRules
for i=1:size(system.output(outNum).mf, 2)
    clear min_values ruletable
    row=1; % matrix row value
    % get minimum for each rules in a group
    for j=1:size(intTable, 1)
        if intTable(j,end) == i 
            ruletable(row,:) = intTable(j,:);
            for k=1:size(system.input, 2)
                mfval = system.input(k).mf(intTable(j,k));
                crisp_values(k) = evalmf(initialVal(k),[mfval.params],mfval.type);
            end
            min_values(row) = min(crisp_values); % find the minimun for each rule
            row=row+1;
            clear crisp_values
        end
    end
    
    % Find firing strength for each group
    firing_strength = max(min_values);
    % add dominant rule to rule list
    if firing_strength ~= 0
        for m=1:length(min_values)
            if min_values(m) == firing_strength
                compressRules(i,:) = ruletable(m,:); 
            end
        end
    else
        compressRules(i,:) = ruletable(1,:);
    end
end

%===========================================================
%   Display new rules integer tables.
%===========================================================
if strcmp(displayOpt, 'on')
    fprintf('\n');
    disp('-------------------------------------------------------------');
    fprintf(' ');
    disp('                      Compressed rules                           ');
    fprintf(' ');
    disp('-------------------------------------------------------------');

    fprintf('\n');
    disp('-------------------------------------------------------------');
    fprintf(' ');

    for i=1:size(system.input, 2)
        fprintf('Input%d ', i);
    end

    fprintf('Output%d ', outNum);

    fprintf('\n');
    disp('-------------------------------------------------------------');
    fprintf('\n');
    disp(compressRules);
    disp('-------------------------------------------------------------');

    fprintf('\n\n');
end