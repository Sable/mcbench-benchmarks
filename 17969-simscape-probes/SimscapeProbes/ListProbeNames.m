% Script to list for names for Simscape probes
%% List probe names only:
get_param(find_system(bdroot,  'LookUnderMasks','all', 'Description', 'Simscape Probe'), 'Name')
%% List Probe name with path:
find_system(bdroot,  'LookUnderMasks','all', 'Description', 'Simscape Probe')
%% List both:
[get_param(find_system(bdroot,  'LookUnderMasks','all', 'Description', 'Simscape Probe'), 'Name'), find_system(bdroot,  'LookUnderMasks','all', 'Description', 'Simscape Probe')]
