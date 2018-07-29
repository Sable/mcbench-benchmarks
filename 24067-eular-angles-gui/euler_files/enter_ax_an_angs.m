function enter_ax_an_angs

global phi theta psi rad deg x y z gamma delta alpha

naner=false;

gamman=str2num(get(gamma,'String'));
if length(gamman)==0
    naner=true;
end

deltan=str2num(get(delta,'String'));
if length(deltan)==0
    naner=true;
end

alphan=str2num(get(alpha,'String'));
if length(alphan)==0
    naner=true;
end

if naner
    nan_error;
else
    
    if get(deg,'Value')
        gamman=pi*gamman/180;
        deltan=pi*deltan/180;
        alphan=pi*alphan/180;
    end
    
    an=ax_an_bounding(gamman,deltan,alphan);
    
    if an(1)
        gamman=an(2);
        deltan=an(3);
        alphan=an(4);
        if get(deg,'Value')
            set(gamma,'String',num2str(180*gamman/pi));
            set(delta,'String',num2str(180*deltan/pi));
            set(alpha,'String',num2str(180*alphan/pi));
        else
            set(gamma,'String',num2str(gamman));
            set(delta,'String',num2str(deltan));
            set(alpha,'String',num2str(alphan));
        end
    end
    
    an=axan2euler(gamman,deltan,alphan); % convert to Euler angles
    an1=an{1};
    phin=an1{1};
    thetan=an1{2};
    psin=an1{3};
    
    if get(deg,'Value')
        set(phi,'String',num2str(180*phin/pi));
        set(theta,'String',num2str(180*thetan/pi));
        set(psi,'String',num2str(180*psin/pi));
    else
        set(phi,'String',num2str(phin));
        set(theta,'String',num2str(thetan));
        set(psi,'String',num2str(psin));
    end

    vn=an{2};
    set(x,'string',num2str(vn(1)));
    set(y,'string',num2str(vn(2)));
    set(z,'string',num2str(vn(3)));


    %enter_eul_angs_1;
    enter_eul_angs(true,gamman,deltan,alphan); % with not set v
    
end
