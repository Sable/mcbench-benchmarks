function command_strings = fig2cmd(figfile,varargin)
    % command_strings = fig2cmd(figfile,varargin)
    % Takes the figfile and generates a cellarr of valid command-strings, that can be
    % pasted in code or sent to eval.  
    % Several modes of operation are available:
    %
    %  cs = fig2cmd(figfile, proplist) ,     
    %  generages the commands reproducing the GUI, with specified props stated explicitly.
    %
    %	 cs = fig2cmd(figfile, 'nondefault', ... )
    % generates commands specifying only nondefault properties among the given ones.
    %
    %  cs = fig2cmd((figfile, 'exclude',...) 
    % generates commands specifying all properties (optionaly 'nondefault') excluding
    % those given as arguments.
    %
    % There is a hard-coded default property list and basic exclude properties. 
    % You can modify them manually at the beginning of the file below.
    %
    %	 Examples :
    %
    % cs = fig2cmd('myfig.fig', 'units','position')
    %
    % may produce output similar to -
    %
    %     cs = 
    %     'figure('units','characters','position',[112      31.38462            49      25.15385])'
    %     'uicontrol('units','characters','position',[6.2      7.23077         33.8      1.30769])'
    %     'axes('units','characters','position',[5.6            3         36.4      3.84615])'
    %
    %
    % cs = fig2cmd('myfig','nondefault','exclude', 'CData')
    %
    %	 would generate GUI commands with comprehensive nondefault property list as arguments,
    % excluding the color data of the gui objects.
    %
    %
    %  cs = fig2cmd('myfig')
    %
    %	is equivalent to    fig2cmd('myfig','nondefault'),   i.e. - nondefault props, within the default
    % prop list.
    %
    % NOTE:   Some properties need to preceed others in order to be interpreted correctly -
    % e.g. ,units-props must preceed size-props or position-props.  
    % The routine leaves this to the user, and only sorts the property arguments  back to the 
    % order in which the user provided them.
    %
    % The routine is designed to automate mundane GUIDE-2-m conversion tasks, i.e. -  to extract 
    % elementary gui objects and properties (figure, axes, uicontrol).  The routine wasn't
    % tested on all possible gui-objects and configurations, but the basic apparatus should
    % apply to all objects, with little or no adaptation.  Please let me know if any gui-objects
    % or props causes problems : ofek@simbionix.com

    
DefaultPropList = {'style','units','position','String','Tag'};

DefaultExcludeList = { 'CData' };

BasicExcludeNonDefaultList = { 'ListboxTop' };  % props whose default value are meaningless

% default vals:
bExclude = false;     
bNonDefault = true;

%% fig file name processing
if~ischar(figfile) || ~all(cellfun(@ischar,varargin))  % all arguments must be strings
    error('All arguments must be strings - consult m-file documentation');
end

if ~strcmpi(figfile(end-3:end),'.fig')
    figfile=[figfile,'.fig'];
end

%% argument processing
ArgList = varargin;

if isempty(ArgList)
    
    bNonDefault = true;
    PropList = DefaultPropList;
else
    
    ExcludeIdx = IdxInCellArr('exclude', ArgList)  ; % enables placement of 'exclude' at any location
    if ~isempty(ExcludeIdx)
	  bExclude=true;
	  ArgList(ExcludeIdx) = [];
    end

    NonDefIdx = IdxInCellArr('nondefault', ArgList); % same as above
    if isempty(NonDefIdx)
	  bNonDefault=false;
    else
	  ArgList(NonDefIdx) = [];
    end
    
    % generation of actual PropList
    if bExclude
	  if bNonDefault
		PropList = [ BasicExcludeNonDefaultList , ArgList ];
	  else
		if isempty(ArgList)
		    PropList = DefaultExcludeList;
		else
		    PropList = ArgList;
		end
	  end
	  
    else %~bExclude
	  if isempty(ArgList) % after keyword exclusion
		PropList = DefaultPropList;
	  else
		PropList = ArgList;
	  end
    end

end


%% additional rules to process PropList

% remove duplicities
PropList = unique(PropList);

% force 'type' at head of list only
PropList(  IdxInCellArr('type', PropList)  ) = [] ;
PropList = ['type', PropList];

% make sure that 'units' precedes 'position', if present.
PropList(  IdxInCellArr('units', PropList)  ) = [] ;
PosIdx = IdxInCellArr('position', PropList);   % have to be a scalar, since the list underwent 'unique'
PropList = [PropList(1:(PosIdx-1)) , 'units', PropList(PosIdx:end) ] ;

%%   Key stage - extraction and sorting of properties to a cell array

    PropCells = ExtractHGProps(figfile, bExclude, bNonDefault, PropList) ; %,props);
	
    if ~bExclude
	  PropCells = SortPropsByList(PropCells,PropList);
    end

%% Crank to a command syntax

   ns = numel(PropCells);
   command_strings = cell(ns,1);
   Mark4Deletion=[];
   for i=1:ns

	 CurNP = size(PropCells{i},1);
	 CurCmdCellArr = PropCells{i};
	 
	 if isempty(IdxInCellArr('type',PropCells{i}(:,1)))
		Mark4Deletion=[Mark4Deletion,i];
	     continue
	 end
	 
	for j=1:CurNP 
	    
	    CurProp = CurCmdCellArr{j,1}; 
	    CurVal = CurCmdCellArr{j,2};
	    
	    if strcmpi(CurProp,'type')
		  command_strings{i} = [CurVal,'(',command_strings{i}];
		  continue % next prop
	    else
		  command_strings{i} = [command_strings{i},'''',CurProp,''','];
	    end
	    
	    if isnumeric(CurVal)
			command_strings{i} = [command_strings{i},mat2str(CurVal),',' ];
			% accounts for square brackets too.
			
	    else % ~numeric
		
		  if iscell(CurVal)
    		    command_strings{i} = [command_strings{i},'''',CurVal{1},''',' ];  % further nesting may be needed
		  else
    		    command_strings{i} = [command_strings{i},'''',CurVal,''',' ];
		  end % iscell
		  
	    end % isnumeric

	end  % for j

	if command_strings{i}(end) ==','  % which is the case most of the times
		command_strings{i}(end)=[];  % remove closing comma 
	end
	
	command_strings{i} = [command_strings{i},')'];
 
   end
   command_strings(Mark4Deletion)=[];
end % main
 
%% helper funcs
%***********************************************************************************************

    function  IdxVec = IdxInCellArr(str, carr)
	  try
	  IdxVec = find(cellfun(@(a) strcmpi(a,str), carr));
	  catch
		keyboard
	  end
    end
    
%***********************************************************************************************    
    function PropCells = ExtractHGProps(figfile, bExclude, bNonDefault, PropList)
	  
    hfig = hgload(figfile);
    set(hfig,'visible','off'); 
    % Using handle-graphics scanning facilities is easier than loading the fig as a mat, and
    % scanning the resulting struct.  As the routine is intended for offline use, this is probably
    % harmless.

    subhandles = findall(hfig);
    nh = numel(subhandles);

    PropCells = cell(nh,1);

    for i=1:nh

	  CurH = subhandles(i);
	  CurPropStruct = get(CurH);
	  CurPropNames = fieldnames(CurPropStruct);   % cell array of strings
	  CurNP = numel(CurPropNames);
	  PropCells{i} = cell(0,2);

	  for j=1:CurNP

		CurPropString = CurPropNames{j};
		CurPropVal = get(CurH, CurPropString);
% 		bCurPropInList = ismember(CurPropString, PropList) ;
		bCurPropInList = ~isempty( IdxInCellArr(CurPropString, PropList) ); % ismember is case-sensitive

		if (bExclude && bCurPropInList  ) ||  ( (~bExclude) && ~bCurPropInList ) || isempty(CurPropVal)
		    continue % next prop
		end

		%***********************************************************************
		% determine DefaultPropVal and compare to CurPropVal
		% Generic design decision is to treat null-default props as props to be omitted. This
		% is overridden manually here.
		ForceIncludeProps = {'Type','Tag'};

		    bEqual2Default = false;
		
		    
		    if bNonDefault

			  if ismember(CurPropString,ForceIncludeProps)
				bEqual2Default = false;
			  else

				try
				    DefaultPropString = ['Default', get(CurH,'type'),CurPropString];
				    DefaultPropVal = get(get(CurH,'parent'), DefaultPropString);
				catch
				    % some real-time props (e.g. 'BeingDeleted') can't be queried for defaults
				    continue % next prop
				end

				if ischar(DefaultPropVal)
				    bEqual2Default =  (isempty(DefaultPropVal) ||  strcmp(CurPropVal,DefaultPropVal)  ) ;
				else
				    bEqual2Default =  (isempty(DefaultPropVal) ||  all(CurPropVal(:) == DefaultPropVal(:))) ;
				end

			  end %  if ismember(CurPropString,ForceIncludeProps)
		    end %    if bNonDefault
			
		%************************************************************************
		% Add prop and prop value to output cell, if needed
		
		if (~bEqual2Default)
		    PropCells{i} = [ PropCells{i} ; {CurPropString,  CurPropVal}];
		end

	  end % for j

    end %for i

    close(hfig)
    
    end % ExtractHGProps

    
%***********************************************************************************************

function NewPropCells = SortPropsByList(PropCells,PropList)
    %TODO: optimize to cellfun
    
    nc = numel(PropCells);
    np = numel(PropList);
    NewPropCells = cell(nc,1);

    for i=1:nc	  
	  for j=1:np
		
		ff= IdxInCellArr(PropList{j}, PropCells{i}(:,1) );
		if isempty(ff)
		    continue
		end
		NewPropCells{i} = [NewPropCells{i} ; PropCells{i}( ff,:) ];
		
	  end % j
    end % i

end % SortPropsByList
