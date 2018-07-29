% Display a text file in a popupmenu
%
% function popupmessage(filename,titlename)
%
% filename-name of the file
% titlename-name of the window
%
% Written by Samuel Cheng, Copyright 2005
%
% You are allowed to redistribute and use this code if this m-file is not modified.

function popupmessage(textfile,titlename,command);

if exist('command')~=1 % setup message
 if exist('textfile')~=1
   error('Please specify the filename. help popupmessage for more info.');
 end
 if exist(textfile)~=2
   error(sprintf('File %s does not exist or is not a text file.',textfile));
 end
 if exist('titlename')~=1
     titlename='';
 end
 if isempty(titlename)
     titlename='';
 end
    
 f=figure;
 set(f,'menubar','none','tag','figure');
 
 h1=addTextBox(f,textfile);
 h2=addOkayButton(f,'OK');
 set(f,'resizefcn','popupmessage('''','''',''resize_callback'')');
 set(f,'name',titlename,'numbertitle','off');
 handles=guihandles(f);
 guidata(f,handles);
else

 feval(command);

end

function resize_callback
handles=guidata(gcbo);
tbpos=getTBPos(handles.figure);
bpos=getOKPos(handles.figure);
set(handles.okaybutton,'position',bpos);
set(handles.textbox,'position',tbpos);

%-----------------------------------
function h=addTextBox(f,textfile)

fid=fopen(textfile,'r');
if (fid==-1) 
  error('Please check your filename, cannot open file');
end

tbpos=getTBPos(f);
h=uicontrol(f,'style','listbox','position',tbpos,'tag','textbox');

id=1;
while 1
     tline = fgetl(fid);
     if ~ischar(tline), break, end
     mystrings{id}=tline; id=id+1;
end
fclose(fid);
if exist('mystrings','var')
    set(h,'string',mystrings);
end
%------------------------------------
function tbpos=getTBPos(f)

margins=[10 10 10 50]; % left, right, top, bottom
pos=get(f,'position');
tbpos=[margins(1) margins(4) pos(3)-margins(1)-margins(2) ...
    pos(4)-margins(3)-margins(4)];
tbpos(tbpos<1)=1;

%----------------------------------
function h=addOkayButton(f,btext)

bpos=getOKPos(f);
h=uicontrol(f,'style','pushbutton','position',bpos,'string',btext,'tag','okaybutton');
set(h,'callback','popupmessage('''','''',''okaybutton_callback'')');

%-----------------------------------
function h=okaybutton_callback
handles=guidata(gcbo);
close(handles.figure);

%------------------------------------
function tbpos=getOKPos(f)

bsize=[60,30];
badjustpos=[0,25];

pos=get(f,'position');

tbpos=[pos(3)/2-bsize(1)/2+badjustpos(1) -bsize(2)/2+badjustpos(2)...
    bsize(1) bsize(2)];
tbpos=round(tbpos);
tbpos(tbpos<1)=1;
