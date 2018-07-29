function DragDropTest
% 
% Example Drag and Drop in Matlab Figures from Windows Explorer or Other Apps
% 
% DrapDropTest creates a simple figure which shows the implementation of dnd using activex.
% The microsoft RichtextCtrl.1 activex control is used to demonstrate dnd ability.  The control
% has several events to which matlab can respond, in particular the OLEDragDrop Event.  
% 
% Type DragDropTest from the command line to test.  Once the figure is
% running try dragging a text file into either of 2 areas on the figure.
% The upper portion will just populate a listbox with the names of files
% that have been dragged into the bar above it.  The lower box displays the
% contents of any text file dragged into it.  The bottom box also allows
% text to be dragged from a text editor such as wordpad.  
% 
% This example is not intended to be robust, so please feel free to use it,
% but make sure to check over the code in detail to make sure it doesn't
% break.  I've just coded this quickly to demonstrate the property.  Feel
% free to email me with questions comments.
% 
% Raphael Austin
% raphael.austin@jhuapl.edu
% 
% Last Updated: 9/10/2007


f=figure;
pos=get(f,'position');
color=get(f,'color');


%use this one to put a file name into a box
uicontrol('style','listbox','position',[pos(3)*.1 250 pos(3)*.8 100],'tag','FileNameList');% create a listbox to show filenames

ProgID='RICHTEXT.RichtextCtrl.1';
h1 = actxcontrol(ProgID, [pos(3)*.1 355 pos(3)*.8 20],f,{'OLEDragDrop',@ShowFileNameOnDrop});
set(h1,'OLEDropMode','rtfOLEDropManual');
set(h1,'text','Drag file into this window to populate the list with filenames...')
uicontrol('style','text','string','File Name Loader','position',[pos(3)*.1 375 pos(3)*.8 20],...
          'backgroundcolor',color,'fontweight','bold');



%use this one to drag text from a word pad document or explorer
ProgID='RICHTEXT.RichtextCtrl.1';
h2 = actxcontrol(ProgID, [pos(3)*.1 20 pos(3)*.8 180],f,{'OLEDragDrop',@ShowFileContentsOnDrop});
set(h2,'OLEDropMode','rtfOLEDropManual');
set(h2,'text','Drag text file into this window for preview...')
uicontrol('style','text','string','Text File Preview','position',[pos(3)*.1 200 pos(3)*.8 20],...
          'backgroundcolor',color,'fontweight','bold');
end



function ShowFileNameOnDrop(varargin)
hObject=varargin{1};
Interface=varargin{3};

try
    data=Interface.GetData(1);
catch

    data=Interface.get.Files.Item(1);
end


set(hObject,'text',data);
list=findobj(gcf,'tag','FileNameList');
Str=cellstr(get(list,'string'));
Str(end+1)={data};
set(list,'string',Str);
end



function ShowFileContentsOnDrop(varargin)
hObject=varargin{1};
Interface=varargin{3};


try
    data=Interface.GetData(1); %this works if its just text copied from one rtf into an rtf box
catch
    data=Interface.get.Files.Item(1); %this works if its a file dragged from explorer over the rtf box
    fid=fopen(data);
    filecontents=fscanf(fid,'%c');
    fclose(fid);
    data=filecontents;
end

set(hObject,'text',data);
end

