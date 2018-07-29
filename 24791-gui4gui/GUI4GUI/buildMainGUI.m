function varargout = buildMainGUI(varargin)
% function varargout = buildMainGUI(varargin)
% Purpose: Builds the "Main" GUI using user-specified menu definition.
%          There are three ways with which this m-file can be used to
%          build a GUI base on user-specified menu data:
%          1) User provide menu definition thru a GUI interactive input
%             gui4gui.fig by running gui4gui in the MATLAB environment.
%             gui4gui invokes buildMainGUI at some point.
%          2) User prepares menu definition into a file, main_inputfile.m.
%             Then, manually run this program (and skip the gui4gui.fig to
%             input menu definition) to build the user GUI.
%          3) Use both.
%
% varargin: Caller provides menu definition data as a structure GID.
%           Only varargin{1} is relevant, any additional input will be
%           ignored.
% varargout: returns the name of the built GUI for use by gui4gui.fig
%
% If nargin == 0, then this GUI will get the data it needs by running
% main_inputfile.m to build the new GUI. The name of this GUI comes 
% from the mat-file. 
% If nargin > 0, then the data necessary for GUI building will come through
% varargin as a struct GID that can either supplied by gui4gui or running
% main_inputfile.m or by "load main_inputfile.mat" prior to running this
% m-file.
%
% Date created: May 24, 2009
% Kadin Tseng, SCV, Boston University

version = '1.0';   % buildMainGUI version number; May 24, 2009

% Gets GID, a struct containing menu definitions for building a GUI
switch nargin
case 0
    % use the new format; it is tmp right now
  GID = main_inputfile;   % GID returns by running m-file
  guiName = GID.guiName;  % name of the new GUI 
case 1
  GID = varargin{1};      % GID comes from input argument
  guiName = GID.guiName;  % name of the new GUI
otherwise
  disp('Too many input; build process terminated')
  return
end

% Number of menus (File, Model, Articles, Tutorial, Examples, Run, Code, Help)
Nmenus = GID.Nmenus;

fid = fopen([guiName '.m'],'w+');  % open file

fprintf(fid,'function %s(varargin)\n',char(GID.guiName));
fprintf(fid,'%% function %s(varargin)\n',char(GID.guiName));
fprintf(fid,'%%\n');
fprintf(fid,'%% This Graphical User Interface is generated with user-supplied menu definition data\n');
fprintf(fid,'%% buildMainGUI.m version %s has been used to generate this GUI\n',version);
fprintf(fid,'%%\n');

fprintf(fid,'fh = figure(''Visible'',''off'', ...\n');
fprintf(fid,'            ''NumberTitle'',''off'', ...  %% turns off MATLAB GUI window heading\n');
fprintf(fid,'            ''Name'',''%s'', ...    %% now, define my own\n',GID.guiName);
fprintf(fid,'            ''Units'',''normalized'', ...\n');
fprintf(fid,'            ''Units'',''normalized'', ...\n');
fprintf(fid,'            ''Position'',[%d %d %d %d], ...\n',GID.position);
fprintf(fid,'            ''Color'',''%s'', ...   %% match bg of MODE_new.jpg\n',GID.bgcolor);
fprintf(fid,'            ''Resize'',''%s'');\n',GID.resize);

fprintf(fid,'set(fh,''MenuBar'',''none''); %% removes MATLAB default menu bar\n');
fprintf(fid,'%% create custom menu bar items as defined by GID loaded above:\n'); 
fprintf(fid,'%% "File", "Model", "Articles", "Tutorials", "Examples", "Run", "Code", "Help"\n');
fprintf(fid,'%%\n');
fprintf(fid,'%% The menu item handles used here are all local, the naming convention is\n');
fprintf(fid,'%% mh_ijk where i, j, and k represent the menu item and sub menu items\n');

fprintf(fid,'%% First, set up all the menu bars (but without any callbacks . . .\n');
fprintf(fid,'%% The menu bars are: File, Model, Articles, Tutorial, Examples, Run, Code, Help\n');
for menu=1:Nmenus
  fprintf(fid,'%% For menu bar item: ''%s''\n', GID.task(menu).name);
  fprintf(fid,'mh%d = uimenu(fh,''Label'', ''%s'');\n', menu, GID.task(menu).name);
% fills in the menu items
  Nitems1 = sum(1 - strcmp(GID.task(menu).label(:,1,1),''));   % number of defined labels; complement of # of nulls
% Menu item for a given menu
  for Item1=1:Nitems1
    fprintf(fid,'mh(%d,%d,1,1) = uimenu(mh%d,''Label'', ''%s'');\n', ...
       menu, Item1, menu, GID.task(menu).label{Item1,1,1});
    Nitems2 = sum(1 - strcmp(GID.task(menu).label(Item1,:,1),''));   % number of defined labels
% Sub menu items for a given Item1 and menu
    for Item2=2:Nitems2   % starts from 2 because 1 holds the preceding level
      fprintf(fid,'mh(%d,%d,%d,1) = uimenu(mh(%d,%d,1,1),''Label'', ''%s'');\n', ...
         menu, Item1, Item2, menu, Item1, ...
         GID.task(menu).label{Item1,Item2,1});
      Nitems3 = sum(1 - strcmp(GID.task(menu).label(Item1,Item2,:),''));   % number of defined labels
% Sub-sub menu items
      for Item3=2:Nitems3
        fprintf(fid,'mh(%d,%d,%d,%d) = uimenu(mh(%d,%d,%d,1),''Label'', ''%s'');\n', ...
           menu, Item1, Item2, Item3, menu, Item1, ...
           Item2, GID.task(menu).label{Item1,Item2,Item3});
      end  % Item3
    end    % Item2
  end      % Item1
  fprintf(fid,'\n\n');
end        % menu
fprintf(fid,'\n\n');

fprintf(fid,'%% Next, setup the callbacks for all relevant menus\n\n');
for menu=1:Nmenus
  Nitems1 = sum(1 - strcmp(GID.task(menu).label(:,1,1),''));   % number of defined labels; complement of # of nulls
% Menu item for a given menu
  for Item1=1:Nitems1
    Nitems2 = sum(1 - strcmp(GID.task(menu).label(Item1,:,1),''));   % number of defined labels
% Sub menu items for a given Item1 and menu
    for Item2=1:Nitems2   % starts from 2 because 1 holds the preceding level
      Nitems3 = sum(1 - strcmp(GID.task(menu).label(Item1,Item2,:),''));   % number of defined labels
% Sub-sub menu items
      for Item3=1:Nitems3
         thiscase =  char(GID.task(menu).type(Item1, Item2, Item3));
         if isempty(thiscase)     % workaround; thiscase is a empty 1x0 array
            thiscase = '';         % it is meant to be ''. needs a real fix
          end
         
          switch thiscase
              case 'doc1'
                 %GID.task(menu).ops{Item1,Item2,Item3}
                fprintf(fid,'set(mh(%d,%d,%d,%d),''callback'', {@opendoc1_Callback ''%s''});\n', ...
                   menu,Item1,Item2,Item3, GID.task(menu).ops{Item1,Item2, Item3});
              case 'run1'
                 %GID.task(menu).ops{Item1,Item2,Item3}
                fprintf(fid,'set(mh(%d,%d,%d,%d),''callback'', {@run1_Callback ''%s''});\n', ...
                   menu,Item1,Item2,Item3, GID.task(menu).ops{Item1,Item2,Item3});
              case 'run2'
                 %GID.task(menu).ops{Item1,Item2,Item3}
                fprintf(fid,'set(mh(%d,%d,%d,%d),''callback'', {@exit_Callback});\n', ...
                   menu,Item1,Item2,Item3);
              case ''
                 %disp(['GID.task(' num2str(menu) ').type(' num2str(Item1) ',' ...
                 %  num2str(Item2) ',' num2str(Item3) ') is NULL; it requires no action'])
              otherwise
                %menu,Item1,Item2,Item3,char(GID.task(menu).type(Item1,Item2,Item3))
                disp('Type not valid');
                return
         end  % switch
      end     % Item3
    end       % Item2
  end         % Item1
end           % menu

% End of callback setup

fprintf(fid,                                          ...
   ['%% Displays a user-provided image on this GUI\n' ...
    '[X,map] = imread(''%s'');\n'                     ...
    'imshow(X,map); %% display image on front page\n' ...
    '\n\n'], GID.frontImage);

fprintf(fid,'set(fh,''Visible'',''on'');\n');

disp([char(10) '***** The ' guiName ' GUI is built successfully *****' char(10)])

fprintf(fid,                                                                 ...
    ['\n\n\n'                                                                ...
     '%% Functions needed by the output GUI will be generated in the'        ...
     ' following . . .\n\n\n']);

fprintf(fid,                                                                 ...
   ['%% generate callback function of the "opendoc1" type operation\n'       ...
    'function opendoc1_Callback(hObject,eventdata,varargin)\n'               ...
    '%% hObject    handle to exit_callback (see GCBO)\n'                     ...
    '%% eventdata  reserved - to be defined in a future version of MATLAB\n' ...
    'open(varargin{1})\n'                                                    ...
    '\n\n\n']);

fprintf(fid,                                                                 ...
   ['function exit_Callback(hObject, eventdata)\n'                           ...
    '%% hObject    handle to exit_Callback (see GCBO)\n'                     ...
    '%% eventdata  reserved - to be defined in a future version of MATLAB\n' ...
    'close all\n'                                                            ...
    '\n\n\n']);

fprintf(fid, ...
   ['%% generate "run1" type callback function\n'                            ...
    'function run1_Callback(hObject, eventdata, varargin)\n'                 ...
    '%% hObject    handle to RT_advanced_run (see GCBO)\n'                   ...
    '%% eventdata  reserved - to be defined in a future version of MATLAB\n' ...
    '%% handles    structure with handles and user data (see GUIDATA)\n'     ...
    'eval(varargin{1})\n'                                                    ...
    '\n\n\n']);

fclose(fid);

varargout = {GID.guiName};   % returns the GUI name for gui4gui

% Facts to consider in determining whether a function should be generated 
% automatically or created separately (as an external file):
% 1) Functions that are generated automatically means that that is part of
%    the automation and the builder can definitely count on to exist.
% 2) The builder rely on the user to provide external functions.
% 3) Internally generated functions are temporary in the sense that every time 
%    the builder is executed, the function is reset to how it is defined by the 
%    builder. Any changes you made to them will be gone.