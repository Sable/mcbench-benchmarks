function [DATA,AxisRange]=demoparm(system)
%DEMOPARM    Parameters for demo systems
%            The demo systems include:
%             1) Logistic map
%             2) Henon map
%             3) Duffing's equation
%             4) Lorenz equation
%             5) Rossler equation
%             6) Van Der Pol equation
%             7) Stewart-McCumber model

%            by Steve W. K. SIU, July 5, 1998.

%-------Common parameters--------
output=0;                   %Don't check "Output File": 1="check", 0="uncheck"
LEout=0;                    %Don't check "Lyapunov Exponents"
ODEout=0;                   %Don't check "Lyapunov Dimension"
LEprecision=1;              %Precision of output values of the 
ODEprecision=1;             %       Lyapunov exponents and dimension
                            %       1="%.4f", 2="%.6f', ..., 5=".12f"
%Line Colors
Blue=1; Black=2; Green=3; Red=4; Yellow=5; Magenta=6; Cyan=7;
LineColor=Blue;              %  line color: Blue


switch system
case 'Logistic map'
   %Parameters for logistic map
   
   IntMethod=1;             %Integration method: 1=Discrete map, 2=ODE45, 3=ODE23
                            % 4=ODE113, 5=ODE23S, 6=ODE15S
   InitialTime=0;           %Initial time: 0
   FinalTime=30000;         %Total time steps: 30000
   TimeStep=1;              %Time step: 1
   RelTol=0;                %Relative tolerance: N.A.
   AbsTol=0;                %Absolute tolerance: N.A.
   IC=[0.1];                %Initial conidition
   LODEnum=1;               %No. of linearized ODEs
   
   %PLOTTING OPTIONS: 	Only one of them can be set "on" (i.e. 1)
   plot1=0;                 %Plot immediately
   plot2=1;                 %Plot every  ItrNum iterations
   ItrNum=20;					
   
   Discard=200;		%Transient iterations to be discarded: 200 iterations = 200*10 time steps
   UpdateSteps=10;	%Update the LEs every 10 time steps
   
   %Axis range for plotting
   AxisRange=[InitialTime,FinalTime,0.5,0.8];

case 'Henon map'
   %Parameters for Henon map
   
   IntMethod=1;          %Integration method: 1=Discrete map, 2=ODE45, 3=ODE23
                         % 4=ODE113, 5=ODE23S, 6=ODE15S
   InitialTime=0;        %Initial time: 0
   FinalTime=20000;      %Total time steps: 20000
   TimeStep=1;           %Time step: 1
   RelTol=0;             %Relative tolerance: N.A.
   AbsTol=0;             %Absolute tolerance: N.A.
   IC=[0 0];             %Initial coniditions
   LODEnum=4;            %No. of linearized ODEs
   
   %PLOTTING OPTIONS: 	Only one of them can be set "on" (i.e. 1)
   plot1=0;              %Plot immediately
   plot2=1;              %Plot every  ItrNum iterations
   ItrNum=20;				
   
   Discard=500;          %Transient iterations to be discarded: 500
   UpdateSteps=1;        %Update the LEs every time step
                         % UpdateSteps > 0 will cause overflow
   
   %Axis range for plotting
   AxisRange=[InitialTime,FinalTime,-2,1];
   
case 'Duffing''s equation'
   
   %Parameters for Duffing's equation
   IntMethod=2;           %Integration method: 1=Discrete map, 2=ODE45, 3=ODE23
                          % 4=ODE113, 5=ODE23S, 6=ODE15S
   InitialTime=0;         %Initial time: 0
   FinalTime=1000;        %Final Time: 1000 sec 
   TimeStep=0.01;         %Time step: 0.01 sec
   RelTol=1e-5;           %Relative tolerance
   AbsTol=1e-6;           %Absolute tolerance
   IC=[0 0 0];            %Initial coniditions
   LODEnum=9;             %No. of linearized ODEs
   
   %PLOTTING OPTIONS: 	Only one of them can be set "on" (i.e. 1)
   plot1=0;               %Plot immediately
   plot2=1;               %Plot every  ItrNum iterations
   ItrNum=10;				
   
   Discard=200;           %Transient iterations to be discarded: 
                          %  200 Iterations = 200*10 time steps = 20 sec
   UpdateSteps=10;        %Update the LEs every 10 time steps
   
   %Axis range for plotting
   AxisRange=[InitialTime,FinalTime,-1,1];

case 'Lorenz equation'
   
   %Parameters for Lorenz equation
   IntMethod=2;            %Integration method: 1=Discrete map, 2=ODE45, 3=ODE23
                           %  4=ODE113, 5=ODE23S, 6=ODE15S
   InitialTime=0;          %Initial time: 0
   FinalTime=1000;         %Final Time: 1000 sec 
   TimeStep=0.01;          %Time step: 0.01 sec
   RelTol=1e-5;            %Relative tolerance
   AbsTol=1e-6;            %Absolute tolerance
   IC=[1 1 1];             %Initial coniditions
   LODEnum=9;              %No. of linearized ODEs
   
   %PLOTTING OPTIONS: 	Only one of them can be set "on" (i.e. 1)
   plot1=0;                %Plot immediately
   plot2=1;                %Plot every  ItrNum iterations
   ItrNum=10;				
   
   
   Discard=200;            %Transient iterations to be discarded: 
                           %   200 Iterations = 200*10 time steps = 20 sec
   UpdateSteps=10;         %Update the LEs every 10 time steps
   
   %Axis range for plotting
   AxisRange=[InitialTime,FinalTime,-25,5];
   
case 'Rossler equation'
   
   %Parameters for Rossler-hyperchaos
   IntMethod=6;             %Integration method: 1=Discrete map, 2=ODE45, 3=ODE23
                            % 4=ODE113, 5=ODE23S, 6=ODE15S
   InitialTime=0;           %Initial time: 0
   FinalTime=1000;          %Final Time: 1000 sec 
   TimeStep=0.01;           %Time step: 0.01 sec
   RelTol=1e-5;             %Relative tolerance
   AbsTol=1e-6;             %Absolute tolerance
   IC=[1 1 1];              %Initial coniditions
   LODEnum=9;              %No. of linearized ODEs
   
   %PLOTTING OPTIONS: 	Only one of them can be set "on" (i.e. 1)
   plot1=0;                 %Plot immediately
   plot2=1;                 %Plot every  ItrNum iterations
   ItrNum=10;				
   
   
   Discard=200;             %Transient iterations to be discarded: 
                            %   200 Iterations = 200*10 time steps = 20 sec
   UpdateSteps=10;          %Update the LEs every 10 time steps
   
   %Axis range for plotting
   AxisRange=[InitialTime,FinalTime,-11,1];

case 'Van Der Pol equation'
   
   %Parameters for Van Der Pol equation
   IntMethod=2;           %Integration method: 1=Discrete map, 2=ODE45, 3=ODE23
                          % 4=ODE113, 5=ODE23S, 6=ODE15S
   InitialTime=0;         %Initial time: 0
   FinalTime=1000;        %Final Time: 1000 sec 
   TimeStep=0.01;         %Time step: 0.01 sec
   RelTol=1e-5;           %Relative tolerance
   AbsTol=1e-6;           %Absolute tolerance
   IC=[0 0 0];            %Initial coniditions
   LODEnum=9;             %No. of linearized ODEs
   
   %PLOTTING OPTIONS: 	Only one of them can be set "on" (i.e. 1)
   plot1=0;               %Plot immediately
   plot2=1;               %Plot every  ItrNum iterations
   ItrNum=10;				
   
   Discard=200;           %Transient iterations to be discarded: 
                          %  200 Iterations = 200*10 time steps = 20 sec
   UpdateSteps=10;        %Update the LEs every 10 time steps
   
   %Axis range for plotting
   AxisRange=[InitialTime,FinalTime,-2,2];

case 'Stewart-McCumber model'
   
   %Parameters for Stewart-McCumber model
   IntMethod=2;           %Integration method: 1=Discrete map, 2=ODE45, 3=ODE23
                          % 4=ODE113, 5=ODE23S, 6=ODE15S
   InitialTime=0;         %Initial time: 0
   FinalTime=2000;        %Final Time: 2000 sec 
   TimeStep=0.01;         %Time step: 0.01 sec
   RelTol=1e-5;           %Relative tolerance
   AbsTol=1e-6;           %Absolute tolerance
   IC=[0 0 0];            %Initial coniditions
   LODEnum=9;             %No. of linearized ODEs
   
   %PLOTTING OPTIONS: 	Only one of them can be set "on" (i.e. 1)
   plot1=0;               %Plot immediately
   plot2=1;               %Plot every  ItrNum iterations
   ItrNum=10;				
   
   Discard=200;           %Transient iterations to be discarded: 
                          %  200 Iterations = 200*10 time steps = 20 sec
   UpdateSteps=10;        %Update the LEs every 10 time steps
   
   %Axis range for plotting
   AxisRange=[InitialTime,FinalTime,-1,1];

otherwise
   error('Invalid system!')
end

%Save the parameters in a matrix 
DATA=[   output,       LEout, LEprecision, ODEout,  ODEprecision, ...
      IntMethod, InitialTime,   FinalTime, TimeStep,      RelTol, ...
         AbsTol,       plot1,       plot2, ItrNum,     LineColor, ...
        Discard, UpdateSteps,     LODEnum,     IC];
