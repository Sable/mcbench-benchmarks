function scrollto(name, pos)

% SCROLLTO Opens variable in the Variables Editor and scrolls to the specified position
%
%   SCROLLTO(NAME, POS) Opens the base workspace variable specified by
%                       NAME and programmatically scrolls to POS.
%
%       NAME    should be a string, i.e. a 1 by N char, pointing to a
%               2-dimensional existing variable in the base workspace.
%               It also works with indexed variables, e.g. 'c{1}', if
%               the referenced object is a supported scrollable class.
%
%       POS     can be a linear index or a pair of subscripts,
%               e.g. [20, 7].
%
%   Supported scrollable classes:
%       * numeric
%       * logical
%       * cell
%       * timeseries
%       * table (from R2013b)
%       * categorical (from 2013b)
%       * dataset (Statistics Toolbox)
%
%   WARNING: This code heavily relies on undocumented and unsupported Matlab functionality.
%
%
%   Examples:
%
%       % Scroll a simple logical variable
%       a   = false(1e6,100);
%       pos = randi(1e8,1);
%       scrollto('a',pos)
%
%       % Scroll somewhere else
%       scrollto('a',[1e5, 28])
%
%       % Wrap into a structure and scroll the indexed variable
%       s.foo = a;
%       scrollto('s.foo',pos)
%
%       % Wrap into cell and scroll with several levels of nesting
%       c = {s};
%       scrollto('c{1}.foo', pos)
%
%       % Scroll 3D array
%       a = rand(10,10,10);
%       scrollto('a(:,:,2)',[5,2])
%
%
% Additional features:
% - <a href="matlab: web('http://www.mathworks.co.uk/matlabcentral/fileexchange/42795','-browser')">FEX scrollto page</a>
% - <a href="matlab: web('http://undocumentedmatlab.com/blog/variables-editor-scrolling/','-browser')">Variables Editor scrolling | Undocumented Matlab</a>
% - <a href="matlab: web('http://www.mathworks.co.uk/matlabcentral/answers/79930','-browser')">Origin: question on MATLAB Answers</a>
% - <a href="matlab: web('http://undocumentedmatlab.com/matlab-java-book/','-browser')">Undocumented Secrets of Matlab-Java Programming</a>
%
% See also: OPENVAR, ISNUMERIC, LOGICAL, CELL, TIMESERIES, TABLE, CATEGORICAL, DATASET, IND2SUB, SUB2IND, FINDJOBJ

% Author: Oleg Komarov (oleg.komarov@hotmail.it)
% Tested on R2013a/b Win7 64 and Vista 32
% Backward compatibility can be tested/(added if possible) on request
% 20 jul 2013 - Created
% 28 aug 2013 - Scrolls from 'caller' ws, e.g. scroll in debug mode; fixed corner case bug of within size-bounds scrolling; fixed bug that swapped the scrolling type of ts to dataset.
% 11 sep 2013 - Added support for table and categorical arrays (classes introduced with R2013b)

%% Checks
narginchk(2,2)

% NAME
if ~(ischar(name) && isrow(name));
    szName = size(name);
    error('scrollto:stringName','NAME should be a string, i.e. a 1xN char, was a %s%s ''%s'' instead.', ...
        sprintf('%dx',szName(1:end-1)), sprintf('%d',szName(end)),class(name))
elseif regexp(name,'([,;][^a-zA-Z]*[a-zA-Z]|eval)','once')
    error('scrollto:riskyName','NAME was: %s\n Potential security threat.',name)
end

% POS
if isempty(pos)|| ~isnumeric(pos) || ~isvector(pos) || numel(pos) > 2 || any(pos < 1) || any(mod(pos,1) > 0)
    error('scrollto:numPos','POS can be a linear index or a pair of subscripts, e.g. [10, 2].')
end
%% Engine
% Persistent variables: desktop instance for performace, isasync, typeName and varSIze to scroll from caller ws
persistent desktop isasync typeName varSize

% If the call is not asynchronous
if isempty(isasync) || ~isasync || isempty(typeName)
    
    % Strip variable name of indexing and check if it exists in the caller ws
    wsname = regexp(name,'^[a-zA-Z]\w*','match','once');
    inws   = strcmp(wsname, evalin('caller','builtin(''who'')'));
    
    if isempty(inws) || ~any(inws)
        openvar(name)
        return
    else
        suppClasses = {'uint8','uint16','uint32','uint64', 'int8', 'int16', 'int32','int64','logical','single','double','cell','dataset','table','categorical','timeseries'};
        varClass    = evalin('caller',['builtin(''class'',',name,');']);
        varSize     = evalin('caller',['builtin(''size'',' ,name,');']);
        idxSuppCl   = strcmp(varClass, suppClasses);
        if any(idxSuppCl) && numel(varSize) < 3
            suppTypes    = {'VariableTable','CellTable','DatasetVariableTable','TableObjectVariableTable','CategoricalVariableTable','TimeSeriesArrayEditorTablePanel:fDataTable'};
            idx2suppType = [ones(1,11) 2 3 4 5 6];
            typeName     = suppTypes{idx2suppType(idxSuppCl)};
        else
            warning('scrollto:unsupportedClass','Cannot scroll ''%s''. Either not a supported class or not scrollable.',name)
            return
        end
    end
    
    % Retrieve desktop instance on first call
    if isempty(desktop)
        desktop = com.mathworks.mde.desk.MLDesktop.getInstance;
    end
    
    % Open/grab focus
    openvar(name)
end

% Reset asynchronicity status
isasync = false;

% Retrieve handle to scrollable table
h = findjobj(desktop.getClient(name),'property',{'name',typeName});

% IF still empty the Variable Editor (VE) is still rendering
if isempty(h)
    % The asynchronous execution of scrollto happens through a callback, therefore I cannot re-retrieve 
    % the typeName from the 'caller' ws (of the callback), but I need to use its previous value.
    asynchronousScrollto(pos,name)
    % The isasync flag is necessary because I cannot simply re-use any previously determined typeName.
    isasync = true;
    return
end

% Update or first scroll will mismatch the row
h.updateUI
pause(0.05)

% Convert linear index to subscripts
if isscalar(pos)
    [pos(1),pos(2)] = ind2sub(varSize, pos);
end
% Rebase to 0 and bound to max scrollability if pos is not a scalar
row = min(pos(1)-1, h.getRowCount-1);
col = min(pos(2)-1, h.getColumnCount-1);

% Select, scroll and update
h.setRowSelectionInterval(row,row)
h.setColumnSelectionInterval(col,col)
pause(0.05)
h.scrollCellToVisible(row,col)
h.updateUI
end

% To scroll you need the variable to be already opened/rendered in the Variables Editor.
% In cases when this is not true, the rendering happens only after the functions has
% finished executing. Thus, we need to first openvar(), terminate the call to scrollto(),
% and finally fire a second call to scrollto().
function asynchronousScrollto(pos,name)
t = timer(...
    'TimerFcn'        ,@(obj,ev) scrollto(name,pos),...
    'StartDelay'      ,0.2                         ,...
    'TasksToExecute'  ,1                           ,...
    'StopFcn'         ,@(obj,ev) delete(obj)       ,...
    'ObjectVisibility','off');
start(t)
end