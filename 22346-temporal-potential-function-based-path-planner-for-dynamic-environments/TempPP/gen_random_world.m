function [world st_r st_c] = gen_random_world(rows,cols,obs,lookahead)
%
%generate random world in three dimensions
%
% create empty world
w (1:rows,1:cols,1:lookahead)=-1;
% set lookahead boundry to 1
w (:,:,lookahead+1) = 1;
% extrapolate obatacle locations
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
tf = 1;
tr = 0;
tc = 0;
% select random goal
while tf == 1
    tf = 0;
    %goal
    tflg = 1;
    while tflg == 1
        tr = round(1 + ( rows - 1) .* rand);
        tc = round(1 + ( cols - 1) .* rand);
        tflg = 0;
        if ( w(tr,tc,lookahead) ~= -1 )
            tflg = 1;
        end
    end
    w(tr,tc,lookahead) = 0;
    v  = backward_chain(w,tr,tc,lookahead);
    if any(v(:,1))== 0
        tf = 1;
        w(tr,tc,lookahead) = -1;
    else
        tflg = 1;
        while tflg == 1
            tflg = 0;
            tr = round(1 + ( rows - 1) .* rand);% find stat state
            tc = round(1 + ( cols - 1) .* rand);
            if v(tr,tc,1) == 0
                tflg = 1;
            end
        end
    end
end
world = w;
st_r = tr;
st_c = tc;
end