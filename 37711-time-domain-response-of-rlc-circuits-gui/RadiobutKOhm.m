function RadiobutKOhm
warning('off','MATLAB:dispatcher:InexactMatch')
Ohandle=findobj('Tag','Ohm');
O=get(Ohandle,'Value');
KOhandle=findobj('Tag','KOhm');
KO=get(KOhandle,'Value');
if KO==1
   O=0;
   set(KOhandle, 'Value', 1); set(KOhandle, 'SelectionHighlight', 'On');
   set(Ohandle,'Value', 0) ;  set(Ohandle,  'SelectionHighlight', 'Off');
  else 
  set(KOhandle, 'Value', 0); set(KOhandle , 'SelectionHighlight', 'Off');
  set(Ohandle,'Value', 1);  set(Ohandle, 'SelectionHighlight', 'On');
  O=1; 
end   
