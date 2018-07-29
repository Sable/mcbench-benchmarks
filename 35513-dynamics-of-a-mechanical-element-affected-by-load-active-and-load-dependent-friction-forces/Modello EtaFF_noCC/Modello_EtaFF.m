%% Modell EtaFF

clear all
clc

%   Data Calculation (ODE 1)

DT=1e-5;                % Integration Step [s]
Time=0;                 % I.C. Time [s]
TiBr=5.0;               % End Simulation Time [s]

%   Servomechanism (SM) Phisical Characteristics

Krel=1e3;               % SM amplifier gain [N/m]
Cass=50;                % Dimensional Viscous Dumping Coefficient SM [N*s/m]
M=2;                    % SM Mass [kg]
FDJ=1;                  % Dynamic Load Independent Friction Force [N]
FSD=2;                  % Static (sticking) to Dynamic (slipping) friction ratio
EtO=0.85;%3/4;%0.6;     % Efficiency (ratio between resisting and driving power) when FR opposes DXJ
EtA=0.6;%2/3;%-0.1;     % Efficiency (ratio between resisting and driving power) when FR aids DXJ

%   Command Input (Com)

ComandoC=0.01;
ComandoC0=0;
startCC=1.0;

ComandoR=0*0.01;%0.025;%0.1;%0.02;
ComandoR0=0*0.01;
startCR=10.0;

ComandoS=0*0.01;
FreqS=5;
ComandoS0=0;
FreqS0=0;
startCS=2.0;

%   Load Input (FR)

LoadC=0;
LoadC0=0;
startLC=0.0;

LoadR=0;%0.025;%0.1;%0.02;
LoadR0=0;
startLR=1.0;

LoadS=10;
FreqLS=10;
LoadS0=0;
FreqLS0=0;
startLS=2.0;

%   Servomechanism I.C.

X=0;
XM=1.25;
DX=0;

%   Parametri x Scrittura Risultati

i=1;
num=1;
PlotStep=round(0.001/DT);
Decim=50;

%%  Saving in folder routine

    disp('Coulomb Friction Models Analisys by Borello')
    disp(' ')
    flagY='N';   
    while((flagY ~= 'Y') && (flagY ~= 'y'))
        reply = input('     Enter the folder name  ( Default = DRAFT ):','s');
        %   Vedi anche il comando 'inputdlg'
        if isempty(reply)
            reply = 'DRAFT';
        end
        flagY = input(['     Is the folder name - ',reply,' - correct? [Y / N]  ( Default = Y )'],'s');
        if isempty(flagY)
            flagY = 'Y';
        end
    end
    mkdir(reply)


%%  Friction Model Selection

    flagY='N';   
    clc
    while((flagY ~= 'Y') && (flagY ~= 'y'))
        modF = input('     Friction Model Selection  ( Default = ETAFF ):\n     NOFF\n     FF\n     ETAFF\n','s');
        %   Vedi anche il comando 'inputdlg'
        if isempty(modF)
            modF = 'ETAFF';
        end
        clc
        if(strcmp(modF,'NOFF') || strcmp(modF,'FF') || strcmp(modF,'ETAFF'))
            flagY = input(['     Is the friction model - ''',modF,''' - corret? [Y / N]  ( Default = Y )'],'s');
            if isempty(flagY)
                flagY = 'Y';
            end
        else
            str = sprintf('The typed name ''%s'' is not corret!!!!\\\\\n', modF);
            disp(str);
        end
    end
    clc


%%  Start Calculation Procedure

Com=Data_Input(Time,ComandoC,ComandoC0,startCC,ComandoR,ComandoR0,startCR,ComandoS,FreqS,ComandoS0,FreqS0,startCS);
FR=Data_Input(Time,LoadC,LoadC0,startLC,LoadR,LoadR0,startLR,LoadS,FreqLS,LoadS0,FreqLS0,startLS);
Data=[Time,Com,X,DX,FR];

while(Time<=TiBr)
    
    Time=Time+DT;
    
    Com=Data_Input(Time,ComandoC,ComandoC0,startCC,ComandoR,ComandoR0,startCR,ComandoS,FreqS,ComandoS0,FreqS0,startCS);
    FR=Data_Input(Time,LoadC,LoadC0,startLC,LoadR,LoadR0,startLR,LoadS,FreqLS,LoadS0,FreqLS0,startLS);
    
    Err=Com-X;
    
    Act=Krel*Err-FR-Cass*DX;
    
% Borello Friction Models

    if strcmp(modF,'FF') % Load-independent Borello friction model
%         disp('FF')
        if(DX == 0.0)
            FF=min(max(-FSD*FDJ,Act),FSD*FDJ);
        else
            FF=FDJ*sign(DX);
        end
        MODF=1;
    elseif  strcmp(modF,'ETAFF') % Load-dependent Borello friction model
%         disp('ETAFF')
        FDO=FDJ+(1/EtO-1)*abs(FR);
        FDA=FDJ+(1-EtA)*abs(FR);
        if(DX == 0.0)
            FF=min(max(-FSD*FDA,Act),FSD*FDO);         
            if(FR <= 0.0)
                FF=min(max(-FSD*FDO,Act),FSD*FDA);
            end
        else
            FF=FDO*sign(DX);
            if(DX*FR <= 0.0)
                FF=FDA*sign(DX);
            end
        end      
        MODF=2;
    else
%         disp('NOFF!!!!')
        FF=0; 
        MODF=3;
    end
    
% Dynamic System

    D2X=(Act-FF)/M;
    Old=DX;
    DX=DX+D2X*DT;
    if(Old*DX < 0.0)
        DX=0;
    end
%     X=min(max(X+(Old+DX)*DT/2,-XM),XM);
    X=min(max(X+DX*DT,-XM),XM);
    if (abs(X) >= XM)
        DX=0;
    end
    
% Plotter
    
    if(i>=PlotStep)
        pippo=[Time,Com,X,DX,FR];
        Data=[Data;pippo];
        i=1;
        num=num+1;
    else
        i=i+1;
    end
    
end


%%  Final Plotting Procedure

figure(1)
subplot(6,1,1:4)
plot(Data(:,1),Data(:,2))
hold all
grid on
% % minY=floor(10*min([min(Data(:,2)) min(Data(:,3)) 0.01*min(Data(:,4)) 0.01*min(Data(:,5))]))/10;
% % maxY=ceil(10*max([max(Data(:,2)) max(Data(:,3)) 0.01*max(Data(:,4)) 0.01*max(Data(:,5))]))/10;
% minY=floor(10*min([min(Data(:,2)) min(Data(:,3)) 0.001*min(Data(:,5))]))/10;
% maxY=ceil(10*max([max(Data(:,2)) max(Data(:,3)) 0.001*max(Data(:,5))]))/10;
% axis ([0 Time minY maxY])
xlim ([0 Time])
plot(Data(:,1),Data(:,3))
% plot(Data(:,1),0.001*Data(:,4))
plot(Data(:,1),0.001*Data(:,5))
title(['Friction Model ',modF,' - K = ',num2str(Krel),' - C = ',num2str(Cass),' - M = ',num2str(M),...
    ' - ComC = ',num2str(ComandoC),' - ComR = ',num2str(ComandoR),' - LoadC = ',num2str(LoadC),' - LoadR = ',num2str(LoadR),...
    ' - FSD = ',num2str(FSD),' - FDJ = ',num2str(FDJ),' - EtO = ',num2str(EtO),' - EtA = ',num2str(EtA)])

subplot(6,1,5:6)
plot(Data(:,1),0.001*Data(:,4))
hold all
grid on
xlim ([0 Time])

%%  Simulink Model
    sim ModelloEtaFF
    
    subplot(6,1,1:4)
    plot(SimOutFF.time,SimOutFF.signals.values(:,2),'o','LineWidth',2,...
                     'MarkerEdgeColor','k',...
                     'MarkerFaceColor','m',...
                     'MarkerSize',3)
%     plot(SimOutFF.time,SimOutFF.signals.values(:,4),'x','LineWidth',2,...
%                      'MarkerEdgeColor','k',...
%                      'MarkerFaceColor','m',...
%                      'MarkerSize',5)
%   	plot(SimOutFF.time,SimOutFF.signals.values(:,1),'^','LineWidth',2,...
%                      'MarkerEdgeColor','k',...
%                      'MarkerFaceColor','m',...
%                      'MarkerSize',5)
                 
	subplot(6,1,5:6)
    plot(SimOutFF.time,SimOutFF.signals.values(:,3),'o','LineWidth',2,...
                     'MarkerEdgeColor','k',...
                     'MarkerFaceColor','m',...
                     'MarkerSize',3)

                 
%% Error Evaluetion

figure(2)
plot(Data(:,1),Data(:,3)-XJmodFF.signals.values(:,1))
grid on
xlim ([0 Time])
xlabel('Time [s]')
ylabel('Error X_M_a_t_l_a_b vs X_S_i_m_u_l_i_n_k  [m]')

%%  Save Simulation

numero = input('     Enter actual test name ( Default = TEST )','s');
if isempty(numero)
    numero = 'TEST';
end
saveas (gcf,[reply,'/',numero])
save ([reply,'/Data_',numero,'.mat'],'Data')
disp(' ')
disp(' ')
disp(' ')
disp('PUSH A BUTTON FOR CLOSING')
pause
close all
clc
