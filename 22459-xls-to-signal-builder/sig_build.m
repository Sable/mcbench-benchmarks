function sig_build()
% ----------------------------------------------------------
% Create Simulink Signal Builder Block from Excel data file.
%
% Each xls sheet is used to create a signal builder group  
% Time vector must be in the first column.
% Each sheet must contain the same signal type (name & number)
% as the first sheet.
%
% Use TestCases.xls for example
%
% ---------------------------------------------------------
% Giacomo Faggiani
% First release - Dec 16th 2008
% ----------------------------------------------------------

[NomeFileXls,] = uigetfile('*.xls','select data file');
if isequal(NomeFileXls,0)
    return
end 

[Type,TestCases] = xlsfinfo(NomeFileXls);

for sheet_index = 1:length(TestCases)

    [Num,Text]=xlsread(NomeFileXls,TestCases{sheet_index});
    
     if sheet_index==1 
        % Use signals names of the first sheet as reference.
        SignalName=Text(end,2:end);
     else
        % Check consistent of signals names.
         if ~isequal(SignalName, Text(end,2:end))
            errordlg('Signals Names mismatch!');
            return;
         end
     end
     
     % Create time vector
     Time{sheet_index}=Num(:,1);
        
     % Create data
     for s=2:size(Text,2)
         Data{s-1,sheet_index}=Num(:,s);
     end
    
end

signalbuilder([], 'create', Time,Data,SignalName,TestCases);



