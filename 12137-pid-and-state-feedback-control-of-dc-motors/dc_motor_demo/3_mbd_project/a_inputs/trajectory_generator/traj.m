function [t1, t2] = traj(s2, s0, v0, a)

if ((s0-s2) < 0)
    if (v0 <= 0)
        acc = a;
    else
        if ((s0-s2) < (-v0^2/(2*a)))
            acc = a;
        else
            acc = -a;
        end
    end
else % ((s0-s2) >= 0)
%     if (v0 == 0)
%         acc = 0;
%     elseif (v0 > 0)
    if (v0 > 0)
        acc = -a;
        elsel
        if ((s0-s2) > v0^2/(2*a))
            acc = -a;
        else
            acc = a;
        end
    end
end

k = s0-s2+v0^2/(2*acc);

t1 = (-v0 + sign(acc) * sqrt(v0^2-acc*k))/(acc);
t2 = 2*t1 + v0/(acc);

