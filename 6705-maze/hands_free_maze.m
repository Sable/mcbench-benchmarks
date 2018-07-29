function hands_free_maze
% My daughter likes playing maze, but there were a couple of problems. She
% is only in kindergarten so invoking a function is not in her vocabulary 
% yet, she gets bored if the mazes are not progressively harder, and I get
% tired of restarting maze every couple of minutes.... so here is a little
% infinite loop to keep even a kindergartener amused.

rr=10;
cc=15;
ii=1;
while 1
    close all
    score(ii,1) = maze(rr,cc,'r')
    pause(5)
    rr=round(rr*1.12);
    cc=round(cc*1.12);
    ii=ii+1;
end