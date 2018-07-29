%% Configurable Simulink Model for DC-DC Converters
%

%% DC-DC Converters
% There are three kinds of switching mode DC-DC converters, buck, boost and
% buck-boost. The buck mode is used to reduce output voltage, whilst the
% boost mode can increase the output voltage. In the buck-boost mode, the
% output voltage can be maintained either higher or lower than the source
% but in the opposite polarity. The simplest forms of these converters are
% schematically represented in Figure 1.

%%
% <html>
% <img src="buck.png" width="180"> <img src="boost.png" width="180"> <img src="buck_boost.png" width="180">
% </html>
% 
% Figure 1. Buck (left), Boost (middle) and Buck-Boost (right) converters.

%%
% These converters consist of the same components, an inductor, $L$, a
% capacitor, $C$ and a switch, which has two states  $u=1$ and $u=0$. All 
% converters connect to a DC power source with a voltage (unregulated),
% $V_\mathrm{in}$ and provide a regulated voltage, $v_\mathrm{o}$ to the
% load resistor, $R$ by controlling the state of the switch. In some
% situations, the load also could be inductive, for example a DC motor, or
% approximately, a current load, for example in a cascade configuration.
% For simplicity, here, only current and resistive loads are to be
% considered.
%

%% Principles 
% The working principles of the these DC-DC converters can be explained as
% follows. In the buck mode, when the switch is on position 1, the DC
% source supplies power to the circuit which results an output voltage
% across the resistor. When the switch changes its position to 0, the
% energy stored in the inductor and capacitor will discharge through the
% resistor. Appropriately controlling the switching position can maintain
% the output voltage at a desired level lower than the source.  
%
% In the boost mode, when the switch is on position 1, the circuit is
% separated into two parts: on the left, the source is charging the
% inductor, meanwhile the capacitor on the right maintains the output
% voltage using previously stored energy. When the switch changes its
% position to 0, both the DC source and energy stored in the inductor will
% supply power to the circuit on the right, hence boost the output voltage.
% Again, the output voltage can be maintain at desired level by controlling
% the switching sequence.
%
% Finally, for the buck-boost mode, switch positions 1 and 0 represents
% charging and discharging modes of the inductor. Appropriately controlling
% the switching sequence can result in output voltage higher or lower than
% the DC source. Since the inductor cannot change the direction of current,
% the output voltage is opposite to the DC source.

%% Model under ideal assumptions
% Under ideal assumptions: ideal switch, ideal capacitor and ideal
% inductor, these converters can be described using ordinary
% differentiation equations as follows:
%
%% Buck converter:
% $C{dv_{c} \over dt} = i_{L} - v_{c}/R - i_{o}$
%
% $L{di_{L} \over dt} = uv_{in} - v_{c}$
%
% where, $i_\mathrm{o}$ is the load current.
%
%% Boost converter:
% $C{dv_\mathrm{c}\over dt}=(1-u)i_\mathrm{L}-v_\mathrm{c}/R-i_\mathrm{o}$
%
% $L{di_\mathrm{L}\over dt}=v_\mathrm{in} - (1-u) v_\mathrm{c}$
%
%% Buck-boost converter:
% $C{dv_\mathrm{c}\over dt}=(1-u)i_\mathrm{L}-v_\mathrm{c}/R-i_\mathrm{o}$
%
% $L{di_\mathrm{L}\over dt}=uv_\mathrm{in} - (1-u) v_\mathrm{c}$
%
% Introduce the following state, time and load normalization:
% 
% $x_1={v_\mathrm{c}\over v_\mathrm{in}}$,  
%
% $x_2={i_\mathrm{L}\over v_\mathrm{in}}\sqrt{{L}\over{C}}$,  
%
% $\tau = {t \over \sqrt{LC}}$,  
%
% $\gamma = {\sqrt{LC}\over R}$,  
%
% $d = {i_\mathrm o \over v_\mathrm{in}}\sqrt{{L}\over {C}}$
% 
% Then the normalized state equations of three converters are as follows:
%
%% Normalized buck model
% $\dot{x_1} = -\gamma x_1 + x_2 - d$
%
% $\dot{x_2}= -x_1 + u $
%
% where, with an abuse of notation, `.' represents the derivation with
% respect to the normalized time, $\tau$. 
%
%% Normalized boost model
% $\dot{x_1} = -\gamma x_1 + (1-u)x_2 - d$
%
% $\dot{x_2} = -(1-u)x_1 + 1$
%
%% Normalized buck-boost model
% $\dot{x_1} = -\gamma x_1 + (1-u)x_2 -d$
%
% $\dot{x_2} = -(1-u)x_1 + u$
%

%% Model with body resistors
% In more general cases, a body resistor of the inductor, $R_\mathrm{L}$
% and an equivalent series resistor (ESR) of the capacitor, $R_\mathrm{c}$
% can be added to the above models.  
%
%% Buck model with $R_\mathrm{L}$ and $R_\mathrm{c}$
% Since,
%
% $C{dv_\mathrm{c}\over dt} = i_\mathrm{L} - v_\mathrm{o}/R - i_\mathrm{o}$
%
% $v_\mathrm{o} = v_\mathrm{c} + R_\mathrm{c}C{dv_\mathrm{c}\over dt}$
%
% $L{di_\mathrm{L}\over dt} = uv_\mathrm{in} - v_\mathrm{o} -
% R_\mathrm{L}i_\mathrm{L}$
%
% Inserting the second equation into the first leads to:
%
% $C{dv_\mathrm{c}\over dt} = i_\mathrm{L} - v_\mathrm{c}/R -
% {R_\mathrm{c}\over R}C{dv_\mathrm{c}\over dt}- i_\mathrm{o}$
%
% $\left(1+{R_\mathrm{c}\over R}\right)C{dv_\mathrm{c}\over
% dt}=i_\mathrm{L} - v_\mathrm{c}/R - i_\mathrm{o}$
%
% Hence,
%
% $v_\mathrm{o}={Rv_\mathrm{c}\over R+R_\mathrm{c}}+{RR_\mathrm{c}\over
% R+R_\mathrm{c}}(i_\mathrm{L}-i_\mathrm{o})$
%
% and the overall model is
%
% $C{dv_\mathrm{c}\over dt}={R\over R+R_\mathrm{c}}\left(i_\mathrm{L} - {v_\mathrm{c}\over R} - i_\mathrm{o}\right)$
%
% $L{di_\mathrm{L}\over dt} = uv_\mathrm{in} - {Rv_\mathrm{c}\over
% R+R_\mathrm{c}} - \left(R_\mathrm{L}+{RR_\mathrm{c}\over R+R_\mathrm{c}}\right) i_\mathrm{L} + {RR_\mathrm{c}i_\mathrm{o}\over R+R_\mathrm{c}}$
% 
% $v_\mathrm{o}={Rv_\mathrm{c}\over R+R_\mathrm{c}}+{RR_\mathrm{c}\over
% R+R_\mathrm{c}}(i_\mathrm{L}-i_\mathrm{o})$
%
%% Boost model with $R_\mathrm{L}$ and $R_\mathrm{c}$
% $C{dv_\mathrm{c}\over dt} = (1-u)i_\mathrm{L} - v_\mathrm{o}/R - i_\mathrm{o}$
%
% $L{di_\mathrm{L}\over dt} = v_\mathrm{in} - (1-u) v_\mathrm{o} - R_\mathrm{L}i_\mathrm{L}$
%
% $v_\mathrm{o} = {Rv_\mathrm{c}\over R+R_\mathrm{c}}+{RR_\mathrm{c}\over
% R+R_\mathrm{c}}((1-u)i_\mathrm{L}-i_\mathrm{o})$
%
%% Buck-boost model with $R_\mathrm{L}$ and $R_\mathrm{c}$
% $C{dv_\mathrm{c}\over dt} = (1-u)i_\mathrm{L} - v_\mathrm{o}/R-i_\mathrm{o}$
%
% $L{di_\mathrm{L}\over dt}=uv_\mathrm{in}-(1-u) v_\mathrm{o}-R_\mathrm{L}i_\mathrm{L}$
%
% $v_\mathrm{o}={Rv_\mathrm{c}\over R+R_\mathrm{c}}+{RR_\mathrm{c}\over R+R_\mathrm{c}}((1-u)i_\mathrm{L}-i_\mathrm{o})$
%
%% Simulink Model
% These three modes of DC-DC converters have been uniformly implemented in
% the MATLAB/Simulink as show in Figure~\ref{fig:simulinkmodel}. 
% 
% <<DCDCModelInside.png>>
%
% Figure 2. A uniform Simulink model of DC-DC converters.
%
% The input-output connections of the model is shown in Figure 3.
% 
% <<DCDCModel.png>>
%
% Figure 3. Input and output connections of the DC-DC converter model.
%
% The first input to the model is the switch signal eight 1 or 0. The
% second one defines the DC source voltage and internal resistance. The
% third input is used to define the output current. The model has two
% outputs, the output voltage and the inductor current, which are the
% states of the system.
%
% The model can be configure with a number of parameters as shown in
% Figure~\ref{fig:simulinkmodelparameters}. These parameters are: the
% capacitance, $C$, inductance, $L$, the internal resistance of the
% capacitor and the inductor, $R_C$ and $R_L$ respectively. Three converter
% modes can be selected through the pull-down menu. One can also define
% either zero or non-zero value to the initial capacitor voltage by
% selecting or de-selecting the ``zero capacitor voltage'' option. Finally,
% the option ``Positive Inductor Current'' defines whether the condition
% $i_L\ge 0$ should be enforced or not.
%
% <<DCDCModelParameters.png>>
%
% Figure 4. Parameters of the DC-DC converter model.
%
