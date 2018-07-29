function piece_processing
global ai ps st hp pc paus frs datas
global highpass lowpass numerator_hp numerator_lp
if st
    stop(ai);
    delete(ai);
else
    data = getdata(ai,ps);
    %datas(1:ps)=datas(ps+1:2*ps);
    datas(1:2*ps)=datas(1*ps+1:3*ps);
    %datas(ps+1:2*ps)=data;
    datas(2*ps+1:3*ps)=data;
    pc=pc+1;
    if (mod(pc,frs)==0)&&(~paus)
        [tmp ii20]=max(data); % syncrhinize to maximum
        %datas1=datas(ii20:ps+ii20-1);
        if (~highpass)&&(~lowpass)
            datas1=datas(ps+ii20:2*ps+ii20-1);
            %datas1=datas(ps+ii20-0:2*ps+ii20-1);
            %datas1(0+1:end)
        end
        if highpass
            datas10=datas(ps+ii20-300:2*ps+ii20-1);
            datas10=filter(numerator_hp,1,datas10);
            datas1=datas10(301:end);
        end
        if lowpass
            datas10=datas(ps+ii20-300:2*ps+ii20-1);
            datas10=filter(numerator_lp,1,datas10);
            datas1=datas10(301:end);
        end
        set(hp,'YData',datas1);
        drawnow;
    end
end