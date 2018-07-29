
function Transformation() % SUTmodelName )

% ============================================================
% TRANSFORMATION is creating a test framework for a selected SUT model (here: SUT_PI)
% This is a draft version of MiLEST by Justyna Zander, Abel Marrero, and Xiong Xuezheng. 2005-2008. 
% Copyrights are reserved. 
% http://www.fokus.fraunhofer.de/en/motion/ueber_motion/technologien/milest/index.html
% ============================================================
% 
clear;
clc;
SUTmodelName = 'SUT_PI';
SOURCE = SUTmodelName;
load_system('Simulink'); % Load Simulink library (background)
load_system('MIL_Test');
load_system(SOURCE);
SUTblockName = 'SUT';
%SUTblockName = get_param(find_system(SUTmodelName, 'BlockType', 'SubSystem'), 'Name'); 
%SUTblockName = SUTblockName{1};
TARGET = [SOURCE '_TC'];
%new_system(TARGET);
copyfile([SOURCE '.mdl'], [TARGET '.mdl'])
load_system(TARGET);
%-------------------------------------
% clear TARGET to start transformation
% should be in the preTransformation phase
terminators = find_system(SOURCE, 'BlockType', 'Terminator');
grounds = find_system(SOURCE, 'BlockType', 'Ground');
lenTer = length(terminators);
lenGr = length(grounds);
termLines = get_param([TARGET '/' SUTblockName],'LineHandles');
for i = 1:lenGr
    delete_block([TARGET '/Ground_' num2str(i)])
    delete_line(termLines.Inport(i));
end
for i = 1:lenTer
    delete_block([TARGET '/Terminator_' num2str(i)])
    delete_line(termLines.Outport(i));
end

%-------------------------------------
% building the generic test structure

add_block('MIL_Test/Validation Function/Test Evaluation Architecture/<system name>', [TARGET '/ValidationFunctions']);
add_block('Simulink/Sinks/Display',[TARGET '/OverallVerdict']);
%add_block('Simulink/Sinks/To Workspace',[TARGET '/OverallVerdictVar']);
%set_param([TARGET '/OverallVerdictVar'], 'VariableName', 'OverallVerdict');
set_param([TARGET '/ValidationFunctions'], 'LinkStatus', 'none')        
set_param([TARGET '/OverallVerdict'], 'Position',[1135 433 1215 457]);
%set_param([TARGET '/OverallVerdictVar'], 'Position',[1140 387 1215 413]);
set_param([TARGET '/ValidationFunctions'], 'Position',[910 409 1040 456]);
%add_line(TARGET,['ValidationFunctions/2'],['OverallVerdictVar/1'],'autorouting','on');
add_block('Simulink/Commonly Used Blocks/Bus Selector', [TARGET '/BSOV']);
set_param([TARGET '/BSOV'], 'Position',[1075 416 1080 454]);
set_param([TARGET '/BSOV'], 'OutputSignals', 'OverallVerdict')
add_line(TARGET,['ValidationFunctions/1'],['BSOV/1'],'autorouting','on');
add_line(TARGET,['BSOV/1'],['OverallVerdict/1'],'autorouting','on');


add_block('Simulink/Commonly Used Blocks/Bus Creator', [TARGET '/BCOut']);
add_block('Simulink/Commonly Used Blocks/Bus Creator', [TARGET '/BCIn']);
add_block('Simulink/Commonly Used Blocks/Bus Creator', [TARGET '/BCInOut']);
set_param([TARGET '/BCOut'], 'Position',[800 341 805 434]);
set_param([TARGET '/BCIn'], 'Position',[800 441 805 519]);
set_param([TARGET '/BCInOut'], 'Position',[870 344 875 526]);

% set number of inputs to the bus
set_param([TARGET '/BCOut'], 'Inputs', num2str(lenTer));
set_param([TARGET '/BCIn'], 'Inputs', num2str(lenGr)); % todo - dep. on the buses inside the sut
for i = 1:lenTer
add_line(TARGET,[SUTblockName '/' num2str(i)],['BCOut/' num2str(i)],'autorouting','on');
end

add_block('MIL_Test/Test Data/Test Data Architecture/<Test data generator>',[TARGET '/<Test data generator>']);
set_param([TARGET '/<Test data generator>'], 'Position',[80 370 230 410]);
%set_param([TARGET '/Test Stimuli'], 'Ports', [0 lenGr 0 0 0 0 0 0] -f);
%add_block([TARGET '/<Test data generator>/<signal1>'],[TARGET '/<Test data generator>/<signal2>']);
%fix_pos(['MIL_Test/Test Data/Test Data Architecture/<Test data generator>'],[TARGET '/<Test data generator>/<signal2>'],0,150);


add_line(TARGET,['BCOut/1'],['BCInOut/1'],'autorouting','on');
add_line(TARGET,['BCOut/1'],['<Test data generator>/2'],'autorouting','on');
add_line(TARGET,['BCIn/1'],['BCInOut/2'],'autorouting','on');
add_line(TARGET,['BCInOut/1'],['ValidationFunctions/1'],'autorouting','on');

% analysis of Signals coming into the SUT
%add_block('Simulink/Commonly Used Blocks/Bus Creator', [TARGET '/BCInSUT']);
%set_param([TARGET '/BCInSUT'], 'Position',[445 371 450 444]);

% add_line(TARGET,['Test Stimuli/1'],['BCInSUT/1'],'autorouting','on');
% add_line(TARGET,['BCInSUT/1'],[SUTblockName '/1'],'autorouting','on');
BusSelInSUT = find_system([SUTmodelName '/' SUTblockName], 'BlockType', 'BusSelector');
DemInSUT =find_system([SUTmodelName '/' SUTblockName], 'BlockType', 'Demux');

% todo - busselctors 
% if BusSelInSUT ~= 0 | DemInSUT ~= 0
%     disp('aha')
% end 

%addterms(TARGET);

%==========================================================================
%==========================================================================
load_system([TARGET '/<Test data generator>']);
% this is very important to disable the link of subsystem, or u will not have the right to change subsystem
% in this situation
set_param([TARGET '/<Test data generator>'],'LinkStatus', 'none');
In_SUT = find_system([TARGET '/SUT'], 'BlockType', 'Inport');
n = length(In_SUT);
Test_D_Gen_S([TARGET '/<Test data generator>'],n);
set_param([TARGET '/<Test data generator>'],'MaskValues', {'1', num2str(n), 'off'});

for i = 1:lenGr

    add_line(TARGET,['<Test data generator>/' num2str(i)],['BCIn/' num2str(i)],'autorouting','on');
    add_line(TARGET,['<Test data generator>/' num2str(i)],[SUTblockName '/' num2str(i)],'autorouting','on');
end


%==========================================================================
save_system;
disp(sprintf('Test Structure "%s" for "%s" built.', TARGET, SOURCE));


