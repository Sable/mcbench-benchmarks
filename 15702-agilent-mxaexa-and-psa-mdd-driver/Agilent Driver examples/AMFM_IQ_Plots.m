function example9
% MATLAB/MXA example 9
% Continuous AM/FM demodulator and multiple display

% Version: 1.0
% Date: Sep 11, 2006  
% 2006 Agilent Technologies, Inc.

oldobjs=instrfind;
if ~isempty(oldobjs)
disp('Cleaning up ...')
delete(oldobjs);
clear oldobjs;
end


% TCPIP parameters
mxa_ip = '141.121.95.145';
mxa_port = 5025;

% MXA Interface creation and connection opening
mxa_if = tcpip(mxa_ip,mxa_port);
mxa = icdevice('Agilent_SA_Driver.mdd', mxa_if);
connect(mxa,'object')

% Make sure the instrument is in the correct mode and continously aquiring
set(mxa,'Mode','Basic');
set(mxa,'SASweepSingle','On');

% create and bring to front figure number 1
figure(1)

th =timer('timerfcn',@update_plot,...
          'ExecutionMode','Fixedspacing',...
          'Period',0.1);
 
start(th)
pause(10)
stop(th)



% Close the MXA connection and clean up
disconnect(mxa);
delete(mxa);
clear mxa;

    function update_plot(varargin)
        % Get IQ data
        iq = invoke(mxa,'WavReadIQData');
        n = length(iq);
        
        % Plot IQ data
        subplot 211
        plot(1:n,real(iq),1:n,imag(iq))
        xlim([1 n])
        title('IQ data')

        
        % Plot AM demod
        subplot 223
        plot(1:n,abs(iq)/mean(abs(iq))-1)
        xlim([1 n])
        title('AM_demod')
        
        % Plot FM demod
        subplot 224
        plot(1:n-1,diff(unwrap(angle(iq))))
        xlim([1 n-1])
        title('FM_demod')
        
    end

end
