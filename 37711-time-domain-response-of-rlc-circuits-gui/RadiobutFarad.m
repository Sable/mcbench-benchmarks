function RadiobutFarad
warning('off','MATLAB:dispatcher:InexactMatch')
Fhandle=findobj('Tag','Farad');
F=get(Fhandle,'Value');
micFhandle=findobj('Tag','micFarad');
micF=get(micFhandle,'Value');
if F==1
   micF=0;
   set(Fhandle, 'Value', 1);   set(Fhandle, 'SelectionHighlight', 'On');
   set(micFhandle,'Value', 0); set(micFhandle, 'SelectionHighlight', 'Off');
  else 
  set(Fhandle, 'Value', 0);    set(Fhandle, 'SelectionHighlight', 'Off');
  set(micFhandle,'Value', 1);  set(micFhandle, 'SelectionHighlight', 'On');
   micF=1;
end   
