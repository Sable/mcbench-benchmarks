function [X,Y] = catenary(a,b,r_length,N,sagInit)
% given two points a=[ax ay] and b=[bx by] in the vertical plane,
% rope length r_length, and the number of intermediate points N,
% outputs the coordinates X and Y of the hanging rope from a to b
% the optional input sagInit initializes the sag parameter for the
% root-finding procedure.

maxIter	= 100;       % maximum number of iterations
minGrad	= 1e-10;     % minimum norm of gradient
minVal	= 1e-8;      % minimum norm of sag function
stepDec	= 0.5;       % factor for decreasing stepsize
minStep	= 1e-9;		 % minimum step size
minHoriz	= 1e-3;		 % minumum horizontal distance

if nargin < 5
	sag = 1;
else
	sag = sagInit;
end

if a(1) > b(1)
	[a,b]	= deal(b,a);
end

d = b(1)-a(1);
h = b(2)-a(2);


if abs(d) < minHoriz % almost perfectly vertical
	X = ones(1,N)*(a(1)+b(1))/2;
	if r_length < abs(h) % rope is stretched
		Y		= linspace(a(2),b(2),N);
	else
		sag	= (r_length-abs(h))/2;
		n_sag = ceil( N * sag/r_length );
		y_max = max(a(2),b(2));
		y_min = min(a(2),b(2));
		Y		= linspace(y_max,y_min-sag,N-n_sag);
		Y		= [Y linspace(y_min-sag,y_min,n_sag)];
	end
	return;
end

X = linspace(a(1),b(1),N);

if r_length <= sqrt(d^2+h^2) % rope is stretched: straight line
	Y = linspace(a(2),b(2),N);
	
else
	% find rope sag
	g  = @(s) 2*sinh(s*d/2)/s - sqrt(r_length^2-h^2);
	dg = @(s) 2*cosh(s*d/2)*d/(2*s) - 2*sinh(s*d/2)/(s^2);

	for iter = 1:maxIter
		val		= g(sag); 
		grad		= dg(sag);
		if abs(val) < minVal || abs(grad) < minGrad
			break
		end
		search	= -g(sag)/dg(sag);
		
		alpha		= 1;
		sag_new  = sag + alpha*search;
		
		while sag_new < 0 || abs(g(sag_new)) > abs(val)
			alpha		= stepDec*alpha;
			if alpha < minStep
				break;
			end
			sag_new	= sag + alpha*search;			
		end
		
		sag = sag_new;
	end

	% get location of rope minimum and vertical bias
	x_left	= 1/2*(log((r_length+h)/(r_length-h))/sag-d);
	x_min		= a(1) - x_left;
	bias		= a(2) - cosh(x_left*sag)/sag;

	Y			= cosh((X-x_min)*sag)/sag + bias;
end