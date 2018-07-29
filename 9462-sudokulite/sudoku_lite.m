function sudoku_lite(arg1,arg2)
% SUDOKU_LITE  A "light" Sudoku generator and helper.
 
%   Dario Fasino   http://www.dimi.uniud.it/fasino   Dec 2005

persistent modeHndl markHndl hintHndl textHndl chckHndl;
persistent h field;   

if nargin < 1
   if ~isempty(findobj('Tag','Sudoku_lite'))
      error('Sudoku_lite is already running...')
   end
   arg1 = 'start';
end;

if strcmp(arg1,'start') ;
   WIDTH = 36;
   HEIGHT = 36;
   OFFSET = 1 + WIDTH / 2;
   
   figHndl = figure('Name','Sudoku_lite',...
      'Position',[250 150 560 420],...
      'Tag','Sudoku_lite',...
      'NumberTitle','off',...
      'Menubar','none',...
      'Visible','off',...
      'Color',[1 1 1]);   
  
tmp = uimenu('Label','&Game');
      uimenu(tmp,'Label','Show status msg', ...
          'Tag','Sudoku_opt_ss', ...
          'Checked','on', ...
          'Callback','sudoku_lite(''set'',''statusmsg'')');
      uimenu(tmp,'Label','Show hints', ...
          'Tag','Sudoku_opt_sh', ...
          'Checked','on', ...
          'Callback','sudoku_lite(''set'',''showhints'')');
      uimenu(tmp,'Label','Joyful ending', ...
          'Tag','Sudoku_opt_je', ...
          'Callback','sudoku_lite(''set'',''joyfulend'')');
      uimenu(tmp,'Label','&M-File Info','Separator','on', ...
          'Callback',['helpwin ',mfilename]);
      uimenu(tmp,'Label','&About ...', ...
          'Callback', ...
          'msgbox(''Written by Dario Fasino (2005)'',''About ...'')');
      uimenu(tmp,'Label','E&xit', ...
          'Callback','close(gcf)','Separator','on');
   
   axes('Units','pixels',...
      'PlotBoxAspectRatio',[1 1 1],...
      'Position',[WIDTH+OFFSET,HEIGHT+OFFSET,9*WIDTH,9*HEIGHT],...
      'Color','none',...
      'Box','on', ...
      'YDir','reverse', ... 
      'XLim',[0 9*WIDTH],...
      'YLim',[0 9*HEIGHT], ...
      'XColor','k','YColor','k','LineWidth',2,...  
      'Tag','mainaxes', ...
      'Xtick',[],'Ytick',[]);
   
   line([0 ; 9*WIDTH]*ones(1,8), [HEIGHT; HEIGHT]*[1:8],...
       'Color','k','LineWidth',1);
   line([0 ; 9*WIDTH]*[1 1], [HEIGHT; HEIGHT]*[3 6],...
       'Color','k','LineWidth',2);
   line([WIDTH; WIDTH]*[1:8],[0 ; 9*HEIGHT]*ones(1,8),...
       'Color','k','LineWidth',1);
   line([WIDTH; WIDTH]*[3 6],[0 ; 9*HEIGHT]*[1 1],...
       'Color','k','LineWidth',2);

   %====================================
   % The STATUS text           
   textHndl = uicontrol('Style','text',...
      'Visible','on',...
      'BackgroundColor',[1 1 1], ...
      'Units','pixels',...
      'FontSize',12, ...
      'FontWeight','normal', ...
      'HorizontalAlignment','left', ...
      'Position', [WIDTH+OFFSET 0 10*WIDTH WIDTH],...
      'String','Select MODE and click NEW to start');
     
   %====================================
   % Information for all buttons
   top=0.90;
   left=0.80;  
   bottom=0.05;
   btnWid=0.12;
   btnHt=0.10;   
   % Spacing between the button and the next command's label
   spacing=0.055;
   
   %====================================
   % The CONSOLE frame
   frmBorder=0.02;
   yPos=0.055-frmBorder;
   frmPos=[left-frmBorder yPos btnWid+2*frmBorder top+2*frmBorder];
   uicontrol( ...
      'Style','frame', ...
      'Units','normalized', ...
      'Position',frmPos, ...
      'BackgroundColor',.75*[1 1 1]);
   
   %====================================
   % The MODE popup
   btnNumber=1;
   yPos=top-(btnNumber-1)*(btnHt+spacing);
   labelStr='Mode';
   labelList='easy|medium|hard|manual';
   callbackStr='';
   
   % Generic label information
   labelPos=[left yPos-spacing+btnHt/2 btnWid btnHt/2];
   uicontrol( ...
        'Style','text', ...
        'Units','normalized', ...
        'Position',labelPos, ...
        'String',labelStr);
   
   % Generic popup information
   btnPos=[left yPos-spacing btnWid btnHt/2];
   modeHndl=uicontrol( ...
      'Style','popup', ...
      'Units','normalized', ...
      'Position',btnPos, ...
      'Enable','on', ...
      'String',labelList);   
   
   %====================================
   % The NEW button
   btnNumber=2;
   yPos=top-(btnNumber-1)*(btnHt+spacing);
   labelStr='New';
   callbackStr='sudoku_lite(''newgame'')';
   
   % Generic button information
   btnPos=[left yPos-spacing btnWid btnHt];
   uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',btnPos, ...
      'String',labelStr, ...
      'Callback',callbackStr);

   %====================================  
   % The MARK popup
   btnNumber=3;
   yPos=top-(btnNumber-1)*(btnHt+spacing);
   labelStr='Mark';
   labelList='1|2|3|4|5|6|7|8|9|(none)';
      
   % Generic label information
   labelPos=[left yPos-spacing+btnHt/2 btnWid btnHt/2];
   uicontrol( ...
        'Style','text', ...
        'Units','normalized', ...
        'Position',labelPos, ...
        'String',labelStr);
   
   % Generic popup information
   btnPos=[left yPos-spacing btnWid btnHt/2];
   markHndl=uicontrol( ...
      'Style','popup', ...
      'Units','normalized', ...
      'Position',btnPos, ...
      'Enable','on', ...
      'String',labelList);   

   %====================================
   % The HINTS button
   btnNumber=4;
   yPos=top-(btnNumber-1)*(btnHt+spacing);
   labelStr='Hints';
   callbackStr='sudoku_lite(''hints'')';
   
   % Generic button information
   btnPos=[left yPos-spacing btnWid btnHt];
   hintHndl=uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',btnPos, ...
      'String',labelStr, ...
      'Callback',callbackStr);
      
   %====================================
   % The CHECK button 
   btnNumber=5;
   yPos=top-(btnNumber-1)*(btnHt+spacing);
   labelStr='Check';
   callbackStr='sudoku_lite(''check'')';
   
   % Generic button information
   btnPos=[left yPos-spacing btnWid btnHt];
   chckHndl=uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',btnPos, ...
      'String',labelStr, ...
      'Callback',callbackStr);
   
   %====================================
   % The CLOSE button
   btnNumber=6;
   yPos=top-(btnNumber-1)*(btnHt+spacing);
   labelStr='Close';
   callbackStr='close(gcf)';
   
   % Generic button information
   btnPos=[left yPos-spacing btnWid btnHt];
   closeHndl=uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',btnPos, ...
      'String',labelStr, ...
      'Callback',callbackStr);
   
   set(chckHndl,'Enable','off'); 
   set(hintHndl,'Enable','off');
   set(gcf,'Resize','off',...
           'Visible','on');                 % only after all is built
   
   field = zeros(9,9);
   h = zeros(9,9);                          % button handles
   for i = 1:9
       for j = 1:9
           h(i,j) = text((i-1)*WIDTH+OFFSET,(j-1)*HEIGHT+OFFSET,'  ', ...
            'FontSize',18, ...
            'HorizontalAlignment','center', ...
            'Units','pixels',...
            'UserData',[i,j]);              % stuff i,j into UserData
       end
   end
   
elseif strcmp(arg1,'newgame') %----------------- NEWGAME -------------------
   
   set(h,'ButtonDownFcn','sudoku_lite(''buttonpress'')', ...
         'String',' ');                     % reset field
         
   mode = get(modeHndl,'Value');
   switch mode 
       case 3                               % mode: hard
           symmetry = 'none';
           maxtrace = 99;
       case 2                               % mode: medium
           symmetry = {'rot180','diag','skew'};
           symmetry = cell2mat(symmetry(1+fix(3*rand)));
           maxtrace = 8;
       case 1                               % mode: easy
           symmetry = {'2axes','rot90','cross'};
           symmetry = cell2mat(symmetry(1+fix(3*rand)));
           maxtrace = 4;
   end
   if mode == 4                             % mode: manual
      field = zeros(9,9);
   else                                     % create new game
      S = [1 2 3 ; 4 5 6 ; 7 8 9];          % Use a group theoretic approach        
      C = [7 8 9 1 2 3 4 5 6];              % to generate Sudoku matrices.
      R = [3 1 2 6 4 5 9 7 8];              % Not all Sudoku matrices 
      P = [1 2 3 4 5 6 7 8 9];              % can be generated in this way,
      if rand < .5                          % but it's a quite large number.
          P(1) = 2; P(2) = 1;
          if rand < .5, P(3) = 6; P(6) = 3; end
          if rand < .5, P(8) = 9; P(9) = 8; end
          if rand < .5, P(4) = 7; P(7) = 4; end
      else      
          P(1) = 4; P(4) = 1;
          if rand < .5, P(9) = 6; P(6) = 9; end
          if rand < .5, P(8) = 7; P(7) = 8; end
          if rand < .5, P(2) = 5; P(5) = 2; end
      end      
      C = P(C(P));
      R = P(R(P));
      sol = [S C(S) C(C(S))];
      sol = [sol ; R(sol) ; R(R(sol))];
      sol = sol([randperm(3) randperm(3)+3 randperm(3)+6], ...
                [randperm(3) randperm(3)+3 randperm(3)+6]);
      per = randperm(9);
      sol = per(sol);
%%%   disp(flipud(sol'))                    % FOR CHEATING

      shown = zeros(9,9);                   % choose visible entries
      shown(1+fix(81*rand(5,1))) = 1;
      field = sol .* pattern(shown,symmetry);
      [newfd,trace] = solver(field);                            
      while any(any(newfd == 0)) | (length(trace) > maxtrace)
          add2pat = rand(9,9) .* (newfd == 0);  
          [vmax,imax] = max(add2pat(:));
          shown(imax) = 1;
          field = sol .* pattern(shown,symmetry);
          [newfd,trace] = solver(field);                      
      end
      if mode == 2 | mode == 3              % mode medium or hard: 
          [I,J] = find(shown);              % increase difficulty by hiding
          for i = 1:length(I)               % unnecessary entries
              stemp = shown;
              stemp(I(i),J(i)) = 0;
              ftemp = sol .* pattern(stemp,symmetry);
              [newfd,trace] = solver(ftemp);                   
              if all(all(newfd)) & (length(trace) <= maxtrace)
                  shown(I(i),J(i)) = 0;
              end
          end
      end
      field = sol .* pattern(shown,symmetry);        % field is ready!
      I = find(field);
      set(h(I),{'String'},cellstr(num2str(field(I))), ...
          'ButtonDownFcn','', ...
          'Color','k');
   end % if mode == 4 
   set(chckHndl,'Enable','on'); 
   sudoku_lite('redraw');
      
elseif strcmp(arg1,'buttonpress') %-------------- BUTTONPRESS --------------
   
   userdata = get(gco,'UserData');
   i = userdata(1);
   j = userdata(2);
   a = get(markHndl,'Value');
   if a ~= 10
       is = 1 + 3*fix((i-1)/3);                      % check if legal move
       js = 1 + 3*fix((j-1)/3);
       if all(a~=field(i,:)) & all(a~=field(:,j)) & ...
               all(all(a~=field(is:is+2,js:js+2)))
          set(h(i,j),'String',num2str(a),'Color','b');
          field(i,j) = a;
       else
          set(textHndl,'String','Illegal move');     % flash illegal move
          oldstr = get(h(i,j),'String'); 
          oldcol = get(h(i,j),'Color'); 
          set(h(i,j),'String',num2str(a),'Color','r'); 
          x = [1:10000]; sound(exp(-.0005*x).*sin((2*pi*440/8192)*x)) % beep, 440 Hz
          pause(.5);
          set(h(i,j),'String',oldstr,'Color',oldcol); 
       end
   else
       set(h(i,j),'String',' ');
       field(i,j) = 0;
   end
   sudoku_lite('redraw');

elseif strcmp(arg1,'hints') %------------------- HINTS ---------------------
      
   hints = hintsavailable(field);       
   I = find(hints);
   set(h(I),{'String'},cellstr(num2str(hints(I))),'Color','m');
   field = field + hints;
   sudoku_lite('redraw');
   
elseif strcmp(arg1,'redraw') %----------------- REDRAW --------------------
      
   tmp = findobj('Tag','Sudoku_opt_sh');       % show hints?
   aux = get(tmp,'Checked');
   if strcmp(aux,'on') 
      hints = hintsavailable(field);           
      nhints = sum(sum(hints~=0));
      if (nhints == 0) | isnan(hints)
         set(hintHndl,'Enable','off');
         set(textHndl,'String','No hints available');
      else
         set(hintHndl,'Enable','on');
         set(textHndl,'String',strcat(num2str(nhints),' hints available'));
      end
   else
      set(textHndl,'String','Ready');    
   end
   if all(all(field~=0))                        % success!
      tmp = findobj('Tag','Sudoku_opt_je');     % joyful ending?
      aux = get(tmp,'Checked');
      if strcmp(aux,'on') 
         load handel
         sound(y(1500:16000),Fs)
      end
      set(textHndl,'String','Success!');
      field = zeros(9,9);
   end
   
elseif strcmp(arg1,'check') %----------------- CHECK -----------------------
   
   [newfd,trace] = solver(field);    
   if isnan(newfd)                              % no solutions
       msgtext = 'No solution exists';
   elseif all(all(newfd~=0))                    % uniquely solvable
          switch length(trace) 
              case 0,          msgtext = 'Solved';
              case {1,2,3,4},  msgtext = 'Uniquely solvable (easy)';
              case {5,6,7,8},  msgtext = 'Uniquely solvable (medium)';
              otherwise        msgtext = 'Uniquely solvable (hard)';
          end  
       else
       msgtext = 'Multiple solutions may exist';
   end
   set(textHndl,'String',msgtext);

elseif strcmp(arg1,'set') %---------------- SET OPTIONS --------------------
   
   if strcmp(arg2,'statusmsg')
       tmp = findobj('Tag','Sudoku_opt_ss');
       aux = get(tmp,'Checked');
       if strcmp(aux,'on') 
           set(tmp,'Checked','off');
           set(textHndl,'Visible','off');
           set(chckHndl,'Visible','off');
       else
           set(tmp,'Checked','on');
           set(textHndl,'Visible','on');
           set(chckHndl,'Visible','on');
       end
   elseif strcmp(arg2,'showhints')
       tmp = findobj('Tag','Sudoku_opt_sh');
       aux = get(tmp,'Checked');
       if strcmp(aux,'on') 
           set(tmp,'Checked','off');
           set(hintHndl,'Visible','off');
       else
           set(tmp,'Checked','on');
           set(hintHndl,'Visible','on');
       end
   elseif strcmp(arg2,'joyfulend')
       tmp = findobj('Tag','Sudoku_opt_je');
       aux = get(tmp,'Checked');
       if strcmp(aux,'on') 
           set(tmp,'Checked','off');
       else
           set(tmp,'Checked','on');
       end
   end
   sudoku_lite('redraw');

end % if strcmp(arg1,'start')

% auxiliary functions: SOLVER -------------------------------------------------

function [newfd,trace] = solver(field);
% explores solvability of given field

trace = [];
hints = hintsavailable(field);      
nhnts = sum(sum(hints~=0));
newfd = field + hints;
while (nhnts > 0) & (~isnan(hints))
    trace = [trace nhnts];
    hints = hintsavailable(newfd);       
    nhnts = sum(sum(hints~=0));
    newfd = newfd + hints;
end

%  auxiliary functions: HINTSAVAILABLE ----------------------------------------

function hints = hintsavailable(field)
% Compute hints for given field
% if (no solution exists) then hints = NaN
%                         else hints = computed hints 
   
   hints = zeros(9,9);
   if all(all(field~=0)) | all(all(field==0)), return, end    
 
   fld3D = ones(9,9,9);                     % build up internal representation
   [I,J,V] = find(field);
   for i = 1:length(V)
       ii = I(i);
       jj = J(i);
       vv = V(i);
       fld3D(ii,jj,:) = 0;
       fld3D(:,jj,vv) = 0;
       fld3D(ii,:,vv) = 0;
       is = 1 + 3*fix((ii-1)/3);
       js = 1 + 3*fix((jj-1)/3);
       fld3D(is:is+2,js:js+2,vv) = 0;
       fld3D(ii,jj,vv) = -1;                % tag entry as marked
   end
   
   for i = 1:9                              % Check if not solvable
       if any(any(sum(fld3D(i,:,:),2) == 0))
           hints = NaN; return 
       end 
       if any(any(sum(fld3D(:,i,:),1) == 0))
           hints = NaN; return 
       end 
       is = 1+3*fix((i-1)/3);                  
       js = 1+3*mod(i-1,3);
       if any(sum(sum(fld3D(is:is+2,js:js+2,:),1),2) == 0)
           hints = NaN; return 
       end 
   end

% Hints are computed by two strategies
% that are applied in parallel on the given field
% None of them is more powerful than the other
       
% The first strategy tries to answer the question
% "What number can occupy that position in the field?"
% If the answer is unique, the found number is hinted there
   
   [I,J] = find(sum(fld3D,3) == 1);
   for i = 1:length(I)
       hints(I(i),J(i)) = find(fld3D(I(i),J(i),:));
   end
   
% The second strategy is like asking
% "Where number N can go within this row (or column, or block)?"
% If the answer is unique, N is hinted in the found position
   
   for i = 1:9
       V = find(sum(fld3D(i,:,:),2) == 1);  % check rows
       for j = 1:length(V)
           I = find(fld3D(i,:,V(j)));
           if all(hints(i,I) == 0 | hints(i,I) == V(j))
               hints(i,I) = V(j);
           else
               hints = NaN; return          % attempts to make different hints
           end
       end
       V = find(sum(fld3D(:,i,:),1) == 1);  % check columns
       for j = 1:length(V)
           I = find(fld3D(:,i,V(j)));
           if all(hints(I,i) == 0 | hints(I,i) == V(j))  
               hints(I,i) = V(j);
           else
               hints = NaN; return          % attempts to make different hints
           end
       end
       is = 1+3*fix((i-1)/3);               % check blocks
       js = 1+3*mod(i-1,3);
       [I,V] = find(sum(sum(fld3D(is:is+2,js:js+2,:),1),2) == 1);
       for j = 1:length(V)
           [I,J] = find(fld3D(is:is+2,js:js+2,V(j)));
           if all(all(hints(is+I-1,js+J-1) == 0 | ...
                      hints(is+I-1,js+J-1) == V(j)))
               hints(is+I-1,js+J-1) = V(j);
           else
               hints = NaN; return          % attempts to make different hints
           end
      end
   end

% auxiliary functions: PATTERN ------------------------------------------------

function pattern = pattern(shown,symmetry);
pattern = shown;
switch symmetry
	case 'cross'
        pattern = pattern | pattern';
        pattern = pattern | rot90(pattern,2)';
	case '2axes'
        pattern = pattern | flipud(pattern);
        pattern = pattern | fliplr(pattern);
	case 'rot90'
        pattern = pattern | rot90(pattern);
        pattern = pattern | rot90(pattern,2);
	case 'rot180'
        pattern = pattern | rot90(pattern,2);
	case 'skew'
        pattern = pattern | pattern';
	case 'diag'
        pattern = pattern | rot90(pattern,2)';
	otherwise                               % nonsymmetric pattern
end
