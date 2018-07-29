function ezimage(fun)
    
    % make sure the path is OK
    prevpath = path;
    path(path, genpath(fileparts(mfilename('fullpath'))));
    
    % path must be reset, even if something fails; 
    % use TRY-CATCH to accomplish this
    try
    
        % EZIMAGE() takes no input, or a function handle
        if (nargin == 0)
            % available functions
            functions = dir('single-objective');
            functions = cellfun(@(x) x(1:end-2), {functions.name}, 'uniformoutput', false);
            functions = functions(3:end);            
            % show list
            clc
            fprintf(1, 'Single-objective functions:\n');
            for ii = 1:numel(functions)
                fprintf(1, ['[', num2str(ii), '] ', functions{ii}, '\n']);
            end
            fprintf(1, '\n');            
            % select one
            while true
                num = str2double(input('Type the number of the function you wish to plot: ', 's'));                
                if isfinite(num) && (num <= numel(functions)), break, end
            end            
            % set proper function
            evalc(['fun = @', functions{num}]);
            
        else
            % errortrap
            if ~isa(fun, 'function_handle')
                path(prevpath);
                error('ezimage:no_function', ...
                    'Please provide a function handle to the function to plot.');
            end
        end
        
        % evaluate function with no argument to get some
        % info about the function
        [dims, lb, ub, solution, minimum] = feval(fun);
        
        % if the number of dimensions exceeds 3, we can't plot
        if (dims > 2) || ~isfinite(dims) % [inf] means arbitrary # dimensions
            path(prevpath);
            error('ezimage:too_many_dimensions',...
                'Given function requires %d dimensions to be plotted, and we live in a 3-D world.', dims+1);
        end
        
        % initialize
        x1 = linspace(lb(1), ub(1), 100);
        x2 = linspace(lb(2), ub(2), 100);
        x3 = zeros(length(x1), length(x2));
        
        % simply loop through the function (most functions expect 
        % [N x 2] vectors as input, so meshgrid does not work)
        for i = 1:length(x1)
            for j = 1:length(x2)
                x3(i, j) = fun([x1(i), x2(j)]);
            end
        end
        
        % build simple grid for axes
        [x1, x2] = meshgrid(x1, x2);
        
        % draw surface
        figure, hold on
        surf(x1', x2', x3, 'Linestyle', 'none')
        
        % draw minima
        plot3(solution(:,1), solution(:,2), repmat(minimum, size(solution,1), 1), ...
            'r.', 'MarkerSize', 20)
        
        % tiles, labels, legend
        xlabel('x_1'), ylabel('x_2'), zlabel('F(x_1, x_2)')
        if (size(solution,1) > 1)
            legend([func2str(fun), '-function'], 'Global Minima')
        else
            legend([func2str(fun), '-function'], 'Global Minimum')
        end
        
        % finalize
        view(-40, 30)
    
    % something's wrong
    catch ME
        % reset previous path
        path(prevpath);
        % and throw error
        rethrow(ME)
    end
    
    % reset previous path
    path(prevpath);
    
end