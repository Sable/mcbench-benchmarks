disp('make some variables...')
x = 2.3
y = rand(4, 3, 2)
z = 'durp durp durp'

disp('import the matlab module')
pymex('import matlab')

disp('"pull" the variables from matlab to python')
pymex('x, y, z = matlab.pull("x", "y", "z")')

disp('print the variables as seen by python')
pymex('matlab.mex_print(x, y, z)')

disp('"push" the variables from python to matlab')
pymex('matlab.push("x2", x, "y2", y, "z2", z)')

disp('test that y is equal to y2')
y == y2
