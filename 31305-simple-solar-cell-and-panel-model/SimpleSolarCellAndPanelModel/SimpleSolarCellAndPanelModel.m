% Example of use of "solar"
% May 2011, tested on MATLAB R2010A
% Translated and improved by Thibaut Leroy (thibaut.leroy@gmail.com), 
% French solar car team Hélios (http://www.helioscar.com)
% HEI (Hautes Etudes d'Ingénieur) engineering school Lille, France

% Sunpower datasheets are property of Sunpower Corporation (http://us.sunpowercorp.com/)
% Based on published code by Francisco M. González-Longatt,
% "Model of Photovoltaic Module in MatlabTM",
% 2DO CONGRESO IBEROAMERICANO DE ESTUDIANTES DE INGENIERÍA ELÉCTRICA, ELECTRÓNICA Y COMPUTACIÓN (II CIBELEC 2005)

function SimpleSolarCellAndPanelModel
    % Cell computations (model VS data, power and current for different temp and suns)
    data = xlsread('SunpowerCurves.xlsx', 'Data', 'A:B'); % Read curve's points from the Excel file
    dataU = data(:,1); % Extract Voltage
    dataI = data(:,2); % Extract Current
    clear data
    
    %Define Voltage
    Va = 0:0.01:1.665;
    
    figure('Color', 'w')
    subplot(2,1,1);
    title('Sunpower A300 cell current/voltage')
    hold on
    plot(dataU, dataI, 'r', 'LineWidth', 1);
    plot(Va, solar(Va,1,25), 'b-', 'LineWidth', 1)
    plot(Va, solar(Va,1,40), 'b--', 'LineWidth', 1)
    plot(Va, solar(Va,1,55), 'b-.', 'LineWidth', 1)
    plot(Va, solar(Va,1,70), 'b:', 'LineWidth', 1)
    ylim([0,Inf]);
    xlabel('Voltage [V]');
    ylabel('Current [A]');
    legend({'Data @ 1000W/m^2 / 25°C' ...
    'Model @ 1000W/m^2 / 25°C', ...
    'Model @ 1000W/m^2 / 40°C', ...
    'Model @ 1000W/m^2 / 55°C', ...
    'Model @ 1000W/m^2 / 70°C'}, ...
    'Location', 'SouthWest');
    grid on

    subplot(2,1,2);
    title('Sunpower A300 cell power/voltage')
    hold on
    plot(dataU, dataU.*dataI, 'r', 'LineWidth', 1);
    plot(Va, Va.*solar(Va,1,25), 'b-', 'LineWidth', 1)
    plot(Va, Va.*solar(Va,0.75,40), 'b--', 'LineWidth', 1)
    plot(Va, Va.*solar(Va,0.5,55), 'b-.', 'LineWidth', 1)
    plot(Va, Va.*solar(Va,0.25,70), 'b:', 'LineWidth', 1)
    ylim([0,Inf]);
    xlabel('Voltage [V]');
    ylabel('Power [W]');
    legend({'Data @ 1000W/m^2 / 25°C' ...
    'Model @ 1000W/m^2 / 25°C', ...
    'Model @ 750W/m^2 / 40°C', ...
    'Model @ 500W/m^2 / 55°C', ...
    'Model @ 250W/m^2 / 70°C'}, ...
    'Location', 'NorthWest');
    grid on
    
    
    % Panel computations
    Ns = 96; % Number of cells serially connected in a panel []. See SunpowerA300PanelDatasheet.pdf
    Va0 = 0:0.01:0.665; % Voltage vector of one cell [V]
    Ia1 = solar(Va0,1,25); % Compute current from voltage vector [A]
    %Compute the new voltage (reverse X and Y cell's graph) for Ns cells
    %Do "interp1" to have a constant spaced vector
    %Do "coerce" to limit extrap values to positive values
    Va1 = max(Ns*interp1(Ia1, Va0, 0:0.001:ceil(max(Ia1)*100)/100, 'linear', 'extrap'), 0);

    Ia2 = solar(Va0,1,50);
    Va2 = max(Ns*interp1(Ia2, Va0, 0:0.001:ceil(max(Ia2)*100)/100, 'linear', 'extrap'), 0);

    Ia3 = solar(Va0,0.8,25);
    Va3 = max(Ns*interp1(Ia3, Va0, 0:0.001:ceil(max(Ia3)*100)/100, 'linear', 'extrap'), 0);

    Ia4 = solar(Va0,0.5,25);
    Va4 = max(Ns*interp1(Ia4, Va0, 0:0.001:ceil(max(Ia4)*100)/100, 'linear', 'extrap'), 0);

    Ia5 = solar(Va0,0.2,25);
    Va5 = max(Ns*interp1(Ia5, Va0, 0:0.001:ceil(max(Ia5)*100)/100, 'linear', 'extrap'), 0);

    figure('Color', 'w')
    title('Sunpower A300 panel power/voltage')
    hold on
    plot(Va1,0:0.001:ceil(max(Ia1)*100)/100, 'k')
    plot(Va2,0:0.001:ceil(max(Ia2)*100)/100, 'c')
    plot(Va3,0:0.001:ceil(max(Ia3)*100)/100, 'r')
    plot(Va4,0:0.001:ceil(max(Ia4)*100)/100, 'g')
    plot(Va5,0:0.001:ceil(max(Ia5)*100)/100, 'b')
    xlabel('Voltage [V]');
    ylabel('Power [W]');
    legend({'Model @ 1000W/m^2 / 25°C' ...
            'Model @ 1000W/m^2 / 50°C', ...
            'Model @ 800W/m^2 / 25°C', ...
            'Model @ 500W/m^2 / 25°C', ...
            'Model @ 200W/m^2 / 25°C'}, ...
            'Location', 'NorthWest');
    grid on
end