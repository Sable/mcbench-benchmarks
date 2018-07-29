%% SEMINAR: INTRODUCTION TO SIMULINK
% This seminar will show some of the basic and intermediate skills for Modeling, 
% Designing and working with Simulink. This script will guide you through.
%% 
% <html>
% <p>Created by Roni Peer, 30.4.2012<b><br />Version 2.0</b></p>
% </html>

%% PART 1: BASICS
% This part will show how to use the basic abilities of Simulink to build, model,
% design and simulate a certain algorithm. Follow the steps bellow to do
% so.

%%% 1. Starting Simulink
% Let's open a new model and look what we can do with Simulink, and how
% it's built. We will build a small example to show the main features. The
% first model would show how to open Simulink, Drag blocks and connect
% them, configuring each block, running a simulation, and use of Stop
% Simulation.
simulink;

%% 
% *To build SLWS_Step_01:*
% 
%% 
% <html>
% <p><a href="matlab:SLWS_Step_01_Begin;">Step 01: Begin</a></p>
% </html>

%%
% # Open Simulink and show the Blocksets, search window, dragging of blocks.
% # Write the equation on the model: $F = ma ;  a = gravity; a = \dot{V}; V =
% \dot{X};$
% # Drag blocks: Constant, Integrator, Scope. Set $X_0 = 500; V_0 = 5; g =-9.81;$
% # Show how to zoom in/out/fit.
% # Find a way to stop the simulation when Altitude = 0;
% # Label the signals, and hide block names.
% # Change Simulation time to 100sec.
% # Simulate, and save the model.
% 
% *To Open a complete step-1 model:*
%% 
% <html>
% <p><a href="matlab:SLWS_Step_01;">Step 01: Complete</a></p>
% </html>

%%% 2. Subsystems and libraries
% The next model would show some use of vector operations, subsystems,
% selector block, and finally to introduce Libraries.
% You can start with this model:
%%
% <html>
% <p><a href="matlab:SLWS_Step_02_Begin;">Step 02: Begin</a></p>
% </html>

%% 
% *To build SLWS_Step_02:*
% 
% # Automaticaly align and resize the blocks.
% # Vectorize the gravity and signals: $g=$ [0 0 -9.81], $V_0=$ [8 -10 5],
% $X_0=$ [0 0 500]
% # Show the port data types.
% # Change solver to ODE23, Max. Step = 1sec.
% # Select the Z-component to stop simulation.
% # Create a subsystem for the "Stop Logic", and Change the Input signal to "Altitude"
% # Open Drag_Library and connect to the input with a "sum" block.
% # Define in MATLAB: $rho=1.2; Cd=0.333; A=1.5; m=150;$
% # Create Configurable Subsystem from the Drag Library
% In the end, you get this model:
%%
% <html>
% <p><a href="matlab:SLWS_Step_02;">Step 02: Complete</a></p>
% </html>

%%% 3. Callbacks and BUSes
% The next model would show some use of BUS Signals, Masking Subsystems.
% You can start with this model:
%%
% <html>
% <p><a href="matlab:SLWS_Step_03_Begin;">Step 03: Begin</a></p>
% </html>

%% 
% *To build SLWS_Step_03:*
% 
% # Create a callback which would load the parameters values ($Cd, A$...)
% # Create a mask for the Variable Density block. Show the constant one also.
% # Create a subsystem from the entire model - Name it Rocketeer.
% # Connect a BUS creator to velocity and Altitude, output them as "State".
% # Connect a constant block to acceleration. Value: $Thrust=$[0 0 1000]
% # Move the scope block to the top layer, and connect with a BUS Selector.
% # Run and verify.
% In the end, you get this model:
%%
% <html>
% <p><a href="matlab:SLWS_Step_03;">Step 03: Complete</a></p>
% </html>

%%% 4. Closing the loop
% The next model would show how to continue to design the controller, 
% and using a model reference.
% You can start with this model:
%%
% <html>
% <p><a href="matlab:SLWS_Step_04_Begin;">Step 04: Begin</a></p>
% </html>

%% 
% *To build SLWS_Step_04:*
% 
% # Change "thrust" to "Desired Velocity", $V=$[0 0 -0.5]
% # Close the loop on velocity. Name the output "Error".
% # Connect a PID controller from Error to Plant. $PI =$ [50 5]
% # Connect scopes to "Thrust" and "Error".
% # Show block execution order. Discuss this concept. Treat Controller as
% Atomic.
% # Convert the controller to a model block, and replace.
% # Show difference between Controller and Plant - Hierarchy.
% # Run. View Error scope inside Controller. Why nothing? Why so slow?
% # Switch to Normal. Don't forget to inline parameters. What now?
% # Show the "Dependancy Viewer" and the "Generate Manifest"
% - You can talk more about controls in the link specified.
% In the end, you get this model:
%%
% <html>
% <p><a href="matlab:SLWS_Step_04;">Step 04: Complete</a></p>
% </html>

%%% 5. "Slow Down!" - Control the rates and Embedded MATLAB
% The next model would show how to adjust the real-life settings of continuous 
% and discrete systems. Also, how to incorprate Embedded MATLAB code into
% the model.
% You can start with this model:
%%
% <html>
% <p><a href="matlab:SLWS_Step_05_Begin;">Step 05: Begin</a></p>
% </html>

%% 
% *To build SLWS_Step_05:*
%
% # Set the PI Controller to Discrete, Sample Time  = 0.5sec.
% # Set the sample time display to Color.
% # Set Thrust outport and Velocity inport to inherit sample time.
% # Update, and look at the error.
% # Add rate transition blocks  before and after the model reference.
% # Change the controller's Solver to Fixed-Step Discrete.
% # Change the input to the controller to be a BUS. Define the BUS with the
% editor: StateBus - Position (3) and Velocity (3).
% # Save the BUS to a mat file, and save it. Use a callback to load it.
% # Include the Embedded MATLAB code in the Model.
% # Run. 
%%
% <html>
% <p><a href="matlab:edit variable_v.m;">Open Embedded MATLAB Code</a></p>
% <p><a href="matlab:SLWS_Step_05;">Step 05: Complete</a></p>
% </html>

%%% 6. Deploying the System
% Simulink allows you to generate different types of code. 
% Open the following model, and generate these types of code:
% Embedded C-Code, HDL (VHDL or Verilog), and PLC Structured
% Text:
%%
% <html>
% <p><a href="matlab:Controller_Code_Gen;">Step 06: Deploy</a></p>
% </html>


%% PART 2: Multi-Domain Modeling
% This part will show how to use the more advanced abilities of Simulink to build, model,
% design and simulate your systems.
% Open the following models, and show how Simulink can aid in desiging
% multi-domain systems:

%%
% <html>
% <p><a href="matlab:warndlg('Please contact Systematics at 03-7660111 to run this example.');">Open Multi-Domain Model</a></p>
% </html>
