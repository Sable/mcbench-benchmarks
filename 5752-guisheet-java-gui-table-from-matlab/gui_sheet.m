function [handle, b] = gui_sheet(title, texts)
% [handle, b] = gui_sheet(title, texts)
% title is a string
% texts is a cell array of strings, where the first row are headers
% handle is handle to the mathworks MWFrame
% b is a handle to mathworks MWListbox
% b.getSelectedRows => gets you the index of the row currently selected by mouse, beginning with zero!!!
% --
% example:
% [handle, b] = gui_sheet('nice table', {'a', 'b', 'c';'1', '2', '3'})
%
% (c) 2004 by Andrej Mosat, mosibiz@tech.chem.ethz.ch
% requires Java runtime environment installed and mathworks components
% ver. 0.5

% GPL License (www.google.com),
% feel free to modify it, if you have any questions or interesting modifications, please send an email.
% there is a problem with some screen resolutions, you can modify it according to your needs, or add another input parameters
% you can access: cursor position, data in the table, visibility of the listbox or frame data.
% this file is far from complete, it is just an example on how to put a table into matlab gui (in this case only external window)
% if you have any idea on how to put a table into an existing gui window, i`ll be very thankful for hints and tips.

import com.mathworks.mwt.* java.awt.* ;

handle=MWFrame(title);

if (~iscell(texts) & ~isnumeric(texts)) | ~isstr(title)
	error('texts must be a cell array of strings or numbers, title must be a string');
end

% preparation of data
[nrows, ncolumns]=size(texts);
width=zeros(1,ncolumns);
% if ~isstr((texts{1,1}))
% 	texts={ {}; texts}
% end

if isnumeric(texts)
	texts={num2cell(ones(size(width))) ; num2cell(texts)};
end

% determining the max. width of each column
for col=1:ncolumns
			headers{1,col}=mat2str(texts{1,col});
	for row=1:nrows
		if isinf(texts{row,col})
			curwidth=4;
		else
			curwidth=length(mat2str(texts{row,col}));
		end
		if curwidth>width(col)
			width(col)=curwidth;
		end
   end % for row
end % for col

% get the actual screen size and size the table accordingly:
dz = handle.getToolkit.getScreenSize;
b = MWListbox;
b.setColumnCount(ncolumns);
% hdrs = {'Qualifiers', 'Return Type', 'Name', 'Arguments'}
% b.setColumnWidth(42,10);

for i=1:ncolumns,
      %wc = 7.5*max([length(headers{1,i})]);
%       b.setColumnWidth(i-1, width(i)*6);
		b.setColumnWidth(i-1, width(i)*6+3);
      b.setColumnHeaderData(i-1,headers{i});
end;
% setting the behaviour of the table (can be found in java awt documentation, or methods of java table)
b.setExcelMode(1);
ts=b.getTableStyle;
ts.setVGridVisible(1);
ts.setHAlignment(1);
b.setTableStyle(ts);
co = b.getColumnOptions;
set(co, 'HeaderVisible', 'on');
set(co, 'Resizable', 'on');
b.setColumnOptions(co);
% ds = javaArray('java.lang.String', 4)
% filling-up the table with data:
text={};
for i=2:nrows
	for j=1:ncolumns
		text{1,j}=mat2str(texts{i,j});
   end
	b.addItem(text);
		text={};
end
b.setSelectedIndex(0);
handle.add(b);
% modify this if your window is too large or small:
curwidth=sum(width)*6.2;
curheight=nrows*30+10;
if dz.width<curwidth
	curwidth=int32(dz.width*0.7);
end
if dz.height<curheight
	curheight=int32(dz.height*0.7);
end

handle.setBounds(300,300,curwidth,curheight);
% this line of code adds a "close and exit" behaviour to the invoked window, if you remove it, your window is uncloseable!!!
% if you loose your hadles, you cannot close it anymore until you restart matlab.
handle.addWindowListener(window.MWWindowActivater(handle));
% sets the visibility of your creation to "on"
handle.setVisible(1);

%----------------------------%
% pane=javax.swing.JOptionPane
% panel=javax.swing.JPanel
% pane.showMessageDialog('', '17 mph', 'Man Speed', 1)

% this shows how to see and play with the data comming from java objects:
% methodsview javax.swing.JOptionPane
