function fh = mycursors(varargin)
% MYCURSORS - Create as many cursors as you want on an axes
%   FH = MYCURSORS(VARARGIN) add cursor on an axes.
%   
%   VARARGIN can contain 0, 1 or 2 elements:
%     1) First input is the handle of the axes on which you want to create the
%        cursor.
%        Default value is the current axes (GCA)
%     2) Second input is the color of the cursor.
%        Default value is red ('r' or [1 0 0])
%
%   FH is a structure containing function handles that enable you to manipulate
%   the cursor. FH structure looks like:
%     FH.add(XPOS) : Adds a cursor on the same axes at the position x = XPOS.
%                    XPOS is facultative. Default value is the middle of the
%                    axes.
%     FH.off(NUM)  : Removes the NUMth cursor created
%                    If NUM is a character string then the function removes only
%                    the last cursor.
%     FH.val(NUM)  : Returns a vector containing the positions of the NUMth
%                    cursor.
%                    If you omit NUM then the function returns the position of
%                    all cursors.
%     FH.hdl()     : Returns a matrix containing the handles of the cursors in  
%                    the first column and the handles of the associated labels
%                    in the second column.

% Default inputs
inArgs = {...
  gca, ... % Current axes is used by default
  'r'  ... % Default color for cursors is red
  };

% Replace default input arguments by input values
inArgs(1:nargin) = varargin;


% Initializations
axeH = inArgs{1};
figH = ancestor(axeH,'figure');
curH = [];
labH = [];
curC = [];
curL = [];
yLim = ylim(axeH);
curColor = inArgs{2};

% Add a cursor
CursorAdd();

% Assign Output Argument
fh = struct('add',@CursorAdd,'off',@CursorOff,'val',@CursorValue,'hdl',@CursorHandles);

% Drag Cursor shape
curCData = [...
  NaN NaN NaN NaN NaN   2   2   2   2   2 NaN NaN NaN NaN NaN NaN
  NaN NaN NaN NaN NaN   2   1   2   1   2 NaN NaN NaN NaN NaN NaN
  NaN NaN NaN NaN NaN   2   1   2   1   2 NaN NaN NaN NaN NaN NaN
  NaN NaN NaN NaN   2   2   1   2   1   2   2 NaN NaN NaN NaN NaN
  NaN NaN NaN   2   1   2   1   2   1   2   1   2 NaN NaN NaN NaN
  NaN NaN   2   1   1   2   1   2   1   2   1   1   2 NaN NaN NaN
  NaN   2   1   1   1   1   1   2   1   1   1   1   1   2 NaN NaN
    2   1   1   1   1   1   1   2   1   1   1   1   1   1   2 NaN
  NaN   2   1   1   1   1   1   2   1   1   1   1   1   2 NaN NaN
  NaN NaN   2   1   1   2   1   2   1   2   1   1   2 NaN NaN NaN
  NaN NaN NaN   2   1   2   1   2   1   2   1   2 NaN NaN NaN NaN
  NaN NaN NaN NaN   2   2   1   2   1   2   2 NaN NaN NaN NaN NaN
  NaN NaN NaN NaN NaN   2   1   2   1   2 NaN NaN NaN NaN NaN NaN
  NaN NaN NaN NaN NaN   2   1   2   1   2 NaN NaN NaN NaN NaN NaN
  NaN NaN NaN NaN NaN   2   2   2   2   2 NaN NaN NaN NaN NaN NaN
  NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
  ];
curHotSpot = [8 8];



%----------------------------------------------------------

  function CursorAdd(varargin)
    % Adds a new cursor on the axes

    % Check input to define default cursor position
    if nargin
      defPos = varargin{1};
    else
      defPos = diff(xlim(axeH)) / 2;
    end

    % Get axes limits
    yLim2 = ylim(axeH);

    % Create Cursor Line
    curH(end+1) = line([defPos defPos],yLim2,'Color',curColor,'LineWidth',2,'Parent',axeH);

    % Create associated label
    labH(end+1) = text(defPos,yLim2(2),...
      sprintf('%u',length(curH)),...
      'BackgroundColor','w',...
      'EdgeColor',curColor,...
      'LineWidth',2,...
      'Color',curColor,...
      'FontSize',8,...
      'FontWeight','bold');

    % Set the WindowButtonDownFcn
    set(curH(end),'ButtonDownFcn',@ButtonDownFcn)

  end

%----------------------------------------------------------

  function CursorOff(varargin)
    % Remove one or all cursors

    % Execute only if there is a cursor
    if ~isempty(curH)
      
      if nargin

        if ischar(varargin{1})
          ind2del = length(curH); % Remove last cursor if nothing is specified
        else
          ind2del = varargin{1};
          ind2del(ind2del>length(curH)) = []; % Remove indices outside the range
          ind2del(ind2del<1) = []; % Remove indices outside the range
        end

        % Delete specified cursor and associated label
        delete(curH(ind2del));
        delete(labH(ind2del));

        % Remove cursor and label handles from vectors
        curH(ind2del) = [];
        labH(ind2del) = [];

        % Update labels
        for indL=1:length(labH)
          set(labH(indL),'String',indL)
        end

      else

        % Remove all cursors and all associated labels
        delete([curH labH]);
        
      end
      
    end

  end

%----------------------------------------------------------

  function res = CursorValue(varargin)
    % Returns the positions of each cursor in a vector
    
    % Executes only if there is a cursor
    if ~isempty(curH)
      
      if nargin
        
        % Ensure that number specified in input argument is correct
        ind = varargin{1};
        ind(ind>length(curH)) = []; % Remove indices outside the range
        ind(ind<1) = []; % Remove indices outside the range
        
        % Retrieve data
        res = get(curH(ind),'XData');
        
      else
        
        % If no input specified then returns all positions
        if ~iscell(get(curH,'XData'))
          res = cell2mat({get(curH,'XData')});
        else
          res = cell2mat(get(curH,'XData'));
        end
        
      end

      % Remove the second column
      res(:,2) = [];
      
    else
      
      % If there is no cursor then returns an empty vector
      res = [];
      
    end
    
  end

%----------------------------------------------------------

  function res = CursorHandles()
    % Returns a matrix with cursor handles in the first column and labels
    % handles in the second
    
    % Execute only if there is a cursor
    if ~isempty(curH)
      
      res = [curH(:) labH(:)];
      
    end
    
  end

%----------------------------------------------------------

  function ButtonDownFcn(varargin)
    
    % Update current cursor handle
    curC = varargin{1};
    
    if ~isempty(curC)
      
      % Get label handle associated
      curL = labH(curC==curH);
      
      % Change cursor pointer
      set(figH,'Pointer','custom','PointerShapeCData',curCData,'PointerShapeHotSpot',curHotSpot)
      
      % Update EraseMode property for the current Cursor
      set(curC,'EraseMode','xor')
      
      % Update figure callbacks
      set(figH,'WindowButtonMotionFcn',@ButtonMotionFcn)
      set(figH,'WindowButtonUpFcn',@ButtonUpFcn)
      
    end
    
  end

%----------------------------------------------------------

  function ButtonUpFcn(varargin)
    
    % Change cursor pointer
    set(figH,'Pointer','arrow')

    % Update EraseMode property for the current Cursor
    set(curC,'EraseMode','normal')
    
    % Update Figure Callbacks
    set(figH,'WindowButtonMotionFcn','')
    
    % Unset current Cursor and label
    curC = [];
    curL = [];
    
  end

%----------------------------------------------------------

  function ButtonMotionFcn(varargin)
    
    % Get current point
    curP = get(axeH,'CurrentPoint');
    
    % Get axes limits
    yLim2 = ylim(axeH);
    
    % Update cursor position
    set(curC,'XData',[curP(1) curP(1)],'YData',[min(yLim(1),yLim2(1)) max(yLim(2),yLim2(2))])
    
    % Move label
    set(curL,'Position',[curP(1) yLim2(2)]);
    
    % Refresh Display
    drawnow;
    
  end


end