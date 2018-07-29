function a = openparwin(win)

koll = findobj('name',win);
if isempty(koll),
   switch win
   case 'Heat Transfer Parameters', guiparht;
   case 'Simulator Parameters', guipar;
   end
else
	figure(koll)
end

