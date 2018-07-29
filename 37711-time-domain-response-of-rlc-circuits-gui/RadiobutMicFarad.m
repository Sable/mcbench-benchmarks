function RadiobutMicFarad
warning('off','MATLAB:dispatcher:InexactMatch')
Fhandle=findobj('Tag','Farad');
F=get(Fhandle,'Value');
micFhandle=findobj('Tag','micFarad');
micF=get(micFhandle,'Value');
if micF==1
   F=0;
   set(micFhandle, 'Value', 1);  set(micFhandle, 'SelectionHighlight', 'On');
   set(Fhandle,'Value', 0);      set(Fhandle, 'SelectionHighlight', 'Off');
  else 
  set(micFhandle, 'Value', 0);   set(micFhandle, 'SelectionHighlight', 'Off');
   set(Fhandle,'Value', 1);      set(Fhandle, 'SelectionHighlight', 'On');
   F=1;
end   
