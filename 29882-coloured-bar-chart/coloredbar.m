function h = coloredbar( x, labels, colors, varargin )
%Coloredbar - create a bar chart with passed in colours
%   x - vector of values for bar heights
%   labels - vector of strings for bar labels
%   colors - vector of color specs for bar colours
%   ... - additional value argument paris for bar chart
%  
% Returns: handle to bar object
%
    if(~isvector(x))
        error('coloredbar currently only accepts single series\n');
    end
    for ii = length(x):-1:1
        h = bar(x(1:ii), 'FaceColor', colors{ii});
        hold on;
    end
    
    set(gca, 'xticklabel', labels);
    
    for ii = 1:2:size(varagin, 2)
        set(h, varargin{ii}, varargin{ii+1});
    end

end

