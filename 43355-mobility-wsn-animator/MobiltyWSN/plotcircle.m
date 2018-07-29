
function plotcircle(Column,Row,Radius,Color)


if (Color ~='b') && (Color ~='g') && (Color ~= 'r') && (Color ~='c') && (Color ~='m') && (Color ~='y') && (Color ~='k') && (Color ~='w')
    error('This is not an available color, Please use help PlotCircle to choose an appropriate color');
end

hold on

t = -pi:pi/64:pi;

x=Radius*cos(t)+Column;
y=Radius*sin(t)+Row;
plot(x,y,Color);