%Function to integrate to calculate the area of a figure
function partieaire = functionviewfactorarea(t)


%Global variables: pt1 to pt2 are the points that define the segment to integrate, normale is the unit normal vector.
global pt1;
global pt2;
global normale;

%Parametric equations of the segment that join pt1 to pt2
x=pt1(1)+(pt2(1)-pt1(1)).*t;
y=pt1(2)+(pt2(2)-pt1(2)).*t;
z=pt1(3)+(pt2(3)-pt1(3)).*t;

%Function to integrate to calculate the area of a figure
partieaire=normale(2).*z.*(pt2(1)-pt1(1))+normale(3).*x.*(pt2(2)-pt1(2))+normale(1).*y.*(pt2(3)-pt1(3));
