%% Buck Converter Efficiency Load current Parameter Sweep 
% Copyright 2004-2013 The MathWorks, Inc.
Model='PS_Model_Efficiency';
open(Model)
%% Sanity check with essentially lossless components. 
Vinput = 2.5;  % DC input
Vset =  1.5;   % desired output
Iload = 1;     % constant load current
Rload = 1;     % shunt load resistance
% Note that Itotal = Iload + Vset/Rload 

FET_Ron    = 1e-5;
FET_Snub   = 1e5;

Cout_R =   1e-6;
L1_R   =   1e-6;
set_param(Model, 'SimulationMode', 'Normal')
sim(Model)

%% Now set some realistic values 
FET_Ron  = 20e-3;
FET_Snub = 1e3;

Cout_R   =  2e-3;
L1_R     =  5e-3;
set_param(Model, 'SimulationMode', 'Normal')
sim(Model)

%% Sweep Iload 
set_param(Model, 'SimulationMode', 'Accelerator')

Il=0.25:0.5:10;
Rload=25; 
L=length(Il);
Eff=0*Iload;

for k=1:L
    Iload=Il(k);
    sim(Model)
    Eff(k)=Efficiency;
    if Vload<0.98*Vset
       plot(Il(k)+Vset/Rload,Eff(k),'--rs','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','r',...
                'MarkerSize',10)
    else
       plot(Il(k)+Vset/Rload,Eff(k),'--rs','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','g',...
                'MarkerSize',10)
   
    end;
    if k==1
         hold on;
         xlabel('Iload in Amps'); ylabel('Efficiency in %')
         title(['Input Voltage=',num2str(Vinput),' V', '   Output Voltage',num2str(Vset),' V'] ); 
    end;
    axis([Il(1), Il(end),75, 100]); 
    drawnow;
end;
plot(Il,Eff,'LineWidth',2);
hold off;




