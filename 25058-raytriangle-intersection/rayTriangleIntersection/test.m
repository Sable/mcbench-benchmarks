% TEST:  Ray/triangle intersection using the algorithm proposed by Möller and Trumbore (1997).

v0 = [10,0,0];
v1 = [0,10,0];
v2 = [0,0,10];
origin = [10 10 10];
direction = -[0.3 0.5 0.7];

triangle = [v0; v1; v2];
[flag, u, v, t] = rayTriangleIntersection(origin, direction, v0, v1, v2);
intersection = origin + t*direction;

figure;
hold on;
grid on;

	% triangle
	trisurf([1 2 3],triangle(:,1), triangle(:,2), triangle(:,3),'FaceColor','green','EdgeColor','none');

	% origin
	text(origin(1), origin(2), origin(3), 'origin');
	plot3(origin(1), origin(2), origin(3), 'k.', 'MarkerSize', 15);

	% direction
	quiver3(origin(1), origin(2), origin(3), direction(1), direction(2), direction(3), 15);

	% intersection 
	plot3(intersection(1), intersection(2), intersection(3), 'r.', 'MarkerSize', 15);

	view(60,30);
	alpha(0.5);
 	axis tight;
	xlabel('x');
	ylabel('y');
	zlabel('z');
