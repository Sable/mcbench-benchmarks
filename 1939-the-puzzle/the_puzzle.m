function the_puzzle(typ)
% the_puzzle -- Interactive puzzle
%
% Type 'the_puzzle' start to the game. Run only one game at a time.
%
%	On the board the gray squares represent 'pegs'. The black squares
% represent 'holes'. PC users will see 'holes' as a square marked 'X'.
% To make a move, click on a 'peg' one position away from a 'hole', with
% a 'peg' in between the two. After the move is made, the 'peg' jumps over
% its neighbor to occupy the 'hole'. The 'peg' that was in between the
% first 'peg' and the 'hole' is removed from the game board. Thus each move
% reduces the 'peg' count by one. The message box on the top right keeps 
% track of the number of pegs left on the board.
%	Diagonal moves are not allowed.
%	The aim of the game is to remove as many 'pegs' as possible. Best
% play will leave one 'peg' on the board.
% 	If you click on a 'peg' that can make a legal move, the 'peg' turns
% blue. PC users will see a '*' on the selected peg. To unselect, click on
% the selected 'peg' again.
% 	The message box on the top left will prompt you for moves.
%
%	Deepak Gangadharan, Department of Electrical Engineering,
%	University of South Florida. (deepak@chuma.cas.usf.edu)
%
global SQval
global SQstat
global SQcon
global Legal
global LastSq
global NumSqr
global ColHo
global ColSq
global mFig
global hlpBtn
global ScrBtn
global Tok
global Status
%
	if nargin == 0
		typ = 'init';
		Status = 0;
	end;
%--------------------------------------
% The initialization process
%--------------------------------------
	if strcmp(typ,'init');
%
% Create the matrix that stores square values
%
		SQval = ones(7) .* 2;
        	SQval(3:5,1:2) = ones(3,2);
		SQval(3:5,6:7) = ones(3,2);
		SQval(3:5,3:5) = ones(3);
        	SQval(1:2,3:5) = ones(2,3);
		SQval(6:7,3:5) = ones(2,3);
		SQval(4,4) = 0;
%
% Number of 'occupied' squares, move token
%
		NumSqr = 32;
		Tok = 0;
		%disp(['Initialisation : ', int2str(Tok)]);
%
% Store possiblity of legal moves, the control matrix
%
	SQstat = 0 * SQval;
	for rw = 1:7
		for cl = 1:7
			if SQval(rw,cl) ~= 2
%
% Process downward moves
%
rwd = rw + 1; rwdd = rw + 2;
if rwd < 8 & rwdd < 8
	if  SQval(rw,cl) == 1 & SQval(rwd,cl) == 1 & SQval(rwdd,cl) == 0
		SQstat(rw,cl) = 1;
	end
end
%
% Process upward moves
%
rwu = rw - 1; rwuu = rw - 2;
if rwu > 0 & rwuu > 0
	if  SQval(rw,cl) == 1 & SQval(rwu,cl) == 1 & SQval(rwuu,cl) == 0
		SQstat(rw,cl) = 1;
	end
end
%
% Process rightward moves
%
clr = cl + 1; clrr = cl + 2;
if clr < 8 & clrr < 8
	if  SQval(rw,cl) == 1 & SQval(rw,clr) == 1 & SQval(rw,clrr) == 0
		SQstat(rw,cl) = 1;
	end
end
%
% Process leftward moves
%
cll = cl - 1; clll = cl - 2;
if cll > 0 & clll > 0
	if  SQval(rw,cl) == 1 & SQval(rw,cll) == 1 & SQval(rw,clll) == 0
		SQstat(rw,cl) = 1;
	end
end
%
			end 	% End of if loop
		end		% End of cl for loop
	end			% End of rw for loop
%
% Now set the display window
%
	Btn = 45;
	Wdt = 7 * Btn;
	Hgt = (7 * Btn) + 90;
	FigPos = [190 250 Wdt Hgt];
	mesg1 = 'The Puzzle';
%
	if Status == 0
		mFig = figure('Position',FigPos);
		Status = 1;
	end
%
	set(mFig,'Resize', 'off', ...
		'NumberTitle', 'off', ...
		'MenuBar', 'none', ...
		'Name', mesg1, ...
		'Color', [.5 .5 .5]);
%
	ColSq = [.71 .71 .71];
	%ColHo = [.71 .71 .71];
	ColHo = [0 0 0];
%
% Set the values for the buttons
%
	SQcon = 0 * SQval;
%
	for rw = 1:7
		for cl = 1:7
			if SQval(rw,cl) ~= 2
%
			BtnPos = [(cl-1)*Btn (rw-1)*Btn Btn-1 Btn-1];
			SQcon(rw,cl) = uicontrol('Style','PushButton', ...
						'Units', 'pixels', ...
						'Position', BtnPos, ...
					'Callback', 'the_puzzle(''move'')', ...
			'UserData', [rw cl SQval(rw,cl) SQstat(rw,cl)]);
%
% Different colors for 'holes' and 'pegs'.
%
			if SQval(rw,cl) == 1
				set(SQcon(rw,cl),'Background',ColSq);
				set(SQcon(rw,cl),'Foreground',ColSq);
				set(SQcon(rw,cl),'String','');
			else
				set(SQcon(rw,cl),'Background',ColHo);
				set(SQcon(rw,cl),'Foreground',[0 0 0]);
				set(SQcon(rw,cl),'String','X');
			end
%
		end 		% End of the if statement.
	end 			% End of cl loop
end 				% end of rw loop
%
% The help box
%
	HelpPos = [ 5 7*Btn+10 140 20];
	mesg2 = 'Ready to start.';
	hlpBtn = uicontrol( 'Style', 'Text', ...
				'Units', 'pixels', ...
				'Position', HelpPos, ...
				'String', mesg2);
%
% The score box
%
	ScorePos = [ 185 7*Btn+10  98 20];
	mesg3 = '32 pegs.';
	ScrBtn = uicontrol( 'Style', 'Text', ...
				'Units', 'pixels', ...
				'Position', ScorePos, ...
				'String', mesg3);
%
% The renew button
%
	RenewPos = [40 7*Btn+45 75 30];
	RenBtn = uicontrol( 'Style', 'Pushbutton', ...
				'Units', 'pixels', ...
				'Position', RenewPos, ...
				'Callback', 'the_puzzle(''init'')', ...
				'String', 'Restart');
%
% The exit button
%
	ExitPos = [198 7*Btn+45 75 30];
	ExtBtn = uicontrol( 'Style', 'Pushbutton', ...
				'Units', 'pixels', ...
				'Position', ExitPos, ...
				'Callback', 'the_puzzle(''exit'')', ...
				'String', 'EXIT');
%
% The info button
%
	InfoPos = [8 5.7*Btn 70 30];
	InfBtn = uicontrol( 'Style', 'Pushbutton', ...
				'Units', 'pixels', ...
				'Position', InfoPos, ...
				'Callback', 'the_puzzle(''help'')', ...
				'String', 'Info');
%-----------------------------------
% Code to deal with a move
%-----------------------------------
	elseif strcmp(typ, 'move')
		ObgCurn = gco(mFig);
		%ObgCurn = get( get(0, 'CurrentFigure'), 'CurrentObject');
		CurnInfo = get(ObgCurn, 'UserData');
%
% Information about the selected square
%
	rw = CurnInfo(1);
	cl = CurnInfo(2);
	Val = CurnInfo(3);
	Stat = CurnInfo(4);
%
% Hit an 'occupied' square where a move is possible **********************
%
	if  Val == 1 & Stat == 1 & Tok == 0;
		Tok = 1;
		%disp(['Legal Possible : ', int2str(Tok)]);
		Legal = 1;
		LastSq = [rw cl];
		%disp(['Legal Possible : ', int2str(LastSq)]);
		set(ObgCurn,'Background','c');
		set(ObgCurn,'Foreground','c');
		set(ObgCurn,'String','*');
		set(hlpBtn, 'String', 'Look for an empty');
%
% Mark the 'holes' in the neighborhood where moves are possible
%
		if (rw+1) < 8 & (rw+2) < 8
			if SQval(rw+1,cl) == 1 & SQval(rw+2,cl) == 0
				set(SQcon(rw+2,cl),'UserData',[rw+2 cl 0 1]);
			end
		end
%
		if (rw-1) > 0 & (rw-2) > 0
			if SQval(rw-1,cl) == 1 & SQval(rw-2,cl) == 0
				set(SQcon(rw-2,cl),'UserData',[rw-2 cl 0 1]);
			end
		end
%
		if (cl+1) < 8 & (cl+2) < 8
			if SQval(rw,cl+1) == 1 & SQval(rw,cl+2) == 0
				set(SQcon(rw,cl+2),'UserData',[rw cl+2 0 1]);
                        end
                end
%
		if (cl-1) > 0 & (cl-2) > 0
			if SQval(rw,cl-1) == 1 & SQval(rw,cl-2) == 0
				set(SQcon(rw,cl-2),'UserData',[rw cl-2 0 1]);
                        end
                end
%
% Change your mind on a move. *****************************************
%
	elseif Val == 1 & Stat == 1 & Tok == 1 & [rw cl] == LastSq
		Tok = 0;
		%disp(['Change Mind : ', int2str(Tok)]);
		Legal = 0;
		set(ObgCurn,'Background',ColSq);
		set(ObgCurn,'Foreground',ColSq);
		set(ObgCurn,'String','');
		set(hlpBtn, 'String', 'Select again');
%
% Unselect the 'holes' previously selected
%
		if (rw+1) < 8 & (rw+2) < 8
			if SQval(rw+1,cl) == 1 & SQval(rw+2,cl) == 0
				set(SQcon(rw+2,cl),'UserData',[rw+2 cl 0 0]);
			end
		end
%
		if (rw-1) > 0 & (rw-2) > 0
			if SQval(rw-1,cl) == 1 & SQval(rw-2,cl) == 0
				set(SQcon(rw-2,cl),'UserData',[rw-2 cl 0 0]);
			end
		end
%
		if (cl+1) < 8 & (cl+2) < 8
			if SQval(rw,cl+1) == 1 & SQval(rw,cl+2) == 0
				set(SQcon(rw,cl+2),'UserData',[rw cl+2 0 0]);
                        end
                end
%
		if (cl-1) > 0 & (cl-2) > 0
			if SQval(rw,cl-1) == 1 & SQval(rw,cl-2) == 0
				set(SQcon(rw,cl-2),'UserData',[rw cl-2 0 0]);
                        end
                end
%
% Complete a legal move  ***********************************************
%
	elseif Legal == 1 & Val == 0 & Stat == 1
		Legal = 0;
		Tok = 0;
		%disp(['Completion : ', int2str(Tok)]);
		%disp(['Completion : ', int2str(LastSq)]);
		NumSqr = NumSqr - 1;
		SQval(LastSq(1),LastSq(2)) = 0;
		set(hlpBtn, 'String', 'One less peg!!');
		mesg4 = ['# of pegs: ',int2str(NumSqr)];
		set(ScrBtn, 'String', mesg4);
		SQval(rw,cl) = 1;
%
% Check to see if both the squares are on the same row or column
%
		if (rw - LastSq(1)) == 0
			Sr = sort([LastSq(2) cl]);
			SQval(rw, Sr(1)+1) = 0;
		elseif (cl - LastSq(2)) == 0
			Sr = sort([LastSq(1) rw]);
			SQval(Sr(1)+1, cl) = 0;
		end
%
% Modify the values on the control matrix to reflect the move
%
        SQstat = 0 * SQval;
        for rw = 1:7
                for cl = 1:7
                        if SQval(rw,cl) ~= 2
%
% Process downward moves
%
rwd = rw + 1; rwdd = rw + 2;
if rwd < 8 & rwdd < 8
        if  SQval(rw,cl) == 1 & SQval(rwd,cl) == 1 & SQval(rwdd,cl) == 0
                SQstat(rw,cl) = 1;
        end
end
%
% Process upward moves
%
rwu = rw - 1; rwuu = rw - 2;
if rwu > 0 & rwuu > 0
        if  SQval(rw,cl) == 1 & SQval(rwu,cl) == 1 & SQval(rwuu,cl) == 0
                SQstat(rw,cl) = 1;
        end
end
%
% Process rightward moves
%
clr = cl + 1; clrr = cl + 2;
if clr < 8 & clrr < 8
        if  SQval(rw,cl) == 1 & SQval(rw,clr) == 1 & SQval(rw,clrr) == 0
                SQstat(rw,cl) = 1;
        end
end
%
% Process leftward moves
%
cll = cl - 1; clll = cl - 2;
if cll > 0 & clll > 0
        if  SQval(rw,cl) == 1 & SQval(rw,cll) == 1 & SQval(rw,clll) == 0
                SQstat(rw,cl) = 1;
        end
end
%
                        end 	% End of if loop
                end 		% End of cl for loop
        end 			% End of rw for loop
%
% Modify the data on the buttons to reflect new values.
%
	for rw = 1:7
		for cl = 1:7
	if SQval(rw,cl) ~= 2
	set(SQcon(rw, cl),'UserData', [rw cl SQval(rw,cl) SQstat(rw,cl)]);
			if SQval(rw,cl) == 1
				set(SQcon(rw,cl),'Background',ColSq);
				set(SQcon(rw,cl),'Foreground',ColSq);
				set(SQcon(rw,cl),'String','');
			else
				set(SQcon(rw,cl),'Background',ColHo);
				set(SQcon(rw,cl),'Foreground',[0 0 0]);
				set(SQcon(rw,cl),'String','X');
%
			end 	 	% End of 'Background' if loop
			end		% End of 'UserData' loop
		end			% End of cl for loop
	end				% End of cl for loop
%
% Check to see if legal moves are still possible
%
	if max(max(SQstat)) == 0
		set(hlpBtn, 'String', 'GAME OVER');
%
% Set title to reflect the game score
%
		if NumSqr == 1
			set(mFig,'Name', 'PERFECT SCORE !!');
		else
			set(mFig,'Name', 'GAME OVER !');
		end
%
	end
%
% A null move **************************************************
%
	else
		set(hlpBtn, 'String', 'No move possible');
	end
% End of the move select if block
%---------------------------------------------
% The Info button
%---------------------------------------------
	elseif strcmp(typ, 'help')
		TxtWdt = 500;
		TxtHgt = 20;
		Lin = 24;
		winhelp = figure('Position',[100 100 TxtWdt Lin*TxtHgt]);
		set(winhelp,'Resize', 'off', ...
                'NumberTitle', 'off', ...
                'MenuBar', 'none', ...
                'Name', 'About The Puzzle', ...
		'Color', [1 1 1]);
%
% The text inside the window
%
		TXTBtn = zeros(1,Lin);
	for n = 1 : Lin
		TXTBtn(n) = uicontrol('Style','Text','Parent',winhelp);
		set(TXTBtn(n),'Units','pixels', ...
			'Position',[0 (Lin-n)*TxtHgt TxtWdt TxtHgt], ...
			'HorizontalAlignment','left', ...
			'Background',[.85 .85 .85]);
	end
%
% The actual help statement
%
txta='   On the board the gray squares represent ''pegs''. The black squares';
set(TXTBtn(1),'String',txta);
txt1='   represent ''holes''. PC users will see ''holes'' as a square marked';
txt2=' ''X''.';
txtb = [txt1,txt2];
set(TXTBtn(2),'String',txtb);
txt1='   To make a move, click on a ''peg'' one position away from a';
txt2=' ''hole'', with';
txtc = [txt1,txt2];
set(TXTBtn(3),'String',txtc);
txt1='   a ''peg'' in between the two. After the move is made, the';
txt2='  ''peg'' jumps over';
txtd = [txt1,txt2];
set(TXTBtn(4),'String',txtd);
txt1='   its neighbor to occupy the ''hole''. The ''peg'' that was in';
txt2=' between the';
txte = [txt1,txt2];
set(TXTBtn(5),'String',txte); 
txt1='   first ''peg'' and the ''hole'' is removed from the game board. Thus';
txt2=' each move';
txtf = [txt1,txt2];
set(TXTBtn(6),'String',txtf);
txt1='   reduces the ''peg'' count by one. The message box on the top right';
txt2=' keeps';
txtg = [txt1,txt2];
set(TXTBtn(7),'String',txtg);
txth ='   track of the number of pegs left on the board.';
set(TXTBtn(8),'String',txth);
txti ='   Diagonal moves are not allowed.';
set(TXTBtn(10),'String',txti);
txt1='   The aim of the game is to remove as many ''pegs'' as possible. Best';
txt2=' play';
txtj = [txt1,txt2];
set(TXTBtn(12),'String',txtj);
txtk='   will leave one ''peg'' on the board.';
set(TXTBtn(13),'String',txtk);
txt1='   If you click on a ''peg'' that can make a legal move, the ''peg''';
txt2=' turns blue.';
txtl = [txt1,txt2];
set(TXTBtn(15),'String',txtl);
txt1='   PC users will see a ''*'' on the selected peg. To unselect,';
txt2=' click on the';
txtm = [txt1,txt2];
set(TXTBtn(16),'String',txtm);
txtn ='   selected ''peg'' again.';
set(TXTBtn(17),'String',txtn);
txto ='   The message box on the top left will prompt you for moves.';
set(TXTBtn(19),'String',txto);
txtp ='   Run only one game at a time.';
set(TXTBtn(21),'String',txtp); 
txtq='   Deepak Gangadharan, Department of Electrical Engineering,';
set(TXTBtn(23),'String',txtq);
txtr='   University of South Florida. (deepak@chuma.cas.usf.edu)';
set(TXTBtn(24),'String',txtr);
%---------------------------------------------
% The EXIT button
%---------------------------------------------
	elseif strcmp(typ, 'exit')
		close(mFig);
		clear global SQval SQstat SQcon Legal LastSq NumSqr ColHo
		clear global ColSq mFig hlpBtn ScrBtn Tok Status 
		clc;
		disp('*------------------------------------------*');
		disp('*    Hope you enjoyed playing the game     *');
		disp('*                                          *');
		disp('*                 author                   *');
		disp('*             Deepak Gangadharan           *');	
		disp('*          deepak@chuma.cas.usf.edu        *');	
		disp('*      http://chuma.cas.usf.edu/~deepak/   *');	
		disp('*                                          *');
		disp('*------------------------------------------*');
	end
% End of game
%
% Created by Deepak Gangadharan on 12th July 1997 at 2109 hrs
% MATLAB Version 4.2c on SunOS 5.5.1 sun4m sparc SUNW SPARCstation-4
%
