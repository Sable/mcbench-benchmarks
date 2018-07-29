function [system,intTable] = createinttable(systemName)
%   Create integer table function
%
%   This function will create integer table for the rule base
%   
%
%   Neelamugilan Gobalakrishnan
%   2006
%   $Revision:1.0 $ $Date: 15/03/2006 $

condStatusInput = 'start'; %Condition status for number of inputs while loop

while strcmp(condStatusInput,'start') | strcmp(condStatusInput,'cont')
    numInputs = input('Enter the number of inputs for this system (min=1,max=5): ');
    fprintf('\n');
    % Validates the number of inputs is more than 0 and 
    % less than 6 
    if numInputs > 0 & numInputs < 6
        condStatusInput = 'stop';
    else
        disp('Invalid value has been entered! ');
        disp('Please reenter your value. ');
        condStatusInput = 'cont';
    end
end

for i=1:numInputs
    %Condition status for number of linguistic values while loop
    condStatusNummfin = 'start';
    while strcmp(condStatusNummfin,'start') | strcmp(condStatusNummfin,'cont')
        fprintf('Enter the number of linguistic values for input %d: ', i);
        nummfin(i) = input('');
        % Validates the number of linguistic values are more than 0
        if nummfin(i) > 0
            condStatusNummfin = 'stop';
        else
            disp('Invalid value has been entered! ');
            disp('It must contain at least 1 linguistic value ');
            condStatusNummfin = 'cont';
        end
    end
end

%===========================================================
%   Create integer table with all the possible inputs
%   combinations.
%===========================================================

row=1;
if numInputs == 1
    for a=1:nummfin(1)
        intTable(row,1) = a;
        row = row + 1;
    end
else
    for a=1:nummfin(1)
        intTable(row,1) = a;
        for b=1:nummfin(2)
            intTable(row,1) = a;
            intTable(row,2) = b;
            if numInputs == 2
                row = row + 1;
            end
            if numInputs > 2
                for c=1:nummfin(3)
                    intTable(row,1) = a;
                    intTable(row,2) = b;
                    intTable(row,3) = c;
                    if numInputs == 3
                        row = row + 1;
                    end
                    if numInputs > 3
                        for d=1:nummfin(4)
                            intTable(row,1) = a;
                            intTable(row,2) = b;
                            intTable(row,3) = c;
                            intTable(row,4) = d;
                            if numInputs == 4
                                row = row + 1;
                            end
                            if numInputs > 4
                                for e=1:nummfin(5)
                                  intTable(row,1) = a;
                                  intTable(row,2) = b;
                                  intTable(row,3) = c;
                                  intTable(row,4) = d;
                                  intTable(row,5) = e;
                                  if numInputs == 5
                                      row = row + 1;
                                  end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

%===========================================================
%   Display integer table with all the possible inputs
%   combinations.
%===========================================================

fprintf('\n');
disp('-------------------------------------------------------------');
fprintf(' ');

for i=1:numInputs
    fprintf('Input%d ', i);
end

fprintf('\n');
disp('-------------------------------------------------------------');
fprintf('\n');
disp(intTable);
disp('-------------------------------------------------------------');

fprintf('\n');

%===========================================================
%   Adding output values to the integer table.
%===========================================================

condStatusOutput = 'start'; %Condition status for number of outputs while loop

while strcmp(condStatusOutput,'start') | strcmp(condStatusOutput,'cont')
    numOutputs = input('Enter the number of outputs for this system : ');
    fprintf('\n');
    % Validates the number of outputs is more than 0 
    if numOutputs > 0
        condStatusOutput = 'stop';
    else
        disp('Invalid value has been entered! ');
        disp('It must contain at least 1 output ');
        condStatusOutput = 'cont';
    end
end

for i=1:numOutputs
    %Condition status for number of linguistic values while loop
    condStatusNummfout = 'start';
    while strcmp(condStatusNummfout,'start') | strcmp(condStatusNummfout,'cont')
        fprintf('Enter the number of linguistic value for output %d: ', i);
        nummfout(i) = input('');
        % Validates the number of linguistic values are more than 0
        if nummfout(i) > 0
            condStatusNummfout = 'stop';
        else
            disp('Invalid value has been entered! ');
            disp('It must contain at least 1 linguistic value ');
            condStatusNummfout = 'cont';
        end
    end
end

fprintf('\n');

for i=1:length(intTable)
    for j=1:numOutputs
        n = 1;
        while n == 1
            fprintf('Enter the linguistic value of output %d for rule number %d \n', j, i);
            fprintf('%d ', intTable(i,1:numInputs));
            fprintf('-> ');
            tmp = input('');
            if tmp > 0 & tmp <= nummfout(j)
                intTable(i,numInputs+j)=tmp;
                n = 2;
            else
                fprintf('Invalid value is been entered! \nPlease enter one of these values [ ');
                fprintf('%d ',1:1:nummfout(j));
                fprintf('] \n\n');
                n = 1;
            end
        end
    end
end

%===========================================================
%   Display the complete integer table.
%===========================================================

fprintf('\n');
disp('-------------------------------------------------------------');
fprintf(' ');
disp('                    Complete integer table                   ');
fprintf(' ');
disp('-------------------------------------------------------------');

fprintf('\n');
disp('-------------------------------------------------------------');
fprintf(' ');

for i=1:numInputs
    fprintf('Input%d ', i);
end

for i=1:numOutputs
    fprintf('Output%d ', i);
end

fprintf('\n');
disp('-------------------------------------------------------------');
fprintf('\n');
disp(intTable);
disp('-------------------------------------------------------------');
fprintf('\n');

for i=1:numInputs
    % Inputs informations
    fprintf('Enter the name for input %d : ', i);
    system.input(i).name = input('','s');
    condStatusRange = 'start';
    while strcmp(condStatusRange,'start') | strcmp(condStatusRange,'cont')
        fprintf('Enter the range for input %d (e.g [0 10] : ', i);
        system.input(i).range = input(''); 
        fprintf('\n');
        if length(system.input(i).range) ~= 2
            disp('Wrong sizes of given argument(s)! ');
            disp('It must contain 2 argument e.g. [0 10] ');
            condStatusRange = 'cont';
        else
            condStatusRange = 'stop';
        end
    end

    % Inputs linguistic values informations
    for j=1:nummfin(i)
        fprintf('Enter the name of linguistic value %d for input %d : ', j, i);
        system.input(i).mf(j).name = input('','s');
        condStatusType = 'start';
        while strcmp(condStatusType,'start') | strcmp(condStatusType,'cont')
            fprintf('Enter the type of linguistic value %d for input %d : ', j, i);
            system.input(i).mf(j).type = input('','s');
            if ~strcmp(system.input(i).mf(j).type, 'trimf') & ~strcmp(system.input(i).mf(j).type, 'trapmf')
                disp('Unsupported type! ');
                disp('Please enter "trimf" or "trapmf" ');
                condStatusType = 'cont';
            else
                condStatusType = 'stop';
            end
        end
        condStatusParam = 'start';
        while strcmp(condStatusParam,'start') | strcmp(condStatusParam,'cont')
            fprintf('Enter the parameters of linguistic value %d for input %d : ', j, i);
            system.input(i).mf(j).params = input('');
            fprintf('\n');
            if strcmp(system.input(i).mf(j).type, 'trimf')
                if length(system.input(i).mf(j).params) ~= 3
                    disp('Wrong size of given parameter(s)! ');
                    disp('It must contain 3 parameters e.g. [0 5 7] ');
                    condStatusParam = 'cont';
                else
                    condStatusParam = 'stop';
                end
            elseif strcmp(system.input(i).mf(j).type, 'trapmf')
                if length(system.input(i).mf(j).params) ~= 4
                    disp('Wrong size of given parameter(s)! ');
                    disp('It must contain 4 parameters e.g. [0 0 5 10] ');
                    condStatusParam = 'cont';
                else
                     condStatusParam = 'stop';
                end
            end
        end
    end
    fprintf('\n');
end

for i=1:numOutputs
    % Outputs informations
    fprintf('Enter the name for output %d : ', i);
    system.output(i).name = input('','s');
    condStatusRange = 'start';
    while strcmp(condStatusRange,'start') | strcmp(condStatusRange,'cont')
        fprintf('Enter the range for output %d (e.g [0 10] : ', i);
        system.output(i).range = input('');
        fprintf('\n');
        if length(system.output(i).range) ~= 2
            disp('Wrong sizes of given argument(s)! ');
            disp('It must contain 2 argument only e.g. [0 10] ');
            condStatusRange = 'cont';
        else
            condStatusRange = 'stop';
        end
    end
    
    % Outputs linguistic values informations
    for j=1:nummfout(i)
        fprintf('Enter the name of linguistic value %d for output %d : ', j, i);
        system.output(i).mf(j).name = input('','s');
        condStatusType = 'start';
        while strcmp(condStatusType,'start') | strcmp(condStatusType,'cont')
            fprintf('Enter the type of linguistic value %d for output %d : ', j, i);
            system.output(i).mf(j).type = input('','s');
            if ~strcmp(system.output(i).mf(j).type, 'trimf') & ~strcmp(system.output(i).mf(j).type, 'trapmf')
                disp('unsupported type! ');
                disp('Please enter "trimf" or "trapmf" ');
                condStatusType = 'cont';
            else
                condStatusType = 'stop';
            end
        end
        condStatusParam = 'start';
        while strcmp(condStatusParam,'start') | strcmp(condStatusParam,'cont')
            fprintf('Enter the parameters of linguistic value %d for output %d : ', j, i);
            system.output(i).mf(j).params = input('');
            fprintf('\n');
            if strcmp(system.output(i).mf(j).type, 'trimf')
                if length(system.output(i).mf(j).params) ~= 3
                    disp('Wrong size of given parameter(s)! ');
                    disp('It must contain 3 parameters only e.g. [0 5 7] ');
                    condStatusParam = 'cont';
                else
                    condStatusParam = 'stop';
                end
            elseif strcmp(system.output(i).mf(j).type, 'trapmf')
                if length(system.output(i).mf(j).params) ~= 4
                    disp('Wrong size of given parameter(s)! ');
                    disp('It must contain 4 parameters only e.g. [0 0 5 10] ');
                    condStatusParam = 'cont';
                else
                     condStatusParam = 'stop';
                end
            end
        end
    end
    fprintf('\n');
end

% Call createfis function to create a system with this rules
createfis(systemName,system,intTable);