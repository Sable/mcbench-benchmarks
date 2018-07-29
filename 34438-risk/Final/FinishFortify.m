function FinishFortify(s,~,troops)

if get(troops, 'UserData') ~= 0
    uiwait(msgbox('There still are troops on the move!'))
else
    uiresume(get(s, 'Parent'))
end