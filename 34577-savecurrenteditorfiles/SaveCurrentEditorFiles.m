%  SAVECURRENTEDITORFILES     save the open files in the editor to matlab shortcut.
%
%  To add the current files
%  SAVECURRENTEDITORFILES                         % interactively asks you for a reference for the files
%  SAVECURRENTEDITORFILES ( 'reference' )         % adds the current files using the supplied name as reference
%  SAVECURRENTEDITORFILES ( 'reference', 1 )      % removes the files associated with the reference
%
%  The code will add a shortcut to the Matlab shortcut bar called "Saved Editor Sessions"
%
%    To retrieve the files click on the shortcut and a list will be provided where you select by entering the 
%      integer associated with the files (listed numerically and using the 'reference' supplied.
%    All files are opened into the editor (All current files are closed). 
%    If a file is no longer found an error message is displayed in the command window.
%
%   Note The second argument can be a structure, as shown below - this is for future customisation.            
%             options.remove = 1;  
%
%   Limitations:  Untested of any versions post     R2011a   (I have tried to code it so it will work by looking at the documentation)
%                 Untested on any versions prior to R2007b
%
%
%  see also edit

% License to use and modify this code is granted freely to all interested, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.

% Programmed and Copyright by Robert J Cumming: rcumming(at)matpi.com, robertjcumming(at)yahoo.co.uk
% $Revision: 1.00 $  $Date: 2011/12/01 16:45:28 $

function SaveCurrentEditorFiles ( myname, arg2 )
  %%
  if nargin == 0
    myname = input ( 'Please enter a name used for future reference: ', 's' );
    if isempty ( myname )
      fprintf ( 'Warning: Nothing updated as name not provided\n' );
      return;
    end
  end
  if nargin < 2
    customisation = struct;
  else
    if ~isstruct ( arg2 )
      customisation.remove = arg2; 
    else
      customisation = arg2;
    end
  end
  if ~isfield ( customisation, 'remove' ); customisation.remove = false; end;
%   if ~isfield ( customisation, 'rename' ); customisation.rename = false; end;
%   if ~isfield ( customisation, 'newname' ); customisation.newname = ''; end;

  switch version ( '-release' )
    case { '2011a' '2011b' '2012a' '2012b' }
      openDocuments = matlab.desktop.editor.getAll;
      editorSummary = {openDocuments.Filename};
    case { '2010a' '2010b' }
      allDocs = editorservices.getAll;
      editorSummary={allDocs.Filename};
    case { '2009a' '2009b' '2008a' '2008b' '2007a' '2007b' '2006a' '2006b' }  
      edhandle = com.mathworks.mlservices.MLEditorServices;
      editorSummaryText = char(edhandle.builtinGetOpenDocumentNames);
      sE = size(editorSummaryText);
      editorSummary = cell(sE(1),1);
      for i=1:sE(1)
        editorSummary{i} = strtrim(editorSummaryText(i,:));
      end      
    otherwise
      fprintf ( 2, 'version not supported\n' );
      return
  end  
%%
  fid = fopen ( fullfile ( prefdir, 'shortcuts.xml' ), 'r' );
  summaryFound = false;
  if fid ~= -1
    lineNo = 1;
    while true
      line = fgetl ( fid );
      if line == -1; break; end
      if ~isempty ( strfind ( line, '<label>Saved Editor Sessions</label>' )  )
        summaryFound = 1;
        break
      end
      lineNo= lineNo + 1;
    end
    fclose ( fid );
  end
  if summaryFound == false % 1st use
    code = '% No support is offered on this shortcut if it has been edited manually (managed by SaveCurrentEditorFiles.m)';
    code = sprintf ( '%s\nif ~exist ( ''editorhistoryshortcutcode'', ''var'' ) && ~exist ( ''editorhistoryshortcutcode_index'', ''var'' )', code );
    code = sprintf ( '%s\neditorhistoryshortcutcode.number=0;%%DONOTEDIT_KEY1', code );
    code = sprintf ( '%s\n%%DONOTEDIT_KEY2;', code );
  else % extract the current code.
    fid = fopen ( fullfile ( prefdir, 'shortcuts.xml' ), 'r' );
    if fid ~= -1
      for i=1:lineNo; %summary{1}.lineNo
        line = fgetl(fid);
        if ( line == -1 ); break; end
      end
      while ( true )
        line = fgetl ( fid );
        if ( line == -1 ); break; end
        index = strfind ( line, '<callback>' ); % start of callback code
        if isempty ( index )
          continue;
        end
        code = sprintf ( '%s;\n', line(index(1)+10:end) );
        break
      end
      store = true;
      sectionremoved = false;
      while true % now search for end of code
        line = fgetl ( fid );
        if ( line == -1 ); break; end
        nameCheck = strfind ( line, 'editorhistoryshortcutcode.name' );
        if ~isempty ( nameCheck ) % found start of block
          if nameCheck == 1
            quotes = strfind ( line, '''' );
            currentName = line(quotes(1)+1:quotes(2)-1);
            if customisation.remove == false
              if strcmp ( currentName, myname )
                fclose ( fid );
                error ( 'SaveCurrentEditorFiles:NameUsed', 'User suggested name ''%s'' already exists', myname );
              end
            end
          end            
          store = true;
          if customisation.remove && nameCheck == 1
            quotes = strfind ( line, '''' );
            currentName = line(quotes(1)+1:quotes(2)-1);
            if strcmp ( currentName, myname )
              store = false;
              sectionremoved = true;
            else 
              store = true;
            end
          end
        end
        if store && sectionremoved % need to countback the indexes of the cases after one has been removed
          line = SaveCurrentEditor_ReplaceIndex ( line, 'editorhistoryshortcutcode.name' );
          line = SaveCurrentEditor_ReplaceIndex ( line, 'editorhistoryshortcutcode.files' );
        end
        index = strfind ( line, '</callback>' ); % end of callback code
        if isempty ( index )
          if store
            code = sprintf ( '%s%s\n', code, line );
          end
          continue;
        end
        code = sprintf ( '%s%s\n', code, line(1:index(1)-1) );
        break
      end
    end
    fclose( fid );
  end  
%   code
%% add the current editor settings to the code
  code = regexprep ( code, '&amp;&amp;', '&&' );
  index = strfind ( code, 'DONOTEDIT_KEY1' );
  index2 = strfind ( code, 'DONOTEDIT_KEY2' );
  start = strfind ( code(1:index), 'editorhistoryshortcutcode' );
  number = str2double ( code(start(end)+33:index-3) ) + 1;
  if ( customisation.remove ); 
    number = number -2; 
  end % reset number back since we are not adding.
  code = sprintf ( '%s=%i;%%%s', code(1:start(end)+31), number, code(index:index2-3) );
  if customisation.remove == false
    code = sprintf ( '%s\neditorhistoryshortcutcode.name{%i} = ''%s'';', code, number, myname );
    count = 1;
    for i=1:length ( editorSummary );
      filename = editorSummary{i};
      if exist ( filename, 'file' ) == 2 % check it is a file
        code = sprintf ( '%s\neditorhistoryshortcutcode.files{%i}{%i} = ''%s'';', code, number, count, filename );
        count = count + 1;
      else
        fprintf ( 2, ' WARNING: File not found: %s\n', filename );
      end
    end
  end
  code = sprintf ( '%s\n%%DONOTEDIT_KEY2', code );
  code = sprintf ( '%s\nfor editorhistoryshortcutcode_index = 1:length ( editorhistoryshortcutcode.name );', code );
  code = sprintf ( '%s\n  disp ( [num2str(editorhistoryshortcutcode_index), ''.'', editorhistoryshortcutcode.name{editorhistoryshortcutcode_index}] );', code );
  code = sprintf ( '%s\nend', code );
  code = sprintf ( '%s\neditorhistoryshortcutcode.answer = input ( ''Please Select (hit enter with no number to cancel):'', ''s'' );', code );
  code = sprintf ( '%s\nif ~isempty ( editorhistoryshortcutcode.answer )', code );
  code = sprintf ( '%s\n  editorhistoryshortcutcode.answer = str2num ( editorhistoryshortcutcode.answer );', code );
  code = sprintf ( '%s\n  if ~isempty ( editorhistoryshortcutcode.answer );', code );
  switch version ( '-release' )
    case { '2011a' '2011b' '2012a' '2012b' }
      code = sprintf ( '%s\n    openDocuments = matlab.desktop.editor.getAll;', code );
      code = sprintf ( '%s\n    openDocuments.close;', code );      
    case { '2010a' '2010b' }
      code = sprintf ( '%s\n    editorservices.closeGroup;', code );
    case { '2009a' '2009b' '2008a' '2008b' '2007a' '2007b' '2006a' '2006b' }  
      code = sprintf ( '%s\n    editorhistoryshortcutcode.Editor = com.mathworks.mlservices.MLEditorServices;', code );
      code = sprintf ( '%s\n    editorhistoryshortcutcode.Editor.closeAll;', code );
  end  
  code = sprintf ( '%s\n    for editorhistoryshortcutcode_index = 1:length ( editorhistoryshortcutcode.files{editorhistoryshortcutcode.answer})', code );
  code = sprintf ( '%s\n      if exist ( editorhistoryshortcutcode.files{editorhistoryshortcutcode.answer}{editorhistoryshortcutcode_index}, ''file'' ) == 2;', code );
  code = sprintf ( '%s\n        edit ( editorhistoryshortcutcode.files{editorhistoryshortcutcode.answer}{editorhistoryshortcutcode_index} );', code );
  code = sprintf ( '%s\n      else', code );
  code = sprintf ( '%s\n       disp ( [''Warning: File "'', editorhistoryshortcutcode.files{editorhistoryshortcutcode.answer}{editorhistoryshortcutcode_index},''" not found'' ] ) ', code );
  code = sprintf ( '%s\n      end', code );
  code = sprintf ( '%s\n    end', code );
  code = sprintf ( '%s\n  end', code );
  code = sprintf ( '%s\nend', code );
  code = sprintf ( '%s\nclear editorhistoryshortcutcode editorhistoryshortcutcode_index', code );
  code = sprintf ( '%s\nelse', code );
  code = sprintf ( '%s\n  fprintf ( 2, ''variables "editorhistoryshortcutcode" and/or "editorhistoryshortcutcode_index" exist in workspace\\n - they must be removed before this code will run\\n'' )', code );
  code = sprintf ( '%s\nend', code );
  

%%
  awtinvoke(com.mathworks.mlwidgets.shortcuts.ShortcutUtils, 'removeShortcut', 'Toolbar Shortcuts', 'Saved Editor Sessions' )
  awtinvoke(com.mathworks.mlwidgets.shortcuts.ShortcutUtils,'addShortcutToBottom', 'Saved Editor Sessions', code, [], 'Toolbar Shortcuts', 'true' );
  
end
function line = SaveCurrentEditor_ReplaceIndex ( line, key )
  nameCheck = strfind ( line, key );
  if nameCheck == 1
    curlyS = strfind ( line, '{' );
    curlyE = strfind ( line, '}' );
    oldIndex = str2double ( line(curlyS(1)+1:curlyE(1)-1) );
    line = sprintf ( '%s%i%s', line(1:curlyS(1)), oldIndex-1, line(curlyE(1):end) );
  end
end
