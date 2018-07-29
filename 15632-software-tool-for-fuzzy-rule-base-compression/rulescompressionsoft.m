%   FUZZY RULE BASE COMPRESSION SOFTWARE
%
%   This software implements advanced inference in fuzzy rule based systems
%   by filtration of non-monotonic rules. This software is for mandani type
%   system only.
%   
%
%   Neelamugilan Gobalakrishnan
%   2006
%   $Revision:1.0 $ $Date: 15/03/2006 $

clc
clear all

disp('***********************************************************');
disp('*                                                         *');
disp('*         FUZZY RULE BASE COMPRESSION SOFTWARE            *');
disp('*                                                         *');
disp('*     This software implements advanced inference in      *');
disp('*     fuzzy rule based systems by filtration of non-      *');
disp('*     monotonic rules.                                    *');
disp('*                                                         *');
disp('***********************************************************');

fprintf('\n\n');

condStatus = 'start'; %Condition status for choice while loop

while strcmp(condStatus,'start') | strcmp(condStatus,'cont')
    clear choise
    fprintf('Enter 1 to create a new system\n');
    fprintf('Enter 2 to load a system (*.fis)\n\n');
    fprintf('Please enter your choice : ');
    choise = input('');
    if choise == 1 % Create a new system
        fprintf('\n');
        systemName = input('Enter the name of this system : ','s');
        % Call createinttable function to create integer table
        [sys intTable] = createinttable(systemName);
        % Arranged the rules into groups
        [groupedTable outNum] = arrangerules(sys,intTable);
        
        % Get the initial values for each inputs
        for i=1:size(sys.input, 2)
            fprintf('\nEnter the initial %s : ', sys.input(i).name);
            initialVal(i) = input('');
        end
        
        displayOpt = 'on'; % Option to display the compressed rules
        % Find dominant rules for provided initial values
        compressRules = finddomrules(sys,intTable,outNum,initialVal,displayOpt);
        
        newSysName = input('Please enter the name for compressed system : ','s');
        fprintf('\n');
        % Create the system with compressed rules
        createfis(newSysName,sys,compressRules);
        
        % Simulates the fuzzy inference system
        a = readfis(newSysName);
        outResult = evalfis([initialVal],a);
        
        fprintf('\n');
        fprintf('The %s value for \n', sys.output(outNum).name);
        
        for i=1:size(sys.input, 2)
            fprintf('%s(%.2f) \n',sys.input(i).name ,initialVal(i));
        end

        fprintf('= %.2f', outResult);
        fprintf('\n\n');
        
        view_surface = input('Do u want to view the output surface (yes/no) : ','s');
        
        % Display the output surface
        while strcmp(view_surface,'yes') 
            fprintf('\nEnter 1 to view the original system, output surface\n');
            fprintf('Enter 2 to view the compressed system, output surface\n\n');
            fprintf('Please enter your option : ');
            option = input('');
            if option == 1
                % Create output surface for the original system
                createoutsurf(sys,systemName,intTable,outNum,option);
                fprintf('\nDo u want to view the output surface with\n');
                view_surface = input('new points or compressed system? (yes/no) : ','s');
            elseif option == 2
                % Create output surface for the compressed system
                createoutsurf(sys,newSysName,intTable,outNum,option);
                fprintf('\nDo u want to view the output surface with\n');
                view_surface = input('new points or original system? (yes/no) : ','s');
            else
                disp('Invalid value has been entered! ');
                fprintf('\n');
                view_surface = 'yes';
            end
        end  
        condStatus = 'stop'; % choice while loop stopping condition
        % Load a system
    elseif choise == 2
        [fileName,pathName]=uigetfile('*.fis','Read FIS');
        if isequal(fileName,0) || isequal(pathName,0)
          % If fileName is zero, "cancel" was hit, or there was an error.
          errorStr='No file was loaded';
          return
        end
        systemName = [pathName fileName];
        
        sys = readfis(systemName);
        
        % Create the integer table
        for i=1:size(sys.rule,2)
            intTable(i,:) = [sys.rule(i).antecedent sys.rule(i).consequent];
        end
        
        fprintf('\n');
        disp('-------------------------------------------------------------');
        fprintf(' ');
        disp('                    Complete integer table                   ');
        fprintf(' ');
        disp('-------------------------------------------------------------');

        fprintf('\n');
        disp('-------------------------------------------------------------');
        fprintf(' ');

        for i=1:size(sys.input,2)
            fprintf('Input%d ', i);
        end

        for i=1:size(sys.output,2)
            fprintf('Output%d ', i);
        end

        fprintf('\n');
        disp('-------------------------------------------------------------');
        fprintf('\n');
        disp(intTable);
        disp('-------------------------------------------------------------');
        fprintf('\n');
        
        % Arranged the rules into groups
        [groupedTable outNum] = arrangerules(sys,intTable);
        
        % Get the initial values for each inputs
        for i=1:size(sys.input, 2)
            fprintf('\nEnter the initial %s : ', sys.input(i).name);
            initialVal(i) = input('');
        end
        
        displayOpt = 'on'; % Option to display the compressed rules
        % Find dominant rules for provided initial values
        compressRules = finddomrules(sys,intTable,outNum,initialVal,displayOpt);
        
        fprintf('\n');
        newSysName = input('Please enter the name for compressed system : ','s');
        % Create the system with compressed rules
        createfis(newSysName,sys,compressRules);
        
        % Simulates the fuzzy inference system
        a = readfis(newSysName);
        outResult = evalfis([initialVal],a);

        fprintf('\n');
        fprintf('The %s value for \n', sys.output(outNum).name);

        for i=1:size(sys.input, 2)
            fprintf('%s(%.2f) \n',sys.input(i).name ,initialVal(i));
        end

        fprintf('= %.2f', outResult);
        fprintf('\n\n');
        
        view_surface = input('Do u want to view the output surface (yes/no) : ','s');
        
        % Display the output surface
        while strcmp(view_surface,'yes') 
            fprintf('\nEnter 1 to view the original system, output surface\n');
            fprintf('Enter 2 to view the compressed system, output surface\n\n');
            fprintf('Please enter your option : ');
            option = input('');
            if option == 1
                % Create output surface for the original system
                createoutsurf(sys,systemName,groupedTable,outNum,option);
                fprintf('\nDo u want to view the output surface with\n');
                view_surface = input('new points or compressed system? (yes/no) : ','s');
            elseif option == 2
                % Create output surface for the compressed system
                createoutsurf(sys,newSysName,groupedTable,outNum,option);
                fprintf('\nDo u want to view the output surface with\n');
                view_surface = input('new points or original system? (yes/no) : ','s');
            else
                fprintf('\n');
                disp('Invalid value has been entered! ');
                view_surface = 'yes';
            end
        end  
        condStatus = 'stop'; % choice while loop stopping condition
    else
        disp('Invalid value has been entered! ');
        condStatus = 'cont'; % Choice while loop continue condition
    end
end