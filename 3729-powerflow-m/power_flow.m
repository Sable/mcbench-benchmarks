function power_flow(filename)
%POWER_FLOW Function to perform a power-flow analysis.
% Function power_flow reads a data set describing a power system
% from a disk file, and performs a power-flow analysis on it.  
% The only argument is the name of the input file.  There are 
% three types of lines in the input file.  The "SYSTEM" line
% specifies the name of the power system and the base apparent 
% power of the power system in MVA.  Its form is:
%
% SYSTEM name baseMVA tol
%
% where
%   name    = The name of the power system
%   baseMVA = The base MVA of the power system
%   tol     = Voltage tolerance
%
% The "BUS" line specifies the characteristics of a bus on the
% power system.  Its form is:
%
% BUS name type volts Pgen Qgen Pload Qload Qcap
%
% where
%   name   = The name of the bus
%   type   = The type of the bus, one of PQ, PV, or SL
%   Vbus   = The initial voltage guess for PQ busses
%            The fixed magnitude of voltage PV busses
%            The fixed magnitude at an angle of 0 deg for Sl busses
%   Pgen   = Is the real power generation in MW at the bus
%   Qgen   = Is the reactive power generation in MVAR at the bus
%   Pload  = Is the real power load in MW at the bus
%   Qload  = Is the reactive power load in MVAR at the bus
%   Qcap   = Is the reactive power of capacitors in MVAR at the bus
%
% The "LINE" line specifies the characteristics of a transmission
% line on the power system.  Note that the impedance of the 
% transformers in series with the transmission line should also
% be lumped into these terms.  Its form is:
%
% LINE from to Rse Xse Gsh Bsh Rating
%
% where
%   from   = The name of the "from" bus
%   to     = The type of the "to" bus
%   Rse    = Per-unit series resistance
%   Xse    = Per-unit series reactance
%   Gsh    = Per-unit shunt conductance
%   Bsh    = Per-unit shunt susceptance
%   Rating = Max power rating of the line in MVAR
%
% The lines should appear in the order:
%  
%  SYSTEM ...
%  BUS ...
%  LINE ...
%
% The program reads the data from the input file and solves for the
% voltages at every bus.  Then, it generates a report giving the 
% voltages and power flows throughout the system.
 
%  Record of revisions:
%      Date       Programmer          Description of change
%      ====       ==========          =====================
%    01/12/00    S. J. Chapman        Original code

% Get the power system data
[bus, line, system] = read_system(filename);

% Byild Ybus
ybus = build_ybus(bus, line);

% Solve for the bus voltages
[bus, n_iter] = solve_system(bus, ybus);

% Display results
report_system(1, bus, line, system, ybus, n_iter);

%================================================================
%================================================================
function [bus, line, system] = read_system(filename)
%READ_SYSTEM Read a power system from disk.
% Function read_system reads a data set describing a power system
% from a disk file.  There are three types of lines in the input
% file.  The "SYSTEM" line specifies the name of the power system
% and the base apparent power of the power system in MVA.  Its 
% form is:
%
% SYSTEM name baseMVA tol
%
% where
%   name    = The name of the power system
%   baseMVA = The base MVA of the power system
%   tol     = Voltage tolerance
%
% The "BUS" line specifies the characteristics of a bus on the
% power system.  Its form is:
%
% BUS name type volts Pgen Qgen Pload Qload Qcap
%
% where
%   name   = The name of the bus
%   type   = The type of the bus, one of PQ, PV, or SL
%   Vbus   = The initial voltage guess for PQ busses
%            The fixed magnitude of voltage PV busses
%            The fixed magnitude at an angle of 0 deg for Sl busses
%   Pgen   = Is the real power generation in MW at the bus
%   Qgen   = Is the reactive power generation in MVAR at the bus
%   Pload  = Is the real power load in MW at the bus
%   Qload  = Is the reactive power load in MVAR at the bus
%   Qcap   = Is the reactive power of capacitors in MVAR at the bus
%
% The "LINE" line specifies the characteristics of a transmission
% line on the power system.  Note that the impedance of the 
% transformers in series with the transmission line should also
% be lumped into these terms.  Its form is:
%
% LINE from to Rse Xse Gsh Bsh Rating
%
% where
%   from   = The name of the "from" bus
%   to     = The type of the "to" bus
%   Rse    = Per-unit series resistance
%   Xse    = Per-unit series reactance
%   Gsh    = Per-unit shunt conductance
%   Bsh    = Per-unit shunt susceptance
%   Rating = Max power rating of the line in MVAR
%
% The lines should appear in the order:
%  
%  SYSTEM ...
%  BUS ...
%  LINE ...
 
%  Record of revisions:
%      Date       Programmer          Description of change
%      ====       ==========          =====================
%    01/12/00    S. J. Chapman        Original code

% Check for a legal number of input arguments.
msg = nargchk(1,1,nargin);
error(msg);

% Initialise counters
n_system  = 0;          % Number of SYSTEM cards
n_bus     = 0;          % Number of BUS cards
n_lines   = 0;          % Number of LINE cards
n_bad     = 0;          % Number of INVALID cards
n_comment = 0;          % Number of comment lines
i_line    = 0;          % Current line number

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Open input file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[fid,message] = fopen(filename,'r');  % FID = -1 for failure.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check for error
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if fid < 0
   str = ['ERROR: Can''t find system file: ' filename];
   error(str);

else

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % File open OK, so read lines.
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   while feof(fid) == 0
   
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Get next line
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      data = fgetl(fid);
      i_line = i_line + 1;
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Extract keyword
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      maxlen = min( [ 6 length(data) ] );
      keyword = data(1:maxlen);
   
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Determine the type of the line
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if strncmpi(keyword,'SYSTEM',6) == 1
      
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % This is a SYSTEM card
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         n_system = n_system + 1;
         
         % Get system name
         blanks = findstr(data,' ');
         test = diff(blanks) > 1;
         for ii = 1:length(test)
            if test(ii) > 0
               system.name = data(blanks(ii)+1:blanks(ii+1)-1);
               break;
            end
         end
         
         % Get base MVA
         ii = blanks(ii+1);
         temp = sscanf(data(ii:length(data)),'%g');
         system.baseMVA = temp(1);
         
         % Voltage tolerance
         system.v_tol = temp(2);
         
      elseif strncmpi(keyword,'BUS',3) == 1
   
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % This is a BUS card
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         n_bus = n_bus + 1;
         
         % Confirm that a SYSTEM card has preceeded this card
         if n_system == 0
            error (['ERROR: A SYSTEM card must precede any BUS cards!']);
         end

         % Get bus name
         blanks = findstr(data,' ');
         test = diff(blanks) > 1;
         for ii = 1:length(test)
            if test(ii) > 0
               bus(n_bus).name = data(blanks(ii)+1:blanks(ii+1)-1);
               break;
            end
         end
         
         % Get bus type
         for ii = ii+1:length(test)
            if test(ii) > 0
               bus(n_bus).type = data(blanks(ii)+1:blanks(ii+1)-1);
               break;
            end
         end
         
         % Get voltage
         ii = blanks(ii+1);
         temp = sscanf(data(ii:length(data)),'%g');
         bus(n_bus).Vbus = temp(1);
         
         % Get power generated, loads, and capactive MVAR
         bus(n_bus).PG = temp(2) / system.baseMVA;
         bus(n_bus).QG = temp(3) / system.baseMVA;
         bus(n_bus).PL = temp(4) / system.baseMVA;
         bus(n_bus).QL = temp(5) / system.baseMVA;
         bus(n_bus).QC = temp(6) / system.baseMVA;
         
      elseif strncmpi(keyword,'LINE',4) == 1
   
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % This is a LINE card
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         n_lines = n_lines + 1;
         
         % Confirm that a SYSTEM card has preceeded this card
         if n_system == 0
            error (['ERROR: A SYSTEM card must precede any LINE cards!']);
         end

         % Get "from" bus name
         blanks = findstr(data,' ');
         test = diff(blanks) > 1;
         for ii = 1:length(test)
            if test(ii) > 0
               line(n_lines).from_name = data(blanks(ii)+1:blanks(ii+1)-1);
               break;
            end
         end
         
         % Get "to" bus name
         for ii = ii+1:length(test)
            if test(ii) > 0
               line(n_lines).to_name = data(blanks(ii)+1:blanks(ii+1)-1);
               break;
            end
         end
         
         % Get numeric values
         ii = blanks(ii+1);
         temp = sscanf(data(ii:length(data)),'%g');

         % Get values
         line(n_lines).Rse    = temp(1);
         line(n_lines).Xse    = temp(2);
         line(n_lines).Gsh    = temp(3);
         line(n_lines).Bsh    = temp(4);
         line(n_lines).rating = temp(5);

      elseif isempty(keyword)
   
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % This is a null line--do nothing
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %n_comment = n_comment + 1;
         
      elseif keyword(1:1) == '%'
   
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % This is a comment line
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         n_comment = n_comment + 1;
         
      else
      
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % This is an invalid line
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         n_bad = n_bad + 1;
         if ischar(data)
            disp(['WARNING: Invalid line ' int2str(i_line) ':  ' data]);
         end
         
      end
   end

   % Now test input data for consistency
   for ii = 1:n_bus
      bus(ii).n_lines = 0;
   end
   for ii = 1:n_lines 
      line(ii).from = 0;
      line(ii).to = 0;
      
      % Check for line terminations
      for jj = 1:n_bus
         if strcmpi(line(ii).from_name, bus(jj).name)
            bus(jj).n_lines = bus(jj).n_lines + 1;
            line(ii).from   = jj;
         end
         if strcmpi(line(ii).to_name, bus(jj).name)
            bus(jj).n_lines = bus(jj).n_lines + 1;
            line(ii).to     = jj;
         end
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Now test input data for consistency.
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   % Check to see that one and only one SYSTEM card
   % was present.
   error_count = 0;
   if n_system == 0
      error_count = error_count + 1;
      disp (['ERROR: No SYSTEM card supplied!']);
   end
   if n_system > 1
      error_count = error_count + 1;
      disp (['ERROR: Too many SYSTEM cards supplied!']);
   end
   
   % Check to see that there are no isolated busses.
   for ii = 1:n_bus
      if bus(ii).n_lines <= 0
         error_count = error_count + 1;
         disp (['ERROR: Isolated bus: ' bus(ii).name]);
      end
   end
   
   % Now check for lines with invalid bus names.
   for ii = 1:n_lines
      if line(ii).from <= 0
         error_count = error_count + 1;
         str = ['ERROR: Invalid from bus on line ' num2str(ii) ...
                ': ' line(ii).from_name];
         disp(str);
      end
      if line(ii).to <= 0
         error_count = error_count + 1;
         str = ['ERROR: Invalid  to  bus on line ' num2str(ii) ...
                ': ' line(ii).to_name];
         disp(str);
      end
   end

   % Check to see that there was one and only one slack bus.
   sl_count = 0;
   for ii = 1:n_bus
      if bus(ii).type == 'SL'
         sl_count = sl_count + 1;
      end
   end
   if sl_count == 0
      error_count = error_count + 1;
      disp (['ERROR: No slack bus specified!']);
   end
   if sl_count > 1
      error_count = error_count + 1;
      disp (['ERROR: Too many slack busses specified!']);
   end
   
   % Check to see that each bus with non-zero generation is
   % either type 'SL' or type 'PV'.
   for ii = 1:n_bus
      if ~strcmp(bus(ii).type,'SL') & ~strcmp(bus(ii).type,'PV') & ...
         ( (bus(ii).PG ~= 0) | (bus(ii).QG ~= 0) )
         error_count = error_count + 1;
         disp (['ERROR: Generator bus ' int2str(ii) ...
                ' specified as type ' bus(ii).type]);
      end
   end
   
   % If there were errors, abort with error message.
   if error_count > 0
      disp([int2str(error_count) ' errors total!']);
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Write out data summary
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   fprintf('Input summary statistics:\n' );
   fprintf('%4d lines in system file\n', i_line );
   fprintf('%4d SYSTEM lines\n', n_system );
   fprintf('%4d BUS lines\n', n_bus );
   fprintf('%4d LINE lines\n', n_lines );
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Close file
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   fclose(fid);
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Abort on errors
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if error_count > 0
      error(['Job aborted due to input errors.']);
   end
   

end

%================================================================
%================================================================
function ybus = build_ybus(bus, line)
%BUILD_YBUS Build the bus admittance matrix from an input array of lines
% Function build_ybus builds a bus admittance matrix from an input
% structure of lines.  Each line stretches between two busses, and it
% characterized by a per-unit series impedance and a per-unit shunt
% admittance.  Each array element in the "line" array contains the 
% following fields:
%
% from_name     Name of "from" bus
% from          Number of "from" bus
% to_name       Name of "to" bus
% to            Number of "to" bus
% Rse           Series resistance, pu
% Xse           Series reactance, pu
% Gsh           Shunt conductance, pu
% Bsh           Shunt susceptance, pu
% Rating        Rated apparent power (MVA)
 
%  Record of revisions:
%      Date       Programmer          Description of change
%      ====       ==========          =====================
%    01/12/00    S. J. Chapman        Original code

% Check for a legal number of input arguments.
msg = nargchk(2,2,nargin);
error(msg);

% Get the number of busses included in the system.
n_bus = length(bus);

% Create ybus
ybus = zeros(n_bus,n_bus);

% Now build the bus admittance matrix
for ii = 1:length(line)

   % Get indices
   fr = line(ii).from;
   to = line(ii).to;

   % Convert series impedance to a series admittance, and
   % conductance and susceptance to a shunt admittance.
   Yse = 1.0 / ( line(ii).Rse + j*line(ii).Xse );
   Ysh = line(ii).Gsh + j*line(ii).Bsh;

   % Diagonal terms
   ybus(fr,fr) = ybus(fr,fr) + Yse;
   ybus(to,to) = ybus(to,to) + Yse;

   % Off-diagonal terms
   ybus(fr,to) = ybus(fr,to) - Yse;
   ybus(to,fr) = ybus(to,fr) - Yse;
   
   % Shunt admittance
   
   ybus(fr,fr) = ybus(fr,fr) + Ysh;
   ybus(to,to) = ybus(to,to) + Ysh;

end

%================================================================
%================================================================
function [bus, n_iter] = solve_system(bus, ybus)
%SOLVE_SYSTEM Solve for the bus voltages in the system
% Function solve_system solves for the bus voltage in the power 
% system using the Gauss-Siedel method.
 
%  Record of revisions:
%      Date       Programmer          Description of change
%      ====       ==========          =====================
%    01/12/00    S. J. Chapman        Original code

% Check for a legal number of input arguments.
msg = nargchk(2,2,nargin);
error(msg);

% Set problem size and initial conditions
n_bus = length(bus);
acc_fac = 1.0;
eps = 0.0001;
n_iter = 0;

% Initialize the real and reactive power supplied to the 
% power system at each bus.  Note that the power at the 
% swing bus doesn't matter, and the reactive power at the
% generator bus will be recomputed dynamically.
for ii = 1:n_bus
   bus(ii).P = bus(ii).PG - bus(ii).PL;
   bus(ii).Q = bus(ii).QG - bus(ii).QL + bus(ii).QC;
end

% Initialize Vbus
for ii = 1:n_bus
   Vbus(ii) = bus(ii).Vbus;
end

% Create an infinite loop
while (1)
   
   % Increment the iteration count
   n_iter = n_iter + 1; 
   
   % Save old bus voltages for comparison purposes
   Vbus_old = Vbus;

   % Calculate the updated bus voltage
   for ii = 1:n_bus
   
      % Skip the swing bus!
      if ~strcmpi(bus(ii).type, 'SL')
      
         % If this is a generator bus, update the reactive
         % power estimate.
         if strcmpi(bus(ii).type, 'PV') 
            temp = 0;
            for jj = 1:n_bus
               temp = temp + ybus(ii,jj) * Vbus(jj);
            end
            temp = conj(Vbus(ii)) * temp;
            bus(ii).Q = -imag(temp);
         end 

         % Calculate updated voltage at bus 'ii'.  First, sum
         % up the current contributions at bus 'ii' from all
         % other busses. 
         temp = 0;
         for jj = 1:n_bus
            if ii ~= jj
               temp = temp - ybus(ii,jj) * Vbus(jj);
            end
         end
         
         % Add in the current injected at this node
         temp = (bus(ii).P - j*bus(ii).Q) / conj(Vbus(ii)) + temp;
         
         % Get updated estimate of Vbus at 'ii'
         Vnew = 1/ybus(ii,ii) * temp;
         
         % Apply an acceleration factor to the new voltage estimate
         Vbus(ii) = Vbus_old(ii) + acc_fac * (Vnew - Vbus_old(ii));
         
         % If this is a generator bus, update the magnitude of the
         % voltage to keep it constant.
         if strcmpi(bus(ii).type, 'PV') 
            Vbus(ii) = Vbus(ii) * abs(Vbus_old(ii)) / abs(Vbus(ii));
         end
      end
   end
 
   % Compare the old and new estimate of the voltages.
   % Note that we will compare the real and the imag parts
   % separately, and both must be within tolerances 
   % for every bus.
   temp = Vbus - Vbus_old;
   if max(abs([real(temp) imag(temp)])) < eps
      break;
   end
end

% Save the bus voltages in the bus array
for ii = 1:n_bus
   bus(ii).Vbus = Vbus(ii);
end

%================================================================
%================================================================
function report_system(fid, bus, line, system, ybus, n_iter)
%REPORT_SYSTEM Write a report of power system load flows.
% Function report_system writes a load flow report to unit "fid".
% If this unit is a file, the file must be opened before the 
% function is called.
 
%  Record of revisions:
%      Date       Programmer          Description of change
%      ====       ==========          =====================
%    01/12/00    S. J. Chapman        Original code

% Check for a legal number of input arguments.
msg = nargchk(6,6,nargin);
error(msg);

% Get number of busses
n_bus = length(bus);

% Reset sums
PGtot = 0;
QGtot = 0;
PLtot = 0;
QLtot = 0;
QCtot = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate and display bus and line quantities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set to titles and labels
fprintf('\n');
fprintf('                                        Results for Ca');
fprintf('se %s\n', system.name);
fprintf('|====================Bus Information=================');
fprintf('======================|=======Line Information======|\n');
fprintf('Bus            Bus   Volts / angle  |--Generation--|-');
fprintf('-----Load-----|--Cap--|      To    |----Line Flow---|\n');
fprintf('no.      Name  Type   (pu)   (deg)    (MW)  (MVAR)   ');
fprintf(' (MW)  (MVAR)   (MVAR)       Bus      (MW)    (MVAR)|\n');
fprintf('|====================================================');
fprintf('====================================================|\n');

% Write out bus information
for ii = 1:n_bus

   % Write bus number
   fprintf('%3d', ii );

   % Write bus name
   fprintf(' %10s', bus(ii).name );
   
   % Write bus type
   fprintf('  %2s', bus(ii).type );

   % Write pu voltage 
   [mag, phase] = r2p(bus(ii).Vbus);
   fprintf('   %5.3f/', mag );
   fprintf('%7.2f', phase );

   % If this is a slack bus, update the real and
   % reactive power supplied.
   if strcmpi(bus(ii).type, 'SL') 
      temp = 0;
      for jj = 1:n_bus
         temp = temp + ybus(ii,jj) * bus(jj).Vbus;
      end
      temp = conj(bus(ii).Vbus) * temp;
      bus(ii).P = real(temp);
      bus(ii).Q = -imag(temp);
   end

   % Write Generation (MW / MVAR) 
   P = (bus(ii).P + bus(ii).PL) * system.baseMVA;
   Q = (bus(ii).Q + bus(ii).QL - bus(ii).QC) * system.baseMVA;
   fprintf(' %7.2f', P );
   fprintf(' %7.2f', Q );
   
   % Sum generation
   PGtot = PGtot + P;
   QGtot = QGtot + Q;

   % Write Load (MW / MVAR) 
   fprintf(' %7.2f', bus(ii).PL * system.baseMVA );
   fprintf(' %7.2f', bus(ii).QL * system.baseMVA );
   
   % Sum loads
   PLtot = PLtot + bus(ii).PL * system.baseMVA;
   QLtot = QLtot + bus(ii).QL * system.baseMVA;

   % Write Capacitive MVAR 
   fprintf(' %7.2f', bus(ii).QC * system.baseMVA );
   
   % Sum capacitive load
   QCtot = QCtot + bus(ii).QC * system.baseMVA;

   % Calculate the powers flowing out of this bus to other buses
   count = 0;
   for jj = 1:length(line)
   
      if line(jj).from == ii
      
         % This line starts at the current bus.
         % Write the "to" bus name
         count = count + 1;
         if count > 1
            fprintf(' %84s', line(jj).to_name );
         else   
            fprintf(' %10s', line(jj).to_name );
         end
         
         % Calculate the current and power flow in line
         kk = line(jj).to;
         il = (bus(ii).Vbus - bus(kk).Vbus) * ybus(ii,kk);
         pl = bus(ii).Vbus * conj(il);
         P  = -real(pl) * system.baseMVA;
         Q  = -imag(pl) * system.baseMVA;
         
         % Display power flows in line
         fprintf('   %7.2f', P );
         fprintf('   %7.2f\n', Q );
         
      elseif line(jj).to == ii
      
         % This line ends at the current bus.
         % Write the "from" bus name
         count = count + 1;
         if count > 1
            fprintf(' %84s', line(jj).from_name );
         else   
            fprintf(' %10s', line(jj).from_name );
         end
         
         % Calculate the current and power flow in line
         kk = line(jj).from;
         il = (bus(ii).Vbus - bus(kk).Vbus) * ybus(ii,kk);
         pl = bus(ii).Vbus * conj(il);
         P  = -real(pl) * system.baseMVA;
         Q  = -imag(pl) * system.baseMVA;
         
         % Display power flows in line
         fprintf('   %7.2f', P );
         fprintf('   %7.2f\n', Q );
         
      end
   end
end      

% Write totals
fprintf('|====================================================');
fprintf('====================================================|\n');
fprintf('                     Totals       ');
fprintf(' %7.2f', PGtot );
fprintf(' %7.2f', QGtot );
fprintf(' %7.2f', PLtot );
fprintf(' %7.2f', QLtot );
fprintf(' %7.2f\n', QCtot );
fprintf('|====================================================');
fprintf('====================================================|\n');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate and display line losses
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Skip some lines
fprintf('\n\n');

% Set up labels
fprintf('                      Line Losses                      \n');
fprintf('|=====================================================|\n');
fprintf('|  Line         From           To     Ploss    Qloss  |\n');
fprintf('|   no.          Bus          Bus      (MW)    (MVAR) |\n');
fprintf('|=====================================================|\n');

% Initialize total line loss 
Pltot = 0;
Qltot = 0;

% Calculate and write out line losses
for ii = 1:length(line);
   jj = line(ii).from;
   kk = line(ii).to;
   il = (bus(jj).Vbus - bus(kk).Vbus) * ybus(jj,kk);
   Pl = abs(il)^2 * line(ii).Rse * system.baseMVA;
   Ql = abs(il)^2 * line(ii).Xse * system.baseMVA;
   
   Pltot = Pltot + Pl;
   Qltot = Qltot + Ql;

   % Write out lines
   fprintf('   %4d',ii);
   fprintf('   %10s',line(ii).from_name);
   fprintf('   %10s',line(ii).to_name);
   fprintf('   %7.2f', Pl );
   fprintf('   %7.2f\n', Ql );
end

% Write out total line losses
fprintf('|=====================================================|\n');
fprintf('                          Totals:');
fprintf('   %7.2f', Pltot );
fprintf('   %7.2f\n', Qltot );
fprintf('|=====================================================|\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate and display alerts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Skip some lines
fprintf('\n\n');

% Initialize alert counter
n_alert = 0;

% Set up labels 
fprintf('                        Alerts                         \n');
fprintf('|=====================================================|\n');

% Check for voltages out of range
for ii = 1:length(bus)
   if (abs(bus(ii).Vbus) < (1.0 - system.v_tol) ) | ...
      (abs(bus(ii).Vbus) > (1.0 + system.v_tol) )
      n_alert = n_alert + 1;
      fprintf('ALERT: Voltage on bus %s out of tolerance.\n',bus(ii).name);
   end
end

% Check for power lines whose ratings are exceeded.
for ii = 1:length(line);
   jj = line(ii).from;
   kk = line(ii).to;
   il = (bus(jj).Vbus - bus(kk).Vbus) * ybus(jj,kk);
   Sl = abs(bus(jj).Vbus * conj(il)) * system.baseMVA;
   
   % Check for line exceeding limit
   if Sl > line(ii).rating
      n_alert = n_alert + 1;
      fprintf('ALERT: Rating on line %d exceeded: %.2f MVA > %.2f MVA.\n', ...
              ii, Sl, line(ii).rating );
   end
end  

% Write out "none" if not alerts were generated
if n_alert == 0
   fprintf('NONE\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display number of iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\nDone in %d iterations.\n', n_iter );

%================================================================
%================================================================
function outval = p2r(mag,phase)
%p2r Convert a complex number in polar format to rectangluar
% Function p2r converts either a complex number in polar format
% with the angle in degrees into a complex number in rectangular
% format.
 
% Define variables:
%   mag       -- Magnitude of number
%   outval    -- Output value in rectangular form
%   phase     -- Phase of number, in degrees

%  Record of revisions:
%      Date       Programmer          Description of change
%      ====       ==========          =====================
%    12/12/99    S. J. Chapman        Original code

% Check for a legal number of input arguments.
msg = nargchk(2,2,nargin);
error(msg);

% Convert number
theta = phase * pi / 180;
outval = mag * ( cos(theta) + j*sin(theta) );

%================================================================
%================================================================
function [mag,phase] = r2p(inval)
%R2P Convert a complex number in rectangular format to polar in degrees
% Function R2P converts either a complex number into a complex
% number in polar format, with the angle in degrees.
 
% Define variables:
%   inval     -- Input value in rectangular form
%   mag       -- Magnitude of number
%   phase     -- Phase of number, in degrees

%  Record of revisions:
%      Date       Programmer          Description of change
%      ====       ==========          =====================
%    12/12/99    S. J. Chapman        Original code

% Check for a legal number of input arguments.
msg = nargchk(1,1,nargin);
error(msg);

% Convert number
mag = abs(inval);
phase = angle(inval) * 180 / pi;
