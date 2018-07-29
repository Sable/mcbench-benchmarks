function h = ccplot(x,y,c,map)
    % CCPLOT Conditionally colored plot
    % 
    %   h = CCPLOT(X,Y,CONDITION,MAP) plots the vector Y versus vector X 
    %   using conditional coloring. CCPLOT maps each value in vector C to a
    %   certain color of the specified colormap MAP. CCPLOT returns handles
    %   to the line objects that can be used to change properties via
    %   set(...)
    %
    %   Examples:
    %       x = linspace(0,4*pi,50);
    %       y = sin(x);
    %       c = y.^2;
    %       map = colormap(jet);
    %       h = ccplot(x,y,c,map);
    %       set(h,'Marker','o');
    
    %   Copyright 2012 Michael Heidingsfeld
    %   $Revision: 1.0 $  $Date: 2012/08/02 15:33:21 $    
    
    if ~(all(size(x) == size(y)) && all(size(x) == size(c)))
        error('Vectors X,Y and C must be the same size');
    end

    N = size(map,1);
    cmax = max(c);
    cmin = min(c);
    cint = (cmax-cmin)/N;
    indices = 1:length(c);
    status = ishold;                % save hold status
    for k = 1:N
        ii = logical(c >= cmin+k*cint) + logical(c <= cmin+(k-1)*cint);
        jj = ones(size(ii)); jj(1:end-1) = ii(2:end);
        ii = logical(ii .* jj);
        X = x; X(indices(ii)) = NaN;
        Y = y; Y(indices(ii)) = NaN;
        h(k) = plot(X,Y,'Color',map(k,:)); 
        hold on;
    end
    if status == 0, hold off; end   % reset hold status
end