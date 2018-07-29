function cursor_demo()
% CURSOR_DEMO - Demo of the MYCURSORS function

% Pictures for the toolbar buttons
pics = CreatePics();

% Create the figure and controls
handles.Fig    = figure('Tag','Fig','Name','Cursors Demo','NumberTitle','off','MenuBar','none','Toolbar','none','Position',[200 200 550 550],'Color',[1 1 1]);
handles.Axe    = axes('Parent',handles.Fig,'Tag','Axe','Units','pixels','Position',[50 200 450 325]);
handles.TbCurs = uitoolbar('Parent',handles.Fig,'Tag','TbCurs');

handles.PtAdd1  = uipushtool('Parent',handles.TbCurs,'Tag','PtAdd1','CData',pics.Plus,'ClickedCallback',@PtAdd1_ClickedCallback,'TooltipString','Add cursor');
handles.PtDel1  = uipushtool('Parent',handles.TbCurs,'Tag','PtDel1','CData',pics.Minus,'ClickedCallback',@PtDel1_ClickedCallback,'TooltipString','Remove last cursor');
handles.PtVal1  = uipushtool('Parent',handles.TbCurs,'Tag','PtVal1','CData',pics.Val,'ClickedCallback',@PtVal1_ClickedCallback,'TooltipString','Display cursors positions');

handles.PtAdd2  = uipushtool('Parent',handles.TbCurs,'Tag','PtAdd2','CData',pics.PlusR,'ClickedCallback',@PtAdd2_ClickedCallback,'TooltipString','Add cursor');
handles.PtDel2  = uipushtool('Parent',handles.TbCurs,'Tag','PtDel2','CData',pics.MinusR,'ClickedCallback',@PtDel2_ClickedCallback,'TooltipString','Remove last cursor');
handles.PtVal2  = uipushtool('Parent',handles.TbCurs,'Tag','PtVal2','CData',pics.ValR,'ClickedCallback',@PtVal2_ClickedCallback,'TooltipString','Display cursors positions');

handles.StVal1  = uicontrol('Parent',handles.Fig,'Tag','StVal1','style','text','units','pixels','position',[ 10 10 210 150],'string','','HorizontalAlignment','left','FontName','Courier New','BackgroundColor',[1 1 1],'ForegroundColor','k');
handles.StVal2  = uicontrol('Parent',handles.Fig,'Tag','StVal2','style','text','units','pixels','position',[230 10 210 150],'string','','HorizontalAlignment','left','FontName','Courier New','BackgroundColor',[1 1 1],'ForegroundColor','r');

% Plot data
plot(sin(-20:.01:20),'Parent',handles.Axe);

% Init Cursor structure
mycurs1 = [];
mycurs2 = [];


%*******************************************************************************


% --- FIRST CURSOR SET ----------------------------------------------

  function PtAdd1_ClickedCallback(varargin)
    % Adds a cursor on the graph

    % If no cursor was created, simply initializes one
    if isempty(mycurs1)
      mycurs1 = mycursors(handles.Axe,'k'); % Create the first cursor and store the structure of function handles
    else
      mycurs1.add(); % Add a cursor to the graph
    end

  end

  function PtDel1_ClickedCallback(varargin)
    % Removes the last cursor added

    % Execute code only if at least one cursor has already been added
    if ~isempty(mycurs1)
      mycurs1.off('last');
    end

  end

  function PtVal1_ClickedCallback(varargin)
    % Displays the positions of all cursors

    % Execute code only if at least one cursor has already been added
    if ~isempty(mycurs1)

      % Get cursors positions
      data = mycurs1.val();

      % Create a matrix with cursor indices on the 1st line and cursor positions
      % on the 2nd line
      data = [1:length(data);data(:)'];

      % Display info in the static text below the axe
      set(handles.StVal1,'string',sprintf('  Cursor %u: %10.2f\n',data(:)))

    end

  end


% --- SECOND CURSOR SET ---------------------------------------------

  function PtAdd2_ClickedCallback(varargin)
    % Adds a cursor on the graph

    % If no cursor was created, simply initializes one
    if isempty(mycurs2)
      mycurs2 = mycursors(handles.Axe,'r'); % Create the first cursor and store the structure of function handles
    else
      mycurs2.add(); % Add a cursor to the graph
    end

  end

  function PtDel2_ClickedCallback(varargin)
    % Removes the last cursor added

    % Execute code only if at least one cursor has already been added
    if ~isempty(mycurs2)
      mycurs2.off('last');
    end

  end

  function PtVal2_ClickedCallback(varargin)
    % Displays the positions of all cursors

    % Execute code only if at least one cursor has already been added
    if ~isempty(mycurs2)

      % Get cursors positions
      data = mycurs2.val();

      % Create a matrix with cursor indices on the 1st line and cursor positions
      % on the 2nd line
      data = [1:length(data);data(:)'];

      % Display info in the static text below the axe
      set(handles.StVal2,'string',sprintf('  Cursor %u: %10.2f\n',data(:)))

    end

  end


% --- OTHER NESTED FUNCTIONS ----------------------------------------

  function pics = CreatePics()
    % Generate pictures matrices to use in the toolbar
    
    % + sign
    pics.Plus  = repmat([ ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN   0   0 NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN   0   0 NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN   0   0 NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN   0   0 NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN   0   0   0   0   0   0   0   0   0   0 NaN NaN NaN ; ...
      NaN NaN NaN   0   0   0   0   0   0   0   0   0   0 NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN   0   0 NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN   0   0 NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN   0   0 NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN   0   0 NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN   ...
      ],[1,1,3]);
    
    % - sign
    pics.Minus = repmat([ ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN   0   0   0   0   0   0   0   0   0   0 NaN NaN NaN ; ...
      NaN NaN NaN   0   0   0   0   0   0   0   0   0   0 NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN   ...
      ],[1,1,3]);
    
    % Matrix
    pics.Val = repmat([ ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN   0   0 NaN NaN   0   0   0 NaN NaN   0   0   0 NaN NaN ; ...
      NaN   0 NaN   0 NaN NaN NaN NaN   0 NaN NaN NaN NaN   0 NaN NaN ; ...
      NaN NaN NaN   0 NaN NaN   0   0   0 NaN NaN NaN   0   0 NaN NaN ; ...
      NaN NaN NaN   0 NaN NaN   0 NaN NaN NaN NaN NaN NaN   0 NaN NaN ; ...
      NaN NaN NaN   0 NaN NaN   0   0   0 NaN NaN   0   0   0 NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN   0 NaN NaN NaN NaN   0   0   0 NaN NaN   0   0   0 NaN NaN ; ...
      NaN   0 NaN   0 NaN NaN   0 NaN NaN NaN NaN   0 NaN NaN NaN NaN ; ...
      NaN   0   0   0 NaN NaN   0   0   0 NaN NaN   0   0   0 NaN NaN ; ...
      NaN NaN NaN   0 NaN NaN NaN NaN   0 NaN NaN   0 NaN   0 NaN NaN ; ...
      NaN NaN NaN   0 NaN NaN   0   0   0 NaN NaN   0   0   0 NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ; ...
      NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN   ...
      ],[1,1,3]);
    
    pS = [16 16 3];
    col = [1 0 0]; % Red
    
    % + sign in red
    pics.PlusR = pics.Plus;
    pics.PlusR(pics.PlusR==0) = 1;
    pics.PlusR = reshape( repmat(col,pS(1)*pS(2),1) .* reshape(pics.PlusR,pS(1)*pS(2),3) , pS );
    
    % - sign in red
    pics.MinusR = pics.Minus;
    pics.MinusR(pics.MinusR==0) = 1;
    pics.MinusR = reshape( repmat(col,pS(1)*pS(2),1) .* reshape(pics.MinusR,pS(1)*pS(2),3) , pS );
    
    % Matrix in red
    pics.ValR = pics.Val;
    pics.ValR(pics.ValR==0) = 1;
    pics.ValR = reshape( repmat(col,pS(1)*pS(2),1) .* reshape(pics.ValR,pS(1)*pS(2),3) , pS );

  end

end