function gen_curves(rows,cols,density)
%
%generate potential value curves
%
rw = gen_random_obs(rows,cols,density,25);
g2x = [2 5:5:45 50:10:100];
g2y(1:16) = 0;
g1x(1:400) = 0;
g1y(1:400) = 0;
for ri = 1:25
    g1i = ri;
    disp(sprintf('Density = %d%% World Number = %d Lookahead = 2',density,ri))
    [w st_r st_c]= gen_random_world(rows,cols,rw(ri).obs,2);
    p = calc_pot_values(w);
    g1x(g1i) = 2;
    g1y(g1i) = p(st_r,st_c,1);
    g1i = g1i + 25;
    g2y(1) = g2y(1) + p(st_r,st_c,1);
    for la = 5:5:45
        disp(sprintf('Density = %d%% World Number = %d Lookahead = %d',density,ri,la))
        [w st_r st_c]= gen_random_world(rows,cols,rw(ri).obs,la);
        p = calc_pot_values(w);        
        g1x(g1i) = la;
        g1y(g1i) = p(st_r,st_c,1);
        g1i = g1i + 25;
    end
    for la = 50:10:100
        disp(sprintf('Density = %d%% World Number = %d Lookahead = %d',density,ri,la))
        [w st_r st_c]= gen_random_world(rows,cols,rw(ri).obs,la);
        p = calc_pot_values(w);
        g1x(g1i) = la;
        g1y(g1i) = p(st_r,st_c,1);
        g1i = g1i + 25;
    end
end
for i = 1:16
    g2y(i) = mean(g1y((1:25)+25*(i-1)));
end
figure(density)
plot(g1x,g1y,'b.')
hold on
plot(g2x,g2y,'g*-')
set(gca,'xtick',[2 5:5:45 50:10:100])
fign = sprintf('-f%d',density);
fn = sprintf('graph_%d_%d_%d',rows,cols,density);
print(fign,'-djpeg',fn)
hold off
tmp.ptx=g1x;
tmp.pty=g1y;
tmp.cx=g2x;
tmp.cy=g2y;
fn = sprintf('curveset_%d_%d_%d',rows,cols,density);
assignin('base',fn,tmp);
evalin('base',sprintf('save %s.mat %s',fn,fn));
end