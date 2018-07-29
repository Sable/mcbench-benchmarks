function RadiobutHenry
warning('off','MATLAB:dispatcher:InexactMatch')
Hhandle=findobj('Tag','Henry');
H=get(Hhandle,'Value');
mHhandle=findobj('Tag','mHenry');
mH=get(mHhandle,'Value');
if H==1
   mH=0;
   set(Hhandle, 'Value', 1);  set(Hhandle, 'SelectionHighlight', 'On');
   set(mHhandle,'Value', 0);  set(mHhandle, 'SelectionHighlight', 'off');
  else 
  set(Hhandle, 'Value', 0);   set(Hhandle, 'SelectionHighlight', 'off');
   set(mHhandle,'Value', 1);  set(mHhandle, 'SelectionHighlight', 'On');
   mH=1;
end   
