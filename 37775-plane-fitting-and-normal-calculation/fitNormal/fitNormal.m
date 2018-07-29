function n = fitNormal(data, show_graph)
%FITNORMAL - Fit a plane to the set of coordinates
%
%For a passed list of points in (x,y,z) cartesian coordinates,
%find the plane that best fits the data, the unit vector
%normal to that plane with an initial point at the average
%of the x, y, and z values.
%
% :param data: Matrix composed of of N sets of (x,y,z) coordinates
%              with dimensions Nx3
% :type data: Nx3 matrix
%
% :param show_graph: Option to display plot the result (default false)
% :type show_graph: logical
%
% :return n: Unit vector that is normal to the fit plane
% :type n: 3x1 vector
	
	if nargin == 1
		show_graph = false;
	end
	
	for i = 1:3
		X = data;
		X(:,i) = 1;
		
		X_m = X' * X;
		if det(X_m) == 0
			can_solve(i) = 0;
			continue
		end
		can_solve(i) = 1;
		
		% Construct and normalize the normal vector
		coeff = (X_m)^-1 * X' * data(:,i);
		c_neg = -coeff;
		c_neg(i) = 1;
		coeff(i) = 1;
		n(:,i) = c_neg / norm(coeff);
		
	end
	
	if sum(can_solve) == 0
		error('Planar fit to the data caused a singular matrix.')
		return
	end
	
	% Calculating residuals for each fit
	center = mean(data);
	off_center = [data(:,1)-center(1) data(:,2)-center(2) data(:,3)-center(3)];
	for i = 1:3
		if can_solve(i) == 0
			residual_sum(i) = NaN;
			continue
		end
		
		residuals = off_center * n(:,i);
		residual_sum(i) = sum(residuals .* residuals);
		
	end
	
	% Find the lowest residual index
	best_fit = find(residual_sum == min(residual_sum));
	
	% Possible that equal mins so just use the first index found
	n = n(:,best_fit(1));
	
	if ~show_graph
		return
	end
	
	range = max(max(data) - min(data)) / 2;
	mid_pt = (max(data) - min(data)) / 2 + min(data);
	xlim = [-1 1]*range + mid_pt(1);
	ylim = [-1 1]*range + mid_pt(2);
	zlim = [-1 1]*range + mid_pt(3);

	L=plot3(data(:,1),data(:,2),data(:,3),'ro','Markerfacecolor','r'); % Plot the original data points
	hold on;
	set(get(L, 'Parent'),'DataAspectRatio',[1 1 1],'XLim',xlim,'YLim',ylim,'ZLim',zlim);
	
	norm_data = [mean(data); mean(data) + (n' * range)];
	
	% Plot the original data points
	L=plot3(norm_data(:,1),norm_data(:,2),norm_data(:,3),'b-','LineWidth',3);
	set(get(get(L,'parent'),'XLabel'),'String','x','FontSize',14,'FontWeight','bold')
	set(get(get(L,'parent'),'YLabel'),'String','y','FontSize',14,'FontWeight','bold')
	set(get(get(L,'parent'),'ZLabel'),'String','z','FontSize',14,'FontWeight','bold')
	title(sprintf('Normal Vector: <%0.3f, %0.3f, %0.3f>',n),'FontWeight','bold','FontSize',14)
	grid on;
	axis square;
	hold off;
end
