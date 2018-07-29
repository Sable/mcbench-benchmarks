function print_char(word,init)
   % simple print routine for psk31 receiver
   % Copyright 2002-2010 The MathWorks, Inc.
   persistent char_table;
   persistent htxt;
   persistent last_char;
   persistent new_line;
   % initialize if nargin ==2
   if nargin==2
      char_table=word;  % The input variable "word" contains 
                        % a lookup table when this routine is 
                        % initialized.
      if isempty(findobj('tag','rcv_1_text'))
          figure('position',[5 25 400 200],'menu','none','tag','rcv_1_text',...
                'name','PSK31  Rcv Output','numbertitle','off');
          htxt=uicontrol('style','text','value',100,...
                           'units','pixels','position',[5,20,395 170],...
                           'horizontalalignment','left','backgroundcolor',[0 0 0],...
                            'foregroundcolor',[0 1 0],...
                            'FontName', 'Arial',...
                            'FontSize', 12,...
                            'FontWeight','bold');
                   
	
	
                        
                        
      end;
      
      set(htxt,'string',''); drawnow;
      new_line=0;
      return
   end;
   s=get(htxt,'string');
   if (new_line > 8) | (length(s) > 8*30)
       s='';  % clear print area 
       new_line=0;
   end;
   
   if word <= length(char_table)
      try 
        last_char=char_table(word);
        if  last_char==char(13)
            new_line=new_line+1; 
        end;
        if  last_char==char(10) 
            last_char=char(13); 
            new_line=new_line+1; 
        end;
        set(htxt,'string',[s,last_char]);
        
      catch
        % debugging, when  things go bad .....
        % looks like the LF character can add a dimension 
        % to the character string.
        [size(s),size(char_table(word))]
        last_char
        abs(last_char)
      end
   else
      set(htxt,'string',[s,'?^?']); % display this when 
                                      % the "word" (character) clearly 
                                      % does not make sense
   end;
