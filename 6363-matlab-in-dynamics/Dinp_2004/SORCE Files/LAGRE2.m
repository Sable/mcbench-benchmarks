                       function lagre2
% *******************************************************************
%                      P r o g r a m    LAGRE2
% *******************************************************************
%
% PURPOSE:
%    Derive differential equations of motion of a mechanical system
%    with two degree of freedom by means of Lagrange equations
%         d/dt(dL/dqt1) - dL/dq1 = QN1(t,q1,q2,qt1,qt2); 
%         d/dt(dL/dqt2) - dL/dq2 = QN2(t,q1,q2,qt1,qt2);
%    Resolve the equations numerically and plots the graphics
%    of the coordinates, velocities and phase planes.
%
% INPUT DATA:
%    L    - åxpression of the Lagrangian  L = L(t, q1, q2, qt1, qt2);
%    QN1  - generalized non potential force QN1 = QN1(t,q1,q2,qt1,qt2);
%    QN2  - generalized non potential force QN2 = QN2(t,q1,q2,qt1,qt2);
%    qj0  - vector initial values of the coordinates;
%    qtj0 - vector initial values of the velocities;
%    Tend - upper bound of the integration;
%    eps  - precision of the calculations;
%    np   - number of parameters .
%    P{1}, P{2}, ..., P{np} - names of the parameters (array of cells);
%
% NOTES:
%   1. The coordinates are designed by the symbols 'q1', 'q2'
%      and velocities by 'qt1', 'qt2';
%   2. The physical names of the parameters are assigned to the
%      cells of the array P like this: P{1}='m', P{2}='c',...;
%   3. All the data can be input from file or in interactive mode.
% 
% EXAMPLE of DATA FILE:
%  % Problem: Elliptical Pendulum
%    L = ['1/2*(m1+m2)*qt1^2 + 1/2*m2*l^2*qt2^2 + ',...
%            'm2*l*qt1*qt2*cos(q2) - 1/2*c*q1^2 + ',...
%            '9.81*m2*l*cos(q2)']; % Lagrangian
%    QN{1} = '-alfa*qt1';  % Generalized
%    QN{2} = '-k*qt2';     % non potential forces
%    qj0   = [0.02, 0];    % Initial coordinates
%    qtj0  = [0.1, 0];     % Initial velocities
%    Tend  = 20;           % Upper bound of integration
%    eps   = 1.e-8;        % Precision of computations
%    np    = 6;            % Number of parameters
%    P{1}  = 'm1';         % Name assignation of the
%    P{2}  = 'm2';         % physical parameters
%    P{3}  = 'l';
%    P{4}  = 'c';
%    P{5}  = 'alfa';
%    P{6}  = 'k';

% ---------------------------------------------------------
%                DATA INPUT OF THE PROBLEM
% =========================================================

 clear
 disp(' ');
 disp(' How will you input the data ?    ');
 disp('     1. From a data file;         ');
 disp('     2. In interactive mode.      ');
 ans = input(' Number of Your choice : '  );
 flag = 0;
 if ans == 1
    while 1
       disp(' ');
       indat = input(' Input the name of the data file :', 's');
       if exist([cd,'\',indat]) % Search only in current directory
          eval(indat);
          flag = 1; break  % Successful
        else               % Unsuccessful
          disp(' ');
          disp([' File ',indat,' not exist!'])
          disp(' You have to:')
          disp(' 1. Enter another DATA file name, or')
          disp(' 2. Input the DATA interactively !')
          ans2 = input(' Your choice, please: ');
          if ans2 == 2, break , end
       end
    end
 end
if flag == 0  
    %Input of the data in-line mode
    L    = input(' Expression of the Lagrangian  L : ','s'          );
    QN1  = input(' Generalized unpotential force QN1 : ','s'        );
    QN2  = input(' Generalized unpotential force QN2 : ','s'        );
    qj0  = input(' Initial values of the coordinates [q10, q20]: '  );
    qtj0 = input(' Initial values of the velocities [qt10, qt20] : ');
    Tend = input(' Upper bound of the integration Tend : '          );
    eps  = input(' Precision of the calculations eps : '            );
    np   = input(' Number of parameters  np : '                     );
    % Asigning names of the parameters
    if np > 0
       disp(' ');
       disp(' Enter names of the parameters:')
       for i = 1:np
           ii = num2str(i);
           P{i} = input([' Name of parameter P',ii,': '],'s');
       end
    end 
 end
 
% ---------------------------------------------------------
%          DERIVING THE DIFFERENTIAL EQUATIONS
% =========================================================

 syms t q1 qt1 qtt1 q2 qt2 qtt2
 Lqt1 = diff(L,qt1);
 deq1 = diff(Lqt1,q1)*qt1 + diff(Lqt1,qt1)*qtt1 + ...
        diff(Lqt1,q2)*qt2 + diff(Lqt1,qt2)*qtt2 + ...
        diff(Lqt1,t) - diff(L,q1) - QN1;
 Lqt2 = diff(L,qt2);
 deq2 = diff(Lqt2,q1)*qt1 + diff(Lqt2,qt1)*qtt1 + ...
        diff(Lqt2,q2)*qt2 + diff(Lqt2,qt2)*qtt2 + ...
        diff(Lqt2,t) - diff(L,q2) - QN2;      
 deq1 = simple(deq1);
 deq2 = simple(deq2);
 disp(' ');
 disp('     *******************************************  ')
 disp('       D i f f e n t i a l   E q u a t i o n s    ')
 disp('     *******************************************  ')
 disp(' ');
 disp([' DEq1: ' ,char(deq1), ' = 0']);
 disp(' ');
 disp([' DEq2: ' ,char(deq2), ' = 0']);

% ---------------------------------------------------------
%                  NUMERICAL SOLUTION
% ========================================================= 

% Input the name of the file-function
disp(' ');
fname = input(' Name of the File-function to be generated: ','s');
flag1 = 'Y';
if exist([cd,'\',fname]) % Search only in curent directory!
    disp(' ');
    disp([' A file-function with name ',fname,' already exist !'])
    flag1 = input(' Overwrite it ? (Y/N): ', 's');
end

% ---------------------------------------------------------
%              GENERATING THE FILE-FUNCTION
% ---------------------------------------------------------

if ( flag1 == 'Y' | flag1 == 'y' )
% Entering the new variables y1, y2, y3, y4 
   deq1 = subs(deq1, {q1,q2,qt1,qt2},{'y(1)','y(2)','y(3)','y(4)'});
   deq2 = subs(deq2, {q1,q2,qt1,qt2},{'y(1)','y(2)','y(3)','y(4)'});
% Determinig inercial coefficients and right sides of DE's b1 and b2 
   a11 = maple('coeff',deq1,qtt1);
   a12 = maple('coeff',deq1,qtt2);
   a22 = maple('coeff',deq2,qtt2);
   b1 = -subs(deq1,{qtt1,qtt2},{'0','0'});
   b2 = -subs(deq2,{qtt1,qtt2},{'0','0'});
% Opening the file to write file-function
   [Fid,mes] = fopen([fname,'.m'],'wt');
% Generating the string with physical parameters: m, c ...
   strpar = '';
   for j = 1:np
      strpar = [strpar,',',P{j}];
   end
   disp(' ');
   titl = input(' Denomination of the Problem: ','s');
%       Writing the headline of the File-function
   fprintf(Fid,['function yt = ',fname,'(t,y',strpar,')\n']);
   fprintf(Fid,['%% ',titl,'\n']);
%       Determing inertial matrix A and vector b   
   fprintf(Fid,'%% Inertial matrix A \n');
   fprintf(Fid,[' A(1,1) = ', char(a11),';\n']);
   fprintf(Fid,[' A(1,2) = ', char(a12),';\n']);
   fprintf(Fid,[' A(2,1) = ', char(a12),';\n']);
   fprintf(Fid,[' A(2,2) = ', char(a22),';\n']);
   fprintf(Fid,'%% Rigth sides of DE''s \n');
   fprintf(Fid,[' b(1) = ', char(b1),';\n']);
   fprintf(Fid,[' b(2) = ', char(b2),';\n']);
%       Writing the first derivatives
   fprintf(Fid,'%% The first derivatives\n');
   fprintf(Fid,' a = A\\b'';\n');
   fprintf(Fid,' yt(1) = y(3); \n');
   fprintf(Fid,' yt(2) = y(4); \n');
   fprintf(Fid,' yt(3) = a(1); \n');
   fprintf(Fid,' yt(4) = a(2); \n');
   fprintf(Fid,' yt = yt''; \n');
   fprintf(Fid,['%% *** End of File-function ',fname,' ***']);
   fclose(Fid);
   edit(fname)
end

% ---------------------------------------------------------
%        INTEGRATION AND VISUALIZATION OF THE REZULTS
% ---------------------------------------------------------

flag2 = 0;
% Initial entering values of the parameters and generating
% the string with parameters 'P{1}, P{2}, ..., P{np}' to be
% passed to the File-function as actual arguments 
if np > 0
   PP = P; % Saving the physical names of the parameters in PP 
   parameters = ' ';
   disp(' ');
   disp(' Input the numerical values of the parameters: ')
   for i = 1:np
       i = num2str(i);
       eval(['P{',i,'}=input([''   '',P{',i,'},'' = '']);']);
       parameters = [parameters,',P{',i,'}'];
   end 
  else
   parameters = [];
end
while 1
    if flag2 == 1
        disp(' ');
        eps  = input(' Precision of the computations eps: ');
        Tend = input(' Upper bound of the integration Tend: ');
        qj0  = input(' Initial coordinates [q10,q20]: ');
        qtj0 = input(' Initial velocities [qt10,qt20]: ');
        if np > 0
          P = PP; % Restoring the names of the parameters !
          disp(' ');
          disp(' Input the numerical values of the parameters: ')
          for i = 1:np
              i = num2str(i);
              eval(['P{',i,'}=input([''   '',P{',i,'},'' = '']);']);
          end 
        end
    end
    y0 = [qj0 qtj0]; % initial conditions
    options = odeset('AbsTol',eps,'RelTol',100*eps);
    % Choosing of the Solver
    disp('                                        ');
    disp('      Choose the proper Solver:         ');
    disp('  -------------------------------       ');
    disp(' A. Non stiff differential equations    ');
    disp('   1. ode45   - middle precision;       ');
    disp('   2. ode23   - low precision;          ');
    disp('   3. ode113  - from low to upper.      ');
    disp('                                        ');
    disp(' B. Stiff differential equations        ');
    disp('   1. ode15s  - from low to upper;      ');
    disp('   2. ode23s  - low precision;          ');
    disp('   3. ode23t  - middle precision;       ');
    disp('   4. ode23tb - low precision.          ');
    disp('                                        ');
    solver = input(' The name of the Solver: ','s');
   
    % Integration of the Differential Equations
        
    eval(['[t,y] = feval(solver,eval([''@'',fname]),',...
                  '[0 Tend],y0,options',parameters,');']);
    % Plotting graphs
    tmin = min(t); tmax = max(t);
    for i = 1:2
        j = num2str(i);
        y1min = min(y(:,i)); 
        y1max = max(y(:,i));
        y2min = min(y(:,i+2)); 
        y2max = max(y(:,i+2));
        dy1   = y1max - y1min;
        dy2   = y2max - y2min;
        xmin  = y1min - 0.1*dy1;
        xmax  = y1max + 0.1*dy1;
        ymin  = y2min - 0.1*dy2;
        ymax  = y2max + 0.1*dy2;
        % Generalized coordinate
        figure % 1
        comet(t,y(:,i))
        plot(t,y(:,i),[tmin tmax],[0 0],'k'), grid on
                axis([tmin, tmax, xmin, xmax]);
        set(gca,'FontName','Arial Cyr','FontSize',12);
        title(['Low of motion {\itq}',j,' = {\itq}',j,'({\itt})'])
        xlabel('{\itt}'); ylabel(['{\itq}',j]); pause
        % Generalized velocity
        figure % 2
        comet(t,y(:,2+i))
        plot(t,y(:,2+i),[tmin tmax],[0 0],'k'), grid on
        axis([tmin, tmax, ymin, ymax]);
        set(gca,'FontName','Arial','FontSize',12);
        title(['Generalized velocity {\it qt}',j,' = {\it qt}',j,'({\itt})'])
        xlabel('{\itt}'); ylabel(['{\it qt}',j]); pause
        % Coordinate and velocity
        figure % 3
        subplot(2,1,1), plot(t,y(:,i),[tmin tmax],[0 0],'k'),grid on
        axis([tmin, tmax, xmin, xmax]);
        set(gca,'FontName','Arial','FontSize',12);
        title(['Low of motion {\itq}',j,' = {\itq}',j,'({\itt})'])
        subplot(2,1,2), plot(t,y(:,2+i),[tmin tmax],[0 0],'k'),grid on
        axis([tmin, tmax, ymin, ymax]);
        set(gca,'FontName','Arial','FontSize',12);
        title(['Generalized velocity {\it qt}',j,' = {\it qt}',j,'({\itt})'])
        pause
        % Phase Plane
        figure % 4
        subplot(1,1,1)
        comet(y(:,i),y(:,2+i))
        plot(y(:,i),y(:,2+i), [xmin,xmax],[0 0],'k',...
                        [0 0],[ymin,ymax],'k'), grid on
        axis([xmin, xmax, ymin, ymax]);         
        set(gca,'FontName','Arial Cyr','FontSize',12);
        title([' Phase Plane {\it qt}',j,' = {\itf}({\itq}',j,')'])
        xlabel(['{\itq}',j]), ylabel(['{\it qt}',j]), pause
        flag2 = 1;
        close all
    end
    disp(' ');
    ans = input(' Would you like to continue? (Y/N): ','s');
    if ans == 'n' | ans == 'N', break, end
end

%  *************** End of Program LAGRE2 *******************
