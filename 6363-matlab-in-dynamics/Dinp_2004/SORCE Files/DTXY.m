                      function dtxy
% *****************************************************************
%                     P r o g r a m    DTXY
% *****************************************************************
%
%  PURPOSE:
%    Resolve numerically differential equations of plane motion
%    of a particle   m*d2x/dt2 = Fx(t,x,y,xt,yt);
%                    m*d2y/dt2 = Fy(t,x,y,xt,yt),
%     plots trajectory and graphics of coordinates and velocity.
%     If possible, the program could solve the problem analytically.
%
%  INPUT DATA:
%     m    - mass of the body ;
%     Fx   - sum of projections of forces on axis x ;
%     Fy   - sum of projections of forces on axis y ;
%     x0   - initial value of the coordinate x ;
%     y0   - initial value of the coordinate y ;
%     v0   - initial value of velocity ;
%     alfa - angle between v0 and horizontal plane;
%     Tend - upper bound of the integration ;
%     eps  - precision of the integration ;
%     np   - number of parameters .
%     P{1}, P{2}, ..., P{np} - names of the parameters (array of cells);
%
%  NOTES:
%   1. The coordinates are designed by the symbols 'x', 'y'
%      and there first derivatives by 'xt', 'yt';
%   2. The physical names of the parameters are assigned to the
%      cells of the array P like this: P{1}='m', P{2}='c',...;
%   3. For analytical solution the values of Tend, eps, np and P are not
%      needed.
%   4. Initial values x0, y0, v0, alfa must to be entered as strings, 
%      even though they represent numbers!
%   5. All the data can be input from file or in interactive mode.
% 
%  EXAMPLE of DATA FILE:
% % Dynamics of a projectile, lanched
% % with initial velocity v0 under 
% % angle "alfa'
%   m    =  'm';
%   Fx   = '-k*xt';
%   Fy   = '-k*yt - m*9.81';
%   x0   = '0';
%   y0   = '0';
%   v0   = 'v0';
%   alfa = 'alfa';
%   Tend = 10;
%   eps  = 1.e-10;
%   np   = 2;
%   P{1} = 'm';
%   P{2} = 'k';

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
    m    = input(' Mass of the body m : ','s'             );
    Fx   = input(' Expression of the projection Fx : ','s');
    Fy   = input(' Expression of the projection Fy : ','s');
    x0   = input(' Initial coordinate x0 : '              );
    y0   = input(' Initial coordinate y0 : '              );
    v0   = input(' Initial velocity v0 : '                );
    alfa = input(' Angle alfa : '                         );
    Tend = input(' Upper bound of the integration Tend : ');
    eps  = input(' Precision of the calculations eps : '  );
    np   = input(' Number of parameters  np : '           );
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
%            Differential Equations of Motion 
% =========================================================
 
             syms t x xt Dx D2x y yt Dy D2y
             Fx = subs(Fx, {xt,yt}, {Dx,Dy});
             Fy = subs(Fy, {xt,yt}, {Dx,Dy});
             deq1 = m*D2x - Fx;
             deq2 = m*D2y - Fy;
             
% ---------------------------------------------------------
%                  ANALYTICAL SOLUTION
% =========================================================

 disp(' ');
 ans = input(' Would you like analytical solution? (Y/N): ','s');
 if ans =='Y' | ans == 'y'
    if ~isstr(x0), x0 = num2str(x0); end
    if ~isstr(y0), y0 = num2str(y0); end
    if ~isstr(v0), v0 = num2str(v0); end
    if ~isstr(alfa), alfa = num2str(alfa); end
    inicond = ['x(0)=',x0,',Dx(0)=','v0*cos(alfa),',...
               'y(0)=',y0,',Dy(0)=','v0*sin(alfa)'];
    [x,y] = dsolve(char(deq1), char(deq2), inicond, 't');
    if ~isempty(x) & ~isempty(y)
       x = simple(x); y = simple(y);
       disp(' ');
       disp('      L o w   o f   M o t i o n   ' );
       disp('   *******************************' );
       disp(' '); disp('x = '); pretty(x)
       disp(' '); disp('y = '); pretty(y)
       disp(' ');
       fname = input(' Name of file to write solution: ','s');
       save(fname, 'x','y');
    end
    disp(' ');
    ans = input(' Would you like numerical solution? (Y/N): ','s');
    if ans == 'N' | ans == 'n', return, end 
    x = 'x'; y = 'y'; % Clear contents of x and y
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
   Fx = subs(Fx,{x,y,Dx,Dy},{'Y(1)','Y(2)','Y(3)','Y(4)'});
   Fy = subs(Fy,{x,y,Dx,Dy},{'Y(1)','Y(2)','Y(3)','Y(4)'});
% Opening the file for writing file-function
   [Fid,mes] = fopen([fname,'.m'],'wt');
% Generating the string with physical parameters: m, c ...
   strpar = '';
   for j = 1:np
      strpar = [strpar,',',P{j}];
   end
   disp(' ');
   titl = input(' Denomination of the Problem: ','s');
%       Writing the headline of the File-function
   fprintf(Fid,['function yt = ',fname,'(t,Y',strpar,')\n']);
   fprintf(Fid,['%% ',titl]);
%       Writing the first derivatives
   fprintf(Fid,'\n%% The first derivatives\n');
   fprintf(Fid, '  yt(1) = Y(3); \n');
   fprintf(Fid, '  yt(2) = Y(4); \n');
   fprintf(Fid,['  yt(3) = ',char(Fx/m),'; \n']);
   fprintf(Fid,['  yt(4) = ',char(Fy/m),'; \n']);
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
% Check-up the type of x0, y0, v0 and alfa  
% and correct it if needed
if ischar(x0)
    x0 = str2num(x0);
    if isempty(x0), x0 = input(' x0 = '); end
end
if ischar(y0)
    y0 = str2num(y0);
    if isempty(y0), y0 = input(' y0 = '); end
end
if ischar(v0)
    v0 = str2num(v0);
    if isempty(v0), v0 = input(' v0 = '); end
end
if ischar(alfa)
    alfa = str2num(alfa);
    if isempty(alfa), alfa = input(' alfa = '); end
end
while 1  
    if flag2 == 1
        disp(' ');
        eps  = input(' Precision of the computations eps: '  );
        Tend = input(' Upper bound of the integration Tend: ');
        x0   = input(' Initial coordinate x0 : '             );
        y0   = input(' Initial coordinate y0 : '             );
        v0   = input(' Initial velocity v0 : '               );
        alfa = input(' Angle alfa : '                        );
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
    inic = [x0 y0 v0*cos(alfa) v0*sin(alfa)]; % initial conditions
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
        
    eval(['[t,Y] = feval(solver,eval([''@'',fname]),',...
                  '[0 Tend],inic,options',parameters,');']);

    % Plotting graphs
   
    tmin  = min(t); tmax = max(t);
    y1min = min(Y(:,1)); 
    y1max = max(Y(:,1));
    y2min = min(Y(:,2)); 
    y2max = max(Y(:,2));
    dy1   = y1max - y1min;
    dy2   = y2max - y2min;
    xmin  = y1min - 0.1*dy1;
    xmax  = y1max + 0.1*dy1;
    ymin  = y2min - 0.1*dy2;
    ymax  = y2max + 0.1*dy2;
    figure % 1
    % Coordinate x
    plot(t, Y(:,1), [tmin,tmax], [0,0], 'k');
    axis([tmin, tmax, xmin, xmax]);
    xlabel('{\itt}'); ylabel('{\itx}'); grid;
    title('Coordinate {\itx} = {\itx}({\itt})'); pause;
    figure % 2
    % Coordinate y
    plot(t, Y(:,2), [tmin,tmax], [0,0], 'k');   
    axis([tmin, tmax, ymin, ymax]);
    xlabel('{\itt}'); ylabel('{\ity}'); grid;
    title('Coordinate {\ity} = {\ity}({\itt})'); pause;
    figure % 3
    % Trajectory
    comet(Y(:,1), Y(:,2))
    plot(Y(:,1), Y(:,2), [xmin, xmax], [0,0],'k',...
                  [0,0], [ymin, ymax], 'k');
    axis([xmin, xmax, ymin, ymax]);                   
    xlabel('{\itx}'); ylabel('{\ity}'); grid;
    title('Trajectory of the particle'); pause;
    figure % 4
    % Velocity
    v = sqrt(Y(:,3).^2 + Y(:,4).^2);
    vmin = min(v); vmax = max(v);
    dv = vmax - vmin;
    comet(t, v)
    plot (t, v, [tmin,tmax], [0,0], 'k');    
    axis([tmin, tmax, vmin - 0.1*dv, vmax + 0.1*dv]);
    xlabel('{\itt}'); ylabel('{\itv}'); grid;
    title('Velocity {\itv} = {\itv}({\itt})'); pause; close;
    flag2 = 1;
    close all
    disp(' ');
    ans = input(' Would you like to continue? (Y/N): ','s');
    if ans == 'n' | ans == 'N', break, end
end

%  ********************* End of Program DTXY **********************
