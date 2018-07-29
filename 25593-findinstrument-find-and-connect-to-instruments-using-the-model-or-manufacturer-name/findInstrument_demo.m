%% Get a list of all the available instruments

findInstrument; % equivalent to passing an empty search tring

%% Find instruments with "10" in their model or vendor name. 
% obj is [] since there are several such instruments 

obj = findInstrument('10')

%% Find an instrument by model number

obj = findInstrument('34405')

%%
% Open the connection, and get the identification string 
fopen(obj)
query(obj,'*IDN?')

%%
% If we try to find the same instrument again, findInstrument won't
% succeed (note the entry that says "Unable to connect"). This is because
% there is already a connection open.

obj2 = findInstrument('34405')

%%
% We need to delete the existing object (which will automatically close 
% it as well)
delete(obj);

%%
% findInstrument will now succeed
obj2 = findInstrument('34405')

%%
% And we can open the connection and query the instrument
fopen(obj2);
query(obj2,'*IDN?')
delete(obj);

%% Find an instrument by the Manufacturer code in the VISA resource string
% (0x975 is the code for Agilent). This fails since there are multiple
% Agilent instruments

obj = findInstrument('0x0957')

%% Find an instrument by the model code in the VISA resource string
% 0x1507 is the code for Agilent 33210A 

obj = findInstrument('0x1507')

%% Find and delete all existing interface objects
% INSTRFINDALL returns all the existing interface objects
instrfindall

%%
% Delete all the existing interface objects with one command
delete(instrfindall)
