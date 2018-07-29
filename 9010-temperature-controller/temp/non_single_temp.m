function non_single_temp(Ti,Td)
    global V1 W  Stop_time V2 d Cp Tr h_rec
    global C1
    global C_signal
    global kc
    global Am
    global Ph
    global ylt xlt ylq xlq
    Tr1 = Tr;
    Tc1 = d*V1/W;
    Tc2 = d*V2/W;
    
    h = findall(0,'tag','edit1')
    kc = get(h,'value');

    fig_hand=findall(0,'type','figure');
    set(fig_hand,'DoubleBuffer','off','backin','off')

    myopts = simset('SrcWorkspace','current');
    sim('..\model\tank2_model_trc',[],myopts);



    a_q = findall(0,'tag','axes_Q');
    a_t = findall(0,'tag','axes_T');
    
    aimage = findall(0,'tag','axes_image_1');
    aimage_child = allchild(aimage);
    set(aimage,'vis','off');
    set(aimage_child,'vis','off');
    
    h_axes7 = findall(0,'tag','axes7');
    h_axes8 = findall(0,'tag','axes8');
    h_rec1 = flipud(findall(h_axes7,'type','rectangle'));
    h_rec2 = flipud(findall(h_axes8,'type','rectangle'));
    h_rec =[h_rec1;h_rec2];
    axes(h_axes7);
    text(-0.1,1,'First(blue)');
    axes(h_axes8);
    text(-0.1,1,'Second(green)');


    if C_signal == 2
        [T1.time,T1.signals.values]=pulseval(T1);
        [T2.time,T2.signals.values]=pulseval(T2);
        [qo.time,qo.signals.values]=pulseval(qo);
    end

    mint = min(min(T1.signals.values),min(T2.signals.values));
    maxt = max(max(T1.signals.values),max(T2.signals.values));
    delta_T = (maxt-mint)/2;
    qmin = min(qo.signals.values);
    qmax = max(qo.signals.values);
    delta_q = (qmax-qmin)/2;
    
    axes(a_t)
    cla
    axis([min(T1.time) max(T1.time) mint-delta_T maxt+delta_T])
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
        color_mat1_1(i) = floor(((T1.signals.values(i)-mint)*(length(c)-41)/(maxt-mint)))+1;
    end

    for i=1:length(T1.time)
        color_mat2_1(i) = floor(((T2.signals.values(i)-mint)*(length(c)-41)/(maxt-mint)))+1;
    end
    
    axes(h_axes7);
%     mint_text=num2str(round(mint*100)/100);
%     maxt_text=num2str(round(maxt*100)/100);
    h=colorbar;
    set(h,'YTickLabel',{'cold',' ',' ',' ',' ','hot'},'tag','hbar')
    
    color_mat1_2 = [color_mat1_1(1) color_mat1_1];
    color_mat1_3 = [color_mat1_1(1) color_mat1_1(1) color_mat1_1];
    color_mat1_4 = [color_mat1_1(1) color_mat1_1(1) color_mat1_1(1) color_mat1_1]; 
    color_mat1_5 = [color_mat1_1(1) color_mat1_1(1) color_mat1_1(1) color_mat1_1(1) color_mat1_1];
    
    color_mat2_2 = [color_mat2_1(1) color_mat2_1];
    color_mat2_3 = [color_mat2_1(1) color_mat2_1(1) color_mat2_1];
    color_mat2_4 = [color_mat2_1(1) color_mat2_1(1) color_mat2_1(1) color_mat2_1]; 
    color_mat2_5 = [color_mat2_1(1) color_mat2_1(1) color_mat2_1(1) color_mat2_1(1) color_mat2_1];
    
    plot(a_t,[min(T1.time) max(T1.time)],[Tr Tr],'--ko','MarkerFaceColor','b')
    
    for i=1:length(T1.time)-1
        plot(a_t,[T1.time(i) T1.time(i+1)],[T1.signals.values(i) T1.signals.values(i+1)],[T2.time(i) T2.time(i+1)],[T2.signals.values(i) T2.signals.values(i+1)])
        plot(a_q,[T1.time(i) T1.time(i+1)],[qo.signals.values(i) qo.signals.values(i+1)]);
        
        n5 = color_mat1_1(i);
        n4 = color_mat1_2(i);
        n3 = color_mat1_3(i);
        n2 = color_mat1_4(i); 
        n1 = color_mat1_5(i);
        
        n10 = color_mat2_1(i);
        n9 = color_mat2_2(i);
        n8 = color_mat2_3(i);
        n7 = color_mat2_4(i); 
        n6 = color_mat2_5(i);
        
        set(h_rec(1),'facecolor',c(n1,:)/255,'EdgeColor',c(n1,:)/255)
        set(h_rec(2),'facecolor',c(n2,:)/255,'EdgeColor',c(n2,:)/255)
        set(h_rec(3),'facecolor',c(n3,:)/255,'EdgeColor',c(n3,:)/255)
        set(h_rec(4),'facecolor',c(n4,:)/255,'EdgeColor',c(n4,:)/255)
        set(h_rec(5),'facecolor',c(n5,:)/255,'EdgeColor',c(n5,:)/255)
        
        set(h_rec(6),'facecolor',c(n6,:)/255,'EdgeColor',c(n6,:)/255)
        set(h_rec(7),'facecolor',c(n7,:)/255,'EdgeColor',c(n7,:)/255)
        set(h_rec(8),'facecolor',c(n8,:)/255,'EdgeColor',c(n8,:)/255)
        set(h_rec(9),'facecolor',c(n9,:)/255,'EdgeColor',c(n9,:)/255)
        set(h_rec(10),'facecolor',c(n10,:)/255,'EdgeColor',c(n10,:)/255)
        drawnow
    end
    beep
    clc