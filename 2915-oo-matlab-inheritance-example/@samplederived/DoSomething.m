function a=DoSomething(c,s)
% samplederived/DoSomething

b=DoSomething(c.samplebase);
if exist('s')
	a='samplederived/DoSomething1';
else
	a='samplederived/DoSomething2';
end
