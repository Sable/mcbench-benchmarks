% Zigzag scan of a matrix
% Argument is a two-dimensional matrix of any size,
% not strictly a square one.
% Function returns a 1-by-(m*n) array,
% where m and n are sizes of an input matrix,
% consisting of its items scanned by a zigzag method.
%
% Alexey S. Sokolov a.k.a. nICKEL, Moscow, Russia
% June 2007
% alex.nickel@gmail.com

function output = zigzag(in)

% initializing the variables
%----------------------------------
h = 1;
v = 1;

vmin = 1;
hmin = 1;

vmax = size(in, 1);
hmax = size(in, 2);

i = 1;

output = zeros(1, vmax * hmax);
%----------------------------------

while ((v <= vmax) & (h <= hmax))
    
    if (mod(h + v, 2) == 0)                 % going up

        if (v == vmin)       
            output(i) = in(v, h);        % if we got to the first line

            if (h == hmax)
	      v = v + 1;
	    else
              h = h + 1;
            end;

            i = i + 1;

        elseif ((h == hmax) & (v < vmax))   % if we got to the last column
            output(i) = in(v, h);
            v = v + 1;
            i = i + 1;

        elseif ((v > vmin) & (h < hmax))    % all other cases
            output(i) = in(v, h);
            v = v - 1;
            h = h + 1;
            i = i + 1;
     end;
        
    else                                    % going down

       if ((v == vmax) & (h <= hmax))       % if we got to the last line
            output(i) = in(v, h);
            h = h + 1;
            i = i + 1;
        
       elseif (h == hmin)                   % if we got to the first column
            output(i) = in(v, h);

            if (v == vmax)
	      h = h + 1;
	    else
              v = v + 1;
            end;

            i = i + 1;

       elseif ((v < vmax) & (h > hmin))     % all other cases
            output(i) = in(v, h);
            v = v + 1;
            h = h - 1;
            i = i + 1;
        end;

    end;

    if ((v == vmax) & (h == hmax))          % bottom right element
        output(i) = in(v, h);
        break
    end;

end;