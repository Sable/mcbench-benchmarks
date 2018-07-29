function single_temp(Ti,Td)
    global V1 W  Stop_time V2 d Cp Tr 
    global C1
    global C_signal
    global kc
    global Am
    global Ph
    global ylt xlt ylq xlq
    Tri=Tr;
    Tc1=d*V1/W;
    h = findall(0,'tag','edit1')
    kc = get(h,'value');

    fig_hand=findall(0,'type','figure');
    set(fig_hand,'DoubleBuffer','off','backin','off')

    myopts = simset('SrcWorkspace','current');
    sim('..\model\single_model_trc',[],myopts);

    aimage = findall(0,'tag','axes_image_1');
    h_rec = flipud(findall(aimage,'type','rectangle'));

    a_q = findall(0,'tag','axes_Q');
    a_t = findall(0,'tag','axes_T');
    if C_signal == 2
        [T1.time,T1.signals.values]=pulseval(T1);
        [qo.time,qo.signals.values]=pulseval(qo);
    end
    
    tmin = min(T1.signals.values);
    tmax = max(T1.signals.values);
    delta_T = (tmax-tmin)/2;
    qmin = min(qo.signals.values);
    qmax = max(qo.signals.values);
    delta_q = (qmax-qmin)/2;
    
    axes(a_t)
    cla
    axis([min(T1.time) max(T1.time) tmin-delta_T tmax+delta_T])
    set(gcf,'renderer','zbuffer')
    ylt = ylabel('Temperature');
    xlt = xlabel('Time');
    hold on
    axes(a_q)
    cla
    axis([min(T1.time) max(T1.time) qmin-delta_q qmax+delta_q])
    ylq = ylabel('Heat');
    xlq = xlabel('Time');
    hold on


    if 768 < length(T1.time)
        r=floor((length(T1.time))/768);
    else
        r=1;
    end

    c = make_color(r);

    for i=1:length(T1.time)
        color_mat1(i) = floor(((T1.signals.values(i)-tmin)*(length(c)-41)/(tmax-tmin)))+1;
    end
    
    format bank
%     tmin_text=num2str(tmin);
%     tmax_text=num2str(tmax);
    axes(aimage)
    h=colorbar;
    set(h,'YTickLabel',{'cold',' ',' ',' ',' ','hot'},'tag','hbar')
    
    color_mat2 = [ color_mat1(1) color_mat1];
    color_mat3 = [ color_mat1(1) color_mat1(1) color_mat1];
    color_mat4 = [ color_mat1(1) color_mat1(1) color_mat1(1) color_mat1]; 
    color_mat5 = [ color_mat1(1) color_mat1(1) color_mat1(1) color_mat1(1) color_mat1]; 
    plot(a_t,[min(T1.time) max(T1.time)],[Tr Tr],'--ko','MarkerFaceColor','b')
    for i=1:length(T1.time)-1
        plot(a_t,[T1.time(i) T1.time(i+1)],[T1.signals.values(i) T1.signals.values(i+1)])
        plot(a_q,[T1.time(i) T1.time(i+1)],[qo.signals.values(i) qo.signals.values(i+1)]);
        
        n5=color_mat1(i);
        n4=color_mat2(i);
        n3=color_mat3(i);
        n2=color_mat4(i); 
        n1=color_mat5(i);
        
        set(h_rec(1),'facecolor',c(n1,:)/255,'EdgeColor',c(n1,:)/255)
        set(h_rec(2),'facecolor',c(n2,:)/255,'EdgeColor',c(n2,:)/255)
        set(h_rec(3),'facecolor',c(n3,:)/255,'EdgeColor',c(n3,:)/255)
        set(h_rec(4),'facecolor',c(n4,:)/255,'EdgeColor',c(n4,:)/255)
        set(h_rec(5),'facecolor',c(n5,:)/255,'EdgeColor',c(n5,:)/255)
        drawnow
    end
    beep
    clc
    
    