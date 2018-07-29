a1 = 2; a2 = 1.5;
options = optimset('LargeScale','off');
x = fminconSym(@(x)myfun0(x,a1),[1;2],[],[],[],[],[],[],@(x)mycon(x,a2),options);
