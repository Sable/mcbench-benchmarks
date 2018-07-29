function RadiobutmHenry
warning('off','MATLAB:dispatcher:InexactMatch')
Hhandle=findobj('Tag','Henry');
H=get(Hhandle,'Value');
mHhandle=findobj('Tag','mHenry');
mH=get(mHhandle,'Value');
if mH==1
   H=0;
   set(mHhandle, 'Value', 1);  set(mHhandle, 'SelectionHighlight', 'On');
   set(Hhandle,'Value', 0);    set(Hhandle, 'SelectionHighlight', 'Off');
  else 
  set(mHhandle, 'Value', 0);   set(mHhandle, 'SelectionHighlight', 'Off');
   set(Hhandle,'Value', 1);    set(Hhandle, 'SelectionHighlight', 'On');
   H=1;
end   
