function varargout = buildRun1GUI(varargin)
% function varargout = buildRun1GUI(varargin)
% Purpose: There are three methods for which the GUI can be used to generate
%          the user-defined GUI:
%          1) User provide menu definition thru a GUI interactive input
%             gui4gui.fig. By selecting the GUI generation button, the
%             collected menu definition data will be passed to this
%             function to generate the user GUI.
%          2) User enters menu definition directly into a file. Then, the
%             user manually run this program to generate the user GUI.
%          3) Combination of the above two methods.
% varargin: Caller provides menu definition data as a structure GID.
%           Only varargin{1} is relevant, any additional input will be
%           ignored. The caller is usually gui4gui. It collects GID
%           interactively (or semi-interactively) and then calls genGUI to 
%           generate the application GUI.
% If nargin == 0, then this GUI assumes that the menu definition data has
% already been generated and saved in gui4gui_input.mat. It uses this
% file to generate the GUI without going thru gui4gui
% Date created: May 21, 2009
% Kadin Tseng, SCV, Boston University
version = '1.0';

if nargin > 0 & isstruct(varargin{1})
  GID = varargin{1};
else  
% loads the data structure that defines the menus
% for the MODE code, there are two situations where this GUI generator might
% be used: Real time task or Fixed duration task. They are both very similar
% in the input requirement but nevertheless requires distinctive m-files
%  varargin{1}
  load run1_inputfile;
%  eval('load varargin{1}');
end

% additional GUI settings:
% fontsize and fontweight for the RUN button
% The title fontsize is 2 sizes larger than the basic user setting
fontsize_title = GID.fontsize + 2;
fontweight_title = GID.fontweight;
fontsize_run = GID.fontsize + 2;
fontweight_run = GID.fontweight;

fid = fopen([GID.guiName '.m'],'w+');

fprintf(fid,'function %s(varargin)\n',GID.guiName);
fprintf(fid,'fh = figure(''Visible'',''off'', ...\n');
fprintf(fid,'            ''HandleVisibility'',''callback'', ...\n');
fprintf(fid,'            ''NumberTitle'',''off'', ...  %% turns off MATLAB GUI window title\n');
fprintf(fid,'            ''Name'',''%s'', ...    %% now, define my own\n',GID.guiName);
fprintf(fid,'            ''Units'',''normalized'', ...\n');
fprintf(fid,'            ''Position'',[%d %d %d %d], ...\n',GID.position);
fprintf(fid,'            ''Color'',''%s'', ...   %% match bg of MODE_new.jpg\n',GID.bgcolor);
fprintf(fid,'            ''Resize'',''%s'');\n',GID.resize);

fprintf(fid,'set(fh,''MenuBar'',''none'');  %% removes MATLAB default menu bar\n');

fprintf(fid,'x0 = 0.1; y0 = 0.85;\n');
fprintf(fid,'x0run = 0.825; y0run = 0.075; %% lower-left corner coord. of the run button\n');
fprintf(fid,'dxst1 = 0.075; dyst1 = 0.05;  %% for static text 1\n');
fprintf(fid,'dxet1 = 0.100; dyet1 = 0.05;  %% for edit text 1\n');
fprintf(fid,'dxst2 = 0.400; dyst2 = 0.10;  %% for static text 2\n');
fprintf(fid,'dxpb1 = 0.050; dypb1 = 0.05;  %% for PDF logo pushbuttons\n');
fprintf(fid,'dxrun = 0.100; dyrun = 0.075; %% for "Run" pushbutton\n');

fprintf(fid,'%% First, create a Heading for the secondary GUI with a static text box\n');
fprintf(fid,'dx = 0.6; dy = 0.125;\n');

fprintf(fid,'st0h = uicontrol(fh, ...\n');
fprintf(fid,'            ''style'',''text'', ...\n');
brkpt = regexp(GID.title,'!');  % check for "!", definde here as line break

%%%% to do: regexprep would be more direct; implementation problem with fprintf 

numLines = length(brkpt) + 1;
switch numLines
  case 1    % one-line title
    fprintf(fid,'            ''String'',[''%s''], ...\n',GID.title);
  case 2    % two-line title
    fprintf(fid,'            ''String'',[''%s'' char(10) ''%s''], ...\n',GID.title(1:brkpt-1),GID.title(brkpt+1:end));
  case 3    % three-line title
    fprintf(fid,'            ''String'',[''%s'' char(10) ''%s'' char(10) ''%s''], ...\n', ...
      GID.title(1:brkpt(1)-1),GID.title(brkpt(1)+1:brkpt(2)-1),GID.title(brkpt(2)+1:end));
  otherwise
    disp('Title with more than 3 lines is not anticipated.')
    disp(' "!" is reserved by the GUI builder to force a new line.')
    disp('Make sure not to use it as part of your GUI title text.')
    return
end
fprintf(fid,'            ''Units'',''normalized'', ...\n');
fprintf(fid,'            ''Position'',[x0,y0,dx,dy], ...\n');
fprintf(fid,'            ''FontSize'',%d, ...\n',fontsize_run);
fprintf(fid,'            ''FontWeight'',''%s'');\n',fontweight_run);
fprintf(fid,'\n');
fprintf(fid,'%% Create static box, edit box, static box, logo (that points to a doc; optional)\n');
fprintf(fid,'y0 = y0 - dy*1.05; space = dxst1*0.20;\n');
nlines = size(GID.string,1);
for line=1:nlines
str = GID.string(line,:);
fprintf(fid,'data.str{%d} = ''%s'';\n',line,str{1});
fprintf(fid,'data.default{%d} = %f;\n',line,str2double(str{2}));
fprintf(fid,'  st1h(%d) = uicontrol(fh,''style'',''text'', ...\n',line);
fprintf(fid,'      ''String'',''%s'', ...\n',str{1});
fprintf(fid,'      ''Units'',''normalized'', ...\n');
fprintf(fid,'      ''Position'',[x0,y0,dxst1,dyst1], ...\n');
fprintf(fid,'      ''FontSize'',%d, ...\n',GID.fontsize);
fprintf(fid,'      ''FontWeight'',''%s'');\n',GID.fontweight);
fprintf(fid,'  et1h(%d) = uicontrol(fh,''Style'',''edit'', ...\n',line);
fprintf(fid,'      ''String'',''%s'', ...\n',str{2});
fprintf(fid,'      ''Units'',''normalized'', ...\n');
fprintf(fid,'      ''Position'',[x0+dxst1+space,y0,dxet1,dyet1], ...\n');
fprintf(fid,'      ''FontSize'',%d, ...\n',GID.fontsize);
fprintf(fid,'      ''FontWeight'',''%s'', ...\n','normal');
fprintf(fid,'      ''callback'',{@edit1_Callback ''%s''});\n',str{1});
fprintf(fid,'  st2h(%d) = uicontrol(fh,''style'',''text'', ...\n',line);
fprintf(fid,'      ''String'',''%s'', ...\n',str{3});
fprintf(fid,'      ''Units'',''normalized'', ...\n');
fprintf(fid,'      ''Position'',[x0+dxst1+dxet1+space*2,y0-0.02,dxst2,dyst2], ...\n');
fprintf(fid,'      ''FontSize'',%d, ...\n',GID.fontsize);
fprintf(fid,'      ''FontWeight'',''%s'');\n',GID.fontweight);
fprintf(fid,'  pb1h(%d) = uicontrol(fh,''Style'',''pushbutton'', ...\n',line);
fprintf(fid,'      ''String'',''PDF'', ...\n');
fprintf(fid,'      ''Units'',''normalized'', ...\n');
fprintf(fid,'      ''Position'',[x0+dxst1+dxet1+dxst2+space*3,y0,dxpb1,dypb1], ...\n');
fprintf(fid,'      ''FontSize'',%d, ...\n',GID.fontsize);
fprintf(fid,'      ''FontWeight'',''%s'', ...\n',GID.fontweight);
fprintf(fid,'      ''callback'',{@opendoc1_Callback ''%s''});\n',str{4});
fprintf(fid,'  y0 = y0 - max([dyst1 dyst2 dyet1 dypb1])*1.1;\n');

end   % end of "line" loop

fprintf(fid, ...
    ['%% save the edit text handles to data\n' ...
     'data.et1h = et1h(1:end);\n']);
fprintf(fid,'for i=1:length(data.str)\n');
fprintf(fid,'   eval([''data.'' data.str{i} ''= data.default{i};'']);\n');
fprintf(fid,'end\n');

fprintf(fid,'data.guiName = ''%s'';\n',GID.guiName);
fprintf(fid,'setappdata(fh, ''myData'', data);\n');

% Foonotes and RUN button
fprintf(fid,'%%align(st0h,''HorizontalAlignment'',''center'');\n');
fprintf(fid,'st3h = uicontrol(fh,''style'',''text'', ...\n');
fprintf(fid,'      ''String'',''%s'', ...\n',GID.fn1);
fprintf(fid,'      ''Units'',''normalized'', ...\n');
fprintf(fid,'      ''Position'',[0.05,0.08,0.60,0.05], ...\n');
fprintf(fid,'      ''HorizontalAlignment'',''Left'', ...\n');
fprintf(fid,'      ''foregroundColor'',[1 0 0], ...\n');
fprintf(fid,'      ''FontSize'',%d, ...\n',GID.fontsize);
fprintf(fid,'      ''FontWeight'',''%s'');\n', GID.fontweight);
fprintf(fid,'st4h = uicontrol(fh,''style'',''text'', ...\n');
fprintf(fid,'      ''String'',''%s'', ...\n',GID.fn2);
fprintf(fid,'      ''Units'',''normalized'', ...\n');
fprintf(fid,'      ''Position'',[0.05,0.02,0.60,0.05], ...\n');
fprintf(fid,'      ''HorizontalAlignment'',''Left'', ...\n');
fprintf(fid,'      ''foregroundColor'',[1 0 0], ...\n');
fprintf(fid,'      ''FontSize'',%d, ...\n',GID.fontsize);
fprintf(fid,'      ''FontWeight'',''%s'');\n',GID.fontweight);
fprintf(fid,'\n');

% this is for either RT or FD (by virtue of GID value)advanced run

fprintf(fid,'runh = uicontrol(fh,''Style'',''pushbutton'', ...\n');
fprintf(fid,'      ''String'',''RUN'', ...\n');
fprintf(fid,'      ''Units'',''normalized'', ...\n');
fprintf(fid,'      ''Position'',[x0run,y0run,dxrun,dyrun], ...\n');
fprintf(fid,'      ''FontSize'',%d, ...\n',fontsize_run);
fprintf(fid,'      ''FontWeight'',''%s'', ...\n',fontweight_run);
fprintf(fid,'      ''callback'',{@run1_Callback ''%s''});\n',GID.run);
fprintf(fid,'PDFbuttons(pb1h);\n');
fprintf(fid,'\n\n');

% use the bgcolor of uicontrol for the GUI figure
fprintf(fid,'etbgcolor = get(et1h(1),''BackgroundColor'');\n');
fprintf(fid,'set(fh,''Color'',etbgcolor);\n');
% Now, turns on the GUI figure
fprintf(fid,'set(fh,''Visible'',''on'');\n');
fprintf(fid,'\n\n');

% Callback functions needed fot this GUI are generated below
% callback function of the "doc1" type
fprintf(fid, ...
    ['function opendoc1_Callback(hObject,eventdata,varargin)\n' ...
     '%% hObject    handle to Exit_menu_item (see GCBO)\n' ...
     '%% eventdata  reserved - to be defined in a future version of MATLAB\n' ...
     'open(varargin{1});\n' ...
     '\n\n']);

% edit text callback
fprintf(fid, ...
  ['function edit1_Callback(hObject, eventdata, varargin)\n' ...
   '%% hObject    handle to edit1 (see GCBO)\n' ...
   '%% eventdata  reserved - to be defined in a future version of MATLAB\n' ...
   '\n' ...
   '%% Hints: get(hObject,''String'') returns contents of edit1 as text\n' ...
   '%%        str2double(get(hObject,''String'')) returns contents of edit1 as a double\n' ...
   '\n' ...
   'fh = get(hObject,''parent'');\n' ...
   'data = getappdata(fh, ''myData'');\n' ...
   'value = str2num(get(hObject,''String''));\n' ...
   'eval([''data.'' varargin{1} ''= value;'']);\n' ...
   'setappdata(fh,''myData'',data);\n' ...
   '\n\n']);

% RUN callback
fprintf(fid, ...
  ['function run1_Callback(hObject, eventdata, varargin)\n' ...
   '%% hObject    handle to run1_Callback \n' ...
   '%% eventdata  reserved - to be defined in a future version of MATLAB\n' ...
   '%% Hints: get(hObject,''String'') returns contents of edit1 as text\n' ...
   '%%        str2double(get(hObject,''String'')) returns contents of edit1 as a double\n' ...
   'fh = get(hObject,''parent'');\n' ...
   'data = getappdata(fh, ''myData'');\n']);
   fprintf(fid,'for i=1:length(data.str)\n');
   fprintf(fid,'   eval([data.str{i} ''= data.'' data.str{i} '';'']);  %% e.g., A9 = data.A9;\n');
   fprintf(fid,'end\n');

fprintf(fid, ...
  ['%% Prevent user from changing the contents of edit boxes\n' ...
   'editBoxEnable2(data,''Off'');\n' ...
   'old_color=get(hObject,''BackgroundColor''); %% save original button color\n' ...
   'set(hObject, ''BackgroundColor'', [1 0 0]); %% Change button color\n' ...
   'set(hObject, ''String'', ''running ...'');\n' ...
   '%% open(''RTcaption.pdf'');\n' ...
   'drawnow    %% to make sure that the "Run" button change color right away\n' ...
   'eval(varargin{1})   %% run the m-file specified by varargin{1}\n']);
fprintf(fid, ...
  ['set(hObject, ''String'', ''Run'');\n' ...
   'set(hObject, ''BackgroundColor'', old_color);\n' ...
   'editBoxEnable2(data,''On'');\n']);
fprintf(fid,'\n\n');

fclose(fid);
disp([char(10) '***** The ' GID.guiName ' GUI is built successfully *****' char(10)]);
