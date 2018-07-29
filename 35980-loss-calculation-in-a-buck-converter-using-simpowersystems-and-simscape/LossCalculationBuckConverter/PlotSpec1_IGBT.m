function [] = PlotSpec1_IGBT(LossSpec_IGBT)
    h1=figure;
    set(h1,'Name',[ LossSpec_IGBT.Manufacturer,', ', LossSpec_IGBT.Description]);
    ScreenS=get(0,'Screensize');
    set(h1,'Position',[ScreenS(3)/60 ScreenS(4)/12 ScreenS(3)/2.4 ScreenS(4)/1.25])
    subplot(3,1,1)
    plot(LossSpec_IGBT.Ic_Eon,LossSpec_IGBT.Eon(1,:),'blue', ...
        LossSpec_IGBT.Ic_Eon,LossSpec_IGBT.Eon(2,:),'red')
    legend('25 deg. C','125 deg. C','Location','NorthWest')
    grid
    Vcc_Value= num2str(LossSpec_IGBT.Vcc_Eon,'%5.0f');
    title(['IGBT Turn-on Switching Energy (Vcc= ', Vcc_Value, ' V)' ])
    ylabel('Eon (mJ)')
    xlabel('Ic (A)')
    hold on
    %
    subplot(3,1,2)
    plot(LossSpec_IGBT.Ic_Eoff,LossSpec_IGBT.Eoff(1,:),'blue', ...
        LossSpec_IGBT.Ic_Eoff,LossSpec_IGBT.Eoff(2,:),'red')
  legend('25 deg. C','125 deg. C','Location','NorthWest')
    grid
    Vcc_Value= num2str(LossSpec_IGBT.Vcc_Eoff,'%5.0f');
    title(['IGBT Turn-off Switching Energy (Vcc= ', Vcc_Value, ' V)' ])
    ylabel('Eoff (mJ)')
    xlabel('Ic (A)')
     %
    subplot(3,1,3)
    plot(LossSpec_IGBT.Vce_OnState(1,:),LossSpec_IGBT.Ic_OnState,'blue', ...
        LossSpec_IGBT.Vce_OnState(2,:),LossSpec_IGBT.Ic_OnState,'red')
    legend('25 deg. C','125 deg. C','Location','NorthWest')
    grid
    title('IGBT On-state Characteristics')
    ylabel('Ic (A)')
    xlabel('Vce (V)')
    %