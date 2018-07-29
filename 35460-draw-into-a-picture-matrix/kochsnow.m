function varargout = kochsnow(iters,varargin)
% varargout = kochsnow(iters,varargin)
% makes a picture of the Koch snowflake(utilizing draw_bndry and draw_circ)
% made of code from http://www.mathworks.de/matlabcentral/newsreader/view_thread/138798
% credits for the snowflake calculation go to Maarten van Reeuwijk
% varargin examples:
% varargin = 'm', m
% varargin = 'save', 'kochsnow%.bmp'  % is replaced by iters
% varargin = 'show', false
% varargout:
% can be called with one or no argument as an output

    angle = [0, -2/3*pi, -2/3*pi];
    l = 1; m = 1024;
    fileout = false;
    show = true;
    
    % varargin
    j = 1;
    while j <= nargin-1
        switch varargin{j}
            case 'm'
                m = varargin{j+1}; j = j+2;
            case 'save'
                fileout = varargin{j+1}; 
                incliters = strfind(fileout,'%');
                sz = size(incliters,2);
                for i = sz:-1:1
                    fileout = strcat(fileout(1:incliters(i)-1), num2str(iters), fileout(incliters(i)+1:end));
                end
                extout = fileout(end-2:end);
                j = j+2;
            case 'show'
                show = varargin{j+1}; j = j+2;
            otherwise
                error('Argument not acceptable!');
        end
    end
    
    % snowflake calculation by Maarten van Reeuwijk
    for i=1:iters
        l = l/3;
        angle1 = zeros([4*length(angle),1]);
        for j=1:length(angle)
          angle1(4*j-3:4*j) = [angle(j), pi/3, -2*pi/3, pi/3];
        end
        angle = angle1;
    end

    x = zeros([length(angle)+1, 1]);
    y = zeros([length(angle)+1, 1]);

    x(1) = 0; y(1) = 0;
    phi=0;
    for i=1:length(angle);
        phi = phi+angle(i);
        x(i+1) = x(i) + l * cos(phi);
        y(i+1) = y(i) + l * sin(phi);
    end
    % end of snowflake calculation by Maarten van Reeuwijk
 
    I = false(m*(max(y)-min(y)),m);
    x = (x+min(x))*m; y = (y-min(y))*m;
    I = draw_clline(I, [y,x], 1, 0);
    I = imfill(I,sub2ind(size(I),m/2,m/2),4);
    
    if show == true, imshow(I,'Border','tight'); end
    if fileout ~= false
        imwrite(I,fileout, extout);
    end
    if nargout == 1, varargout = {I}; end
end