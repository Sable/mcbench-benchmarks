clc;
pzstat = input('enter a puzzle in 3 x 3 form (use 0 for space) ..........:   ');
pzrstat = [1 2 3;4 5 6;7 8 0];
intv000 = size(pzstat);
if not(all(intv000 == [3 3]))
    msgbox('Input is not in correct format.............. The format must be 3 x 3 matrix. The blank space should be replaced by 0.','8-Puzzle suresh Kumar Gadi');
else
    pzinl = [];
    pzhis = [];
    pzrhis = [];
    intv00g = 0;
    [intv0h1,intv0h2] = gskcostastar(pzstat,pzrstat);
    intv00h = intv0h1 + intv0h2;
    intv00f = intv00h + intv00g;
    pzinl = gskpzjoin(pzinl,pzstat,intv00f,intv00g,intv00h);
    pzhis = gskpzjoin(pzhis,pzstat,intv00f,intv00g,intv00h);
    pzhis(:,13)=0;
    pzhis(1,14)=0;
    pzhis(1,15)=1;
    intv001 = 1;
    intv0ct = 0;
    intv0nd = 1;
    intv1nd = 1;
    while intv001 == 1;
        intv0ct = intv0ct + 1;
        [pzout, intv00f, intv00g, intv00h] =  gskpzget(pzinl,1);
        [intv002, intv003] = find(pzout==0);
        pzinl = [];
        if intv00h ~= 0
% % % % % % left
            if intv003 > 1
                pzout1 = pzout;
                pzout1(intv002,intv003) = pzout(intv002,intv003 - 1);
                pzout1(intv002,intv003 - 1) = 0;
                [intv0h1,intv0h2] = gskcostastar(pzout1,pzrstat);
                intv00h = intv0h1 + intv0h2;
                intv0g1 = intv00g + 1;
                intv00f = intv0g1 + intv00h;
                [pzinl] =  gskpzjoin(pzinl,pzout1,intv00f,intv0g1,intv00h);
            end
% % % % % % top
            if intv002 > 1
                pzout1 = pzout;
                pzout1(intv002,intv003) = pzout(intv002-1,intv003);
                pzout1(intv002-1,intv003) = 0;
                [intv0h1,intv0h2] = gskcostastar(pzout1,pzrstat);
                intv00h = intv0h1 + intv0h2;
                intv0g1 = intv00g + 1;
                intv00f = intv0g1 + intv00h;
                [pzinl] =  gskpzjoin(pzinl,pzout1,intv00f,intv0g1,intv00h);                
            end
% % % % % % right
            if intv003 < 3
                pzout1 = pzout;
                pzout1(intv002,intv003) = pzout(intv002,intv003 + 1);
                pzout1(intv002,intv003 + 1) = 0;
                [intv0h1,intv0h2] = gskcostastar(pzout1,pzrstat);
                intv00h = intv0h1 + intv0h2;
                intv0g1 = intv00g + 1;
                intv00f = intv0g1 + intv00h;
                [pzinl] =  gskpzjoin(pzinl,pzout1,intv00f,intv0g1,intv00h);                
            end
% % % % % % down
            if intv002 < 3
                pzout1 = pzout;
                pzout1(intv002,intv003) = pzout(intv002 + 1,intv003);
                pzout1(intv002 + 1,intv003) = 0;
                [intv0h1,intv0h2] = gskcostastar(pzout1,pzrstat);
                intv00h = intv0h1 + intv0h2;
                intv0g1 = intv00g + 1;
                intv00f = intv0g1 + intv00h;
                [pzinl] =  gskpzjoin(pzinl,pzout1,intv00f,intv0g1,intv00h);                
            end
% % % % % % compare with history
            [intv003, intv004] = size(pzinl);
            for intv004 = 1 : intv003
                intv005 = gsksearch(pzhis,pzinl(intv004,:));
                if ~isempty(intv005)
%                     pzhis(intv005,13) = 1;
                else
                    [intv007 , intv008] = size(pzhis);
                    intv008 = pzinl(intv004,1:12);
                    intv008(13) = 0;
                    intv008(14) = intv0nd;
                    intv1nd = intv1nd + 1;
                    intv008(15) = intv1nd;
                    pzhis(intv007+1,:)=intv008;
                end
            end
% % % % % % selecting new node
            intv005 = find(pzhis(:,13) == 1);
            intv006 = length(intv005);
            pzrhis = pzhis;
            for intv007 = 1:intv006
                pzrhis(intv005(intv007)-(intv007-1),:)=[];
            end
            intv003 = min(pzrhis,[],1);
            [pzout, intv00f, intv00g, intv00h] =  gskpzget(intv003,1);
            [intv002, intv003] = find((pzrhis(:,10)==intv00f) & (pzrhis(:,13) == 0));
%             intv002 = intv002(1,1);
            [pzout, intv00f, intv00g, intv00h] =  gskpzget(pzrhis,intv002(1,1));
            intv0nd = pzrhis(intv002(1,1),15);
            pzinl = [];
            [pzinl] =  gskpzjoin(pzinl,pzout,intv00f,intv00g,intv00h);
            intv005 = gsksearch(pzhis,pzinl);
            pzhis(intv005,13) = 1;
            intv001 = 1;
        else
            intv001 = 2;
        end
    end
% % Display of steps
    [intv000, intv001] = size(pzhis);
    intv002 = 1;
    pzshow = [];
    intvcnt = 0;
    while intv002 ==1
        intvcnt = intvcnt + 1;
        pzshow(intvcnt) = intv000;
        intv000 = pzhis(intv000,14);
        if intv000 == 0
            intv002 = 2;
        else
            intv002 = 1;
        end
    end
    for intv000 = 1 : intvcnt
        [pzout, intv00f, intv00g, intv00h] =  gskpzget(pzhis,pzshow(intvcnt-intv000+1));
        intv000
        pzout
    end
end