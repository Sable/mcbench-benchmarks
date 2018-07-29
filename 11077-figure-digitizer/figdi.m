function figdi
% figure digitizer
% 
% Use:  1.  Input image to be digitized, e.g. test.jpg. You can type the
%           name of the image in the editable text field, or push "Browse"
%           button to browse the file.  
%       2.  Digitize left x, by pushing "Digi x1," and enter corresponding
%           value for x1.
%       3.  Similarly for x2, y1, y2.
%       4.  Digitize x & y along a curve, press "Return" when done.
%       5.  x & y will be plotted and displayed.
%
% Note: x & y axis can be linear or log
%       
% Tips: How to save a jpg image file from a figure in a PDF file
%       1.  open the PDF file using Adobe Reader 7.07 (Free on the WEB)
%       2.  select the figure using the Snapshot tool of Adobe Reader
%       3.  File -> print
%       4.  "Selected graphic" in "print range," "Fit to printer margins"
%           for "print scaling."
%       5.  select "print to file" ... ...
%
% I beleive that these codes are also a good example of GUI development
%
%   by Hongxue Cai (h-cai@northwestern.edu)
%

% delete figdi GUI figure, if any
delete(findobj('tag','h_fig'));
%
% %  GUI figgure (Hide the GUI as it is being constructed.)
h_fig   = figure('units', 'normalized', 'position', [0.15 0.05 0.8 0.9], 'color', [0.5 0.6 0.7], ...
            'resize', 'on', 'numbertitle', 'off', 'name', 'Figure Digitizer', ...
            'menubar','none', 'tag', 'h_fig', 'Visible', 'off');
        
% %  Generate the structure of handles.
% %  This structure will be used to share data between callback functions of
% %  different graphical objets
handles = guihandles(h_fig);     

%% define default values here ---------------5
handles.x1v = 0;
handles.x2v = 10;
handles.y1v = 0;
handles.y2v = 10;
handles.xaxes = 'linear';
handles.yaxes = 'linear';


% %  Construct graphical components (objects) ======================>
% % push buttons ---------------------------->
xpb = 0.85;
wpb = 0.1;
hpb = 0.06;
h_pbx1  = uicontrol('Style', 'pushbutton', 'units', 'normalized', 'String', 'Digi x1',...
                'Position', [xpb 0.85 wpb hpb]);
set(h_pbx1, 'fontweight', 'bold', 'fontsize', 11, 'foregroundcolor', 'r');

h_pbx2    = uicontrol('Style', 'pushbutton', 'units', 'normalized', 'String', 'Digi x2',...
                'Position', [xpb 0.75 wpb hpb]);
set(h_pbx2, 'fontweight', 'bold', 'fontsize', 11, 'foregroundcolor', 'r');        

h_pby1      = uicontrol('Style', 'pushbutton', 'units', 'normalized', 'String', 'Digi y1',...
                'Position', [xpb 0.65 wpb hpb]);
set(h_pby1, 'fontweight', 'bold', 'fontsize', 11, 'foregroundcolor', 'r');

h_pby2    = uicontrol('Style', 'pushbutton', 'units', 'normalized', 'String', 'Digi y2',...
                'Position', [xpb 0.55 wpb hpb]);
set(h_pby2, 'fontweight', 'bold', 'fontsize', 11, 'foregroundcolor', 'r')

h_pbxy    = uicontrol('Style', 'pushbutton', 'units', 'normalized', 'String', 'Digi xy',...
                'Position', [0.65 0.40 wpb hpb]);
set(h_pbxy, 'fontweight', 'bold', 'fontsize', 12, 'foregroundcolor', 'r')

h_pbbrowse    = uicontrol('Style', 'pushbutton', 'units', 'normalized', 'String', 'Browse',...
                'Position', [xpb 0.20 wpb hpb]);
set(h_pbbrowse, 'fontweight', 'bold', 'fontsize', 12, 'foregroundcolor', 'r')
% % <------------------------------------------

% % static text ------------------------------------------------->
xtext = 0.6;
h_textx1      = uicontrol('Style', 'text', 'units', 'normalized', 'String', 'x1 value',...
                'Position', [xtext 0.85 wpb hpb]);
set(h_textx1, 'backgroundcolor', [0.5 0.6 0.7], 'foregroundcolor', 'b')
set(h_textx1, 'fontweight', 'bold', 'fontsize', 14)

h_textx2      = uicontrol('Style', 'text', 'units', 'normalized', 'String', 'x2 value',...
                'Position', [xtext 0.75 wpb hpb]);
set(h_textx2, 'backgroundcolor', [0.5 0.6 0.7], 'foregroundcolor', 'b')
set(h_textx2, 'fontweight', 'bold', 'fontsize', 14)

h_texty1      = uicontrol('Style', 'text', 'units', 'normalized', 'String', 'y1 value',...
                'Position', [xtext 0.65 wpb hpb]);
set(h_texty1, 'backgroundcolor', [0.5 0.6 0.7], 'foregroundcolor', 'b')
set(h_texty1, 'fontweight', 'bold', 'fontsize', 14)

h_texty2      = uicontrol('Style', 'text', 'units', 'normalized', 'String', 'y2 value',...
                'Position', [xtext 0.55 wpb hpb]);
set(h_texty2, 'backgroundcolor', [0.5 0.6 0.7], 'foregroundcolor', 'b')
set(h_texty2, 'fontweight', 'bold', 'fontsize', 14)

h_textfile      = uicontrol('Style', 'text', 'units', 'normalized', 'String', 'Figure file:',...
                'Position', [xtext 0.25 wpb hpb]);
set(h_textfile, 'backgroundcolor', [0.5 0.6 0.7], 'foregroundcolor', 'b')
set(h_textfile, 'fontweight', 'bold', 'fontsize', 14)

h_textreturn      = uicontrol('Style', 'text', 'units', 'normalized', 'String', 'Press "Return" when done!',...
                'Position', [0.75 0.40 2*wpb hpb]);
set(h_textreturn, 'backgroundcolor', [0.5 0.6 0.7], 'foregroundcolor', 'k')
set(h_textreturn, 'fontweight', 'bold', 'fontsize', 14)

h_textaxes      = uicontrol('Style', 'text', 'units', 'normalized', 'String', 'Axes type:',...
                'Position', [xtext 0.1 wpb hpb]);
set(h_textaxes, 'backgroundcolor', [0.5 0.6 0.7], 'foregroundcolor', 'b')
set(h_textaxes, 'fontweight', 'bold', 'fontsize', 14)

h_textx      = uicontrol('Style', 'text', 'units', 'normalized', 'String', 'X',...
                'Position', [xtext+0.05 0.1 wpb hpb]);
set(h_textx, 'backgroundcolor', [0.5 0.6 0.7], 'foregroundcolor', 'k')
set(h_textx, 'fontweight', 'bold', 'fontsize', 14)

h_texty      = uicontrol('Style', 'text', 'units', 'normalized', 'String', 'Y',...
                'Position', [xtext+0.18 0.1 wpb hpb]);
set(h_texty, 'backgroundcolor', [0.5 0.6 0.7], 'foregroundcolor', 'k')
set(h_texty, 'fontweight', 'bold', 'fontsize', 14)

% % <---------------------------------------------------------------

% % Popumenu--------------------------------->
str = cell(2, 1);
str{1} = 'linear';
str{2} = 'log';
h_pmx      = uicontrol('Style', 'popupmenu', 'units', 'normalized', 'String', str,...
                'Position', [xtext+0.12 0.1 0.08 hpb]);
set(h_pmx, 'backgroundcolor', [0.5 0.6 0.7], 'foregroundcolor', 'k')
set(h_pmx, 'fontweight', 'bold', 'fontsize', 14)

h_pmy      = uicontrol('Style', 'popupmenu', 'units', 'normalized', 'String', str,...
                'Position', [xtext+0.25 0.1 0.08 hpb]);
set(h_pmy, 'backgroundcolor', [0.5 0.6 0.7], 'foregroundcolor', 'k')
set(h_pmy, 'fontweight', 'bold', 'fontsize', 14)
% % <----------------------------------------------------



% % editable text field ------------------------------------->
xedit = 0.72;
h_editx1      = uicontrol('Style', 'edit', 'units', 'normalized', 'String', '0',...
    'Position', [xedit 0.85 wpb hpb]);
% set(h_editx1, 'backgroundcolor', 'b', 'foregroundcolor', 'y')
set(h_editx1, 'fontweight', 'bold', 'fontsize', 12)

h_editx2      = uicontrol('Style', 'edit', 'units', 'normalized', 'String', '10',...
    'Position', [xedit 0.75 wpb hpb]);
% set(h_editx2, 'backgroundcolor', 'b', 'foregroundcolor', 'y')
set(h_editx2, 'fontweight', 'bold', 'fontsize', 12)

h_edity1      = uicontrol('Style', 'edit', 'units', 'normalized', 'String', '0',...
    'Position', [xedit 0.65 wpb hpb]);
% set(h_edity1, 'backgroundcolor', 'b', 'foregroundcolor', 'y')
set(h_edity1, 'fontweight', 'bold', 'fontsize', 12)

h_edity2      = uicontrol('Style', 'edit', 'units', 'normalized', 'String', '10',...
    'Position', [xedit 0.55 wpb hpb]);
% set(h_edity2, 'backgroundcolor', 'b', 'foregroundcolor', 'y')
set(h_edity2, 'fontweight', 'bold', 'fontsize', 12)

h_editFile      = uicontrol('Style', 'edit', 'units', 'normalized', 'String', 'test.jpg',...
    'Position', [xtext 0.2 2.4*wpb hpb]);
% set(h_editFile, 'backgroundcolor', 'k', 'foregroundcolor', 'y')
set(h_editFile, 'fontweight', 'bold', 'fontsize', 12)
% % <----------------------------------------------------------

% % Axis --------------------------------------->
xaxes = 0.15;
waxes = 0.4;
haxes = 0.35;
handles.ha1      = axes('Position', [xaxes 0.56 waxes haxes]);
% This is just an example. When you input an image, the plot will be
% updated
plot([1 2 5 10 15 20], [1 2.5 4 6 3 5], 'r-^');
handles.ha2      = axes('Position', [xaxes 0.1 waxes haxes]);
% % <------------------------------------------------
% 
% % <=================================================================
% 
% %  Associate callbacks with components  --------------------->
set(h_pbx1, 'Callback', {@h_pbx1_Callback, handles});
set(h_pbx2, 'Callback', {@h_pbx2_Callback, handles});
set(h_pby1, 'Callback', {@h_pby1_Callback, handles}); 
set(h_pby2, 'Callback', {@h_pby2_Callback, handles});
set(h_pbxy, 'Callback', {@h_pbxy_Callback, handles});
set(h_pbbrowse, 'Callback', {@h_pbbrowse_Callback, handles});

set(h_editx1, 'Callback', {@h_editx1_Callback, handles});
set(h_editx2, 'Callback', {@h_editx2_Callback, handles});
set(h_edity1, 'Callback', {@h_edity1_Callback, handles});
set(h_edity2, 'Callback', {@h_edity2_Callback, handles});
set(h_edity2, 'Callback', {@h_edity2_Callback, handles});
set(h_editFile, 'Callback', {@h_editFile_Callback, handles});

set(h_pmx, 'Callback', {@h_pmx_Callback, handles});
set(h_pmy, 'Callback', {@h_pmy_Callback, handles});
% % < -----------------------------------------------------------------

% Make GUI visible, update handles
set(h_fig,  'visible', 'on'); 
guidata(h_fig, handles);

% % Sub-functions, callback functions  ===========================>

%  Callbacks for popupmenu 4 x axes type   --------------------->
function h_pmx_Callback(h_pmx, eventdata, handles)
% X, linear or log?
val = get(h_pmx,'Value');
str = get(h_pmx, 'String');
handles.xaxes = str{val};

guidata(h_pmx, handles);
%<---------------------------------------------------------

%  Callbacks for popupmenu 4 y axes type   --------------------->
function h_pmy_Callback(h_pmy, eventdata, handles)
% Y, linear or log?
val = get(h_pmy,'Value');
str = get(h_pmy, 'String');
handles.yaxes = str{val};

guidata(h_pmy, handles);
%<---------------------------------------------------------

%  Callbacks for pusbutton "Digi x1"   --------------------->
function h_pbx1_Callback(h_pbx1, eventdata, handles)
% digitizing x1, left x coordonate
handles = guidata(h_pbx1);

[handles.x1, temp]  = ginput(1);

guidata(h_pbx1, handles);
%<---------------------------------------------------------

%  Callbacks for pusbutton "Digi x2"   --------------------->
function h_pbx2_Callback(h_pbx2, eventdata, handles)
% digitizing x2, right x coordonate
handles = guidata(h_pbx2);

[handles.x2, temp]  = ginput(1);

guidata(h_pbx2, handles);
%<---------------------------------------------------------


%  Callbacks for pusbutton "Digi y1"   --------------------->
function h_pby1_Callback(h_pby1, eventdata, handles)
% digitizing y1, lower y coordonate
handles = guidata(h_pby1);

[temp, handles.y1]  = ginput(1);

guidata(h_pby1, handles);
%<---------------------------------------------------------

%  Callbacks for pusbutton "Digi y2"   --------------------->
function h_pby2_Callback(h_pby2, eventdata, handles)
% digitizing y2, upper y coordonate
handles = guidata(h_pby2);

[temp, handles.y2]  = ginput(1);

guidata(h_pby2, handles);
%<---------------------------------------------------------

%  Callbacks for pusbutton "Digi xy"   --------------------->
function h_pbxy_Callback(h_pbxy, eventdata, handles)
% digitizing x, y, coordinates of a curve
handles = guidata(h_pbxy);

[handles.x, handles.y]  = ginput;

a = (handles.x2v - handles.x1v)/(handles.x2 - handles.x1);
b = handles.x2v - handles.x2*a;
c = (handles.y2v - handles.y1v)/(handles.y2 - handles.y1);
d = handles.y2v - handles.y2*c;

xx = a*handles.x + b;
yy = c*handles.y + d;

axes(handles.ha2)
if cstrcmp(handles.xaxes, 'log') & cstrcmp(handles.yaxes, 'log')
    loglog(xx, yy, 'k-o')
end
if cstrcmp(handles.xaxes, 'linear') & cstrcmp(handles.yaxes, 'linear')
    plot(xx, yy, 'k-o')
end
if cstrcmp(handles.xaxes, 'linear') & cstrcmp(handles.yaxes, 'log')
    semilogy(xx, yy, 'k-o')
end
if cstrcmp(handles.xaxes, 'log') & cstrcmp(handles.yaxes, 'linear')
    semilogx(xx, yy, 'k-o')
end

xlabel('x')
ylabel('y')

disp('x & y are the following:')
[xx(:) yy(:)]

guidata(h_pbxy, handles);
%<---------------------------------------------------------


%  Callbacks for pusbutton "Browse"   --------------------->
function h_pbbrowse_Callback(h_pbbrowse, eventdata, handles)
% browsing figure file
handles = guidata(h_pbbrowse);

[handles.filename, handles.path] = uigetfile('*.jpg','Select figure file to be digitized!');

file = [handles.path handles.filename];
I = imread(file);
axes(handles.ha1)
imshow(I)

guidata(h_pbbrowse, handles);

%<---------------------------------------------------------


%  Callbacks for editable text field 4 x1 value   --------------------->
function h_editx1_Callback(h_editx1, eventdata, handles)
% x1 value
handles = guidata(h_editx1);

handles.x1v = str2num(get(h_editx1, 'String'));

guidata(h_editx1, handles);
%<---------------------------------------------------------


%  Callbacks for editable text field 4 x2 value   --------------------->
function h_editx2_Callback(h_editx2, eventdata, handles)
% x2 value
handles = guidata(h_editx2);

handles.x2v = str2num(get(h_editx2, 'String'));

guidata(h_editx2, handles);
%<---------------------------------------------------------


%  Callbacks for editable text field 4 y1 value   --------------------->
function h_edity1_Callback(h_edity1, eventdata, handles)
% y1 value
handles = guidata(h_edity1);

handles.y1v = str2num(get(h_edity1, 'String'));

guidata(h_edity1, handles);
%<---------------------------------------------------------


%  Callbacks for editable text field 4 y2 value   --------------------->
function h_edity2_Callback(h_edity2, eventdata, handles)
% y2 value
handles = guidata(h_edity2);

handles.y2v = str2num(get(h_edity2, 'String'));

guidata(h_edity2, handles);
%<---------------------------------------------------------


%  Callbacks for editable text field 4 figure filename   --------------------->
function h_editFile_Callback(h_editFile, eventdata, handles)
% file name
handles = guidata(h_editFile);

file = get(h_editFile, 'String');
I = imread(file);
axes(handles.ha1)
imshow(I)

guidata(h_editFile, handles);
%<---------------------------------------------------------

function a = cstrcmp(s1, s2)
if length(s1)== length(s2)
    if s1 == s2
        a = 1;
    else 
        a=0;
    end
else
    a = 0;
end
