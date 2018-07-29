                    function lagren
% *****************************************************************
%                   Universal Program LAGREN
% *****************************************************************
%
% PURPOSE:
%   - Derives differential equatiopns of motion of a mechanical
%     system  with arbitrary degree of freedom 's' by means of
%     LAGRANGE equations:
%         d/dt(dL/dqtj)- dL/dqj = QNj, j = 1, 2, ..., s ;
%   - Generate automatic the file-function, wich describes right-
%     hand sides of canonical differential equations system;
%   - Integrates the equations numerically and plots the graphics
%     of the coordinates, velocities and phase planes.
%     For systems with one degree of freedom, could find analytical
%     solution, if possible.
% 
% INPUT DATE:
%   s - degree of freedom of the system;
%   L = L(t,q1,q2,...,qs,qt1,qt2,...,qts)- Lagrangian;
%   QN{j} = F(t,q1,q2,...,qs,qt1,qt2,...,qts)- generalized
%   non potential forces (array of cells), j = 1,2,...,s ;
%   np - number of parameters;
%   P{1}, P{2}, ..., P{np} - names of the parameters (array of cells);
%   qj0  = [q10,q20,...,qs0] - vector initial coordinates;
%   qtj0 = [qt10,qt20,...,qts0] - vector initial velocities;
%   Tend - upper bound of the integration;
%   eps  - precision of the computations.
%
% NOTES:
%   1. The coordinates are designed by the symbols q1,q2,...,qs;
%   2. The velocities are designed by the symbols qt1,qt2,...,qts;
%   3. The physical names of the parameters are assigned to the
%      cells of the array P like this: P{1}='m1', P{2}='alfa',...;
%   4. All the data can be input from file or in interactive mode;
%   5. If, for a mechanical system with 1 degre of fredom, you think
%      to try an analytical solution, you have to enter initial
%      coordinate qj0 and initial velocity qtj0 as strings like this:
%         qj0  = 'q0';  ( or qj0  = '0.1';)
%         qtj0 = 'qt0'; ( or qtj0 = '7.0';)
%      After you have got the analytical solution and save it in a file,
%      you can immediately continue with the numerical solution. Than,
%      if qj0 and qtj0 have been symbols, you will be prompted to enter 
%      there numerical values!
%
% EXAMPLE of DATA FILE:
%  % Problem: Elliptical Pendulum
%    s = 2;                % Degree of freedom
%    L = ['1/2*(m1+m2)*qt1^2 + 1/2*m2*l^2*qt2^2 + ',...
%            'm2*l*qt1*qt2*cos(q2) - 1/2*c*q1^2 + ',...
%            '9.81*m2*l*cos(q2)']; % Lagrangean
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
disp(' How will you input the data? ');
disp('   1. From a DATA file;       ');
disp('   2. In interactive mode.    ');
ans = input(' Enter Your choice (1 or 2): ');
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
    % Input the DATA in-line mode
    disp(' ');
    s = input(' Degree of freedom s = ');
    L = input(' Lagrangian L = ','s');
    for j = 1:s
        QN{j} = input([' Generalized non potential force QN',...
                         num2str(j),' = '],'s');
    end
    qj0  = input(' Vector initial coordinates [q10,q20,...,qs0] = '  );
    qtj0 = input(' Vector initial velocities [qt10,qt20,...,qts0] = ');
    Tend = input(' Upper bound of the integration Tend = '           );
    eps  = input(' Precision of the calculations eps = '             );
    np   = input(' Number of the parameters np = '                   );
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

disp('                                                    ')
disp('      D i f f e r e n t i a l   E q u a t i o n s   ')
disp('   *************************************************')
disp('                                                    ')
for j = 1:s
  % Computing the partial derivatives
  jj = num2str(j);
  L1 = diff( L, ['qt',jj]);
  L2 = diff( L, ['q' ,jj]);
  % Substitution of 'qj' with 'qj(t)' 
  % and 'qtj' with 'qtj(t)' in dL/dqtj
  for i = 1:s
    i = num2str(i);
    L1 = subs( L1, {['q' ,i],['qt',i]}, ...
                   {['q' ,i,'(t)'],['qt' ,i,'(t)']});
  end
  % Obtaining of the Lagrange Equations
  deq{j} = diff(L1,'t')- L2 - QN{j}; 
  % Equalizing of the designations in the Diff. Equations:
  %              diff(qti(t),t).. -->  D2qi
  %              diff(qi(t),t)... -->  Dqi
  %              qti(t).......... -->  Dqi
  %              qti............. -->  Dqi
  %              qi(t)........... -->  qi
  for i = 1:s
    i = num2str(i); 
    deq{j} = maple('subs',['{diff(qt',i,'(t),t) = D2q',i],...
                          ['diff(q',i,'(t),t) = Dq',i],...
                          ['qt',i,'(t) = Dq',i],...
                          ['qt',i,'= Dq',i],...
                          ['q',i,'(t) = q',i,'}'],deq{j});
  end
  eval(['deq',jj,'= deq{',jj,'}']);
end

% ---------------------------------------------------------
%                  ANALYTICAL SOLUTION
% =========================================================

if s == 1
 disp(' ');
 ans = input(' Would you like analytical solution? (Y/N): ','s');
 if ans =='Y' | ans == 'y'
    if ~isstr(qj0) , qj0  = num2str(qj0) ; end % Repairing user
    if ~isstr(qtj0), qtj0 = num2str(qtj0); end % input errors!
    syms q1
    inicond = ['q1(0)=',qj0,',Dq1(0)=',qtj0];
    q1 = dsolve(char(deq1), inicond, 't');
    if ~isempty(q1)
        disp(' ');
        disp('   Low of Motion   ');
        disp(' ***************** ');
        disp(' ');
        disp('q1 = '); pretty(q1)
        disp(' ');
        fname = input(' Name of file to write solution: ','s');
        save(fname, 'q1');
    end
    disp(' ');
    ans = input(' Would you like numerical solution? (Y/N): ','s');
    if ans == 'N' | ans == 'n', return, end 
    q1 = 'q1'; % Clear contents of q1 !
 end
end

% ---------------------------------------------------------
%                  NUMERICAL SOLUTION
% ========================================================= 

% Input the name of the file-function
disp(' ');
fname = input(' Name of the File-function to be generated: ','s');
flag1 = 'Y';
if exist([cd,'\',fname]) % Search only in current directory!
    disp(' ');
    disp([' A file-function with name ',fname,' already exist !'])
    flag1 = input(' Overwrite it ? (Y/N): ', 's');
end

% ---------------------------------------------------------
%              GENERATING THE FILE-FUNCTION
% ---------------------------------------------------------

if ( flag1 == 'Y' | flag1 == 'y' )
% Opening the file for writing file-function
   [Fid,mes] = fopen([fname,'.m'],'wt');
%
% Computing of the inertial matrix À
%
   A{1,1} = maple('coeff',deq{1},'D2q1');
   if s > 1
       for i = 2:s
           ii = int2str(i);
           A{i,i} = maple('coeff',deq{i},['D2q',ii]);
           for j = 1:i-1
               jj = num2str(j);
               A{i,j} = maple('coeff',deq{i},['D2q',jj]);
               A{j,i} = A{i,j};
           end
       end
   end
%
% Computing of the right-hand sides 'b' of the DE-s 
%
   strD2q0 = '{D2q1=0'; % string, equating generalized
   if s > 1             % accelerations to zero
       for i = 2:s
           i = num2str(i);
           strD2q0 = [strD2q0,',D2q',i,'=0'];
       end
   end
   strD2q0 = [strD2q0,'}'];
   for i = 1:s
       b{i} = -maple('subs',strD2q0,deq{i});
   end
%
% --------------------------------------------------------
%  In matrix À and in vector b are made the substitutions 
%        qj  = y(j)
%        qtj = y(s+j),
%  to reduce the DE to the system of first order.
% --------------------------------------------------------

%  - Generating the substitutions string 'cansubs':
%     {q1=y(1),q2=y(2),...,qs=y(s),
%      Dq1=y(s+1),Dq2=y(s+2),...,Dqs=y(2s)}
%
   s1 = num2str(s+1);
   cansubs = ['{q1=y(1),Dq1=y(',s1,')'];
   for j = 2:s
       jj = num2str(j);
       spj = num2str(s+j);
       cansubs = [cansubs,',q',jj,'=y(',jj,'),Dq',jj,...
                                  '=y(',spj,')'];
   end
   cansubs = [cansubs,'}'];
%  - Performing the substitutions
   for i = 1:s
       b{i} = maple('subs',cansubs,b{i});
       for j = 1:s
           A{i,j} = maple('subs',cansubs,A{i,j});
       end
   end
% Generating the string with physical parameters m1,m2,...
   strpar = '';
   for j = 1:np
      strpar = [strpar,',',P{j}];
   end
   disp(' ');
   titl = input(' Denomination of the Problem: ','s');
%       Writing the headline of the File-function
   fprintf(Fid,['function yt = ',fname,'(t,y',strpar,')\n']);
   fprintf(Fid,['%% ',titl]);
%       Writing the inertial matrix A
   fprintf(Fid,'\n%% The inertial matrix À\n');
   fprintf(Fid,'  A = [');
   for i = 1:s % obtaining and writing the i-th row of matrix
       for j = 1:s
           switch j
               case 1
                  fprintf(Fid,[' ',char(A{i,j})]);
               otherwise
                  fprintf(Fid,[', ',char(A{i,j})]);
           end
       end
       if i == s, break, end
       fprintf(Fid,';\n       ');   
   end
   fprintf(Fid,' ]; \n');
%       Writing the vector of right-hand sides b
   fprintf(Fid,'%% Vector of right-hand sides b \n');
   fprintf(Fid,'  b = [ ');
   for i = 1:s 
       fprintf(Fid,char(b{i}));
       if i == s, break, end
       fprintf(Fid,';\n        ');   
   end
   fprintf(Fid,' ]; \n');
%
%       Writing the last part of the File-function
   fprintf(Fid,'%% Computing the generalized accellerations \n');
   fprintf(Fid,['  a = A\\b;',' \n']);
   fprintf(Fid,'%% Computing the first derivatives \n');           
   ss = num2str(s);
   s1 = num2str(s+1);
   s2 = num2str(2*s);
   fprintf(Fid,['  yt(1:',ss,') = y(',s1,':',s2,'); \n']);
   fprintf(Fid,['  yt(',s1,':',s2,') = a(1:',ss,'); \n']);
   fprintf(Fid,'  yt = yt'';\n');
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
if s ==1
   % Check-up type of qj0 and qtj0 and correct
   % it if needed
   if ischar(qj0)
       qj0 = str2num(qj0);
       if isempty(qj0), qj0 = input(' qj0 = '); end
   end
   if ischar(qtj0)
       qtj0 = str2num(qtj0);
       if isempty(qtj0), qtj0 = input(' qtj0 = '); end
   end
end
while 1
    if flag2 == 1
        disp(' ');
        eps  = input(' Precision of the computations eps: '      );
        Tend = input(' Upper bound of the integration Tend: '    );
        qj0  = input(' Initial coordinates [q10,q20,...,qs0]: '  );
        qtj0 = input(' Initial velocities [qt10,qt20,...,qts0]: ');
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
    for i = 1:s
        j = num2str(i);
        y1min = min(y(:,i)); 
        y1max = max(y(:,i));
        y2min = min(y(:,i+s)); 
        y2max = max(y(:,i+s));
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
        comet(t,y(:,s+i))
        plot(t,y(:,s+i),[tmin tmax],[0 0],'k'), grid on
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
        subplot(2,1,2), plot(t,y(:,s+i),[tmin tmax],[0 0],'k'),grid on
        axis([tmin, tmax, ymin, ymax]);
        set(gca,'FontName','Arial','FontSize',12);
        title(['Generalized velocity {\it qt}',j,' = {\it qt}',j,'({\itt})'])
        pause
        % Phase Plane
        figure % 4 
        subplot(1,1,1)
        comet(y(:,i),y(:,s+i))
        plot(y(:,i),y(:,s+i), [xmin,xmax],[0 0],'k',...
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

%  ***************** End of Program LAGREN *******************
