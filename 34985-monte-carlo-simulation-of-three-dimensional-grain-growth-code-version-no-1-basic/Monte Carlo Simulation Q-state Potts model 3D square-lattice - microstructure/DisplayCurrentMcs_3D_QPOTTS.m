display('- - - - - - - - - - - - -')
if mcs==1
    fprintf('Solving [%d] st MC Step \n',mcs);
elseif mcs==2
    fprintf('Solving [%d] nd MC Step \n',mcs);
elseif mcs==3
    fprintf('Solving [%d] rd MC Step \n',mcs);
else
    fprintf('Solving [%d] th MC Step \n',mcs);
end
% display('Calculating Del(E)')