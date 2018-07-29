function [] = COREmkrequirements()

global CURRENT_PROJECT
disp(' ')
disp(['Importing requirements from: ' CURRENT_PROJECT ,'\Requirements.xls'])
disp('Warning: ensure that all required fields in Requirements.xls are properly filled.')

waitbar0tot = 5;
%% Get assumptions from excel file
waitbar0 = waitbar(0/waitbar0tot,'Importing Assumptions');
[~,~,raw]=xlsread('Requirements.xls','Assumptions');  
raw(1,:) = []; %get rid of header row
raw(:,1) = []; %get rid of description column

for ii = 1:size(raw,1)
    varname = raw{ii,1};
    var = raw{ii,2};
    if ischar(varname) %keep going
        if isnumeric(var) %numeric
            evalc(['baseAC.Ass.',varname '=' num2str(var)]);
        elseif ischar(var) %string
            if strcmp('@',var(1)) %if function handle
                evalc(['baseAC.Ass.',varname '=' var]);
                checkandtrytocopy(var(2:end))
            else
                evalc(['baseAC.Ass.',varname '= ''' var '''']);
            end
        else 
            beep;beep;
            fprintf('Unknown parameter/assumption type %s\n',varname)
        end
    else
        break
    end
end
disp('*****Assumptions:')
disp(baseAC.Ass)

%%
disp(' ')
waitbar(1/waitbar0tot,waitbar0,'Importing point performance requirements');
[~,txt,raw]=xlsread('Requirements.xls','Point Performance');
raw(1,:) = []; %get rid of header row
% raw(:,1) = []; %get rid of description column
nPP = size(txt,1)-2;
if nPP <=0
    disp('invalid or no point performance specified')
end

for ii = 2:size(raw,1)
    label = raw{ii,1};
    if ischar(label)
        for jj = 1:size(raw,2)
            varname = raw{1,jj};
            if ischar(varname)
                writeloc = ['PPStates(' num2str(ii-1) ').' varname];
                eval([writeloc ' = (raw{ii,jj});']);
            else
                break
            end
        end
    else
        break
    end
end
waitbar(1.5/waitbar0tot,waitbar0,'converting to SI units');
for ii = 1:length(PPStates) %#ok<NODEF>
    PPStates(ii).range = convlength(PPStates(ii).range,'naut mi','m'); %#ok<*AGROW>
    PPStates(ii).hmin = convlength(PPStates(ii).hmin,'ft','m');
    PPStates(ii).hmax = convlength(PPStates(ii).hmax,'ft','m');
    PPStates(ii).Vmin = convvel(PPStates(ii).Vmin,'kts','m/s');
    PPStates(ii).Vmax = convvel(PPStates(ii).Vmax,'kts','m/s');
    PPStates(ii).ROC = convvel(PPStates(ii).ROC,'ft/min','m/s');
    PPStates(ii).omega = convangvel(PPStates(ii).omega,'deg/s','rad/s');
    PPStates(ii).AccessPwr = convpower(PPStates(ii).AccessPwr,'hp','W');
    PPlabels{ii,1} = PPStates(ii).label;
end
disp('*****Point performance requirements (converted to SI):')
disp(PPStates);
Spec.PPStates = PPStates;
Spec.PPlabels = PPlabels;
Spec.nPPrequirements = length(PPStates);


%%
disp(' ')
waitbar(2/waitbar0tot,waitbar0,'Importing additional constraints');
[~,txt,raw]=xlsread('Requirements.xls','Constraints'); 
raw(1,:) = []; %get rid of header row
raw(:,1) = []; %get rid of description column
nconstraints = size(txt,1)-1;
if nconstraints == 0
    Spec.nonllabels = [];
    Spec.nonlcon = [];
    Spec.nonlvals = [];
    disp('no additional constraints')
else
    for ii = 1:nconstraints
        Spec.nonllabels{ii,1} = raw{ii,1};
        Spec.nonlcons{ii,1}=eval(['@' raw{ii,2} ';']);
        checkandtrytocopy(raw{ii,2})
        Spec.nonlvals(ii,1)=raw{ii,3};
    end
end
Spec.nnonl = nconstraints;
disp('*****Additional constraints:')
disp('    Label            Nonlcon            constraint value...')
disp(raw)
disp(' ')

%%
waitbar(3/waitbar0tot,waitbar0,'Importing objective functions');
[~,txt,raw]=xlsread('Requirements.xls','Objectives');
raw(1,:) = []; %get rid of header row
raw(:,1) = []; %get rid of description column
nObj = size(txt,1)-1;
if nObj == 0
    Objectives = [];
    disp('no Objectives')
else
    for ii = 1:nObj
        Objectives{ii,1}=eval(['@' raw{ii,2} ';']);
        checkandtrytocopy(raw{ii,2})
        Spec.Objlabels{ii,1}=raw{ii,1};
    end
end
disp('*****Objective functions:')
disp(raw)
Spec.nObj = nObj;
Spec.Objfuncs = Objectives;
disp(' ')

%%
waitbar(4/waitbar0tot,waitbar0,'Defining Design Variables');
disp('*****Design Variables:')
[~,txt,raw]=xlsread('Requirements.xls','Design Variables');
disp(txt)
txt(1,:) = [];
raw(1,:) = []; %get rid of header row
nMyDesignVars = size(txt,1);
if nMyDesignVars == 0
    MyDesignXlabels = [];
    MyDesignXnames = [];
    MyDesignTypVals = [];
else
    for ii = 1:nMyDesignVars
        MyDesignXnames{ii,1}=txt{ii,1};
        MyDesignXlabels{ii,1}=txt{ii,2};
        MyDesignTypVals(ii,1)=raw{ii,3};
    end
end
Spec.MyDesignXlabels = MyDesignXlabels;
Spec.MyDesignXnames = MyDesignXnames;
Spec.nMyDesignVars = nMyDesignVars;
Spec.MyDesignTypVals = MyDesignTypVals;
disp(' ')

%%
Spec.baseAC = baseAC;

save Requirements.mat Spec
disp('Spec saved to Requirements.mat')
disp(' ')
waitbar(1,waitbar0,'complete');
close(waitbar0)
end

function checkandtrytocopy(functionstring)
global CORE_PARENT_DIR
if strcmp(functionstring(end-1:end),'.m')
    functionstring(end-1:end)=[];
end
%see if it is in the project folder or on path
if exist(functionstring)<2 %#ok<EXIST>
    beep;
    fprintf('\n%s function NOT found in project folder or on path\n',...
        functionstring);
    if get_yes_or_no(sprintf(...
            'Attempt to copy %s.m from toolbox folder? [Y]/N: ',...
            functionstring),true)
        try
            copyfile([CORE_PARENT_DIR '\toolbox\' functionstring '.m'])
        catch
            beep;
            disp('Copy failed. Be sure to populate project folder before proceeding')
        end
    end
end
end

function out = convlength ( in, uin, uout)
%CONVLENGTH Convert from length units to SI length units.
if ~strcmpi('m',uout)
    error('invalid output unit')
end

%conversion to m
if strcmpi('naut mi',uin)
    slope = 1852;
elseif strcmpi('ft',uin)
    slope = 0.3048;
else
    error('invalid input unit string')
end

out = in.*slope;
end

function out = convangvel ( in, uin, uout)
%conversion from deg/s to rad/s
if strcmpi('deg/s',uin) && strcmpi('rad/s',uout)
    out = in.*0.017453292519943;
else
    error('unit(s) not supported')
end
end