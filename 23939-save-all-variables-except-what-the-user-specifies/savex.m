function savex(varargin)
% % SAVEX
% % 
% % save all variables that are present in the workspace EXCEPT what you
% % specify explicitly (by including the variable names or by using regular 
% % expressions).
% % 
% % Author         : J.H. Spaaks
% % Date           : April 2009
% % MATLAB version : R2006a on Windows NT 6.0 32-bit
% %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % 
% % test1a = 0;
% % test2a = 2;
% % test3a = 4;
% % test4a = 6;
% % test5a = 8;
% % 
% % test1b = 1;
% % test2b = 3;
% % test3b = 5;
% % test4b = 7;
% % test5b = 9;
% % 
% % % This example saves all variables that are present in the workspace except
% % % 'test2a' and 'test5b'. 'test3' is ignored since there is no variable by
% % % that name:
% % savex('save-by-varname.mat','test2a','test3','test5b')
% % 
% % % This example saves all variables that are present in the workspace except
% % % 'test4a', 'test4b' and 'test2b':
% % savex('save-by-regexp.mat','-regexp','test4[ab]','t[aeiou]st2[b-z]')
% % 
% % % This example saves all variables that are present in the workspace except 
% % % those formatted as Octave system variables, such as '__nargin__':
% % savex('no-octave-system-vars.mat','-regexp','^__+.+__$')
% % 
% % % This example saves all variables that are present in the workspace except 
% % % those which are specified using regular expressions, saving in ascii
% % % format. Supported options are the same as for SAVE.
% % savex('save-with-options.txt','-regexp','test4[ab]',...
% % 't[aeiou]st2[b-z]','-ascii')
% % 
% % 
% % 
% % % clear
% % % load('save-by-varname.mat')
% % % 
% % % clear
% % % load('save-by-regexp.mat')
% % % 
% % % clear
% % % load('no-octave-system-vars.mat')
% % % 
% % % clear
% % % load('save-with-options.txt','-ascii')
% % % 


varList = evalin('caller','who');
saveVarList = {};

if ismember(nargin,[0,1])
    % save all variables
    saveVarList = varList
    for u = 1:numel(saveVarList)
        eval([saveVarList{u},' = evalin(',char(39),'caller',char(39),',',char(39),saveVarList{u},char(39),');'])
    end    
    save('matlab.mat',varList{:})
    
elseif strcmp(varargin{2},'-regexp')
    % save everything except the variables that match the regular expression
    
    optionsList = {};
    inputVars ={};
    for k=3:numel(varargin)
        if strcmp(varargin{k}(1),'-')
            optionsList{1,end+1} = varargin{k};
        else
            inputVars{1,end+1} = varargin{k};
        end
    end
    

    for k=1:numel(varList)
        
        matchCell = regexp(varList{k},inputVars,'ONCE');
       
        matchBool = repmat(false,size(matchCell));
        for m=1:numel(matchCell)
            if ~isempty(matchCell{m})
                matchBool(m) = true;
            end
        end
        if ~any(matchBool)
            saveVarList{end+1} = varList{k};
        end
    end

    for u = 1:numel(saveVarList)
        eval([saveVarList{u},' = evalin(',char(39),'caller',char(39),',',char(39),saveVarList{u},char(39),');'])
    end
    
    save(varargin{1},saveVarList{:},optionsList{:})
    
    
    
elseif ischar(varargin{1})
    % save everything except the variables that the user defined in
    % varargin{2:end}
    optionsList = {};
    inputVars = {};
    for k=2:numel(varargin)
        if strcmp(varargin{k}(1),'-')
            optionsList{1,end+1} = varargin{k};
        else
            inputVars{1,end+1} = varargin{k};
        end
    end
    
    for k=1:numel(varList)
        
        if ~ismember(varList{k},inputVars)

            saveVarList{end+1} = varList{k};
            
        end
        
    end

    for u = 1:numel(saveVarList)
        eval([saveVarList{u},' = evalin(',char(39),'caller',char(39),',',char(39),saveVarList{u},char(39),');'])
    end
    
    save(varargin{1},saveVarList{:},optionsList{:})
    
else
    error('Unknown function usage.')
end
    
    

