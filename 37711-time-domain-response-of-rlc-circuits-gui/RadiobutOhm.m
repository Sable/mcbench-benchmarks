function Radiobut
warning('off','MATLAB:dispatcher:InexactMatch')
Ohandle=findobj('Tag','Ohm');
O=get(Ohandle,'Value');
KOhandle=findobj('Tag','KOhm');
KO=get(KOhandle,'Value');
if O==1
   KO=0;
   set(Ohandle, 'Value', 1);   set(Ohandle, 'SelectionHighlight', 'On');
   set(KOhandle, 'Value', 0);  set(KOhandle, 'SelectionHighlight', 'off');
   %set(Ohandle, 'Value', 1, gca, 'Box', 'On')
   %set(KOhandle,'Value', 0, gca, 'Box', 'Off')
  else 
   set(Ohandle, 'Value', 0);   set(Ohandle, 'SelectionHighlight', 'off');
   set(KOhandle, 'Value', 1);  set(KOhandle, 'SelectionHighlight', 'On');
   %set(Ohandle, 'Value', 0, gca, 'Box', 'Off')
   %set(KOhandle,'Value', 1, gca, 'Box', 'On')
end   
