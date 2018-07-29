% insert to current
eggsp(2:wd,orv(1))=eggsp(1:wd-1,orv(1));
eggsp(1,orv(1))=true;
orv=[orv(2:end)  orv(1)];
move=true;