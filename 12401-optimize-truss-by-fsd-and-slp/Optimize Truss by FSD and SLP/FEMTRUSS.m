%*************************************************************************
%***              FINITE ELEMENT ANALYSIS FOR PLANE TRUSS              ***
%***                     Nguyen Quoc Duan : I-2-1-b                    ***
%*************************************************************************
%             This is a practise exercise on Optimizing Structures

%                     University of Liege - EMMC 
%            ( European Master in Mechanics of Constructions )
%  Professor : Bui Cong Thanh (Faculty of Civil Engineering-HCMUT,Vietnam)
%  Student   : Nguyen Quoc Duan (EMMC11 - Ho Chi Minh City, Vietnam )


clear all; close all; clc;

disp(' The program is working. Please wait for a while, professor !');
disp ('DIMENSIONS IN : KN-cm ')
format short ;

% INITIAL DATA

L=300   ;   % L = 3m = 300 cm
h=300   ;   % h = L = 300 cm
P=25    ;   % P = 25 kN : concentrated load 
E=2e4   ;   % Elastic modulus of the material (kN/cm2)
sigU=16 ;   % Upper bound of stresses (kN/cm2)
sigL=-16;   % Lower bound of stresses (kN/cm2)


% INPUT DATA

%-------------------------------------------------------------------------
%                      control input data
%-------------------------------------------------------------------------

nel=7;           % number of elements
nnel=2;          % number of nodes per element
ndof=2;          % number of dofs per node
edof=nnel*ndof;  % number of dofs per element    
nnode=5;         % total number of nodes in system
sdof=nnode*ndof; % total system dofs  

%-------------------------------------------------------------------------
%                       nodal coordinates
%-------------------------------------------------------------------------

gcoord(1,1)=0.0 ;   gcoord(1,2)=0.0 ;  
gcoord(2,1)=L   ;   gcoord(2,2)=0.0 ;   
gcoord(3,1)=2*L ;   gcoord(3,2)=0.0 ;  
gcoord(4,1)=L   ;   gcoord(4,2)=h   ;  
gcoord(5,1)=2*L ;   gcoord(5,2)=h   ;

X=zeros(nnode,1);   % x-coordinates of nodes
Y=zeros(nnode,1);   % y-coordinates of nodes

for inode=1:nnode
    X(inode)=gcoord(inode,1);
    Y(inode)=gcoord(inode,2);
end
    
%-------------------------------------------------------------------------
%                       nodal connectivity
%-------------------------------------------------------------------------

nodes(1,1)=1;  nodes(1,2)=2;   
nodes(2,1)=2;  nodes(2,2)=3;   
nodes(3,1)=1;  nodes(3,2)=4;   
nodes(4,1)=2;  nodes(4,2)=4;   
nodes(5,1)=4;  nodes(5,2)=3;   
nodes(6,1)=3;  nodes(6,2)=5;   
nodes(7,1)=4;  nodes(7,2)=5;   

% Length of bar 
Lbar = zeros(nel,1);
for i=1:nel
    Lbar(i)=sqrt((X(nodes(i,2))-X(nodes(i,1)))^2+...
                +(Y(nodes(i,2))-Y(nodes(i,1)))^2);
end

%-------------------------------------------------------------------------
%                   material and geometric properties
%-------------------------------------------------------------------------

syms X1 X2 X3 real      % cross-section area variables  (cm2)
A=[X1 X1 X2 X2 X2 X3 X3]';   % cross-section area matrix of elements


% ------------------------------------------------------------------------
%                       MESH CONFIGURATION
% ------------------------------------------------------------------------
figure;  
h=gcf;
set(h,'name','Truss form');
set(h,'NumberTitle','off');
axis equal;
title('Undeformation Truss Form');

m=zeros(nel,2); % matrix of beginning nodes of the elements
n=zeros(nel,2); % matrix of ending nodes of the elements

for iel=1:nel
    m(iel,:)=[X(nodes(iel,1)) Y(nodes(iel,1))];
    n(iel,:)=[X(nodes(iel,2)) Y(nodes(iel,2))];
end

for iel=1:nel
    x=[m(iel,1) n(iel,1)];
    y=[m(iel,2) n(iel,2)];
    if iel==1 | iel==2
        plot(x,y,'r','LineWidth',3);
    elseif iel==3 | iel==4 | iel==5
        plot(x,y,'b','LineWidth',3);
    else
        plot(x,y,'g','LineWidth',3);
    end
    
     % locate the order number of elements at the midpoint
    text((x(1)+x(2))/2,(y(1)+y(2))/2,num2str(iel)); 
    hold on;
end
 
   % locate the order number of nodes 
   for inod=1:nnode
   text(X(inod),Y(inod),num2str(inod));
   end
 
%-------------------------------------------------------------------------
%                       applied constraints
%-------------------------------------------------------------------------

bcdof(1)=1;      % 1st dof (horizontal displ) is constrained
bcval(1)=0;      % whose described value is 0 
bcdof(2)=2;      % 2nd dof (vertical displ) is constrained
bcval(2)=0;      % whose described value is 0
bcdof(3)=6;      % 6th dof (horizontal displ) is constrained
bcval(3)=0;      % whose described value is 0 
bcdof(4)=9;      % 9th dof (horizontal displ) is constrained
bcval(4)=0;      % whose described value is 0 

%-------------------------------------------------------------------------
%                       initialization to zero
%-------------------------------------------------------------------------

ff=sym(zeros(sdof,1));              % system force vector
kk=sym(zeros(sdof,sdof));           % system stiffness matrix
SS=sym(zeros(nel,sdof));
index=zeros(nnel*ndof,1);           % index vector
elforce=zeros(nnel*ndof,1);         % element force vector
eldisp=sym(zeros(nnel*ndof,1));     % element nodal displacement vector
k=sym(zeros(nnel*ndof,nnel*ndof));  % element stiffness matrix
stress=sym(zeros(nel,1));           % stress vector for every element

%------------------------------------------------------------------------
%                       applied nodal force
%------------------------------------------------------------------------

ff(8)=-P;      % the 4th node has the force P in the downward direction
ff(10)=-2*P;    % the 5th node has the force 2P in the downward direction

for iel=1:nel             % loop for the total number of elements
    nd(1)=nodes(iel,1);   % 1st connected node i for the (iel)-th element
    nd(2)=nodes(iel,2);   % 2nd connected node j for the (iel)-th element
    x1=X(nd(1));          % x-coordinate of 1st node i
    y1=Y(nd(1));          % y-coordinate of 1st node i
    x2=X(nd(2));          % x-coordinate of 1st node j
    y2=Y(nd(2));          % y-coordinate of 1st node j
    leng=(sqrt((x2-x1)^2+(y2-y1)^2));   % the length of the element
    c=(x2-x1)/leng;   % cosin between element and x-coordinate direction
    s=(y2-y1)/leng;   % sin between element and x-coordinate direction
    index=feeldof(nd,nnel,ndof);     % system dofs of the iel-th element
    [k]=fetruss(E,leng,A(iel),c,s);  % Compute stiffness matrix 
    [kk]=feasmbl(kk,k,index);        % Assembly into the system matrix
    S=(E/leng)*[-c -s c s];
    edof=length(index);
    for i=1:edof
        ii=index(i);
        SS(iel,ii)=SS(iel,ii)+S(i);   % stresses matrix
    end
end

%-------------------------------------------------------------------------
%               apply constraints and solve the matrix
%-------------------------------------------------------------------------

[kk,ff]=feaplyc(kk,ff,bcdof,bcval);  % apply the boundary conditions

displacement=simplify(kk\ff);   % solution for nodal displacements

stress=simplify(SS*displacement);   % stresses of bars 

stress
displacement

save femtruss A stress Lbar;

disp('***************************************************************');
disp('***                      Completed !                        ***');
disp('***   THANK YOU FOR YOUR INTERESTING LECTURES, PROFESSOR !  ***');
disp('***************************************************************');




