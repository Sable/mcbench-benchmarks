%% Specify the model name
model = 'engine_ol';
% Create the operating point specification object.
opspec = operspec(model);
% Set the constraints on the outputs in the model.
% Output (1) - rad//s to rpm
limit=[2000:200:4000];
for index=1:length(limit),
    opspec.Outputs(1).y = limit(index);
    opspec.Outputs(1).Known = true;
    % Create the options
    opt = linoptions('DisplayReport','off');
    % Perform the operating point search.
    [op(index),opreport] = findop(model,opspec,opt);
end
% Create the linearization I/O as specified in the model
io=getlinio(model);
% Linearize the model
sys = linearize(model,op,io);
% Plot the resulting linearization.
bode(sys)
%% Design controllers with a 2 rad/sec crossover
Options = pidtuneOptions('CrossoverFrequency',3.5);
pidsys=pidtune(sys,'pi',Options);
%% Look at the gains
plot_format(limit,[pidsys.Kp'; pidsys.Ki']);
%% Show step
figure
step(feedback(pidsys*sys,1));

% Copyright 2013 The MathWorks, Inc
