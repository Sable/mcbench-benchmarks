function sl_customization(cm)
    % SL_CUSTOMIZATION - Model Advisor customization demonstration.
    % Copyright 2008 The MathWorks, Inc.
    % register custom checks 
    cm.addModelAdvisorCheckFcn(@defineModelAdvisorChecks);
    % register custom process callback
    cm.addModelAdvisorProcessFcn(@ModelAdvisorProcessFunction);
end
function [checkCellArray taskCellArray] = ModelAdvisorProcessFunction(stage, system, checkCellArray, taskCellArray)   %#ok
    switch stage
        case 'configure'
            for i=1:length(checkCellArray)
                % hidden all checks that do not belong to Demo group
                if (strcmp(checkCellArray{i}.Group, 'Demo Folder|Folder 1'))
                    % do nothing
                    checkCellArray{i}.Visible = true;
                    checkCellArray{i}.Value = false;
                else
                    checkCellArray{i}.Value = false;
                end
            end
        case 'process_results'
            % Runs after a check has been run.
    end % ends switch statment
end

% -----------------------------
% defines Model Advisor Checks
% -----------------------------
function defineModelAdvisorChecks
    mdladvRoot = ModelAdvisor.Root;

    %% --- sample check 1
    rec                     = ModelAdvisor.Check('dataLoggingSettings');
    rec.Title               = 'Validate data logging settings';
    rec.TitleTips           = ['Checks that signal logging is enabled with a ',...
                               'unique name and that the format is set to ',...
                               'structure with time'];
    rec.setCallbackFcn(@dataLoggingSettingsFunc,'None','StyleThree');
    % set input parameters
    rec.setInputParametersLayoutGrid([1 1]);
    inputParam1             = ModelAdvisor.InputParameter;
    inputParam1.Name        = 'Save existing data to file';
    inputParam1.Type        = 'Bool';
    inputParam1.Value       = false;
    inputParam1.Description = 'File name is based on model name and time stamp';
    inputParam1.setRowSpan([1 1]);
    inputParam1.setColSpan([1 1]);
    rec.setInputParameters({inputParam1});
    % set fix operation
    myAction             = ModelAdvisor.Action;
    myAction.Name        = 'Save and clear data';
    myAction.Description = ['Enables logging, sets format to structure with ',...
                            'if the option is selected the data is saved ',...
                            'to file.  If not selected the logging name ',...
                            'incremented'];
    myAction.setCallbackFcn(@dataLoggingSettingsAction);
    rec.setAction(myAction);
    rec.ListViewVisible = false;     % The list view explore isn't needed
    mdladvRoot.publish(rec, 'Demo Folder|Folder 1'); 
    
    %% --- sample check 2
    rec                     = ModelAdvisor.Check('inputDataConfiguration');
    rec.Title               = 'Check the models data input configuration';
    rec.TitleTips           = ['The model must have either root level ',...
                               'Inports enabled or Signal builder / ',...
                               'fromWorkspace blocks in the model'];
    rec.setCallbackFcn(@inputDataConfigurationFunc,'None','StyleThree');
    % set input parameters
    rec.ListViewVisible = false;     % The list view explore isn't needed
    %mdladvRoot.register(rec);        % Register the check.
    mdladvRoot.publish(rec,'Demo Folder|Folder 2');    
               
    %% --- sample check 3
    rec                     = ModelAdvisor.Check('signalLoggingEnabled');
    rec.Title               = 'Verify that required signals are logged';
    rec.TitleTips           = ['All named signals must be logged.  As an'...
                               ' option the user can select a prefix',...
                               ' that defines the named signals to log.'];
    rec.setCallbackFcn(@signalLoggingEnabledFunc,'None','StyleThree');
    % set input parameters
    rec.setInputParametersLayoutGrid([1 2]);
    inputParam1             = ModelAdvisor.InputParameter;
    inputParam1.Name        = 'Use prefix';
    inputParam1.Type        = 'Bool';
    inputParam1.Value       = false;
    inputParam1.Description = 'Enable signal filtering based on user define prefix';
    inputParam1.setRowSpan([1 1]);
    inputParam1.setColSpan([1 1]);
    inputParam2             = ModelAdvisor.InputParameter;
    inputParam2.Name        = 'Prefix string';
    inputParam2.Type        = 'String';
    inputParam2.Value       = 'LogMe_';
    inputParam2.Description = 'The Signal Name Prefix';
    inputParam2.setRowSpan([1 1]);
    inputParam2.setColSpan([2 2]);
    
    rec.setInputParameters({inputParam1, inputParam2});
    % set fix operation
    myAction             = ModelAdvisor.Action;
    myAction.Name        = 'Enable Logging';
    myAction.Description = 'Log selected signals';
    myAction.setCallbackFcn(@signalLoggingEnabledAction);
    rec.setAction(myAction);
    rec.ListViewVisible = true; 
    
    mdladvRoot.publish(rec,'Demo Folder|Folder 2');
    
    % How to move a check...
    % ID we want to move...'Check model and local libraries for updates'
    
    %% --- sample check 4: Stateflow
    rec                     = ModelAdvisor.Check('stateflowExample');
    rec.Title               = 'Provided information on Stateflow Charts';
    rec.TitleTips           = ['Returns chart name, use of history junctions',...
                               ' and multi-branch junctions'];
    rec.setCallbackFcn(@stateflowExampleFunc,'None','StyleThree');
    % set input parameters
    rec.ListViewVisible = false;     % The list view explore isn't needed
    %mdladvRoot.register(rec);        % Register the check.
    mdladvRoot.publish(rec,'Demo Folder|Folder 2');    
    
    
end

function [ResultDescription, ResultDetails] = dataLoggingSettingsFunc(system)
    % initilize the returns to empty
    ResultDescription = {};
    ResultDetails     = {};
    % Pass fail flags:  This check has three thing it checks, stored in "eachPass"
    allPass    = 1;
    eachPass   = {1,1,1};

    % get the model advisor handle for the model.
    mdladvObj = Simulink.ModelAdvisor.getModelAdvisor(system);
    % pass fail status to "pass" 
    mdladvObj.setCheckResultStatus(false);         
   
    % Formated Pass / Fail text
    passText = ModelAdvisor.Text('Pass:',{'bold','pass'});
    failText = ModelAdvisor.Text('Fail:',{'bold','fail'});    
    
    logEnabled = simget(system,'SignalLogging');     % Part one: Is signal logging enabled?
    if (strcmp(logEnabled,'off'))
        tempStr = ModelAdvisor.Text('The signal Logging was not enabled.');
        ResultDescription{end+1} = [failText,tempStr];                               
        ResultDetails{end+1}     = {};                                                              
        allPass                  = 0;
        eachPass{1}              = 0;
    else
        tempStr = ModelAdvisor.Text('Signal Logging is enabled.');
        ResultDescription{end+1} = [passText,tempStr];                                       
        ResultDetails{end+1}     = {};                                                              
    end
    
    % Check to see if the logging name exists in the base workspace
    logName     = simget(system,'SignalLoggingName');
    existInBase = evalin('base',['exist(''',logName,''',''var'')']);
    
    if (existInBase == 1)
  
        tempStr = ModelAdvisor.Text('The logged data already exists in the base worksace');
        ResultDescription{end+1} = [failText,tempStr];                                     
        ResultDetails{end+1}     = {};                               
        allPass                  = 0;
        eachPass{2}              = 0;        
    else
        tempStr = ModelAdvisor.Text('The logged data does not exist in the base worksace');
        ResultDescription{end+1} = [passText,tempStr];                                                              
        ResultDetails{end+1}     = {};                               
    end

    saveFormat     = simget(system,'SaveFormat');
    if (strcmp(saveFormat,'StructureWithTime') ~= 1)  
        
        tempStr = ModelAdvisor.Text('Data is being logged in the wrong format');
        ResultDescription{end+1} = [failText,tempStr];                               
        ResultDetails{end+1}     = {};                                                              
        allPass                  = 0;
        eachPass{3}              = 0;        
    else
        tempStr = ModelAdvisor.Text('Data is being logged in the correct format');
        ResultDescription{end+1} = [passText,tempStr];                               
        ResultDetails{end+1}     = {};                                                              
    end
    
    if (allPass == 1)
        mdladvObj.setActionEnable(0); % the check passed, therefore enable action button
        ResultDescription{end+1} = ModelAdvisor.Text('All Logging information is set up correct');
        ResultDetails{end+1}     = {};                                       
        mdladvObj.setCheckResultStatus(true);     
    else
        mdladvObj.setCheckResultData(eachPass);
        mdladvObj.setActionEnable(1);      
        mdladvObj.setCheckResultStatus(false);     
        mdladvObj.setCheckErrorSeverity(1); % The check failed
    end
    
end

function [ResultDescription, ResultDetails] = inputDataConfigurationFunc(system)
    % initilize the returns to empty
    ResultDescription = {};
    ResultDetails     = {};
    hasPassed         = 1;
    % get the model advisor handle for the model.
    mdladvObj = Simulink.ModelAdvisor.getModelAdvisor(system);
    % pass fail status to "fail" 
    mdladvObj.setCheckResultStatus(true);         
    passText = ModelAdvisor.Text('Pass: ',{'bold','pass'});
    failText = ModelAdvisor.Text('Fail: ',{'bold','fail'});    
    
    % first see if the model has root level inports
    % By setting the SearchDepth Parameter to 1 only the root level is
    % checked
    rootIn = find_system(system,'SearchDepth',1,'BlockType','Inport');
    % So there are no root level inports, need to check for blocks that
    % supply signals.  E.g. fromWorkspace, fromFile, or SignalBuilder
    fromFile = find_system(system,'BlockType','FromFile');
    fromWS   = find_system(system,'BlockType','FromWorkspace');
    % The Signal Builder blocks is actually a Masked Subsystem.
    % Because of this we need to search based on the mask type
    sigBuilder = find_system(system,'MaskType','Sigbuilder block');
    % Cat the signals together so it can be checked in one step.
    allSource  = [fromFile;fromWS;sigBuilder];
    if (isempty(allSource))  && (isempty(rootIn))
        % error detected: No inports or Other sources.
        ResultDescription{end+1} = ModelAdvisor.Paragraph(['No signal',...
                                   ' sources where detected in the model']);
        ResultDetails{end+1}     = {};         
        hasPassed                = 0;
    end
    if (isempty(allSource)==0)
        % if fromWorkspace blocks or fromFile blocks are found make
        % sure the data / file exists
        if (~isempty(fromFile))
            % For every fromFile block check that the mat file exists
            for inx = 1 : length(fromFile)
                matName = get_param(fromFile{inx},'FileName');
                % see if the file exists
                if (exist(matName,'file') == 0)
                    ResultDescription{end+1} = ModelAdvisor.Text(['The file ',...
                        matName,' does not exist for the following from file block']);%#ok  
                    % this will add a hyper link to the block
                    ResultDetails{end+1} = fromFile{inx};%#ok<AGROW>
                    hasPassed            = 0;                    
                end
            end % ends for loop
        end
        if (~isempty(fromWS))
            % For every fromFile block check that the mat file exists
            for inx = 1 : length(fromWS)
                varName = get_param(fromWS{inx},'VariableName');
                % see if the file exists
                if (evalin('base',['exist(''',varName,''',''var'')']) == 0)
                    ResultDescription{end+1} = ModelAdvisor.Text(['The workspace variable ',...
                        varName,' does not exist for the following from workspace block']);%#ok  
                    % this will add a hyper link to the block
                    ResultDetails{end+1} = fromWS{inx}; %#ok                                                          
                    hasPassed            = 0;                    
                end
            end % ends for loop
        end
    end 
    if (isempty(rootIn) == 0)
        % check to make sure that the root level inport data is enabled and
        % that the data exists for the the root level inports
        % This data exists as part of the configurtation set
        myObj     = getActiveConfigSet(system);
        isEnabled = get_param(myObj,'LoadExternalInput');
        if (strcmp(isEnabled,'on'))
            % check that the workspace params exist
            varStr          = get_param(myObj,'ExternalInput');
            [vars,passFail] = parseOutVars(varStr);
            if (passFail == 0)
                t1 = ModelAdvisor.Text('The following variables where not in the base workspace ');                
                t2 = ModelAdvisor.Text([vars{:}],{'bold','fail'}); % bold & red
                
                ResultDescription{end+1} = [failText t1 t2];  
                % this will add a hyper link to the block
                ResultDetails{end+1} = {};                                                         
                hasPassed            = 0;                
            end % Ends the passFail check
        else % the model dosn't have the input enabled
            t1                       = ModelAdvisor.Text('The model has root level inputs,');
            t2                       = ModelAdvisor.Text(' but the inputs where not enabled in the data logging menu');                
            ResultDescription{end+1} = [failText t1 t2];              
            ResultDetails{end+1}     = {};                                                                     
            hasPassed                = 0;                            
        end % Ends the isEnabled if
    end
    
    if (hasPassed == 1)
        mdladvObj.setActionEnable(0); % the check passed, therefore enable action button
        ResultDescription{end+1} = [passText,ModelAdvisor.Text('Input information is correctly configured')];
        ResultDetails{end+1}     = {};                                       
        mdladvObj.setCheckResultStatus(true);     
    else
        mdladvObj.setActionEnable(1);      
        mdladvObj.setCheckResultStatus(false);     
        mdladvObj.setCheckErrorSeverity(1); % The check failed
    end
        
end

function [ResultDescription, ResultDetails] = signalLoggingEnabledFunc(system)
    % initilize the returns to empty
    ResultDescription = {};
    ResultDetails     = {};

    % get the model advisor handle for the model.
    mdladvObj = Simulink.ModelAdvisor.getModelAdvisor(system);
    % pass fail status to "pass" 
    mdladvObj.setCheckResultStatus(false);         
    

    % get the model information:
    allLines = find_system(system, 'FindAll', 'on', 'type', 'line');
    % get the names off of the lines
    lineNames = get_param(allLines,'Name');
    % get the array index of just the non empty string
    index = find(strcmp(lineNames,'')==0);
    % sub-select the old arrays
    linesOfInt = allLines(index);
    lineNames  = lineNames(index);
    
    % Signal logging is enabled at the source port so we get that first
    lineSrPort = get_param(linesOfInt,'SrcPortHandle');
    lineSrPort = [lineSrPort{:}]; % get it into an easy to use format...
    logEnabled = get_param(lineSrPort,'DataLogging');
    index      = find(strcmp(logEnabled,'on') == 0); 
    % sub-select the old arrays
    linesOfInt    = allLines(index);
    lineNames     = lineNames(index);
    lineSrPortAll = lineSrPort(index);
    lineParentAll = get_param(lineSrPortAll,'Parent');
    
    % get input parameters
    inputParams = mdladvObj.getInputParameters;
    usePrefix   = inputParams{1}.Value;    
    prefixStr   = inputParams{2}.Value;
    
    lineParent = []; 
    lineSrPort = [];                 
    
    if (isempty(linesOfInt) == 0)    
        if (usePrefix == 1)
            % look at ust the signals with the desired prefix
            index = strfind(lineNames,prefixStr);
            if (isempty(index) == 0)            
                for qnx = 1 : length(index)
                    if (isempty(index{qnx}) == 0) && (index{qnx} == 1)
                        % subselect the line parents needed.
                        lineParent{end+1} = lineParentAll{qnx}; 
                        lineSrPort(end+1) = lineSrPortAll(qnx);                 
                    end
                end % ends for loop
            end % ends the isempty loop
        else % Not using prefix, so any lines are game
            lineParent = lineParentAll;
            lineSrPort = lineSrPortAll;
        end % ends the if (usePrefix == 0) struct
        
        if (isempty(lineParent) == 0) 
            ResultDescription{end+1} = ModelAdvisor.Text(['Enable signal',...
                    ' logging on the following signals']);
            % this will add a hyper link to the block
            ResultDetails{end+1}     = lineParent;                                                        
            mdladvObj.setCheckResultData(lineSrPort);
            mdladvObj.setActionEnable(1);      
            mdladvObj.setCheckResultStatus(false);     
            mdladvObj.setCheckErrorSeverity(1); % The check failed
            % Add the information to the list view 
            myLVParam            = ModelAdvisor.ListViewParameter;    
            myLVParam.Name       = 'Unlogged Signals'; % the name appeared at pull down filter
            myLVParam.Data       = get_param(lineSrPort,'Object');  % needs to be the object
            myLVParam.Attributes = {'Name','DataLogging'}; % name is default property
            mdladvObj.setListViewParameters({myLVParam});                
        else
            mdladvObj.setCheckResultStatus(true);     
            mdladvObj.setCheckErrorSeverity(0); % The check failed
        end
    end % ends (isempty(linesOfInt) == 0)    
    
    
end

function [ResultDescription, ResultDetails] = stateflowExampleFunc(system)
    % initilize the returns to empty
    ResultDescription = {};
    ResultDetails     = {};

    % get the model advisor handle for the model.
    mdladvObj = Simulink.ModelAdvisor.getModelAdvisor(system);
    % pass fail status to "pass" 
    mdladvObj.setCheckResultStatus(true);         
    
    % This check will provide information only: Information will be
    % recorded in a table:
    
    rt        = sfroot;
    chart     = rt.find('-isa','Stateflow.Chart');
    numCharts = length(chart);
    table     = ModelAdvisor.Table((numCharts * 3),2);
    chj       = ModelAdvisor.Text('Chart uses history junctions',{'bold'});
    cn        = ModelAdvisor.Text('Chart Name',{'bold'});
    cmt       = ModelAdvisor.Text('Chart uses junctions with multiple transitions',{'bold'});  
    trueTxt   = ModelAdvisor.Text('TRUE',{'fail','bold'});
    falseTxt  = ModelAdvisor.Text('FALSE',{'pass','bold'});    
    for inx = 1 : numCharts
        curChart = chart(inx);
        rowBase  = (inx - 1) * 3;
        table.setEntry(1 + rowBase,1,cn);        
        table.setEntry(1 + rowBase,2,ModelAdvisor.Text(curChart.Name,{'italic','bold'}));
        junc           = curChart.find('-isa','Stateflow.Junction');
        hasHist        = 0;
        hasMultOutJunc = 0;
        multiJuncs     = {};
        for jnx = 1 : length(junc)
            if (strcmp(junc(jnx).Type,'HISTORY'))
                hasHist = 1;
            else
                transOut = junc(jnx).sourcedTransitions;
                if (length(transOut) > 1)
                    hasMultOutJunc    = 1;
                    multiJuncs{end+1} = junc(jnx);
                end
            end
        end % end jnx loop
        table.setEntry(2 + rowBase,1,chj);
        if (hasHist == 0)
            table.setEntry(2 + rowBase,2,falseTxt);
        else
            table.setEntry(2 + rowBase,2,trueTxt);            
        end

        table.setEntry(3 + rowBase,1,cmt);
        if (hasMultOutJunc == 0)
            table.setEntry(3 + rowBase,2,falseTxt);
        else
            table.setEntry(3 + rowBase,2,trueTxt);            
        end
        if (hasMultOutJunc == 1)
            ResultDescription{end+1} = ModelAdvisor.Text('Link to Bad Junctions');
            ResultDetails{end+1}     = multiJuncs;
        end
        
    end % end inx loop
    ResultDescription{end+1} = table;
    ResultDetails{end+1}     = {};
end

function [missVars,pf] = parseOutVars(varStr)
    
    pf       = 1; % defaults to pass
    missVars = {};
    % step 1: remove the start /
    varStr = regexprep(varStr,' ','');
    varStr = varStr(2:end-1);
    varStr = regexp(varStr,',','split');
    for inx = 1 : length(varStr)
        found = evalin('base',['exist(''',varStr{inx},''',''var'')']);
        if (found == 0)
            pf              = 0; % failed
            missVars{end+1} = [varStr{inx},' ']; %#ok Note the space is added for display
        end
    end
    

end

function result = dataLoggingSettingsAction(taskobj)
    mdladvObj = taskobj.MAObj;
    % Get the name of the system:
    system    = getfullname(mdladvObj.System);
    % get input parameters
    inputParams = mdladvObj.getInputParameters;
    saveOrInc   = inputParams{1}.Value;
    % get the checks that passed / failed
    eachPass = mdladvObj.getCheckResultData(mdladvObj.getActiveCheck);
    % create the return text
    result = ModelAdvisor.Paragraph;
    
    
    if (eachPass{1} == 0)
        set_param(system,'SignalLogging','on');
        result.addItem('Signal Logging now enabled');        
    end
    if (eachPass{2} == 0)
        % first the file name        
        logName = simget(system,'SignalLoggingName');          
        if (saveOrInc == 1)
            fName   = [logName,'_',datestr(now,30)];
            evalin('base',['save ',fName,' ',logName,';']);
            evalin('base',['clear ',logName,';']);
            result.addItem('File saved: data deleted from base workspace');                
        else
            % check to see if it ends in a number
            [newName] = incrementNumber(logName);
            set_param(system,'SignalLoggingName',newName);
            result.addItem(['Signal name incremented to ',newName]);                    
        end
    end
    if (eachPass{3} == 0)
        set_param(system,'SaveFormat','StructureWithTime');
        result.addItem('Signal Logging format changed to structure with time');                
    end
    % save result
    mdladvObj.setActionEnable(false);
end

function result = signalLoggingEnabledAction(taskobj)
    mdladvObj = taskobj.MAObj;
    % get the source ports in question...
    lineSrPort = mdladvObj.getCheckResultData(mdladvObj.getActiveCheck);
    for inx = 1 : length(lineSrPort)
        set_param(lineSrPort(inx),'DataLogging','on');
    end
    % create the return text
    result = ModelAdvisor.Paragraph;
    result.addItem('Signal logging now enabled');                    
    % disable the action button
    mdladvObj.setActionEnable(false);
end

function [newName] = incrementNumber(logName)
    % The format of the extension is VarName_#
    % if there are multiple _ in the string we look for the last one
    underLoc = findstr(logName,'_');
    if (isempty(underLoc))
        % there are no post scripts... start a new version
        newName = [logName,'_1'];
    else
        endNum = logName(underLoc(end)+1:end);
        endNum = str2double(endNum);
        % check to make sure that the end was a number
        if (isnan(endNum)) 
            newName = [logName,'_1'];
        else
            endNum = endNum + 1;
            newName = [logName(1:underLoc(end)),num2str(endNum)];
        end % ends if (isempty(endNum))
    end % ends if (isempty(underLoc))
end