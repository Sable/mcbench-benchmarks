function planner(rows,cols,obs,start,goal)
%
% path planner simulator
%
density = size(obs,2)/(rows*cols);% find obstacle density
ndensity = 9;
for d = 9:10:89
    if d <= density
        ndensity = d;
    else
        break;
    end
end
csetname = sprintf('curveset_%d_%d_%d',rows,cols,ndensity);
if(evalin('base',sprintf('exist(''%s'',''var'')',csetname))==0)% try to load curveset from matlab runtime memory
    if(evalin('base',sprintf('exist(''%s.mat'',''file'')',csetname))==0)% try to load curveset from hard drive
        disp('Generating curve set');
        evalin('base',sprintf('gen_curves(%d,%d,%d)',rows,cols,ndensity));% generate curveset
    else
        disp('Loading curve set from file');
        evalin('base',sprintf('load %s.mat',csetname));
    end
    curveset = evalin('base', csetname);
else
    disp('Loading curve set from memory');
    curveset = evalin('base', csetname);
end
clear csetname;
sol1 = forward_chain(rows,cols,obs,goal,start,100);% find time to reach shallowest solution
if (sol1 == -1)
    disp('Run program after reloading world');% Dynamics changed
    return;
end
la = find_good_la(rows,cols,obs,goal,start,sol1,curveset);% estimate lookahead to use
world = extend_world(rows,cols,obs,goal,la);% extend world in time
pot_vals = calc_pot_values(world);% Calculate potential values
[res path] = traverse_world(start,pot_vals);% Follow negative potential gradient
if (res == 0)
    disp('Run program after reloading world');% Dynamics changed or Goal became unreachable
    return;
end
show_path(world,path)% display path traversed
end