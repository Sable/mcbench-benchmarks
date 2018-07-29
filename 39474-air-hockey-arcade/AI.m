%%%%%%%%%%Programmed by: Chi-Hang Kwan%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%Completion Date: December 13, 2012%%%%%%%%%%%%%%%%%%%

function posc_new = AI(window,pos,vel,posc,tstep)
tb = get(window,'UserData');

posf = pos + vel*tstep; %the position of the puck at the next frame
maxspeed = 1; %maximum moving speed of the computer's mallet

if posf(2) < 0
    pos_desire = [posf(1) tb.fieldh/4];
else
    if (posc(2)-posf(2)) > tb.r_mallet && abs(posf(1)-posc(1)) < tb.r_mallet %sweet spot to strike
        pos_desire = posf;
        if (posc(2)-posf(2))<(tb.r_mallet + tb.r_puck + 0.06)       
            maxspeed = 2; %accelerate to hit puck when it is within 6cm of impact
        end
    else
        pos_desire(2) = posf(2) + tb.r_mallet+tb.r_puck + 0.03;
        if (posf(2)-posc(2))>=(tb.r_mallet-tb.r_puck)
            pos_desire(1) = posf(1) + sign(posc(1)-posf(1))*(tb.r_mallet+tb.r_puck+0.01);
        else
            pos_desire(1) = posf(1);
        end
    end
end

%%%%%%%%%%To ensure the mallet stays within its own half%%%%%%%%%%%%%
if abs(pos_desire(1))>tb.fieldw/2-tb.r_mallet    
    pos_desire(1)= sign(pos_desire(1))*(tb.fieldw/2-tb.r_mallet);
end
if pos_desire(2) > tb.fieldh/2-tb.r_mallet
    pos_desire(2)= tb.fieldh/2-tb.r_mallet;
elseif pos_desire(2) < tb.r_mallet
    pos_desire(2) = tb.r_mallet;
end

%%%%%%%%%%To limit the speed of travel of the mallet%%%%%%%%%%%%%
delta = pos_desire - posc;
deltam = sqrt(delta(1)^2 + delta(2)^2);
if deltam == 0
    posc_new = posc;
else
    posc_new = posc + min(deltam,tstep*maxspeed)/deltam*delta;
end

