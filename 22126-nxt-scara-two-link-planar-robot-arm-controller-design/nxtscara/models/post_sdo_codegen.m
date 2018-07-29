% Post-Processing of Code Generation with Simulink Data Object
% Recover the variables and signal resolutions to pre-code generation.

% clear signal objects
cmd = 'clear';
for n = 1:num_sig
	cmd = [cmd, ' ', sig.name{n}];
end
eval(cmd)

% reset signal resolution
for n = 1:length(sig.handle.Signals)
	set_param(sig.handle.Signals(n), 'MustResolveToSignalObject', 'off')
end
for n = 1:length(sig.handle.States)
	set_param(sig.handle.States(n), 'StateMustResolveToSignalObject', 'off')
end

% clear parameter objects
cmd = 'clear';
for n = 1:num_param
	cmd = [cmd, ' ', param.name{n}];	
end
eval(cmd)

% make parameter data
cmd = [];
for n = 1:num_param
	cmd = [cmd, param.name{n}, ' = param.value{', num2str(n), '};'];
end
eval(cmd)

clear n cmd sig param num_sig num_param
