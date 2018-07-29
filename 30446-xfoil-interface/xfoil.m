function [pol,foil] = xfoil(coord,alpha,Re,Mach,varargin)
% Run XFoil and return the results.
% [polar,foil] = xfoil(coord,alpha,Re,Mach,{extra commands})
%
% Xfoil.exe needs to be in the same directory as this m function.
% For more information on XFoil visit these websites;
%  http://en.wikipedia.org/wiki/XFOIL 
%  http://web.mit.edu/drela/Public/web/xfoil
% 
% Inputs:
%    coord: Normalised foil co-ordinates (n by 2 array, of x & y 
%           from the TE-top passed the LE to the TE bottom)
%           or a filename of the XFoil co-ordinate file
%           or a NACA 4 or 5 digit descriptor (e.g. 'NACA0012')
%    alpha: Angle-of-attack, can be a vector for an alpha polar
%       Re: Reynolds number (use Re=0 for inviscid mode)
%     Mach: Mach number
% extra commands: Extra XFoil commands
%           The extra XFoil commands need to be proper xfoil commands 
%           in a character array. e.g. 'oper/iter 150'
%
% The transition criterion Ncrit can be specified using the 
% 'extra commands' option as follows,
% foil = xfoil('NACA0012',10,1e6,0.2,'oper/vpar n 12')
%  
%   Situation           Ncrit
%   -----------------   -----
%   sailplane           12-14
%   motorglider         11-13
%   clean wind tunnel   10-12
%   average wind tunnel    9 <= standard "e^9 method"
%   dirty wind tunnel    4-8
%
% A flap deflection can be added using the following command,
% 'gdes flap {xhinge} {yhinge} {flap_defelction} exec' 
%
% Outputs:
%  polar: structure with the polar coefficients (alpha,CL,CD,CDp,CM,
%          Top_Xtr,Bot_Xtr) 
%   foil: stucture with the specific aoa values (s,x,y,UeVinf,
%          Dstar,Theta,Cf,H,cpx,cp) each column corresponds to a different
%          angle-of-attack.
%
% If there are different sized output arrays for the different incidence
% angles then they will be stored in a structured array, foil(1),foil(2)...
%
% Examples:
%    % Single AoA with a different number of panels
%    [pol foil] = xfoil('NACA0012',10,1e6,0.0,'panels n 330')
%
%    % Change the maximum number of iterations
%    [pol foil] = xfoil('NACA0012',5,1e6,0.2,'oper iter 50')
%
%    % Deflect the trailing edge by 20deg at 60% chord and run multiple incidence angles
%    [pol foil] = xfoil('NACA0012',[-5:15],1e6,0.2,'oper iter 150','gdes flap 0.6 0 5 exec')
%    % Plot the results
%    figure; 
%    plot(pol.alpha,pol.CL); xlabel('alpha [\circ]'); ylabel('C_L'); title(pol.name);  
%    figure; subplot(3,1,[1 2]);
%    plot(foil(1).xcp(:,end),foil(1).cp(:,end)); xlabel('x');
%    ylabel('C_p'); title(sprintf('%s @ %g\\circ',pol.name,foil(1).alpha(end))); 
%    set(gca,'ydir','reverse');
%    subplot(3,1,3);
%    I = (foil(1).x(:,end)<=1); 
%    plot(foil(1).x(I,end),foil(1).y(I,end)); xlabel('x');
%    ylabel('y'); axis('equal');   
%

% Some default values
if ~exist('coord','var'), coord = 'NACA0012'; end;
if ~exist('alpha','var'), alpha = 0;    end;
if ~exist('Re','var'),    Re = 1e6;      end;
if ~exist('Mach','var'),  Mach = 0.2;    end;

% default foil name
foil_name = [mfilename]; 

% default filenames
wd = fileparts(which(mfilename)); % working directory, where xfoil.exe needs to be
fname = [mfilename];
file_coord= [wd filesep foil_name '.foil'];

% Save coordinates
if ischar(coord),  % Either a NACA string or a filename
  if ~isempty(regexpi(coord,'^NACA *[0-9]{4,5}$')), % Check if a NACA string
    foil_name = coord;
  else             % Filename supplied
    % set coord file
    file_coord = coord;
  end;  
else
  % Write foil ordinate file
  if exist(file_coord,'file'),  delete(file_coord); end;
  fid = fopen(file_coord,'w');
  if (fid<=0),
    error([mfilename ':io'],'Unable to create file %s',file_coord);
  else
    fprintf(fid,'%s\n',foil_name);
    fprintf(fid,'%9.5f   %9.5f\n',coord');
    fclose(fid);
  end;
end;

% Write xfoil command file
fid = fopen([wd filesep fname '.inp'],'w');
if (fid<=0),
  error([mfilename ':io'],'Unable to create xfoil.inp file');
else
  if ischar(coord),
    if ~isempty(regexpi(coord,'^NACA *[0-9]{4,5}$')),  % NACA string supplied
      fprintf(fid,'naca %s\n',coord(5:end));
    else  % filename supplied
      fprintf(fid,'load %s\n',file_coord);
    end;  
  else % Coordinates supplied, use the default filename
    fprintf(fid,'load %s\n',file_coord);
  end;
  % Extra Xfoil commands
  for ii = 1:length(varargin),
    txt = varargin{ii};
    txt = regexprep(txt,'[ \\\/]+','\n');
    fprintf(fid,'%s\n\n',txt);
  end;
  fprintf(fid,'\n\noper\n');
  % set Remolds and Mach
  fprintf(fid,'re %g\n',Re);
  fprintf(fid,'mach %g\n',Mach);
  
  % Switch to viscous mode
  if (Re>0)
    fprintf(fid,'visc\n');  
  end;

  % Polar accumulation 
  fprintf(fid,'pacc\n\n\n');
  % Xfoil alpha calculations
  for ii = 1:length(alpha)
    % Individual output filenames
    file_dump{ii} = sprintf('%s_a%06.3f_dump.dat',fname,alpha(ii));
    file_cpwr{ii} = sprintf('%s_a%06.3f_cpwr.dat',fname,alpha(ii));
    % Commands
    fprintf(fid,'alfa %g\n',alpha(ii));
    fprintf(fid,'dump %s\n',file_dump{ii});
    fprintf(fid,'cpwr %s\n',file_cpwr{ii});
  end;
  % Polar output filename
  file_pwrt = sprintf('%s_pwrt.dat',fname);
  fprintf(fid,'pwrt\n%s\n',file_pwrt);
  fprintf(fid,'plis\n');
  fprintf(fid,'\nquit\n');
  fclose(fid);

  % execute xfoil
  cmd = sprintf('cd %s && xfoil.exe < xfoil.inp > xfoil.out',wd);
  [status,result] = system(cmd);
  if (status~=0),
    disp(result);
    error([mfilename ':system'],'Xfoil execution failed! %s',cmd);
  end;

  % Read dump file
  %    #    s        x        y     Ue/Vinf    Dstar     Theta      Cf       H
  jj = 0;
  ind = 1;
  for ii = 1:length(alpha)
    jj = jj + 1;

    fid = fopen([wd filesep file_dump{ii}],'r');
    if (fid<=0),
      error([mfilename ':io'],'Unable to read xfoil output file %s',file_dump{ii});
    else
      D = textscan(fid,'%f%f%f%f%f%f%f%f','Delimiter',' ','MultipleDelimsAsOne',true,'CollectOutput',1,'HeaderLines',1);
      fclose(fid);
      delete([wd filesep file_dump{ii}]);
      % store data
      if ((jj>1) && (size(D{1},1)~=length(foil(ind).x)) && sum(abs(foil(ind).x(:,1)-size(D{1},1)))>1e-6 ),
        ind = ind + 1;
        jj = 1;
      end;
      foil(ind).s(:,jj) = D{1}(:,1);
      foil(ind).x(:,jj) = D{1}(:,2);
      foil(ind).y(:,jj) = D{1}(:,3);
      foil(ind).UeVinf(:,jj) = D{1}(:,4);
      foil(ind).Dstar(:,jj) = D{1}(:,5);
      foil(ind).Theta(:,jj) = D{1}(:,6);
      foil(ind).Cf(:,jj) = D{1}(:,7);
      foil(ind).H (:,jj)= D{1}(:,8);
    end;

    foil(ind).alpha(1,jj) = alpha(jj);

    % Read cp file
    fid = fopen([wd filesep file_cpwr{ii}],'r');
    if (fid<=0),
      error([mfilename ':io'],'Unable to read xfoil output file %s',file_cpwr{ii});
    else
      C = textscan(fid,'%f%f','Delimiter',' ','MultipleDelimsAsOne',true,'CollectOutput',1,'HeaderLines',1);
      fclose(fid);
      delete([wd filesep file_cpwr{ii}]);
      % store data
      foil(ind).xcp = C{1}(:,1);
      foil(ind).cp(:,jj) = C{1}(:,2);
    end;
  end;

  % Read polar file
  %  
  %       XFOIL         Version 6.96
  %  
  % Calculated polar for: NACA 0012                                       
  %  
  % 1 1 Reynolds number fixed          Mach number fixed         
  %  
  % xtrf =   1.000 (top)        1.000 (bottom)  
  % Mach =   0.000     Re =     1.000 e 6     Ncrit =  12.000
  %  
  %   alpha    CL        CD       CDp       CM     Top_Xtr  Bot_Xtr
  %  ------ -------- --------- --------- -------- -------- --------
  fid = fopen([wd filesep file_pwrt],'r');
  if (fid<=0),
    error([mfilename ':io'],'Unable to read xfoil polar file %s',file_pwrt);
  else
    % Header
    % Calculated polar for: NACA 0012 
    P = textscan(fid,' Calculated polar for: %[^\n]','Delimiter',' ','MultipleDelimsAsOne',true,'HeaderLines',3);
    pol.name = strtrim(P{1}{1});
    % xtrf =   1.000 (top)        1.000 (bottom)  
    P = textscan(fid,' xtrf =%f (top) %f (bottom)','Delimiter',' ','MultipleDelimsAsOne',true,'CollectOutput',1,'HeaderLines',3);
    pol.xtrf_top = P{1}(1);
    pol.xtrf_bot = P{1}(2);
    % Mach =   0.000     Re =     1.000 e 6     Ncrit =  12.000
    P = textscan(fid,' Mach = %f Re = %f e %f Ncrit = %f','Delimiter',' ','MultipleDelimsAsOne',true,'CollectOutput',1,'HeaderLines',0);
    pol.Mach = P{1}(1);
    pol.Re = P{1}(2) * 10^P{1}(3);
    pol.Ncrit = P{1}(4);

    % data
    P = textscan(fid,'%f%f%f%f%f%f%f','Delimiter',' ','MultipleDelimsAsOne',true,'CollectOutput',1,'HeaderLines',3);
    fclose(fid);
    delete([wd filesep file_pwrt]);
    % store data
    pol.alpha = P{1}(:,1);
    pol.CL  = P{1}(:,2);
    pol.CD  = P{1}(:,3);
    pol.CDp = P{1}(:,4);
    pol.Cm  = P{1}(:,5);
    pol.Top_xtr = P{1}(:,6);
    pol.Bot_Xtr = P{1}(:,7);
  end;


end;
