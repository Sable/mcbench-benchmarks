% Specify training parameters
ntrain = 15*15;
epsilon=0.000025;
c=40000;

% Set up training data
[X, Y] = meshgrid(linspace(-2,2,15),linspace(-2,2,15));
X = X + rand(15,15)*4/15;
Y = Y + rand(15,15)*4/15;

z = sin(0.5*X + Y.^2).*cos(X) ;

xdata = [reshape(X,ntrain,1) reshape(Y,ntrain,1)]';
ydata = [reshape(z,ntrain,1)]';

% Train the SVR
[~, alpha0,b0] = svr(xdata,ydata,[],[],[],c,epsilon);

% Evaluate the SVR model at new input values
[X1, Y1] = meshgrid(linspace(-2,2,15),linspace(-2,2,15));
for x=1:15
    for y=1:15
        z1(x,y) = svr(xdata,[],[X1(1,x) Y1(y,1)]',alpha0,b0,[],[]);
    end
end

% Plot the result
surf(Y,X,z); hold on
surf(X1,Y1,z1)