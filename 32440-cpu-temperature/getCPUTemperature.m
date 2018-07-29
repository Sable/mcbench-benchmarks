function info = getCPUTemperature
% The function uses WMIService to get Information via WMI_MSAcpi_ThermalZoneTemperature-Class about the CPU.
% It is an example on how to connect to COM and take use of Computer services
% 
% Further Readings:
%   http://msdn.microsoft.com/de-de/library/ms811533.aspx
%   http://msdn.microsoft.com/en-us/library/aa394579(v=vs.85).aspx
%   http://www.scriptinternals.de/new/defaultUS.asp?WMI_MSAcpi_ThermalZoneTemperature
%   http://www.microsoft.com/download/en/details.aspx?id=8572
%
% Programmed by Sven Koerner: koerner(underline)sven(add)gmx.de
% Date: 2011/08/05 


objLocator  = actxserver('WbemScripting.SWbemLocator');             % COM connection
objService  = objLocator.ConnectServer('.', 'root\WMI');            % connet to WMI
colItems    = objService.ExecQuery('SELECT * FROM MSAcpi_ThermalZoneTemperature', 'WQL');  % query the actual values


% Collect the Values
for i=1:1:colItems.Count
  % evaluate the Query
    info(i,1).InstanceName            = colItems.ItemIndex(i-1).Properties_.Item('InstanceName').Value;                     % Name of Instance
    info(i,1).is_active               = colItems.ItemIndex(i-1).Properties_.Item('Active').Value;                           % is Active
    info(i,1).ActiveTripPoint         = colItems.ItemIndex(i-1).Properties_.Item('ActiveTripPoint').Value;                  % Temperature levels (in tenths of degrees Kelvin) at which the OS must activate active cooling
    info(i,1).CriticalTripPoint_10K   = colItems.ItemIndex(i-1).Properties_.Item('CriticalTripPoint').Value;                % Temperature (in tenths of degrees Kelvin) at which the OS must shutdown the system
    info(i,1).CurrentTemperature_10K  = colItems.ItemIndex(i-1).Properties_.Item('CurrentTemperature').Value;               % Temperature at thermal zone in tenths of degrees Kelvin
    info(i,1).PassiveTripPoint_10K    = colItems.ItemIndex(i-1).Properties_.Item('PassiveTripPoint').Value;                 % Temperature (in tenths of degrees Kelvin) at which the OS must activate CPU throttling 
    info(i,1).SamplingPeriod          = colItems.ItemIndex(i-1).Properties_.Item('SamplingPeriod').Value;
    
    % Calculate Temperatur from Kelvin to deg Celsius
    info(i,1).CriticalTripPoint_C     = info(i,1).CriticalTripPoint_10K/10-273.2;
    info(i,1).CurrentTemperature_C    = info(i,1).CurrentTemperature_10K/10-273.2;
    info(i,1).PassiveTripPoint_C      = info(i,1).PassiveTripPoint_10K/10-273.2;
    
    % Display current Temperature
    disp([info(i,1).InstanceName,  ' has a temperature of actual ', num2str(info(i,1).CurrentTemperature_C), ' °C' ] );
    
end;

