%%%%%%%%%%Programmed by: Chi-Hang Kwan%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%Completion Date: December 13, 2012%%%%%%%%%%%%%%%%%%%

function posc_new = AI_advanced(window,pos,vel,posc,tstep)

tb = get(window,'UserData');
posf = pos + vel*tstep; %position of puck at next time frame
maxspeed = 1; %maximum moving speed of the computer's mallet
t = -1; %default value for time to intercept puck (<0 means undefined)

if posf(2) < 0
    posd = [posf(1) tb.fieldh/4];
else
    if (posc(2)-posf(2)) > tb.r_mallet && abs(posf(1)-posc(1)) < tb.r_mallet %sweet spot to strike
        posd = posf;
        if (posc(2)-posf(2))<(tb.r_mallet + tb.r_puck + 0.06)   
            maxspeed = 2; %accelerate to hit the puck when it is within 6cm
        end
    else
        if vel(1)>0 %calculate time to hit side rails
            tw = (tb.fieldw/2 - posf(1) - tb.r_puck)/abs(vel(1));
        elseif vel(1)<0
            tw = (posf(1) + tb.fieldw/2 - tb.r_puck)/abs(vel(1));
        else
            tw = 100;
        end
        if vel(2)>0 %calculate time to hit back wall
            tbase = (tb.fieldh/2-posf(2))/vel(2);
        else
            tbase = 100;
        end
        
        posd(2) = posf(2) + tb.r_mallet+tb.r_puck + 0.03;
        if (posf(2)-posc(2))>=(tb.r_mallet-tb.r_puck)
            posd(1) = posf(1) + sign(posc(1)-posf(1))*(tb.r_puck);
        else
            posd(1) = posf(1);
        end
        
        %calculate time to intercept puck
        posr = posd-posc;
        c = posr(1)^2+posr(2)^2;
        b = 2*(posr(1)*vel(1) + posr(2)*vel(2));
        a = vel(1)^2 + vel(2)^2 - maxspeed^2;
        if (b^2-4*a*c) > 0
            tt(1) = (-b + sqrt(b^2-4*a*c))/2*a;
            tt(2) = (-b - sqrt(b^2-4*a*c))/2*a;
            ind = find(tt==abs(tt));
            if length(ind)>0
                t = min(tt(ind));                
            end
        end
        
        if t>0 && t<tw && t<tbase %time to intercept puck is usable
            posd = [posd(1)+vel(1)*t posd(2)+vel(2)*t]; 
        elseif vel(2)> 0.2 && tw<tbase %rebounding off side rails is imminent
            posd = [0 tb.fieldh/2-tb.r_mallet];
        end
       
    end
end

%%%%%%%%%%To ensure the mallet stays within its own half%%%%%%%%%%%%%
if abs(posd(1))>tb.fieldw/2-tb.r_mallet    
    posd(1)= sign(posd(1))*(tb.fieldw/2-tb.r_mallet);
end
if posd(2) > tb.fieldh/2-tb.r_mallet
    posd(2)= tb.fieldh/2-tb.r_mallet;
elseif posd(2) < tb.r_mallet
    posd(2) = tb.r_mallet;
end

%%%%%%%%%%To limit the speed of travel of the mallet%%%%%%%%%%%%%
delta = posd - posc;
deltam = sqrt(delta(1)^2 + delta(2)^2);
if deltam == 0
    posc_new = posc;
else
    posc_new = posc + min(deltam,tstep*maxspeed)/deltam*delta;
end

