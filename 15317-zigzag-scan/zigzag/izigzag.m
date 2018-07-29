% Inverse zigzag scan of a matrix
% Arguments are: a 1-by-m*n array, 
% where m & n are vertical & horizontal sizes of an output matrix.
% Function returns a two-dimensional matrix of defined sizes,
% consisting of input array items gathered by a zigzag method.
%
% Alexey S. Sokolov a.k.a. nICKEL, Moscow, Russia
% June 2007
% alex.nickel@gmail.com

function output = izigzag(in, vmax, hmax)

% initializing the variables
%----------------------------------
h = 1;
v = 1;

vmin = 1;
hmin = 1;

output = zeros(vmax, hmax);

i = 1;
%----------------------------------

while ((v <= vmax) & (h <= hmax))

    if (mod(h + v, 2) == 0)                % going up

        if (v == vmin)
            output(v, h) = in(i);

            if (h == hmax)
	      v = v + 1;
	    else
              h = h + 1;
            end;

            i = i + 1;

        elseif ((h == hmax) & (v < vmax))
            output(v, h) = in(i);
            i;
            v = v + 1;
            i = i + 1;

        elseif ((v > vmin) & (h < hmax))
            output(v, h) = in(i);
            v = v - 1;
            h = h + 1;
            i = i + 1;
        end;
        
    else                                   % going down

       if ((v == vmax) & (h <= hmax))
            output(v, h) = in(i);
            h = h + 1;
            i = i + 1;
        
       elseif (h == hmin)
            output(v, h) = in(i);

            if (v == vmax)
	      h = h + 1;
	    else
              v = v + 1;
            end;

            i = i + 1;

       elseif ((v < vmax) & (h > hmin))
            output(v, h) = in(i);
            v = v + 1;
            h = h - 1;
            i = i + 1;
        end;

    end;

    if ((v == vmax) & (h == hmax))
        output(v, h) = in(i);
        break
    end;

end;