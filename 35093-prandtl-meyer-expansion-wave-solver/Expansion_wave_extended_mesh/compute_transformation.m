function [Updated_Grid] = compute_transformation(i,Grid,H,E,Theta)
if (Grid.x(i) < E)
    Grid.y_s(i) = 0;
    Grid.h(i) = H;   
else
    Grid.y_s(i) = (-Grid.x(i)*tan(Theta)) + (E*tan(Theta));
    Grid.h(i) = H + (Grid.x(i)*tan(Theta)) - (E*tan(Theta));
end
for j = 1:401,
    if (Grid.x(i) < E)
        Grid.m1(j,i) = 0;
    else
        Grid.m1(j,i) = (tan(Theta)/Grid.h(i)) - (Grid.y_t(j)*(tan(Theta)/Grid.h(i)));
    end
    Grid.y(j,i) = (Grid.y_t(j)*Grid.h(i)) + Grid.y_s(i);
    Grid.m2(j,i) = 1/Grid.h(i);
end
Updated_Grid = Grid;
end