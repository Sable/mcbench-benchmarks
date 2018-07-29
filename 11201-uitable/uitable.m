function [varargout] = uitable(varargin)
% UITABLE creates a two dimensional graphic uitable
%       This is an alternative to MATLAB 7's UITABLE.  It will work
%       with MATLAB 6.5 and also in no-JAVA mode.
%       
%Uses:
%     UITABLE creates a modal 15x6 table of empty cells 
%
%     UITABLE(hAxes) creates a modal 15x6 uitable within the boundaries
%     specified by position of the axes handle "hAxes"
%
%     UITABLE(data) creates a modal uitable corresponding to the numerical
%     or cell array "data"
%
%     UITABLE(P) creates a uitable according to the properties specified in
%     the property structure "P" (see list of properties below)
%
%     UITABLE(hAxes,data)
%     UITABLE(hAxes,P) 
%     UITABLE(data,P)
%     UITABLE(hAxes,data,P)
%     are all acceptable combinations of the inputs listed above
%
%     [data] = UITABLE(...), when running the uitable as modal, will return
%     the table contents "data" as a numerical array or as a cell array if
%     not all table entries are numerics
%
%     [data,checkedRows] = UITABLE(...), when running the uitable as modal and
%     if checkBoxes are used (see properties below), will return also a vector
%     containing the rows that have been checked 
%
%     [hAxes] = UITABLE(...), when running the uitable non-modally, will
%     return the handle to the axes within which the table lies.  The data
%     can then be accessed via:
%                      a = getappdata(hAxes,'data');
%                      b = getappdata(hAxes,'checkedRows');
%
%
%NOTES!!!!!
%   1. When running on MICROSOFT WINDOWS, a cell will not be updated
%      unless you press ENTER after editing the cell.  On UNIX systems, the table
%      is updated automatically.  (see uicontrol reference in MATLAB help)
%   2. All application data associated with a specified axes will be destroyed
%      before creating the table.  If you want to store additional appdata
%      with the axes, please use setappdata AFTER the table has been created.
%   3. Data are presented as strings in the table.  The numeric data you
%      recover from the table may not have the same precision as the original
%      numeric data you submitted using UITABLE(data).  Set an appropriate
%      P.precision value (see Properties below).
%   4. This axes-based implementation of a uitable is an alternative method for
%      specifying cell size.  If you want larger cells, make the axes larger and
%      select appropriate P.nVisibleRows & P.nVisibleCols parameters.
%   5. If cell highlighting is on, you must click the cell once to select it,
%      and then once more to edit it.
%   6. Highlighting can be cleared by pressing the small box marked "H" in the
%      top left corner of the table
%   7. Table refresh speed depends on the number of cells used.  It is
%      suggested to use less than 400 cells.
%   8. In modal mode, pressing 'Cancel' wll yield empty ouputs (i.e. []).
%   9. All properties are case sensitive.
%  10. If relative column widths are specified using P.colWidth (see Properties
%      below), the column width in pixels will change depending on the
%      position of the horizontal slider.  The axes width will be filled
%      with P.nVisibleCols while maintaining the P.colWidth relative column widths.  
%  11. If running MATLAB in non-JAVA mode, run time may be slow in MATLAB 7.
%      This does not appear to be a problem if using MATLAB 6.5.
%
%Properties:
%     
%               modal:  0 or 1 specifying modal state
%        nVisibleRows:  int specifying number of visible rows
%        nVisibleCols:  int specifying number of visible columns
%           colLabels:  0, 1, or cell array of strings for column labels
%          checkBoxes:  0, 1, or vector of int for check boxes
%          rowNumbers:  0 or 1 for row numbers
%
%     disabledColumns:  [] or vector of int for preventing column editing
%            colWidth:  1 or vector of int for indicating relative column widths
%       highlightCell:  0 or 1  -- highlight selected cell
%        highlightRow:  0 or 1  -- highlight row of selected cell
%        highlightCol:  0 or 1  -- highlight column of selected cell
%            fontsize:  int for font size
%           precision:  s for formatting data (see fprintf)
%
%
%Examples:
%
%     a = uitable;
%
%     %Creates an empty 15x6 modal uitable in a new figure window.
%
%     a = uitable(rand(3,2));
%
%     %Creates a 3x2 modal uitable in a new figure window.
%
%     figure;
%     hAxes = axes('units','pixels','position',[45 45 400 140]);
%     a = uitable(hAxes, cell(3,12));
%
%     %Creates an empty 3x12 modal uitable in the axes specified by hAxes
%
%     data = rand(20,4);
%     P = struct('modal',0, 'nVisibleRows',19, 'colWidth',[5 1 3 3]);
%     P.checkBoxes = [2 5 9];
%     P.highlightCell = 0;
%     P.colLabels = 0;
%     P.precision = '%.3f';
%     ha = uitable(data,P);
%     a = getappdata(ha,'data');
%     b = getappdata(ha,'checkedRows');
%
%     %Creates a 20x4 non-modal uitable in a new figure window; table
%     %contains 3 check boxes, variable column widths, no column labels,
%     %with 3 digits of precision, etc.  Data is retrieved from the
%     %axes using gettappdata.
%
%     P.checkBoxes = [4 4];
%     P.colLabels = {'apples','oranges','bananas','water','melon','cherry'};
%     [a,b] = uitable(P);
%
%     %Creates a modal uitable with text boxes for only the 4th row.
%
%     see also UITABLE (from Matlab 7)
%
%
%Acknowledgements:
%
%This was developed based on the functions "tableGUI" by Joaquim Luis
%(2006-02-17) and "Editable Table in MATLAB" by Morris Maynard (2005-01-17)
%which are both available from the MATLAB Central File Exchange.
%
%Author:
%
% Todd C Pataky (0todd0@gmail.com)  26-May-2006


%Programming Notes:
%
%1. Since edit uicontrol callbacks are not executed until ENTER is pressed
%       on WINDOWS systems, I implemented highlighting behavior using
%       ButtonDownFcn.  However, this requires that the enabled state be
%       be 'inactive' or 'off'.  Thus there is the awkward behavior of
%       double-clicking when you want to edit a cell.
%2. Visibility is set to 'off' initially for all controls, as well as the figure
%       if a new figure is required.  This it so that the completed table is
%       presented all at once, instead of piece by piece. 
%3. All table information is stored as axes application data in the form of
%       structure "tb".  The handles for all uicontrols can be obtained
%       through this structure.  All uicontrols are stored separately.
%       Thus, beware with functions like findobj('type','uicontrol').
%       Matlab 7's new gui feature: "panel" can help avoid this problem.
%       In non-modal mode, the tb structure can be accessed using:
%             tb = getappdata(gca,'tb');
%
%       The structure tb contains the following fields:
%                 hAxes:                axes handle
%                  data: {mxn cell}     data as cell array
%                  geom: [1x1 struct]   geometric constants
%            vertSlider: [1x1 struct]   (uicontrol handle and information)
%           horizSlider: [1x1 struct]   (  "  )
%             colLabels: [1x1 struct]   (  "  )
%            checkBoxes: [1x1 struct]   (  "  )
%            rowNumbers: [1x1 struct]   (  "  )
%     unhighlightButton: [1x1 struct]   (  "  )
%          modalButtons: [1x1 struct]   (  "  )
%                 edits: [1x1 struct]   (  "  )  <-- cells of table
%
%       






%%%%%%%%%%%%%%%%%%%%
%MAIN PROGRAM
%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%
%PRELIMINARY DATA CHECKS
%%%%%%%%%%%%%%%%%%%%
%   - path, data, and parameter checks 
%   - parameters P set and not modified after these preliminaries
                 prelim_shadowCheck
[hAxes,data,P] = prelim_assignArg(varargin);
                 prelim_deleteExistingTable(hAxes);
           [P] = prelim_correctPformat(P);
                 prelim_checkNargout(P,nargout);           
[hAxes,data,P] = prelim_defaults(hAxes,data,P);
        [data] = prelim_data2strings(data,P);

        
        

%%%%%%%%%%%%%%%%%%%%
%CREATE TABLE FUNCTIONS
%%%%%%%%%%%%%%%%%%%%
%   - table structure tb created based on hAxes, data, and P
%   - only uicontrol handle properties are modified after
%     these create functions
[tb] = create_tbStructure(hAxes,data,P);
[tb] = create_cells(tb,P);
[tb] = create_colLabels(tb,P);
[tb] = create_rowNumbers(tb,P);
[tb] = create_checkBoxes(tb,P);
[tb] = create_sliders(tb,P);
[tb] = create_unhighlightButton(tb,P);
[tb] = create_modalButtons(tb,P);
setappdata(tb.hAxes,'tb',tb);   %save the completed tb structure


%%%%%%%%%%%%%%%%%%%%
%SET TABLE PROPERTIES
%%%%%%%%%%%%%%%%%%%%
%   - position, enabled state, etc. set before making table visible to user
visibility.rows = 1:P.nVisibleRows;
visibility.cols = 1:P.nVisibleCols;
setappdata(tb.hAxes,'visibility',visibility);
set_disabledColumns(tb,P)
set_positions(tb,P)
set_axesAppData(tb)
set_visibility(tb,P)



%%%%%%%%%%%%%%%%%%%%
%OUTPUT
%%%%%%%%%%%%%%%%%%%%
%   - select outputs based on modal or non-modal
if P.modal   %output data and checked rows
    setappdata(gcf,'ok2close',0);
    set(gcf,'deletefcn',@callback_close);
    uiwait(gcf)  %wait for user to press "OK" or "cancel" button
    if ishandle(tb.hAxes)   %false if window closed with the "X"
        varargout{1} = getappdata(tb.hAxes,'data');   %output table data or [] if cancelled
        if ~isequal(P.checkBoxes,0)
            varargout{2} = getappdata(tb.hAxes,'checkedRows');
        end
        close(gcf)
    else varargout{1}=[];   %if window closed with the "X"
         varargout{2}=[];
    end
else varargout{1} = tb.hAxes;   %if not modal mode, output axes handle
end






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SUB-FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PRELIMINARY FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% these functions are run before the table is created
% to check path, data, and parameter formats

function prelim_shadowCheck
%%%%%%%%%%%%%%%%
%PURPOSE: ensure that no other function "uitable" is in the path
%%%%%%%%%%%%%%%%
w = which('uitable.m','-all');
if length(w)>1
    warning('Multiple uitable.m files found in the current path.  Rename the file(s) to avoid shadowing.')
    fprintf('\n\n')
    for k=1:length(w)
        fprintf('%s\n',w{k});
    end
    fprintf('\n\n')
end





function [hAxes,data,P] = prelim_assignArg(arg)
%%%%%%%%%%%%%%%%
%PURPOSE: ensure that user's call adheres to one of the specified usages
%         (see initial comments)
%%%%%%%%%%%%%%%%
if length(arg)>3
    error('Too many inputs.')
end
for k=1:length(arg)
    if isempty(arg{k})
        error('Empty input argument.')
    end
end
%%%%%%%%%%%%%%%%%%%%
%check for usage depending on the number of inputs
%%%%%%%%%%%%%%%%%%%%
switch length(arg)
    case 0      %usage:  uitable
        hAxes = [];
        data = [];
        P = [];
    case 1      %usages:  uitable(hAxes); uitable(data); uitable(P)
        x = arg{1};
        if ishandle(x)
            hAxes = x;   data = [];   P = [];
        elseif isnumeric(x) | iscell(x)
            hAxes = [];   data = x;   P = [];
        elseif isstruct(x)
            hAxes = [];   data = [];   P = x;
        else error('Incorrect argument class.')
        end
    case 2      %usages:    uitable(hAxes,data), uitable(hAxes,P), uitable(data,P)
        x1 = arg{1};
        x2 = arg{2};
        if ishandle(x1)  &  ( isnumeric(x2) | iscell(x2) )
            hAxes = x1;   data = x2;   P = [];
        elseif ishandle(x1)  &   isstruct(x2)
            hAxes = x1;   data = [];   P = x2;
        elseif ( isnumeric(x1) | iscell(x1) )   &   isstruct(x2)
            hAxes = [];   data = x1;   P = x2;
        else error('Incorrect argument class.');
        end
    case 3      %usage:   uitable(hAxes,data,P)
        hAxes = arg{1};   data = arg{2};   P = arg{3};
        if ~all([ishandle(hAxes) isnumeric(data)|iscell(data) isstruct(P)])
            error('Incorrect argument class.');
        end
end
%%%%%%%%%%%%%%%%%%%%
%if hAxes is specified, make sure that it is a handle to a single axes
%%%%%%%%%%%%%%%%%%%%
if ~isempty(hAxes)
    if ~isequal(get(hAxes,'type'),'axes')
        error('hAxes must be an axes handle')
    elseif length(hAxes)>1
        error('hAxes must be a single handle')
    end
end
%%%%%%%%%%%%%%%%%%%%
%make sure that data contains more than one element
%and that, if a single element, it is not a previously deleted axes
%%%%%%%%%%%%%%%%%%%%
if ~isempty(data) & length(data)==1
    if isempty(hAxes)
        error('Input argument must be a valid axes handle.')
    else error('Data must be an array containing more than one element.')
    end
end
%%%%%%%%%%%%%%%%%%%%
%make sure that P is not a multi-dimensional structural array 
%%%%%%%%%%%%%%%%%%%%
if ~isempty(P) & length(P)>1
    error('P must be a 1x1 structured array.')
end







function prelim_deleteExistingTable(hAxes)
%%%%%%%%%%%%%%%%%
%PURPOSE: overwrite previous table
%%%%%%%%%%%%%%%%%
if isempty(hAxes)
    return
end
%%%%%%%%%%%%%%%%%%%%
%delete all controls
%%%%%%%%%%%%%%%%%%%%
h=[];
if isappdata(hAxes,'tb')
    tb = getappdata(hAxes,'tb');
    fnames = fieldnames(tb);
    for k=1:length(fnames)
        a = getfield(tb,fnames{k});
        if isfield(a,'h')
            fprintf('Deleting previous controls: %s\n',fnames{k});
            h0 = getfield(a,'h');
            h = [h; h0(:)];
        end
    end
    lh = length(h);
    delete(h)
    fprintf('Deleted %.0f uicontrols\n\n',lh)
end
%%%%%%%%%%%%%%%%%%%%
%remove all appdata
%%%%%%%%%%%%%%%%%%%%
appdata = getappdata(hAxes);
if ~isempty(appdata)
    fnames = fieldnames(appdata);
    for k=1:length(fnames)
        fprintf('Deleting previous appdata: %s\n',fnames{k});
        rmappdata(hAxes,fnames{k});
    end
    fprintf('\n')
end







function [P] = prelim_correctPformat(P)
%%%%%%%%%%%%%%%%%%%%%%%
%PURPOSE: complete parameter list with defaults and ensure correct format
%%%%%%%%%%%%%%%%%%%%%%%
if isempty(P)
    P=struct('nVisibleRows',10);
end
if ~isstruct(P) | length(P)>1
    error('P must be a 1x1 structural array.')
end
fnames = fieldnames(P);
requiredFields = {'nVisibleRows','nVisibleCols','fontsize','precision',...
        'colLabels','checkBoxes','rowNumbers',...
        'highlightCell','highlightRow','highlightCol',...
        'disabledColumns','colWidth','modal'};
defaultValues = {10,4,7,'%2f',   1,0,1,   1,1,1,   [],1,1};
%%%%%%%%%%%%%%%%%%%%
%check that all fields are required fields
%%%%%%%%%%%%%%%%%%%%
a = ismember(fnames,requiredFields);
if ~all(a)
    ind = find(~a);
    badfield = fnames{ind(1)};
    error(['Incorrect field name:  P.',badfield,' --- (note: case sensitive)'])
end
%%%%%%%%%%%%%%%%%%%%
%if field does not exist, set default value:
%%%%%%%%%%%%%%%%%%%%
for k=1:length(requiredFields)
    if isempty(strmatch(requiredFields{k},fnames,'exact'));
        P = setfield(P,requiredFields{k},defaultValues{k});
    end
end
%%%%%%%%%%%%%%%%%%%%
%check that all fields have the correct format
%%%%%%%%%%%%%%%%%%%%
fnames = fieldnames(P);
for k=1:length(fnames)
    x = getfield(P,fnames{k});
    err=0;
    switch fnames{k}
    case {'nVisibleRows','nVisibleCols','fontsize'}
        if isnumeric(x) & length(x)==1
            if rem(x,1) | x<2
                err=1;
            end
        else err=1;
        end
        if err;  error(['P.',fnames{k},' must be a single integer greater than 1.']);  end
    case 'precision'
        if ~isstr(x)
            error(['P.precision must be a string.']);
        end
    case 'colLabels'
        if isnumeric(x) & length(x)==1
            if ~ismember(x,[0 1])
                err=1;
            end
        elseif ~iscellstr(x)
            err=1;
        end
        if err;  error(['P.colLabels must be a 0, 1, or a cell array of strings']); end
    case 'checkBoxes'
        if isnumeric(x) & ~length(x)==0
            if length(x)==1
                if ~ismember(x,[0 1])
                    err = 1;
                end
            elseif any(x<1) | any(rem(x,1))
                err = 1;
            end
        else err=1;
        end
        if err; error(['Check boxes must be a 0, 1, or a vector of integers > 0.']);end     
    case {'rowNumbers','highlightCell','highlightRow','highlightCol','modal'}
        if isnumeric(x) & length(x)==1
            if ~ismember(x,[0 1])
                err=1;
            end
        else err=1;
        end
        if err; error(['P.',fnames{k},' must be a 0 or 1.']);  end
    case 'disabledColumns'
        if isnumeric(x)
            if any(rem(x,1)) | any(x<1)
                err=1;
            end
        else err=1;
        end
        if err;  error('P.disabledCols must be [], or a vector of integers > 0.'); end
    case 'colWidth'
        if isnumeric(x) & length(x)==1
            if x~=1
                err=1;
            end
        elseif isnumeric(x) & length(x)>1
            if any(x<1) | any(x>10)
                err=1;
            end
        else err=1;
        end
        if err;  error('P.colWidth must be a 1 or a vector of values from 1 to 10'); end
    end
end
    
    



function prelim_checkNargout(P,narg)
%%%%%%%%%%%%%%%%%%%%%%%
%PURPOSE: check that user has specified correct number of output arguments
%%%%%%%%%%%%%%%%%%%%%%%
if P.modal & (narg > 2)
        error('Maximum two output arguments [data,checkedRows] when running in modal mode.')
elseif ~P.modal & narg > 1
    error('Maximum one output argument [hAxes] when running in non-modal mode.')
end




function [hAxes,data,P] = prelim_defaults(hAxes,data,P)
%%%%%%%%%%%%%%%%%%%%%%%
%PURPOSE: check that hAxes and data are correct format; create if necessary
%%%%%%%%%%%%%%%%%%%%%%%
if isempty(data)
    data = cell(15,6);
elseif isnumeric(data)
    data = num2cell(data);  %converted back to numeric before being output
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Adjust number of visible rows/columns if necessary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if P.nVisibleRows > size(data,1)
    warning('P.nVisibleRows is less than the number of data rows. Adjusting P.nVisibleRows.')
end
if P.nVisibleCols > size(data,2)
    warning('P.nVisibleCols is less than the number of data columns. Adjusting P.nVisibleCols.')
end
P.nVisibleRows = min(P.nVisibleRows,size(data,1));
P.nVisibleCols = min(P.nVisibleCols,size(data,2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%If uniform column width selected, create a vector of ones
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isequal(P.colWidth,1)
    P.colWidth = ones(1,size(data,2));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%If no axes specified, create axes in a new figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(hAxes)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %note: the parameters for axesW and axes H (below) are from "create_tbStructure";
    %   if you'd like to modify default control sizes, please change the
    %   parameters both here and in "create_tbStructure"
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    axesW = P.nVisibleCols*80   +   ~isequal(P.checkBoxes,0)*15   +...
        P.rowNumbers*30   +   (P.nVisibleRows < size(data,1))*15;
    axesH = P.nVisibleRows*20   +   ~isequal(P.colLabels,0)*20   +...
        (P.nVisibleCols < size(data,2))*15 + P.modal*30;
    axespos = [   5   5   axesW      axesH   ]; 
    figpos  = [   5   5   axesW+10   axesH+10   ]; 
    fh = figure('unit','pixels','numbertitle','off','menubar','none','resize','off',...
        'position',figpos,'name','uitable','visible','off');
    if size(data,2)==1
        set(fh,'name','')
    end
    hAxes = axes('units','pixels','position',axespos,'visible','off');
    movegui(fh,'east')
end







function [data] = prelim_data2strings(data,P)
%%%%%%%%%%%%%%%%%%%%%%%
%PURPOSE: change all data to strings to allow for user formatting of numerics
%%%%%%%%%%%%%%%%%%%%%%%
X = data(:);
for k=1:length(X)
    x = X{k};
    switch class(x)
        case {'logical','int88','uinit88','int16','uint16','int32','uint32','int64','uint64','single','double'}
            s = num2str(x,P.precision);
        case 'char'
            s = x;
        case {'cell','struct'}
            error('All cells must contain numbers or strings.')
        case 'function handle'
            warning('Function handle detected.  Not formatiing the handle.')
            s = num2str(x);
    end
    data{k} = s;
end
data = reshape(  X  ,  size(data));





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   CREATE FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if all of the preliminary checks are passed, 
% these functions are called to create the uicontrols
% that compose the table 



function [tb] = create_tbStructure(hAxes,data,P)
%%%%%%%%%%%%%%%%%%%%%%%
%PURPOSE: assemble and check appropriateness of geometrical information
%%%%%%%%%%%%%%%%%%%%%%%
tb.hAxes = hAxes;
tb.data = data;
tb.geom.axesPos = get(hAxes,'position');
tb.geom.nRows = size(tb.data,1);
tb.geom.nCols = size(tb.data,2);
%%%%%%%%%%%%%%%%%%%%
%detemine which ui controls are necessary
%   and assign widths/heights to the controls
%%%%%%%%%%%%%%%%%%%%
if P.nVisibleRows < tb.geom.nRows   %add vertical slider
    tb.vertSlider.W = 15;   %slider width
else tb.vertSlider.W = 0;
end
if P.nVisibleCols < tb.geom.nCols   %add horizontal slider
    tb.horizSlider.H = 15;  %slider height
else tb.horizSlider.H = 0;
end
if isequal(P.colLabels,0)     %add column labels
    tb.colLabels.H = 0;
else tb.colLabels.H = 20;   %column label height
end
if isequal(P.checkBoxes,0)
    tb.checkBoxes.W = 0;
else tb.checkBoxes.W = 15;   %check box width (and height)
end
if isequal(P.rowNumbers,0)
    tb.rowNumbers.W = 0;   %row number width
else tb.rowNumbers.W = 30;
end
if any([P.highlightCell P.highlightRow P.highlightCol tb.colLabels.H tb.rowNumbers.W])
    tb.unhighlightButton.W = 13;
else tb.unhighlightButton.W = 0;
end
if P.modal
    tb.modalButtons.H = 30;
else tb.modalButtons.H = 0;
end
%%%%%%%%%%%%%%%%%%%%
%compute the locations of the four border of the table:
%%%%%%%%%%%%%%%%%%%%
tb.geom.Lborder = tb.geom.axesPos(1) + max( (tb.checkBoxes.W + tb.rowNumbers.W), tb.unhighlightButton.W );
tb.geom.Rborder = tb.geom.axesPos(1) + tb.geom.axesPos(3) - tb.vertSlider.W;
tb.geom.Bborder = tb.geom.axesPos(2) + tb.horizSlider.H + tb.modalButtons.H;
tb.geom.Tborder = tb.geom.axesPos(2) + tb.geom.axesPos(4) - max( tb.colLabels.H , tb.unhighlightButton.W );
%%%%%%%%%%%%%%%%%%%%
%although redundant, for convenience specify table width and height
%%%%%%%%%%%%%%%%%%%%
tb.geom.width = tb.geom.Rborder - tb.geom.Lborder;
tb.geom.height = tb.geom.Tborder - tb.geom.Bborder;
%%%%%%%%%%%%%%%%%%%%
%set initial cell width and height;
%note that width will be adjusted online in setPosition
%%%%%%%%%%%%%%%%%%%%
tb.geom.cellW = floor(tb.geom.width/P.nVisibleCols);
tb.geom.cellH = floor(tb.geom.height/P.nVisibleRows);
%%%%%%%%%%%%%%%%%%%%
%GEOMETRICAL CHECKS
%%%%%%%%%%%%%%%%%%%%
%check that there are at least 20 pixels for each dimension of each cell
if tb.geom.nRows*tb.geom.nCols > 400
    warning('More than 400 cells. High processing time for table creation and update.')
end
%check that there each cell is at least 35 x 15 pixels
if (tb.geom.cellW < 35) | (tb.geom.cellH < 17)   %fontsize=7 works well with cellH=17
    warning('Axes too small.')
    fprintf('\n\nPlease make axes bigger or reduce the value of one or both of:\n');
    fprintf('P.nVisibleRows, P.nVisibleCols\n\n')
end
%check fontsize - cellH relation
if (P.fontsize > 7) & (tb.geom.cellH < 24)
    warning('P.fontsize too large')
    fprintf('\n\nTry P.fontsize=7\n\n');
end
%check that there are not less than nVisibleRows in the table
if P.nVisibleRows > tb.geom.nRows 
    error('P.nVisibleRows is greater than the number of rows in the table.')
end
%check that there are not less than nVisibleCols in the table
if P.nVisibleCols > tb.geom.nCols 
    error('P.nVisibleCols is greater than the number of columns in the table.')
end
%check that there is one column label for each column
if iscell(P.colLabels)  &  ~isequal(prod(size(P.colLabels)),tb.geom.nCols)
    error('There must be one column label for each column.')
end
%check that the checkBoxes are less than or equal to the nRows
if max(P.checkBoxes) > tb.geom.nRows
    error('checkBoxes value: %.0f  is greater than the number of rows: %.0f.',max(P.checkBoxes),tb.geom.nRows)
end
%check that the disabledColumns are less than or equal to the nCols
if max(P.disabledColumns) > tb.geom.nCols
    error('P.disabledColumns value: %.0f   is greater than the number of columns: %.0f.',max(P.disabledColumns),tb.geom.nCols)
end
%check that the colWidth vector is equal in length to the nCols
if ~isequal(P.colWidth,1) & length(P.colWidth)~=tb.geom.nCols
    error('P.colWidth has %.0f values.  It must contain one value for each of %.0f columns.',length(P.colWidth),tb.geom.nCols)
end







function [tb] = create_cells(tb,P)
%%%%%%%%%%%%%%%%%%%%
%PURPOSE: create all table cells as edit uicontrols
%%%%%%%%%%%%%%%%%%%%
%compute position of cell#1 (in the upper left corner)
pos0 = [tb.geom.Lborder   tb.geom.Tborder-tb.geom.cellH    tb.geom.cellW(1)    tb.geom.cellH];
%%%%%%%%%%%%%%%%%%%%
%set column widths if no need for a horizontal slider;
%if a horiz slider is needed, col widths are updated in set_positions
%%%%%%%%%%%%%%%%%%%%
if tb.geom.nCols == P.nVisibleCols
    colW = round( P.colWidth / sum(P.colWidth)   *   tb.geom.width );
else colW = tb.geom.cellW*ones(1,tb.geom.nCols);
end
%%%%%%%%%%%%%%%%%%%%
%compute the difference from pos0
%%%%%%%%%%%%%%%%%%%%
dX = repmat(   [0 colW(1:end-1)]   ,   tb.geom.nRows,  1   );
dY = repmat(  -tb.geom.cellH*[0:(tb.geom.nRows-1)]'  ,    1   ,   tb.geom.nCols);
%%%%%%%%%%%%%%%%%%%%
%initialize handles and cell array of original positions:
%%%%%%%%%%%%%%%%%%%%
h = zeros(size(tb.data));
origPos = cell(size(tb.data));
%%%%%%%%%%%%%%%%%%%%
%cycle through rows and columns
%%%%%%%%%%%%%%%%%%%%
for i = 1:tb.geom.nRows
    for j = 1:tb.geom.nCols
        pos = [pos0(1)+dX(i,j)   pos0(2)+dY(i,j)   colW(j)   pos0(4)];
        origPos{i,j} = pos;
        h(i,j) = uicontrol('Style','edit','unit','pixels','backgroundcolor','w',...
            'string',num2str(tb.data{i,j},P.precision),...
            'position',pos,'fontsize',P.fontsize,'visible','off',...
            'callback',{@callback_updateAppData,tb.hAxes});
        if P.highlightCell | P.highlightRow | P.highlightCol
            set(h(i,j),'enable','inactive','buttonDownFcn',{@callback_highlight,tb.hAxes,P,i,j});
            %note that the 'inactive' setting is necessary for buttonDown
            %behaviour (highlighting)
        end
    end
end
tb.edits.h = h;
tb.edits.origPos = origPos;








function [tb] = create_colLabels(tb,P);
%%%%%%%%%%%%%%%%%%%%
%PURPOSE: create column label uicontrols
%%%%%%%%%%%%%%%%%%%%
colLabels = P.colLabels;
if isequal(colLabels,0)
    tb.colLabels.h = [];
	tb.colLabels.origPos = [];
    return
end
%%%%%%%%%%%%%%%%%%%%
%create automatic column labels if necessary
%%%%%%%%%%%%%%%%%%%%
if isequal(colLabels,1)
    nreps = ceil(tb.geom.nCols/26);
    ntrailers = mod(tb.geom.nCols,26);
    if ~ntrailers;  ntrailers=26; end
    ABC = char((0:25) + 65);  %uppercase letters of the alphabet
    ABC = repmat(ABC,nreps,1);  %double, triple, etc. lettering ('AA','BB',...)
    s={};
    for k=1:nreps
        if k<nreps
            s = [s; cellstr(ABC(1:k,:)')];
        else s = [s; cellstr(ABC(1:k,1:ntrailers)')];
        end
    end
    colLabels = s';
end 
%%%%%%%%%%%%%%%%%%%%
%calculate position of leftmost label (column 1):
%note that the widths will be updated online by setPosition
%%%%%%%%%%%%%%%%%%%%
pos0 = [tb.geom.Lborder   tb.geom.Tborder    tb.geom.cellW    tb.colLabels.H];
%%%%%%%%%%%%%%%%%%%%
%set column widths if no need for a horizontal slider;
%if a horiz slider is needed, col widths are updated in set_positions
%%%%%%%%%%%%%%%%%%%%
if tb.geom.nCols == P.nVisibleCols
    colW = round( P.colWidth / sum(P.colWidth)   *   tb.geom.width );
else colW = tb.geom.cellW*ones(1,tb.geom.nCols);
end
%%%%%%%%%%%%%%%%%%%%
%compute the difference from pos0
%%%%%%%%%%%%%%%%%%%%
dX = [0 colW(1:end-1)];
%%%%%%%%%%%%%%%%%%%%
%initialize handles and cell array of original positions:
%%%%%%%%%%%%%%%%%%%%
h = zeros(1,tb.geom.nCols);
origPos = cell(1,tb.geom.nCols);
%%%%%%%%%%%%%%%%%%%%
%create one pushbutton for each column
%%%%%%%%%%%%%%%%%%%%
for k = 1:tb.geom.nCols
    pos = [pos0(1)+dX(k)   pos0(2)   colW(k)   pos0(4)];
    origPos{k} = pos;
    h(k) = uicontrol('Style','pushbutton','unit','pixels','enable','inactive',...
        'string',colLabels{k},'position',pos,'fontsize',P.fontsize,'visible','off',...
        'ButtonDownFcn',{@callback_colLabelPress,tb.hAxes,P,k});
end
tb.colLabels.h = h;
tb.colLabels.origPos = origPos;







function [tb] = create_rowNumbers(tb,P)
%%%%%%%%%%%%%%%%%%%%
%PURPOSE: create row number uicontrols
%%%%%%%%%%%%%%%%%%%%
if tb.rowNumbers.W   %see create_tbStructure
    %%%%%%%%%%%%%%%%%%%%
    %calculate position of top check box:
    %%%%%%%%%%%%%%%%%%%%
    x = tb.edits.origPos{1,1};
    w = tb.rowNumbers.W;
    pos0 = [ x(1)-w   x(2)+2   w   x(4)-4 ];
    %%%%%%%%%%%%%%%%%%%%
    %initialize handles and cell array of original positions
    %%%%%%%%%%%%%%%%%%%%
    h = zeros(tb.geom.nRows,1);
    origPos = cell(tb.geom.nRows,1);
    for k=1:tb.geom.nRows
        pos = pos0   +   [0   -(k-1)*tb.geom.cellH   0 0];
        origPos{k} = pos;
        h(k) = uicontrol('Style','text','unit','pixels',...
            'position', pos,'string',k,'fontsize',P.fontsize,'visible','off',...
            'enable','inactive','ButtonDownFcn',{@callback_rowNumberPress,tb.hAxes,P,k});
    end   
else h=[]; origPos={};
end
tb.rowNumbers.h = h;
tb.rowNumbers.origPos = origPos;





function [tb] = create_checkBoxes(tb,P)
%%%%%%%%%%%%%%%%%%%%
%PURPOSE: create check box uicontrols
%%%%%%%%%%%%%%%%%%%%
%note that if P.checkboxes~=0, checkboxes are created for all rows
%   if checkboxes are not deisred for all rows...
%   e.g.  P.checkBoxes = [1 2 5 9]';
%   then these boxes are hidden (see set_visibility(P))
%   this makes it easier to catalog which rows have been checked
if tb.checkBoxes.W   %see create_tbStructure
    %calculate position of top check box:
    x = tb.edits.origPos{1,1};
    w = tb.checkBoxes.W;
    pos0 = [ x(1)-w-tb.rowNumbers.W   (x(2) + tb.geom.cellH - w - 2)   w   w ];
    %initialize handles and cell array of original positions
    h = zeros(tb.geom.nRows,1);
    origPos = cell(tb.geom.nRows,1);
    for k=1:tb.geom.nRows
        pos = pos0   +   [0   -(k-1)*tb.geom.cellH   0 0];
        origPos{k} = pos;
        h(k) = uicontrol('Style','checkbox','unit','pixels',...
            'position', pos,'Value',1,'visible','off',...
            'callback',{@callback_updateAppData,tb.hAxes});
    end
    %%%%%%%%%%%%%%%%%%%%
    %adjust the checkBox value depending on P.checkBoxes
    %%%%%%%%%%%%%%%%%%%%
    if ~isequal(P.checkBoxes,1)
        values = num2cell(   ismember( [1:tb.geom.nRows]' , P.checkBoxes)   );
        set(h,{'value'},values);
    end
else h=[]; origPos={};
end
tb.checkBoxes.h = h;
tb.checkBoxes.origPos = origPos;








function [tb] = create_sliders(tb,P)
%%%%%%%%%%%%%%%%%%%%
%PURPOSE: create slider uicontrols if necessary
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%
%create vertical slider
%%%%%%%%%%%%%%%%%%%%
if tb.vertSlider.W   %see create_tbStructure
    tb.vertSlider.pos = [ tb.geom.Rborder   tb.geom.Bborder   tb.vertSlider.W   tb.geom.height];
    nExtraRows = tb.geom.nRows - P.nVisibleRows;
    tb.vertSlider.min = 1;
    tb.vertSlider.max = nExtraRows + tb.vertSlider.min;
    tb.vertSlider.step(1) = 1/nExtraRows;
    tb.vertSlider.step(2) = max(   2*tb.vertSlider.step(1)   ,  0.25   );
    tb.vertSlider.h = uicontrol('style','slider','units','pixels',...
        'position',tb.vertSlider.pos,'visible','off',...
        'min',tb.vertSlider.min,'max',tb.vertSlider.max,'Value',tb.vertSlider.max,'SliderStep',tb.vertSlider.step);
    set(tb.vertSlider.h,'callback',{@callback_vSlider,tb.hAxes,P})
else tb.vertSlider.h = [];
end
%%%%%%%%%%%%%%%%%%%%
%create horizontal slider
%%%%%%%%%%%%%%%%%%%%
if tb.horizSlider.H   %see create_tbStructure
    tb.horizSlider.pos = [ tb.geom.Lborder   tb.geom.Bborder-tb.horizSlider.H   tb.geom.width   tb.horizSlider.H ];
    nExtraCols = tb.geom.nCols - P.nVisibleCols;
    tb.horizSlider.min = 1;
    tb.horizSlider.max = nExtraCols + tb.horizSlider.min;
    tb.horizSlider.step(1) = 1/nExtraCols;
    tb.horizSlider.step(2) = max(   2*tb.horizSlider.step(1)   ,  0.25   );
    tb.horizSlider.h = uicontrol('style','slider','units','pixels',...
        'position',tb.horizSlider.pos,'visible','off',...
        'min',tb.horizSlider.min,'max',tb.horizSlider.max,'Value',tb.horizSlider.min,'SliderStep',tb.horizSlider.step);
    set(tb.horizSlider.h,'callback',{@callback_hSlider,tb.hAxes,P})
else tb.horizSlider.h = [];
end





function [tb] = create_unhighlightButton(tb,P)
%%%%%%%%%%%%%%%%%%%%
%PURPOSE: create a button to clear highlighting
%%%%%%%%%%%%%%%%%%%%
if tb.unhighlightButton.W   %see create_tbStructure
    w = tb.unhighlightButton.W;
    pos = [   (tb.geom.Lborder - w - 1)    tb.geom.Tborder+1   w    w   ];
    tb.unhighlightButton.h = uicontrol('Style','pushbutton','unit','pixels','enable','inactive',...
        'string','H','position',pos,'fontsize',5,'visible','off',...
        'backgroundcolor',0.9*[1 1 1],'foregroundcolor',0.8*[1 0 0],...
        'ButtonDownFcn',{@callback_unhighlight,tb.hAxes,P});
else tb.unhighlightButton.h = [];
end



function [tb] = create_modalButtons(tb,P)
%%%%%%%%%%%%%%%%%%%%
%PURPOSE: create "OK" and "Cancel" buttons if running uitable modally
%%%%%%%%%%%%%%%%%%%%
if tb.modalButtons.H
    %%%%%%%%%%%%%%%%%%%%
    %create cancel button
    %%%%%%%%%%%%%%%%%%%%
    if tb.geom.nCols==1
        cancelW = floor(1*tb.geom.width/2);
    elseif tb.geom.width<200
        cancelW = floor(tb.geom.width/3);
    else cancelW = floor(tb.geom.width/5);
    end
    cancelH = tb.modalButtons.H;
    cancelX = tb.geom.Rborder - cancelW;
    cancelY = tb.geom.Bborder - tb.horizSlider.H - cancelH;
    h(2) = uicontrol('Style','pushbutton','unit','pixels','string','Cancel',...
        'position',[cancelX cancelY cancelW cancelH],'fontsize',P.fontsize,...
        'backgroundcolor',0.9*[1 1 1],'foregroundcolor',0.8*[1 0 0],...
        'visible','on','callback',{@callback_cancel,tb.hAxes});
    %%%%%%%%%%%%%%%%%%%%
    %create OK button
    %%%%%%%%%%%%%%%%%%%%
    if tb.geom.nCols ==1
        okW = floor(tb.geom.width/2);
    elseif tb.geom.width<200
        okW = floor(2*tb.geom.width/3);
    else okW = floor(tb.geom.width/3);
    end
    okH = tb.modalButtons.H;
    okX = cancelX - okW;
    okY = cancelY;
    h(1) = uicontrol('Style','pushbutton','unit','pixels','string','OK',...
        'position',[okX okY okW okH],'fontsize',P.fontsize,...
        'backgroundcolor',0.9*[1 1 1],'foregroundcolor',0.8*[0 1 0],...
        'visible','on','callback',{@callback_OK,tb.hAxes});
    %%%%%%%%%%%%%%%%%%%%
    %save the handles to the tb structure
    %%%%%%%%%%%%%%%%%%%%
    tb.modalButtons.h = h;
else tb.modalButtons.h = [];
end








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SETTING FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% these functions set various states of the newly created
%       table and uicontrols
% they are also called by the CALLBACK functions below



function set_visibility(tb,P)
%%%%%%%%%%%%%%%%%%%%
%PURPOSE: adjust uicontrol visibility
%%%%%%%%%%%%%%%%%%%%
visibility = getappdata(tb.hAxes,'visibility');
set(gcf,'visible','on')
set(tb.vertSlider.h,'visible','on')
set(tb.horizSlider.h,'visible','on')
set(tb.unhighlightButton.h,'visible','on')
%%%%%%%%%%%%%%%%%%%%
%set visibility for row-related uicontrols
%%%%%%%%%%%%%%%%%%%%
vR = ismember(   [1:tb.geom.nRows]'   ,   visibility.rows   );   %change visibleRows into a logical vector
vstring = repmat({'off'},size(vR));
vstring(find(vR)) = {'on'};
if ~isempty(tb.rowNumbers.h)
    set(tb.rowNumbers.h(:),{'visible'},vstring(:));
end
if length(P.checkBoxes) > 1   %if user has selected specific rows for checkBoxes
    vR2 = ismember(   [1:tb.geom.nRows]'   ,   P.checkBoxes   );
    vR2 = vR & vR2;
    vstring2 = repmat({'off'},size(vR2));
    vstring2(find(vR2)) = {'on'};
    set(tb.checkBoxes.h(:),{'visible'},vstring2(:));
elseif ~isempty(tb.checkBoxes.h)
    set(tb.checkBoxes.h(:),{'visible'},vstring(:));
end
%%%%%%%%%%%%%%%%%%%%
%set visibility for column-related uicontrols
%%%%%%%%%%%%%%%%%%%%
vC = ismember(   1:tb.geom.nCols   ,   visibility.cols   );
vstring = repmat({'off'},size(vC));
vstring(find(vC)) = {'on'};
if ~isempty(tb.colLabels.h(:))
    set(tb.colLabels.h(:),{'visible'},vstring(:));
end
%%%%%%%%%%%%%%%%%%%%
%set visibility for edits
%%%%%%%%%%%%%%%%%%%%
vR = repmat(vR,1,tb.geom.nCols);   %create logical matrix
vC = repmat(vC,tb.geom.nRows,1);
V = vC & vR;   %visibility matrix
vstring = repmat({'off'},size(V));
vstring(find(V)) = {'on'};
set(tb.edits.h(:),{'visible'},vstring(:));
%%%%%%%%%%%%%%%%%%%%
%extinguish axes visibility
%%%%%%%%%%%%%%%%%%%%
set(tb.hAxes,'visible','off')






function set_positions(tb,P)
%%%%%%%%%%%%%%%%%%%%
%PURPOSE: adjust uicontrol positions
%%%%%%%%%%%%%%%%%%%%
visibility = getappdata(tb.hAxes,'visibility');
%%%%%%%%%%%%%%%%%%%%
%change positions depending on the slider values
%%%%%%%%%%%%%%%%%%%%
if tb.vertSlider.W
    vSlidVal = get(tb.vertSlider.h,'value');
    vSlidMax = tb.vertSlider.max;
    deltaY = (vSlidMax-vSlidVal)*tb.geom.cellH;   %#pixels to move the table up
else deltaY = 0;
end
% if tb.horizSlider.H | ~isappdata(tb.hAxes,'data')  %first call to function 
    % 	hSlidVal = get(tb.horizSlider.h,'value');
    visibleCols = visibility.cols;
    %Since columns can have variable widths,
    %   update widths as a function of the horizontal slider position
    %   such that the axes are filled
    %%%%%%%%%%%%%%%%%%%%
    %initialize column widths and x positions
    %%%%%%%%%%%%%%%%%%%%
    colW = tb.geom.cellW * ones(1,tb.geom.nCols);
    xpos = tb.geom.Lborder * ones(1,tb.geom.nCols);
    %%%%%%%%%%%%%%%%%%%%
    %set the column width and x positions for the visible columns
    %%%%%%%%%%%%%%%%%%%%
    colW(visibleCols) = round( P.colWidth(visibleCols) / sum(P.colWidth(visibleCols)) * tb.geom.width );
    xpos(visibleCols) = xpos(visibleCols) + cumsum([0 colW(visibleCols(1:end-1))]);
    %%%%%%%%%%%%%%%%%%%%
    %create matrices for all cells
    %%%%%%%%%%%%%%%%%%%%
    colW = repmat(colW,tb.geom.nRows,1);
    xpos = repmat(xpos,tb.geom.nRows,1);
% end
%%%%%%%%%%%%%%%%%%%%
%update row-related uicontrols
%%%%%%%%%%%%%%%%%%%%
if ~isempty(tb.rowNumbers.h)
    pos = cell2mat(tb.rowNumbers.origPos);
    pos(:,2) = pos(:,2) + deltaY;    %adjust the Y position
    pos = mat2cell( pos,  ones(size(pos,1),1) , 4 );
    set(tb.rowNumbers.h,{'position'},pos);
end
if ~isempty(tb.checkBoxes.h)
    pos = cell2mat(tb.checkBoxes.origPos);
    pos(:,2) = pos(:,2) + deltaY;    %adjust the Y position
    pos = mat2cell( pos,  ones(size(pos,1),1) , 4 );
    set(tb.checkBoxes.h,{'position'},pos);
end
%%%%%%%%%%%%%%%%%%%%
%update column-related uicontrols
%%%%%%%%%%%%%%%%%%%%
if ~isempty(tb.colLabels.h)
    pos = cell2mat(tb.colLabels.origPos(:));
	pos(:,1) = xpos(1,:)';   %adjust the X position
	pos(:,3) = colW(1,:)';   %adjust the width
    pos = mat2cell( pos,  ones(size(pos,1),1) , 4 );
    set(tb.colLabels.h(:),{'position'},pos);
end

%%%%%%%%%%%%%%%%%%%%
%update table
%%%%%%%%%%%%%%%%%%%%
pos = cell2mat(tb.edits.origPos(:));
% if tb.horizSlider.H | ~isappdata(tb.hAxes,'data')
    pos(:,1) = xpos(:);    %adjust the X position
    pos(:,3) = colW(:);   %adjust the width
% end
pos(:,2) = pos(:,2) + deltaY;    %adjust the Y position
pos = mat2cell( pos,  ones(size(pos,1),1) , 4 );   %change into a cell array of row vectors
set(tb.edits.h(:),{'position'},pos);






function set_disabledColumns(tb,P)
%%%%%%%%%%
if isempty(P.disabledColumns)
    return
end
set(  tb.edits.h(:,P.disabledColumns)  ,  'enable','inactive', 'foregroundcolor',0.5*[1 1 1]);




function set_axesAppData(tb)
%%%%%%%%%%%%%%%
%get table data
A = get(tb.edits.h,'string');
%%%%%%%%%%%%%%%%%%%%
%if all cells contain numbers, convert to numerical matrix
%%%%%%%%%%%%%%%%%%%%
a = zeros(size(A));
numeric = 1;
for k=1:length(A)
    if isempty(str2num(A{k}))
        numeric = 0;
        break
    else a(k) = str2num(A{k});
    end
end
if numeric
    A = a;
end
A = reshape( A , tb.geom.nRows, tb.geom.nCols );
%%%%%%%%%%%%%%%%%%%%
%get checkbox data
%%%%%%%%%%%%%%%%%%%%
setappdata(tb.hAxes,'data',A)
if ~isempty(tb.checkBoxes.h)
    a = find(cell2mat(get(tb.checkBoxes.h,'value')));
    setappdata(tb.hAxes,'checkedRows',a)
else setappdata(tb.hAxes,'checkedRows',[])
end






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CALLBACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%these functions are called when the user
%interacts with the uicontrols

function callback_updateAppData(obj,event,hAxes)
%%%%%%%%%%%%%%
tb = getappdata(hAxes,'tb');
set_axesAppData(tb)


function callback_vSlider(obj,event,hAxes,P)
%%%%%%%%%
tb = getappdata(hAxes,'tb');
visibility = getappdata(hAxes,'visibility');
val = round(get(obj,'value'));
set(obj,'value',val);    %snapping behaviour
%%%%%%%%%%%%%%%%%%%%
%compute visible rows:
%%%%%%%%%%%%%%%%%%%%
firstVisibleRow = get(obj,'max') - val + 1;
visibility.rows = firstVisibleRow : (firstVisibleRow + P.nVisibleRows -1);
setappdata(tb.hAxes,'visibility',visibility);
set_visibility(tb,P)
set_positions(tb,P)



function callback_hSlider(obj,event,hAxes,P)
%%%%%%%%%
tb = getappdata(hAxes,'tb');
visibility = getappdata(hAxes,'visibility');
val = round(get(obj,'value'));
set(obj,'value',val);    %snapping behaviour
%%%%%%%%%%%%%%%%%%%%
%compute visible columns:
%%%%%%%%%%%%%%%%%%%%
firstVisibleCol = val;
visibility.cols = firstVisibleCol : (firstVisibleCol + P.nVisibleCols -1);
setappdata(tb.hAxes,'visibility',visibility);
set_visibility(tb,P)
set_positions(tb,P)



function callback_highlight(obj,event,hAxes,P,row,col)
%%%%%%%%%
%this callback is executed only if one of the three P.highlight options is selected
tb = getappdata(hAxes,'tb');
%%%%%%%%%%%%%%%%%%%%
%reset all cells
%%%%%%%%%%%%%%%%%%%%
set(tb.edits.h,'backgroundcolor','w','enable','inactive')
%%%%%%%%%%%%%%%%%%%%
%highlight cell, row, column, or all
%%%%%%%%%%%%%%%%%%%%
if P.highlightRow
    set(tb.edits.h(row,:),'backgroundColor','y')
end
if P.highlightCol
    set(tb.edits.h(:,col),'backgroundColor','y')
end
if P.highlightCell
    set(obj,'backgroundColor','y','enable','on')
else set(obj,'backgroundColor','w','enable','on')
end
set_disabledColumns(tb,P)



function callback_unhighlight(obj,event,hAxes,P)
%%%%%%%%%%%%%%%
tb = getappdata(hAxes,'tb');
set(tb.edits.h,'backgroundcolor','w')
if any([P.highlightCell P.highlightRow P.highlightCol])
    set(tb.edits.h,'enable','inactive')
end


function callback_colLabelPress(obj,event,hAxes,P,col)
%%%%%%%%%%%%%%%
tb = getappdata(hAxes,'tb');
set(tb.edits.h(:),'backgroundcolor','w')
set(tb.edits.h(:,col),'backgroundColor','c')
if any([P.highlightCell P.highlightRow P.highlightCol])
    set(tb.edits.h,'enable','inactive')
end


function callback_rowNumberPress(obj,event,hAxes,P,row)
%%%%%%%%%%%%%%%
tb = getappdata(hAxes,'tb');
set(tb.edits.h(:),'backgroundcolor','w')
set(tb.edits.h(row,:),'backgroundColor','c')
if any([P.highlightCell P.highlightRow P.highlightCol])
    set(tb.edits.h,'enable','inactive')
end


function callback_OK(obj,event,hAxes)
%%%%%%%%%%%%%%%
setappdata(gcf,'ok2close',1);
uiresume



function callback_cancel(obj,event,hAxes)
%%%%%%%%%%%%%%%
setappdata(hAxes,'data',[]);
setappdata(hAxes,'checkedRows',[]);
setappdata(gcf,'ok2close',1);
uiresume



function callback_close(obj,event)
%%%%%%%%%%%%%%%
getappdata(gcf,'ok2close');
if ~getappdata(gcf,'ok2close')
    error('Use the "OK" or "cancel" button to exit modal mode.')
end

