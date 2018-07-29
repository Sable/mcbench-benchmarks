function window
global holdon

if (holdon) holdon= 0; else holdon= 1; end
if strcmp(get(gcbo, 'Checked'),'on')
    set(gcbo, 'Checked', 'off');
else 
    set(gcbo, 'Checked', 'on');
end
return
