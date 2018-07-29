function add_to_buffer
global po pso pco
global Fs s
global ao
global pla pau
global hdls
global vol
global hd1 hd2
if pla
    i1=1+pso*(pco-1);
    i2=pso*pco;
    L=size(s,1);
    if (i1>L)||(i2>L)
        pla=false;
        stop(ao);
        delete(ao);
    else
        if pau
            d1=0*s(i1:i2,:);

            
            
            
            putdata(ao,d1);
        else
            d1=vol*s(i1:i2,:);
            d1=[filter(hd1,d1(:,1))  filter(hd2,d1(:,2)) ];

            putdata(ao,d1);
            display_time_script;
            pco=pco+1;
        end
    end
else
    stop(ao);
    delete(ao);
end