% TODO : to be vectorised
% F. Andrianasy, Ven13Aug2010, 20h37

function abc = to_ABC(xy)
    x = xy(1);
    y = xy(2);
   
    b = y/sin(pi/3);
    a = 100 - (x + b*cos(pi/3));
    c = 100 - (a + b);
    abc = [a b c]';
 end
