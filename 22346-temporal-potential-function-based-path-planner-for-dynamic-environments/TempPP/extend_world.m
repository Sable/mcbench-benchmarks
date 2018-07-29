function world = extend_world(rows,cols,obs,goal,lookahead)
%
%extends the world to the given look-ahead
%
%intialize world
w (1:rows,1:cols,1:lookahead)=-1;
%initialize loo-ahead boundary
w (:,:,lookahead+1) = 1;
%extrapolate obstacle positons
for i = 1:length(obs)
    tr = obs(i).r;
    tc = obs(i).c;
    tv = obs(i).vel;
    w(tr,tc,1) = 1;
    for j = 1:lookahead-1
        switch obs(i).dir
            case 'N'
                tr = round(tr - tv);
                if tr < 1 
                    tr = 1 + (tr * -1);
                    obs(i).dir = 'S';
                end
            case 'E'
                tc = round(tc + tv);
                if tc > cols
                    tc = cols - (tc - cols);
                    obs(i).dir = 'W';
                end               
            case 'S'
                tr = round(tr + tv);
                if tr > rows
                    tr = rows - (tr - rows);
                    obs(i).dir = 'N';
                end
            case 'W'
                tc = round(tc - tv);
                if tc < 1 
                    tc = 1 + (tc * -1);
                    obs(i).dir = 'E';
                end
            otherwise
                disp('Not Supported')
        end
        if (w(tr,tc,j+1) == 1)
            switch obs(i).dir
                case 'N'
                    tr = tr + 1;
                    if tr > rows 
                        tr = tr - 1;
                    end
                case 'E'
                    tc = tc - 1;
                    if tc < 1
                        tc = tc + 1;
                    end  
                case 'S'
                    tr = tr - 1;
                    if tr < 1
                        tr = tr + 1;
                    end
                case 'W'
                    tc = tc + 1;
                    if tc > cols
                        tc = tc - 1;
                    end
                otherwise
                    disp('Not Supported')
            end
        end
        w(tr,tc,j+1) = 1;
    end
end
%extrapolate goal location
tr = goal.r;
tc = goal.c;
tv = goal.vel;
w(tr,tc,1) = 0;
for j = 1:lookahead-1
    switch goal.dir
        case 'N'
            tr = round(tr - tv);
            if tr < 1
                tr = 1 + (tr * -1);
                goal.dir = 'S';
            end
        case 'E'
            tc = round(tc + tv);
            if tc > cols
                tc = cols - (tc - cols);
                goal.dir = 'W';
            end
        case 'S'
            tr = round(tr + tv);
            if tr > rows
                tr = rows - (tr - rows);
                goal.dir = 'N';
            end
        case 'W'
            tc = round(tc - tv);
            if tc < 1
                tc = 1 + (tc * -1);
                goal.dir = 'E';
            end
        otherwise
            disp('Not Supported')
    end
    if w(tr,tc,j+1) ~= 1
        w(tr,tc,j+1) = 0;
    end
end
world = w;
end