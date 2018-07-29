 function [ep]=NEA(data,varargin);
% y=NEA(data) performs network environ analysis on model "data".
%
% y=NEA(data,0) performs network environ analysis on model "data", but
% does not show the results in the workspace (they are still saved as
% 'NEA_ouput.mat')
% 
% VERSION REV 1.0.0
% Brian D. Fath & Stuart R. Borrett 2004
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% I. INTRODUCTION
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% This program is a compilation of algorithms for network environ
% analysis.  This is a self-contained program; all functions required are 
% included in this file.
%
% REQUIRED DATA INPUT
% The input variable 'data' is an (n+1 x n+2) matrix composed of an nxn 
% flow matrix (F), an nx1 input vector (z), an nx1 storage vector (x), 
% a 1xn output vector (y), and a 1x2 vector of zeros.  Data should have 
% consistant units and reflect a system at steady-state (though some 
% analyses remain valid for non-steadystate (i.e., structural analysis)).
% .
%
% DATA OUTPUT
% 'ep' is a vector of environ properties and network statistics.  To 
% return additional variables to the Matlab workspace, place the variable 
% name into the output definition.  For example, [A,G,ep]=NEA(data) will
% return A, G and ep to the workspace. All resultant variables are stored in 
% NEA_output.mat.
%
% PROGRAM OUTLINE
% I.	Introduction
% II.	Initialize Parameters
% III.	Main Program
%       a.  Verify Steady-State Assumption
%       b.	Network Environ Analysis
%           i.	Structural Analysis
%           ii.	Throughflow Analysis
%           iii. Storage Analysis
%       	iv.	Utility Analysis
%           v.	Unit Environs
%           vi.	Control Analysis
%       c.	Summary of Environ Properties and Network Statistics
% IV.	Subfunctions
%       a.	NEA_structure
%       b.	NEA_throughflow
%       c.	NEA_storage
%       d.	NEA_utility
%       e.	NEA_u_environs
%       f.  NEA_control
% V.	Auxiliary Programs
%       a.	Unpack
%       b.	Environ Error Tolerance
%       c.	Bcratio
%       d.  Mode
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
tic     % Starts program timer

% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% II.  Initialize Parameters -=-=-=-==-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

% control variable number of inputs (sets disp_ctrl to default)
if length(varargin)==0, disp_ctrl=1;
elseif length(varargin)==1, disp_ctrl=varargin{1}; 
end

global n I
[F, y, z, x]=unpack(data);  % Unpacks the data matrix into component parts
n=length(F);				% length of F gives the dimensions of the flow matrix
T=sum(F')'+z;				% total throughflow at each compartment including input
FD=F-diag(T);				% flow matrix with negative throughflows on diagonal
I=eye(n);			    	% nxn identity matrix

% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% III.  Main Program  =-=-=-=-=-==-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

% Check Steady-State Assumption
Tin=sum(F')+z';     % inputs
Tout=sum(F)+y;      % outputs
pd=abs((Tin-Tout))./Tin; % proportional difference in node throughflow
ss_tol=5e-3;        % steady-state tolerance facor

pd_count=length(find(pd>=ss_tol));  % find number of proportional throughflow 
                                    % differences that are greater than
                                    % 0.0005 or 0.05%.
if pd_count==0
    disp('Steady-state assumption met')
else
    disp('Proportoinal Difference between Tin and Tout = '), pd
    error('Model does not meet steady-state requirement');    
    return          % terminates program
end

% Network Environ Analysis
% ----------------------------------------
% Structural Analysis (SUBFUNCTION_1)
[A,A1,structure_ep]=NEA_structure(F);
% Throughflow Analysis (SUBFUNCTION_2)
[G,GP,N,NP,flow_ep]=NEA_throughflow(F,y,z,T,FD);
% Storage Analysis (SUBFUNCTION_3)
[C,CP,S,SP,P,Q,PP,QP,dt,stor_ep]=NEA_storage(F,T,x,FD);
% Utility Analysis (SUBFUNCTION_4)
[D,DS,U,Y,US,YS,utility_ep]=NEA_utility(FD,T,x);
% Unit Environ Analysis (SUBFUNCTION_5)
[E,EP,SE,SEP,environ_error_tol]=NEA_u_environs(G,N,GP,NP,P,Q,PP,QP);
% Control Analysis (SUBFUNCTION_6)
[CN,CQ]=NEA_control(N,NP,Q,QP);

% Summary of Network and Environ Properties
ep=[structure_ep,flow_ep,stor_ep,utility_ep]'; 
ep_labels1={'# nodes, n','# links, L','connectance, L/n^2', ...
    'link density, L/n','path proliferation',... 
    'TST','Cycling Index (T)',...
    'MODE_0 boundary','MODE_1, 1st pass',...
    'MODE_2, cycled','MODE_3, dissipative','MODE_4, boundary'...
    'Amp (T,output)','Amp (T,input)',...
    'I/D (T,output)','I/D (T,input)','Homog (T,output)',...
    'Homog (T,input)', 'Aggradation',... 
    'Cycling Index (S)','Amp (S,output)',...
    'Amp (S,input)','I/D (S,output)','I/D (S,input)',...
    'Homog (S,output)','Homog (S,input)',... 
    'Synergism (T)','Mutualism (T)',...
    'Synergism (S)','Mutualism (S)'}';   % ep labels 

% Table of Environ Properties
indx=1:length(ep_labels1); eee=num2cell(indx)'; ep_labels=[eee ep_labels1];       
eeee=num2cell(ep); ep_table=[eee ep_labels1 eeee]; 

contents={'F' 'z' 'y' 'x' 'T' 'A' 'A1' 'G',...
        'GP' 'N' 'NP' 'CN' 'C' 'P' 'Q' 'S' 'CP' 'PP' 'QP' 'SP' 'CQ',...
        'D' 'DS' 'U' 'Y' 'US' 'YS' 'E' 'EP' 'SE' 'SEP',...
        'ep' 'ep_table' 'contents'};

save NEA_output F z y x T A A1 G GP N NP CN C CP S SP P Q dt PP QP CQ D DS U Y US YS E EP SE SEP ep ep_table contents

% -------------------------------------------------------------------------
%                         DISPLAY CONTROL
% -------------------------------------------------------------------------
% This section allows you to turn on and off the display of various results
% in the workspace.

switch disp_ctrl
    case 1          % insert the parameter you want to see into this list
        disp('Original System Data')
        F,z,y,x
        disp('Structural Analysis')
        A,A1
        disp('Throughflow Analysis')
        T,G,GP,N,NP
        disp('Storage Analysis')
        C,CP,S,SP,P,Q,dt,PP,QP
        disp('Control Analysis')
        disp('Throughflow'),CN
        disp('Storage'),CQ
        disp('Utility Analysis')
        D,DS,U,Y,US,YS
        disp('Unit Environs')
        disp('numerical error tolerance'),environ_error_tol
        disp('Unit output flow environs'),E
        disp('Unit input flow environs'),EP
        disp('Unit output storage environs'),SE
        disp('Unit input storage environs'),SEP
        disp('Environ Properties')
        ep_table
    case 0
end
prog_time=toc;               % time elapsed during program

% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% IV.   SUBFUNCTIONS  =-=-=-=-=-==-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

% -------------------------------------------------------------------------
% SUBFUNCTION_1: Structural Analysis (PRIMARY)
% -------------------------------------------------------------------------

function [A,A1,structure_ep]=NEA_structure(F)
% y=netstructure(data,struct_plots)  
% This subfunction calculates several statistics that describe the network
% structure of the system.
% *******************************************************************
global n I
A=sign(F);             % nxn adjacency matrix
A1=A+I;			       % nxn adjacency walk matrix
L=nnz(A);              % number of links or arcs in the network
C=L/(n^2);             % network connectance
Ln=L/n;                % link density
max_eig=max(abs(eig(A))); % dominant eigenvalue of A = rate of 
       % pathway proliferation.  This can serve as a complexity index
structure_ep=[n,L,C,Ln,max_eig];   % return variable

% -------------------------------------------------------------------------
% SUBFUNCTION_2: Throughflow Analysis
% -------------------------------------------------------------------------
function [G,GP,N,NP,flow_ep]=NEA_throughflow(F,y,z,T,FD);
% [G,GP,N,NP,flow_ep]=NEA_throughflow(F,y,z,T,FD)  
% This subfunction perfoms the input and output oriented throughflow
% normalized environ analysis
% *******************************************************************
global n I
% Direct throughflow 
G=I+FD*inv(diag(T));	    % fij/Tj for i,j=1:n -- output matrix
GP=I+inv(diag(T))*FD;		% fij/Ti for i,j=1:n -- input matrix
% Integral throughflow 
N=inv(I-G)	;	    % integral output flow matrix -- I+G+G^2+G^3+...
NP=inv(I-GP);		% integral input flow matrix -- I+GP+GP^2+GP^3+...
dN=diag(N);

[MODE_0,MODE_1,MODE_2,MODE_3,MODE_4]=mode(N,z); % mode analysis

% Throughflow environ properties
% ********************************************************************
p=ones(n,1);		    	% ones vector
TSTc=sum(((dN-p)./dN).*T);% cycled (mode 2) throughflow
TST=sum(T);		            % total system throughflow
CIF=TSTc/TST;	    		% cycling index (modified from Finn 1976)
Z=sum(z);                   % boundary flow

% Amplification parameter
NAF=length(find((N-diag(dN))>1));           % output 
NAFP=length(find((NP-diag(diag(NP)))>1));   % input 

% Indirect effects parameter
IDF=sum(sum(N-I-G))/sum(G(:));    	    % indirect to direct ratio (output)
IDFP=sum(sum(NP-I-GP))/sum(GP(:));  	% indirect to direct ratio (input)	

% Homogenization parameter
CVG=std(G(:))/mean(G(:));	    		% coefficient of variation for G
CVN=std(N(:))/mean(N(:));	    		% coefficient of variation for N
HF=[CVG/CVN];				        	% homogenization parameter (output)

CVGP=std(GP(:))/mean(GP(:));			% coefficient of variation for G
CVNP=std(NP(:))/mean(NP(:));			% coefficient of variation for N
HFP=[CVG/CVN];				        	% homogenization parameter (input)

% Network Aggradation or Average Path Length
AGG=TST/Z;      % Jorgensen, Patten and Straskraba (2000)
                % Original formulation of average path length (Finn 1976)
                % This parameter is expected to increase as systems develop.

flow_ep=[TST,CIF,MODE_0,MODE_1,MODE_2,MODE_3,MODE_4,...
        NAF,NAFP,IDF,IDFP,HF,HFP,AGG];

% -------------------------------------------------------------------------
% SUBFUNCTION_3: Storage Analysis
% -------------------------------------------------------------------------
function [C,CP,S,SP,P,Q,PP,QP,dt,stor_ep]=NEA_storage(F,T,x,FD) % Storage Analysis
% [P,Q,PP,QP,dt,stor_ep]=NEA_storage(F,T,x,FD)  
% This subfunction perfoms the input and output oriented storage
% normalized environ analysis
% *******************************************************************
global I n
% Direct storage matrices
C=FD*inv(diag(x));         	% fij/xj for i,j=1:n -- output matrix
CP=inv(diag(x))*FD;       	% fij/xi for i,j=1:n -- input matrix
dt=-1/floor(min(diag(C)));	% smallest whole number to make diag(C) nonnegative
P=I+C*dt;                   % non-dimensional direct output storage matrix
PP=I+CP*dt;                	% non-dimensional direct input storage matrix
% Integral storage matrices
S=-inv(C);		    	% dimensionalized integral output community matrix
SP=-inv(CP);	    	% dimensionalized integral input community matrix
Q=inv(I-P);		    	% integral output storage matrix -- I+P+P^2+P^3+...
QP=inv(I-PP);	    	% integral input storage matrix -- I+PP+PP^2+PP^3+...
dQ=diag(Q)	;	    	% diag of integral output storage matrix (=diag(QP))

% Storage environ properties
% ********************************************************************
p=ones(n,1);		    	% ones vector
TSTcs=sum(((dQ-p)./dQ).*T);	% cycled (mode 2) throughflow
TSTs=sum(T);		    	% total system throughflow
CIS=TSTcs/TSTs;		    	% cycling index (storage)

% Amplification parameter
NAS=length(find((Q-diag(diag(Q)))>1));	    
NASP=length(find((QP-diag(diag(QP)))>1));

% Indirect effects parameter
IDS=sum(sum(Q-I-P))/sum(P(:));	    % indirect to direct ratio (output matrix)
IDSP=sum(sum(QP-I-PP))/sum(PP(:));  % indirect to direct ratio (input matrix)	

% Homogenization parameter
CVP=std(P(:))/mean(P(:));	    	% Coefficient  of variation for G
CVQ=std(Q(:))/mean(Q(:));   	    % Coefficient  of variation for N
HS=[CVP/CVQ];				    	% homogenization parameter (output storage)

CVPP=std(PP(:))/mean(PP(:));		% Coefficient  of variation for GP
CVQP=std(QP(:))/mean(QP(:));		% Coefficient  of variation for NP
HSP=[CVPP/CVQP];			    	% homogenization parameter (input storage)

stor_ep=[CIS,NAS,NASP,IDS,IDSP,HS,HSP];

% -------------------------------------------------------------------------
% SUBFUNCTION_4: Utility Analysis
% -------------------------------------------------------------------------
function [D,DS,U,Y,US,YS,utility_ep]=NEA_utility(FD,T,x)
% *******************************************************************
global I n
% Direct Utility, Throughflow ---------------------------------------
D=inv(diag(T))*(FD-FD')	;   % (fij-fji)/Ti for i,j=1:n, (GP-G') -- utility matrix
e=eig(D);		    		% convergence test
if abs(max(e))>=1           % check for convergence
    disp('WARNING: Throughflow Utility matrix does not converge');
    U=-9999;                %  flag if no convergence
    Y=-9999;                %  flag if no convergence
    NSF=-9999; PNF=-9999;   %  flag if no convergence
else
    % Integral Utility, Throughflow
	U=inv(I-D);	          	% Nondimensional integral flow utility
	Y=diag(T)*U;		    % Dimensional integral flow utility
    
    % Throughflow Utility Indices    
    NSF=bcratio(Y);		    % flow benefit cost ratio (calls other function) (Synergism)
	B=[1 1;1 -1];			% coefficient matrix
	Z=[n^2;sum(sum(sign(U)))]; % vector with total n and addition of all entries
	X=B\Z;					% solve for number of positive and negative signs
	PNF=X(1,1)/X(2,1);		% ratio of positive to negative signs (mutualism)
end     

% Direct Utility, Storage --------------------------------------------
DS=inv(diag(x))*(FD-FD');	% (fij-fji)/xi for i,j=1:n, (CP-C') -- utility matrix
e=eig(DS);
if abs(max(e))>=1       % check for convergence
    disp('WARNING: Storage Utility matrix does not converge');
    % Integral Utility, Storage
	US=-9999;		    % flag if no convergence
	YS=-9999;		    % flag if no convergence
    NSS=-9999; PNS=-9999;% flag if no convergence
else
    % Integral Utility, Storage
	US=inv(I-DS);		% Nondimensional integral storage utility
	YS=diag(T)*US;		% Dimensional integral storage utility
    
    % Storage Utility Indices
    NSS=bcratio(YS); 	% storage benefit cost ratio (calls other function)
    B=[1 1;1 -1];		% coefficient matrix
	Z=[n^2;sum(sum(sign(US)))]; % vector with total n and addition of all entries
	X=B\Z;				% solve for number of positive and negative signs
	PNS=X(1,1)/X(2,1);	% storage ratio of positive to negative signs
end     

utility_ep=[NSF,PNF,NSS,PNS];

% -------------------------------------------------------------------------
% SUBFUNCTION_5: Unit Environs
% -------------------------------------------------------------------------
function [E,EP,SE,SEP,environ_error_tol]=NEA_u_environs(G,N,GP,NP,P,Q,PP,QP)
% This subfunction calculates the unit environs (input, output,
% throughflow, and storage) for the given system.  Noticeable numerical
% error is usually apparent in the resultant matricies. Here, I use the
% subfunction "environ_error" removes an arbitrary amount of error by
% setting values less than "environ_error_tol" to 0.  A more appropriate way
% might be to round the values to a particular decimal place.

% IMPORTANT:  Check the error tolerance level to make sure it is
% appropriate
% *************************************************************************

global I n
E=zeros(n+1,n+1,n); EP=zeros(n+1,n+1,n); 
SE=zeros(n+1,n+1,n); SEP=zeros(n+1,n+1,n);
	    % these statements dimensionalize E, EP, SE, and SEP as 3-D
	    % variables.
        
environ_error_tol=1e-10; 
% The value of this is arbitrary. Other ways to set this variable are possible.

% Throughflow unit environs ----------------
for i=1:n
	E(1:n,1:n,i)=G*diag(N(:,i));
	E(1:n,1:n,i)=E(1:n,1:n,i)-diag(N(:,i));
	E(n+1,1:n,i)=sum(-E(1:n,1:n,i));
    E(1:n,n+1,i)=sum(-E(1:n,1:n,i)')';		% unit output flow environs
    E=environ_error(E,environ_error_tol); % AUX1
end

for i=1:n
	EP(1:n,1:n,i)=diag(NP(i,:))*GP;
	EP(1:n,1:n,i)=EP(1:n,1:n,i)-diag(NP(i,:));
	EP(1:n,n+1,i)=sum(-EP(1:n,1:n,i)')';
    EP(n+1,1:n,i)=sum(-EP(1:n,1:n,i));		% unit input flow environs
    EP=environ_error(EP,environ_error_tol); % AUX1
end

% Storage unit environs	--------------------
for i=1:n
	SE(1:n,1:n,i)=P*diag(Q(:,i));
	SE(1:n,1:n,i)=SE(1:n,1:n,i)-diag(Q(:,i));
	SE(n+1,1:n,i)=sum(-SE(1:n,1:n,i));
    SE(1:n,n+1,i)=sum(-SE(1:n,1:n,i)')';	% unit output storage environs
    SE=environ_error(SE,environ_error_tol); % AUX1
end
for i=1:n
	SEP(1:n,1:n,i)=diag(QP(i,:))*PP;
	SEP(1:n,1:n,i)=SEP(1:n,1:n,i)-diag(QP(i,:));
	SEP(1:n,n+1,i)=sum(-SEP(1:n,1:n,i)')';
	SEP(n+1,1:n,i)=sum(-SEP(1:n,1:n,i));	% unit input storage environs
    SEP=environ_error(SEP,environ_error_tol); % AUX1
end

% ------------------------------------------------
% SUBFUNCTION_6: Control Analysis
% ------------------------------------------------
function [CN,CQ,CN_diff, CQ_diff]=NEA_control(N,NP,Q,QP)
% This subfunciton calculates the ratio control or dominance matrix. 
%*************************************
global I n
warning off MATLAB:divideByZero %temporarily turn off divide by 0 warning
% Throughflow
CN_temp=N./NP'; 
j=find(CN_temp<1 & CN_temp>=0); 
CN=zeros(n);
CN(j)=1-CN_temp(j);

% Storage
CQ_temp=Q./QP'; 
i=find(CQ_temp<1 & CQ_temp>=0); 
CQ=zeros(n);
CQ(j)=1-CQ_temp(j);

warning on MATLAB:divideByZero %turn on divide by 0 warning

% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% =-=-=-=-=-=-=              AUXILIARY PROGRAMS           =-=-=-=-=-=-=-=-=
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

% -------------------------------------------------------------------------
% AUX1: Unpack (AUXILIARY PROGRAM)
% -------------------------------------------------------------------------
function [F, y, z, x]=unpack(DATA)
% function [F, y, z, x]=unpack2(DATA), where data= n+1 x n+2 matrix when 
% n=number of network nodes function that unpacks data from a condensed 
% format.  data matrix contains F,z,x,y
% data unpack
% Stuart R. Borrett | 2002
% *************************

n=length(DATA)-2;
F=DATA(1:n,1:n);
y=DATA(n+1,1:n);
z=DATA(1:n,n+1);
x=DATA(1:n,n+2);

% -------------------------------------------------------------------------
% AUX2: Environ Error (AUXILIARY PROGRAM)
% -------------------------------------------------------------------------
function ret=environ_error(E,tolerance)
% ret=environ_error2(E), where E is a 3-D environ matrix
% This program removes some numerical error by replacing very small values 
% (under the error tolerance) with a 0.  The suggested error level is 1e-10, 
% although there is no formal reason for choosing this level.  Further 
% analysis is needed to determine the most appropriate level.
% ***************************************************

et=tolerance;           % error tolerance level
[m,n,o]=size(E);
L=m*n*o;
for i=1:L
    if E(i)>0&E(i)<et
        E(i)=0;
    end
    if E(i)<0&E(i)>(-1*et)
        E(i)=0;
    end 
end
ret=E;
   
% -------------------------------------------------------------------------
% AUX3: Bcratio (AUXILIARY PROGRAM)
% -------------------------------------------------------------------------
function r=bcratio(Y);
%  This calculates the ratio of sum of positive to sum of
%  negative interactions in the system.  
%  The B matrix sets up a pair of linear equations where
%  pos+neg=sum(sum(abs(Y))) and pos-neg=sum(sum(Y))
%  This set of equations is solved, X, and a ratio is taken.
%  The next line zeros out the diagonal elements
%  Y=Y-diag(diag(Y));
% **********************************************************

plus=sum(sum(abs(Y)));
minus=sum(sum(Y));
B=[1 1;1 -1];
Z=[plus;minus];
X=B\Z;
r=X(1,1)/X(2,1); 

% -------------------------------------------------------------------------
% AUX4: MODE (AUXILIARY PROGRAM)
% -------------------------------------------------------------------------
function [T0,T1,T2,T3,T4]=mode(N,z);
% This function partitions flow into five different modes.  Mode 0 is
% the boundary input -- flow that reaches a compartment from across the 
% system boundary.  Mode 1 is internal first passage flow -- total internal
% flow from compartment j to compartment i for the first time along all
% available pathways (including cycles that do not touch i).  Mode 2 is
% cycled flow -- total contribution that returns to a compartment after its
% initial visit.  Modes 3 and 4 are dissipative equivalents to Modes 1 
% and 0, respectively.
% *****************************************************
global I n
mode0=diag(I*z);
mode1=inv(diag(diag(N)))*N*diag(z)-diag(I*z);
mode2=(diag(diag(N))-I)*inv(diag(diag(N)))*N*diag(z);
TSC = sum((diag(diag(N))-I)*inv(diag(diag(N)))*N*diag(z));
T0=sum(sum(mode0));
T1=sum(sum(mode1));
T2=sum(sum(mode2));
T3=T1;
T4=T0;
T=T0+T1+T2;
