function res = calc_pot_values(w)
%
%calculate potential values for non obstacle and foal locations in given world
%
r = size(w,1);
c = size(w,2);
for t = size(w,3):-1:1
    for x = 1:r
        for y = 1:c
            if w(x,y,t) == -1
                n = w(x,y,t+1);
                if x ~= 1
                    n = n + w(x-1,y,t+1);
                else
                    n = n + 1;% boundary condition
                end
                if x ~= r
                    n = n + w(x+1,y,t+1);
                else
                    n = n + 1;
                end
                if y ~= 1
                    n = n + w(x,y-1,t+1);
                else
                    n = n + 1;
                end
                if y ~= c
                    n = n + w(x,y+1,t+1);
                else
                    n = n + 1;
                end
                w(x,y,t) = n / 5;% take average of neighbors
            end
        end
    end
end
res = w;
end
