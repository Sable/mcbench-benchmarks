function ret = drawBayesGauss2D(mu,c,prProb,ax)
%	Draw Bayes classification results for 2D Gaussian distributions.
%	mu:		2-by-N, mean vector for N classes.
%	c:		2-by-2-by-N, cov matrices.
%	prProb:	1-by-N, prior probabilities.
%	ax:		[xmin xmax ymin ymax], plotting ranges.
%	ret:	If a return value is required, it will be a 1-by-N cell array
%		containing N function_handles of N posterior probabilities.
%		You can use ret{i}(X,Y) to get post-prob of class i at (X,Y).
%
%	Yan Ke, THUEE, xjed09@gmail.com, 110413

classNum = length(prProb);
sampleNum = 100; % for meshgrid
dx = (ax(2)-ax(1))/sampleNum;
dy = (ax(4)-ax(3))/sampleNum;
[X Y] = meshgrid(ax(1):dx:ax(2),ax(3):dy:ax(4));
poProb = zeros(size(X)); % posterior probabilities
log_poProb = -inf(size(X));
classMap = zeros(size(X));
funcs = cell(1,classNum);

for p = 1:classNum
	mu1 = mu(:,p);
	c1 = c(:,:,p);
	c1i = inv(c1);
	funcs{p} = @(X,Y)1/(2*pi*sqrt(det(c1)))*...
		exp(-( ...
		c1i(1)*(X-mu1(1)).^2 + ...
		2*c1i(2)*(X-mu1(1)).*(Y-mu1(2)) + ...
		c1i(4)*(Y-mu1(2)).^2 ...
		)/2) * prProb(p);
	poProb1 = funcs{p}(X,Y);
	poProb(poProb1 > poProb) = poProb1(poProb1 > poProb);
	
	% use log(post-prob) instead of post-prob to compare and get classMap,
	% or if P(wi|x) is very close to zero for each i, we'll get a wrong
	% classMap.
	log_poProb1 = log(prProb(p)) - log(det(c1))/2 - (...
		c1i(1)*(X-mu1(1)).^2 + ...
		2*c1i(2)*(X-mu1(1)).*(Y-mu1(2)) + ...
		c1i(4)*(Y-mu1(2)).^2 ...
		)/2;
	I = (log_poProb1 > log_poProb);
	classMap(I) = p;
	log_poProb(I) = log_poProb1(I);
	

end

% fill different color in diff region
figure,hold on,axis equal,axis(ax)
pcolor(X,Y,classMap), shading flat

% draw the bounding quadratic curve
if classNum == 2 
	mu1 = mu(:,1);	mu2 = mu(:,2);
	c1 = c(:,:,1);	c2 = c(:,:,2);
	c1i = inv(c1);	c2i = inv(c2);
	
	coef2 = -(c1i-c2i)/2;
	coef1 = c1i*mu1-c2i*mu2;
	w10 = -mu1'*c1i*mu1/2 - log(det(c1))/2 + log(prProb(1));
	w20 = -mu2'*c2i*mu2/2 - log(det(c2))/2 + log(prProb(2));
	coef0 = w10-w20;
	
	fq = @(x,y) coef2(1)*x.^2 + 2*coef2(2)*x.*y + coef2(4)*y.^2 + ...
		coef1(1)*x + coef1(2)*y + ...
		coef0;
	h = ezplot(fq,ax);
	set(h,'LineWidth',3);
	
end

% draw a ellipse indicating center and cov of each class
for p = 1:classNum
	mu1 = mu(:,p);
	c1 = c(:,:,p);
	c1i = inv(c1);
	fe = @(x,y) c1i(1)*(x-mu1(1)).^2 + ...
		2*c1i(2)*(x-mu1(1)).*(y-mu1(2)) + c1i(4)*(y-mu1(2)).^2 - 1;
	ezplot(fe,ax); % (X-mu1)'*c1i*(X-mu1) = 1
	text(mu1(1),mu1(2),num2str(p));
end
xlabel('x1'),ylabel('x2')
title('classification result & class scatter,ellipse -> \sigma');

% plot 3D posterior probabilities
figure,axis equal,axis(ax)
surf(X,Y,poProb,classMap/classNum)
xlabel('x1'),ylabel('x2'),zlabel('P(\omega_i)*P(x|\omega_i)'),
title('posterior probability')

if nargout == 1, ret = funcs; end

end
