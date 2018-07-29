function matlab_figures_to_word_document
%This program converts a Matlab Figure File with a title to Word Document
%through ActiveX Control. The program is designed for a figure with a
%single graph with a title.  It converts the graph title to an array,
%deletes the title, copies the figure to the clipboard, pastes the
%clipboard contents to the Word Document, and writes the title as text
%beneath the figure.  The program can operate in two modes:
%	1.	Single file - Use Lines 12 through 15
%	2.	All files in a directory - Use Lines 16 through 25
%
%The program is currently designed for two lines of text, but more can be
%added by copying and pasting the four lines of code that write text and
%adjusting the subscript numbers.  The program could also be adjusted to
%handle a single-line title by deleting the code that writes the second
%line of the title.  The title in the Word Document will also contain
%today's date, but that can be changed by deleting the appropriate code.
%
%At present, the program only creates new files.

%Operate on just one file
	%[filename pathname] = uigetfile('*.fig', 'Select file to open');
		%full_name = [pathname filename];
	%create_word_figure(full_name);
%Get entire directory
	pathname = uigetdir;
	file_directory = dir([pathname '\*.fig']);
		num_files = length(file_directory);
	%Get individual files
	for k = 3:num_files
		filename = file_directory(k,1).name;
		full_name = [pathname '\' filename];
		create_word_figure(full_name);
	end
%End of main program

function create_word_figure(full_name);
	%Open New Word Document
		Doc = actxserver('Word.Application');
		set(Doc,'Visible',1);
		MS = invoke(Doc.Documents,'Add');
		new = 1;
	%Open file and obtain information to be written to word file
		hndl = open(full_name);								%Open figure and get its handle
		ax_title_hndl = get(gca, 'Title');					%Get handle of title
		Ax_Title_Array = get(ax_title_hndl, 'String');		%Get string of handle
		delete(ax_title_hndl);								%Delete title from figure
		print -dmeta										%Copy figure to clipboard
		close(hndl);										%Close the figure
	%Write to document
		%Put figure in document
			invoke(Doc.Selection, 'Paste');
		%Put first line of title in document
			invoke(Doc.Selection, 'TypeParagraph');
			set(Doc.Selection, 'Text',char(Ax_Title_Array(1)));
			set(Doc.Selection.ParagraphFormat,'Alignment',1);
		%Put second line of title in document
			invoke(Doc.Selection,'MoveDown');
			invoke(Doc.Selection, 'TypeParagraph');
			set(Doc.Selection, 'Text',char(Ax_Title_Array(2)));
			set(Doc.Selection.ParagraphFormat,'Alignment',1);
		%Put today's date in document
			invoke(Doc.Selection,'MoveDown');
			invoke(Doc.Selection, 'TypeParagraph');
			set(Doc.Selection, 'Text',date);
			set(Doc.Selection.ParagraphFormat,'Alignment',1);
	%Save word file
		[fpath,fname,fext] = fileparts(full_name);
		word_name = [fname '.doc'];
		full_name = [fpath '\' word_name];
		invoke(MS,'SaveAs',full_name);
		invoke(Doc,'Quit');
		delete(Doc);
%End of function
%End of program