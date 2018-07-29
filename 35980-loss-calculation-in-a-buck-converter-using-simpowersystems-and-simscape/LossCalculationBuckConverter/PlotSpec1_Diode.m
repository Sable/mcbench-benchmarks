function [] = PlotSpec1_Diode(LossSpec_Diode)
%
    h2=figure;
    set(h2,'Name',[ LossSpec_Diode.Manufacturer,', ', LossSpec_Diode.Description]);
    ScreenS=get(0,'Screensize');
    set(h2,'Position',[ScreenS(3)/2.3 ScreenS(4)/12 ScreenS(3)/2.4 ScreenS(4)/1.25])
    subplot(2,1,1)
    plot(LossSpec_Diode.If_Erec,LossSpec_Diode.Erec(1,:),'blue', ...
        LossSpec_Diode.If_Erec,LossSpec_Diode.Erec(2,:),'red')
    legend('25 deg. C','125 deg. C','Location','NorthWest')
    grid
    Vcc_Value= num2str(LossSpec_Diode.Vcc_Erec,'%5.0f');
    title(['Diode Reverse Recovery Energy (Vcc= ', Vcc_Value, ' V)' ])
    ylabel('Erec (mJ)')
    xlabel('If (A)')
    %
    subplot(2,1,2)
    plot(LossSpec_Diode.Vf_OnState(1,:),LossSpec_Diode.If_OnState,'blue', ...
        LossSpec_Diode.Vf_OnState(2,:),LossSpec_Diode.If_OnState,'red')
    legend('25 deg. C','125 deg. C','Location','NorthWest')
    grid
    title('Diode On-state Characteristics')
    ylabel('If (A)')
    xlabel('Vf (V)')