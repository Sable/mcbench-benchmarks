function rworlds = gen_random_obs(rows,cols,density,nworlds)
%
%Generated set of random obstacles to use to create random worlds
%
nobs = round((density/100)*rows*cols); %find number of obstacles
for i = 1:nworlds
    w(1:rows,1:cols) = -1;
    for j = 1:nobs
        tf = 1;
        while tf==1 %select empty location
            tr = round(1 + ( rows - 1) .* rand);
            tc = round(1 + ( cols - 1) .* rand);
            tf = 0;
            if w(tr,tc) == 1
                tf = 1;
            end            
        end
        w(tr,tc) = 1;
        tdir = round(1 + ( 4 - 1) .* rand);%set a random direction
        switch tdir
            case 1
                td = 'N';
            case 2
                td = 'E';
            case 3
                td = 'W';
            case 4
                td = 'S';
        end        
        tv = round((min(rows,cols)-1) .* rand);%set a random velocity
        rw(i).obs(j).r = tr;
        rw(i).obs(j).c = tc;
        rw(i).obs(j).vel = tv;
        rw(i).obs(j).dir = td;
    end
end
rworlds = rw;
end