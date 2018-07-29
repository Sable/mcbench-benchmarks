% Author: Housam Binous

% VLE Computations using Matlab

% National Institute of Applied Sciences and Technology, Tunis, TUNISIA

% Email: binoushousam@yahoo.com

global PAR y x G1 G2 PS1 PS2 PS1e PS2e G1e G2e xe ye Te M

title1	= 'Antoine''s Equation and Wilson''s Model Parameters ';

% default values of Antoine's constants and Wilson model parameters
% commands to create the dialog box where one has to give the constants
% and parameters for the binary mixture of his choice

ind1	= {'A1 (7.11714)','A2 (6.95465)','B1 (1210.595)',...
           'B2 (1170.966)','C1 (229.664)','C2 (226.232)',...
           'A12 (116.1171)','A21 (-506.8519)','V1 (74.05)','V2 (80.67)'};

setpar	=	{'7.11714','6.95465','1210.595','1170.966',...
             '229.664','226.232',...
             '116.1171','-506.8519','74.05','80.67'};

options.resize='on';

prompt		=	ind1;
def			=	setpar;
dlgTitle	=	title1;
lineNo		=	1;

M	=	inputdlg(prompt,dlgTitle,lineNo,def,options);

if isempty(M)==0
    PAR	=	str2num(char(M));
else
    PAR=  [7.11714,6.95465,1210.595,1170.966,...
             229.664,226.232,...
             116.1171,-506.8519,74.05,80.67]';  
end

disp('vle parameters:')
disp(' ')
disp(PAR);      

% bubble point computation using fsolve

options = optimset('display','off');

for i=1:101
    xe(i)=(i-1)*0.01;
    x=xe(i);
    Te(i)=fsolve(@EQUIL,70,options);
    ye(i)=y;
    G1e(i)=G1;
    G2e(i)=G2;
    PS1e(i)=PS1;
    PS2e(i)=PS2;
end

% display all results in table format

data=[xe; ye; Te; G1e; G2e; G1e.*PS1e./(G2e.*PS2e)]'

