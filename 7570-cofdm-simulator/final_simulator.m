%DATE:21/04/2005
%COFDM SIMULATOR
%BY:Apurva Gupta
%B.ENG,ELECTRONICs & COMMUNICATION ENGINEERING,
%UNIVERSITY OF LEEDS,UK
%SUPERVISOR:Prof.G.Markarian

function varargout = final_simulator(varargin)
% FINAL_SIMULATOR M-file for final_simulator.fig
%      FINAL_SIMULATOR, by itself, creates a new FINAL_SIMULATOR or raises the existing
%      singleton*.
%
%      H = FINAL_SIMULATOR returns the handle to a new FINAL_SIMULATOR or the handle to
%      the existing singleton*.
%
%      FINAL_SIMULATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL_SIMULATOR.M with the given input arguments.
%
%      FINAL_SIMULATOR('Property','Value',...) creates a new FINAL_SIMULATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_simulator_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_simulator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help final_simulator

% Last Modified by GUIDE v2.5 24-Apr-2005 12:30:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_simulator_OpeningFcn, ...
                   'gui_OutputFcn',  @final_simulator_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before final_simulator is made visible.
function final_simulator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final_simulator (see VARARGIN)

% Choose default command line output for final_simulator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes final_simulator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = final_simulator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function [varargout] = code1(varargin)
M=2;
EbNomin = 1; EbNomax = 5; % EbNo range, in dB
numerrmin = 10; % Compute BER only after 5 errors occur.
EbNovec = EbNomin:1:EbNomax; % Vector of EbNo values
numEbNos = length(EbNovec); % Number of EbNo values
% Preallocate space for certain data.
ber = zeros(1,numEbNos); % BER values
intv = cell(1,numEbNos); % Cell array of confidence intervals
% Loop over the vector of EbNo values.
for jj = 1:numEbNos
   EbNo = EbNovec(jj);
   snr = EbNo; % Because of binary modulation
   ntrials = 0; % Number of passes through the while loop below
   numerr = 0; % Number of errors for this EbNo value
   % Simulate until numerrmin errors occur.
   while (numerr < numerrmin)
      msg= zeros(1,1e6);%message is a string of a thousand zeros.
      %t = poly2trellis([4 3],[4 5 17;7 4 2]); % Define trellis.
      %code = convenc(msg,t); % Encode a string of ones.
      txsig = pskmod(msg,M); % Modulate.
      rxsig = awgn(txsig, snr, 'measured'); % Add noise.
      decodmsg = pskdemod(rxsig,M); % Demodulate.
      %qcode = quantiz(decodmsg,[0.001,.1,.3,.5,.7,.9,.999]);% Quantize to prepare for soft-decision decoding.
      %tblen = 48; delay = tblen; % Traceback length
      %decoded = vitdec(qcode,t,tblen,'cont','soft',3); % Decode.
      newerrs = biterr(msg,decodmsg); % Errors in this trial
      numerr = numerr + newerrs; % Total errors for this EbNo value
      ntrials = ntrials + 1; % Update trial index.
   end
   % Error rate and 98% confidence interval for this EbNo value
   [ber(jj), intv1] = berconfint(numerr,(ntrials * 1e6),.98);
   intv{jj} = intv1; % Store in cell array for later use.
   disp(['EbNo = ' num2str(EbNo) ' dB, ' num2str(numerr) ...
         ' errors, BER = ' num2str(ber(jj))])
end
% Use BERFIT to plot the best fitted curve,
% interpolating to get a smooth plot.
fitEbNo = EbNomin:0.25:EbNomax; % Interpolation values
berfit(EbNovec,ber,fitEbNo);

% Also plot confidence intervals.
hold on;
grid on;
%axes(handles.axes2);
for jj=1:numEbNos
   semilogy([EbNovec(jj) EbNovec(jj)],intv{jj},'g-+');
end
%hold off;
if nargout == 0
  builtin('code1', varargin{:});
else
  [varargout{1:nargout}] = builtin('code1', varargin{:});
end

%--------------------------------------------------------------
function [varargout] = code2(varargin)
M=2;
EbNomin = 1; EbNomax = 5; % EbNo range, in dB
numerrmin = 10; % Compute BER only after 5 errors occur.
EbNovec = EbNomin:1:EbNomax; % Vector of EbNo values
numEbNos = length(EbNovec); % Number of EbNo values
% Preallocate space for certain data.
ber = zeros(1,numEbNos); % BER values
intv = cell(1,numEbNos); % Cell array of confidence intervals
% Loop over the vector of EbNo values.
for jj = 1:numEbNos
   EbNo = EbNovec(jj);
   snr = EbNo; % Because of binary modulation
   ntrials = 0; % Number of passes through the while loop below
   numerr = 0; % Number of errors for this EbNo value
   % Simulate until numerrmin errors occur.
   while (numerr < numerrmin)
      msg= zeros(1,1e6);%message is a string of a thousand zeros.
      %t = poly2trellis([4 3],[4 5 17;7 4 2]); % Define trellis.
      %code = convenc(msg,t); % Encode a string of ones.
      txsig = pskmod(msg,M); % Modulate.
      rxsig = awgn(txsig, snr, 'measured'); % Add noise.
      decodmsg = pskdemod(rxsig,M); % Demodulate.
      %qcode = quantiz(decodmsg,[0.001,.1,.3,.5,.7,.9,.999]);% Quantize to prepare for soft-decision decoding.
      %tblen = 48; delay = tblen; % Traceback length
      %decoded = vitdec(qcode,t,tblen,'cont','soft',3); % Decode.
      newerrs = biterr(msg,decodmsg); % Errors in this trial
      numerr = numerr + newerrs; % Total errors for this EbNo value
      ntrials = ntrials + 1; % Update trial index.
   end
   % Error rate and 98% confidence interval for this EbNo value
   [ber(jj), intv1] = berconfint(numerr,(ntrials * 1e6),.98);
   intv{jj} = intv1; % Store in cell array for later use.
   disp(['EbNo = ' num2str(EbNo) ' dB, ' num2str(numerr) ...
         ' errors, BER = ' num2str(ber(jj))])
end
% Use BERFIT to plot the best fitted curve,
% interpolating to get a smooth plot.
fitEbNo = EbNomin:0.25:EbNomax; % Interpolation values
berfit(EbNovec,ber,fitEbNo);

% Also plot confidence intervals.
hold on;
grid on;
%axes(handles.axes2);
for jj=1:numEbNos
   semilogy([EbNovec(jj) EbNovec(jj)],intv{jj},'g-+');
end
%hold off;
if nargout == 0
  builtin('code2', varargin{:});
else
  [varargout{1:nargout}] = builtin('code2', varargin{:});
end

%-------16QAM-------------------------------------------
function [varargout] = code3(varargin)
bits=1e5;
M=16;
EbNomin = 1; EbNomax = 5; % EbNo range, in dB
numerrmin = 10; % Compute BER only after 5 errors occur.
EbNovec = EbNomin:1:EbNomax; % Vector of EbNo values
numEbNos = length(EbNovec); % Number of EbNo values
% Preallocate space for certain data.
ber = zeros(1,numEbNos); % BER values
intv = cell(1,numEbNos); % Cell array of confidence intervals
% Loop over the vector of EbNo values.
for jj = 1:numEbNos
   EbNo = EbNovec(jj);
   snr = EbNo;%*0.5*log2(M);% Because of binary modulation
   ntrials = 0; % Number of passes through the while loop below
   numerr = 0; % Number of errors for this EbNo value
   % Simulate until numerrmin errors occur.
   while (numerr < numerrmin)
      msg= zeros(bits,1);%message is a string of a thousand zeros.
      txsig = qammod(msg,M); % Modulate.
      noise = awgn(txsig, snr,'measured'); % Add noise.
      decodmsg = qamdemod(noise,M); % Demodulate.
      newerrs = biterr(msg,decodmsg); % Errors in this trial
      numerr = numerr + newerrs; % Total errors for this EbNo value
      ntrials = ntrials + 1; % Update trial index.
   end
   % Error rate and 98% confidence interval for this EbNo value
   [ber(jj), intv1] = berconfint(numerr,(ntrials * bits),.98);
   intv{jj} = intv1; % Store in cell array for later use.
   disp(['EbNo = ' num2str(EbNo) ' dB, ' num2str(numerr) ...
         ' errors, BER = ' num2str(ber(jj))])
end
% Use BERFIT to plot the best fitted curve,
% interpolating to get a smooth plot.
fitEbNo = EbNomin:0.25:EbNomax; % Interpolation values
berfit(EbNovec,ber,fitEbNo);

% Also plot confidence intervals.
hold on;
grid on;
%set(gcf,'DefaultAxesColorOrder',[1 0 0;0 1 0;0 0 1])
%axes(handles.axes2);
for jj=1:numEbNos
   semilogy([EbNovec(jj) EbNovec(jj)],intv{jj},'g-+');
end
if nargout == 0
  builtin('code3', varargin{:});
else
  [varargout{1:nargout}] = builtin('code3', varargin{:});
end

%------64QAM------------------------------------------------
function [varargout] = code4(varargin)
bits=1e5;
M=64;
EbNomin = 5; EbNomax = 15; % EbNo range, in dB
numerrmin = 5; % Compute BER only after 5 errors occur.
EbNovec = EbNomin:1:EbNomax; % Vector of EbNo values
numEbNos = length(EbNovec); % Number of EbNo values
% Preallocate space for certain data.
ber = zeros(1,numEbNos); % BER values
intv = cell(1,numEbNos); % Cell array of confidence intervals
% Loop over the vector of EbNo values.
for jj = 1:numEbNos
   EbNo = EbNovec(jj);
   snr = EbNo;%*0.5*log2(M);% Because of binary modulation
   ntrials = 0; % Number of passes through the while loop below
   numerr = 0; % Number of errors for this EbNo value
   % Simulate until numerrmin errors occur.
   while (numerr < numerrmin)
      msg= zeros(bits,1);%message is a string of a thousand zeros.
      txsig = qammod(msg,M); % Modulate.
      noise = awgn(txsig, snr,'measured'); % Add noise.
      decodmsg = qamdemod(noise,M); % Demodulate.
      newerrs = biterr(msg,decodmsg); % Errors in this trial
      numerr = numerr + newerrs; % Total errors for this EbNo value
      ntrials = ntrials + 1; % Update trial index.
   end
   % Error rate and 98% confidence interval for this EbNo value
   [ber(jj), intv1] = berconfint(numerr,(ntrials * bits),.98);
   intv{jj} = intv1; % Store in cell array for later use.
   disp(['EbNo = ' num2str(EbNo) ' dB, ' num2str(numerr) ...
         ' errors, BER = ' num2str(ber(jj))])
end
% Use BERFIT to plot the best fitted curve,
% interpolating to get a smooth plot.
fitEbNo = EbNomin:0.25:EbNomax; % Interpolation values
berfit(EbNovec,ber,fitEbNo);

% Also plot confidence intervals.
hold on;
grid on;
%set(gcf,'DefaultAxesColorOrder',[1 0 0;0 1 0;0 0 1])
%axes(handles.axes2);
for jj=1:numEbNos
    %legend('Emperical BER','64QAM','Poly Ratio fit');
    semilogy([EbNovec(jj) EbNovec(jj)],intv{jj},'g-+');
end
if nargout == 0
  builtin('code4', varargin{:});
else
  [varargout{1:nargout}] = builtin('code4', varargin{:});
end


function [varargout] = conv_code1(varargin)
M=2;
EbNomin = 1; EbNomax = 5; % EbNo range, in dB
numerrmin = 5; % Compute BER only after 5 errors occur.
EbNovec = EbNomin:1:EbNomax; % Vector of EbNo values
numEbNos = length(EbNovec); % Number of EbNo values
% Preallocate space for certain data.
ber = zeros(1,numEbNos); % BER values
intv = cell(1,numEbNos); % Cell array of confidence intervals
% Loop over the vector of EbNo values.
for jj = 1:numEbNos
   EbNo = EbNovec(jj);
   snr = EbNo; % Because of binary modulation
   ntrials = 0; % Number of passes through the while loop below
   numerr = 0; % Number of errors for this EbNo value
   % Simulate until numerrmin errors occur.
   while (numerr < numerrmin)
      msg= zeros(1,1e6);%message is a string of a thousand zeros.
      t = poly2trellis([4 3],[4 5 17;7 4 2]); % Define trellis.
      code = convenc(msg,t); % Encode a string of ones.
      txsig = pskmod(code,M); % Modulate.
      rxsig = awgn(txsig, snr, 'measured'); % Add noise.
      decodmsg = pskdemod(rxsig,M); % Demodulate.
      qcode = quantiz(decodmsg,[0.001,.1,.3,.5,.7,.9,.999]);% Quantize to prepare for soft-decision decoding.
      tblen = 48; delay = tblen; % Traceback length
      decoded = vitdec(qcode,t,tblen,'cont','soft',3); % Decode.
      newerrs = biterr(msg,decoded); % Errors in this trial
      numerr = numerr + newerrs; % Total errors for this EbNo value
      ntrials = ntrials + 1; % Update trial index.
   end
   % Error rate and 98% confidence interval for this EbNo value
   [ber(jj), intv1] = berconfint(numerr,(ntrials * 1e6),.98);
   intv{jj} = intv1; % Store in cell array for later use.
   disp(['EbNo = ' num2str(EbNo) ' dB, ' num2str(numerr) ...
         ' errors, BER = ' num2str(ber(jj))])
end
% Use BERFIT to plot the best fitted curve,
% interpolating to get a smooth plot.
fitEbNo = EbNomin:0.25:EbNomax; % Interpolation values
berfit(EbNovec,ber,fitEbNo);

% Also plot confidence intervals.
hold on;
grid on;
%axes(handles.axes2);
for jj=1:numEbNos
   semilogy([EbNovec(jj) EbNovec(jj)],intv{jj},'g-+');
end
%hold off;
if nargout == 0
  builtin('conv_code1', varargin{:});
else
  [varargout{1:nargout}] = builtin('conv_code1', varargin{:});
end
%------------------------------------------------------------
function [varargout] = conv_code2(varargin)
M=4;
EbNomin = 1; EbNomax = 10; % EbNo range, in dB
numerrmin = 5; % Compute BER only after 5 errors occur.
EbNovec = EbNomin:1:EbNomax; % Vector of EbNo values
numEbNos = length(EbNovec); % Number of EbNo values
% Preallocate space for certain data.
ber = zeros(1,numEbNos); % BER values
intv = cell(1,numEbNos); % Cell array of confidence intervals
% Loop over the vector of EbNo values.
for jj = 1:numEbNos
   EbNo = EbNovec(jj);
   snr = EbNo; % Because of binary modulation
   ntrials = 0; % Number of passes through the while loop below
   numerr = 0; % Number of errors for this EbNo value
   % Simulate until numerrmin errors occur.
   while (numerr < numerrmin)
      msg= zeros(1,1e6);%message is a string of a thousand zeros.
      t = poly2trellis([4 3],[4 5 17;7 4 2]); % Define trellis.
      code = convenc(msg,t); % Encode a string of ones.
      txsig = pskmod(code,M); % Modulate.
      rxsig = awgn(txsig, snr, 'measured'); % Add noise.
      decodmsg = pskdemod(rxsig,M); % Demodulate.
      qcode = quantiz(decodmsg,[0.001,.1,.3,.5,.7,.9,.999]);% Quantize to prepare for soft-decision decoding.
      tblen = 48; delay = tblen; % Traceback length
      decoded = vitdec(qcode,t,tblen,'cont','soft',3); % Decode.
      newerrs = biterr(msg,decoded); % Errors in this trial
      numerr = numerr + newerrs; % Total errors for this EbNo value
      ntrials = ntrials + 1; % Update trial index.
   end
   % Error rate and 98% confidence interval for this EbNo value
   [ber(jj), intv1] = berconfint(numerr,(ntrials * 1e6),.98);
   intv{jj} = intv1; % Store in cell array for later use.
   disp(['EbNo = ' num2str(EbNo) ' dB, ' num2str(numerr) ...
         ' errors, BER = ' num2str(ber(jj))])
end
% Use BERFIT to plot the best fitted curve,
% interpolating to get a smooth plot.
fitEbNo = EbNomin:0.25:EbNomax; % Interpolation values
berfit(EbNovec,ber,fitEbNo);

% Also plot confidence intervals.
hold on;
grid on;
%axes(handles.axes2);
for jj=1:numEbNos
   semilogy([EbNovec(jj) EbNovec(jj)],intv{jj},'g-+');
end
%hold off;
if nargout == 0
  builtin('conv_code2', varargin{:});
else
  [varargout{1:nargout}] = builtin('conv_code2', varargin{:});
end
%-------------------------------------------------------------
function [varargout] = conv_code3(varargin)
M=2;
EbNomin = 1; EbNomax = 5; % EbNo range, in dB
numerrmin = 10; % Compute BER only after 10 errors occur.
EbNovec = EbNomin:1:EbNomax; % Vector of EbNo values
numEbNos = length(EbNovec); % Number of EbNo values
% Preallocate space for certain data.
ber = zeros(1,numEbNos); % BER values
intv = cell(1,numEbNos); % Cell array of confidence intervals
% Loop over the vector of EbNo values.
for jj = 1:numEbNos
   EbNo = EbNovec(jj);
   snr = EbNo;%*0.5*log2(M); % Because of binary modulation
   ntrials = 0; % Number of passes through the while loop below
   numerr = 0; % Number of errors for this EbNo value
   % Simulate until numerrmin errors occur.
   while (numerr < numerrmin)

      msg = zeros(1e6,1);%message is a string of a thousand zeros.
      t = poly2trellis(7,[171 133]); % Define trellis.
      code = convenc(msg,t); % Encode a string of ones.
      txsig = pskmod(code,M); % Modulate.
      rxsig = awgn(txsig, snr, 'measured'); % Add noise.
      decodmsg = pskdemod(rxsig,M); % Demodulate.
      qcode = quantiz(decodmsg,[0.001,.1,.3,.5,.7,.9,.999]);% Quantize to prepare for soft-decision decoding.
      tblen = 48; delay = tblen; % Traceback length
      decoded = vitdec(qcode,t,tblen,'cont','soft',3); % Decode.
      newerrs = biterr(msg,decoded); % Errors in this trial
      numerr = numerr + newerrs; % Total errors for this EbNo value
      ntrials = ntrials + 1; % Update trial index.
   end
   % Error rate and 98% confidence interval for this EbNo value
   [ber(jj), intv1] = berconfint(numerr,(ntrials * 1e6),.98);
   intv{jj} = intv1; % Store in cell array for later use.
   disp(['EbNo = ' num2str(EbNo) ' dB, ' num2str(numerr) ...
         ' errors, BER = ' num2str(ber(jj))])
end
% Use BERFIT to plot the best fitted curve,
% interpolating to get a smooth plot.
fitEbNo = EbNomin:0.25:EbNomax; % Interpolation values
berfit(EbNovec,ber,fitEbNo);

% Also plot confidence intervals.
hold on;
grid on;
%axes(handles.axes2);
for jj=1:numEbNos
   semilogy([EbNovec(jj) EbNovec(jj)],intv{jj},'g-+');
end
%hold off;
if nargout == 0
  builtin('conv_code3', varargin{:});
else
  [varargout{1:nargout}] = builtin('conv_code3', varargin{:});
end


%-------------------------------------------------------
function [varargout] = conv_code4(varargin)
M=4;
EbNomin = 1; EbNomax = 5; % EbNo range, in dB
numerrmin = 10; % Compute BER only after 10 errors occur.
EbNovec = EbNomin:1:EbNomax; % Vector of EbNo values
numEbNos = length(EbNovec); % Number of EbNo values
% Preallocate space for certain data.
ber = zeros(1,numEbNos); % BER values
intv = cell(1,numEbNos); % Cell array of confidence intervals
% Loop over the vector of EbNo values.
for jj = 1:numEbNos
   EbNo = EbNovec(jj);
   snr = EbNo*0.5*log2(M); % Because of binary modulation
   ntrials = 0; % Number of passes through the while loop below
   numerr = 0; % Number of errors for this EbNo value
   % Simulate until numerrmin errors occur.
   while (numerr < numerrmin)

      msg = zeros(1e6,1);%message is a string of a thousand zeros.
      t = poly2trellis(7,[171 133]); % Define trellis.
      code = convenc(msg,t); % Encode a string of ones.
      txsig = pskmod(code,M); % Modulate.
      rxsig = awgn(txsig, snr, 'measured'); % Add noise.
      decodmsg = pskdemod(rxsig,M); % Demodulate.
      qcode = quantiz(decodmsg,[0.001,.1,.3,.5,.7,.9,.999]);% Quantize to prepare for soft-decision decoding.
      tblen = 48; delay = tblen; % Traceback length
      decoded = vitdec(qcode,t,tblen,'cont','soft',3); % Decode.
      newerrs = biterr(msg,decoded); % Errors in this trial
      numerr = numerr + newerrs; % Total errors for this EbNo value
      ntrials = ntrials + 1; % Update trial index.
   end
   % Error rate and 98% confidence interval for this EbNo value
   [ber(jj), intv1] = berconfint(numerr,(ntrials * 1e6),.98);
   intv{jj} = intv1; % Store in cell array for later use.
   disp(['EbNo = ' num2str(EbNo) ' dB, ' num2str(numerr) ...
         ' errors, BER = ' num2str(ber(jj))])
end
% Use BERFIT to plot the best fitted curve,
% interpolating to get a smooth plot.
fitEbNo = EbNomin:0.25:EbNomax; % Interpolation values
berfit(EbNovec,ber,fitEbNo);

% Also plot confidence intervals.
hold on;
grid on;
%axes(handles.axes2);
for jj=1:numEbNos
   semilogy([EbNovec(jj) EbNovec(jj)],intv{jj},'g-+');
end
%hold off;
if nargout == 0
  builtin('conv_code4', varargin{:});
else
  [varargout{1:nargout}] = builtin('conv_code4', varargin{:});
end

% --- Executes on selection change in modulation.
function modulation_Callback(hObject, eventdata, handles)
% hObject    handle to modulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns modulation contents as cell array
%        contents{get(hObject,'Value')} returns selected item from modulation


% --- Executes during object creation, after setting all properties.
function modulation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in coding.
function coding_Callback(hObject, eventdata, handles)
% hObject    handle to coding (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns coding contents as cell array
%        contents{get(hObject,'Value')} returns selected item from coding


% --- Executes during object creation, after setting all properties.
function coding_CreateFcn(hObject, eventdata, handles)
% hObject    handle to coding (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in interleaving.
function interleaving_Callback(hObject, eventdata, handles)
% hObject    handle to interleaving (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns interleaving contents as cell array
%        contents{get(hObject,'Value')} returns selected item from interleaving


% --- Executes during object creation, after setting all properties.
function interleaving_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interleaving (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in int.
function int_Callback(hObject, eventdata, handles)
% hObject    handle to int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
popup_sel_index = get(handles.interleaving, 'Value');
switch popup_sel_index
    case 1

bits =1e6
M=2
EbNomin = 1; EbNomax = 5; % EbNo range, in dB
numerrmin = 10; % Compute BER only after 5 errors occur.
EbNovec = EbNomin:1:EbNomax; % Vector of EbNo values
numEbNos = length(EbNovec); % Number of EbNo values
% Preallocate space for certain data.
ber = zeros(1,numEbNos); % BER values
intv = cell(1,numEbNos); % Cell array of confidence intervals
% Loop over the vector of EbNo values.
for jj = 1:numEbNos
   EbNo = EbNovec(jj);
   snr = EbNo; % Because of binary modulation
   ntrials = 0; % Number of passes through the while loop below
   numerr = 0; % Number of errors for this EbNo value
   % Simulate until numerrmin errors occur.
   while (numerr < numerrmin)
      % st1 = 27221; st2 = 4831; % States for random number generator
      msg= zeros(bits,1);%message is a string of a thousand zeros.
      t = poly2trellis(7,[171 133]); % Define trellis.
      %t = poly2trellis([4 3],[4 5 17;7 4 2]); % Define trellis.
      code = convenc(msg,t); % Encode a string of ones.
      nrows = 5; % Use 5 shift registers
      slope = 3; % Delays are 0, 3, 6, 9, and 12.
      inter = convintrlv(code,nrows,slope); % Interleave.
      txsig = pskmod(inter,M); % Modulate.
      rxsig = awgn(txsig, snr, 'measured'); % Add noise.
      decodmsg = pskdemod(rxsig,M); % Demodulate.
      deinter = convdeintrlv(decodmsg,nrows,slope); % Deinterleave.
      qcode = quantiz(deinter,[0.001,.1,.3,.5,.7,.9,.999]);% Quantize to prepare for soft-decision decoding.
      tblen = 48; delay = tblen; % Traceback length
      decoded = vitdec(qcode,t,tblen,'cont','soft',3); % Decode.
      newerrs = biterr(msg,decoded); % Errors in this trial
      numerr = numerr + newerrs; % Total errors for this EbNo value
      ntrials = ntrials + 1; % Update trial index.
   end
   % Error rate and 98% confidence interval for this EbNo value
   [ber(jj), intv1] = berconfint(numerr,(ntrials *bits ),.98);
   intv{jj} = intv1; % Store in cell array for later use.
   disp(['EbNo = ' num2str(EbNo) ' dB, ' num2str(numerr) ...
         ' errors, BER = ' num2str(ber(jj))])
end
% Use BERFIT to plot the best fitted curve,
% interpolating to get a smooth plot.
fitEbNo = EbNomin:0.25:EbNomax; % Interpolation values
berfit(EbNovec,ber,fitEbNo);

% Also plot confidence intervals.
hold on;
grid on;
%set(gcf,'DefaultAxesColorOrder',[1 0 0;0 1 0;0 0 1])
%axes(handles.axes2);
for jj=1:numEbNos
   semilogy([EbNovec(jj) EbNovec(jj)],intv{jj},'g-+');
end

    case 2
        
bits =1e6
M=4
EbNomin = 1; EbNomax = 5; % EbNo range, in dB
numerrmin = 10; % Compute BER only after 5 errors occur.
EbNovec = EbNomin:1:EbNomax; % Vector of EbNo values
numEbNos = length(EbNovec); % Number of EbNo values
% Preallocate space for certain data.
ber = zeros(1,numEbNos); % BER values
intv = cell(1,numEbNos); % Cell array of confidence intervals
% Loop over the vector of EbNo values.
for jj = 1:numEbNos
   EbNo = EbNovec(jj);
   snr = EbNo*0.5*log2(M); % Because of binary modulation
   ntrials = 0; % Number of passes through the while loop below
   numerr = 0; % Number of errors for this EbNo value
   % Simulate until numerrmin errors occur.
   while (numerr < numerrmin)
      % st1 = 27221; st2 = 4831; % States for random number generator
      msg= zeros(bits,1);%message is a string of a thousand zeros.
      t = poly2trellis(7,[171 133]); % Define trellis.
      %t = poly2trellis([4 3],[4 5 17;7 4 2]); % Define trellis.
      code = convenc(msg,t); % Encode a string of ones.
      nrows = 5; % Use 5 shift registers
      slope = 3; % Delays are 0, 3, 6, 9, and 12.
      inter = convintrlv(code,nrows,slope); % Interleave.
      txsig = pskmod(inter,M); % Modulate.
      rxsig = awgn(txsig, snr, 'measured'); % Add noise.
      decodmsg = pskdemod(rxsig,M); % Demodulate.
      deinter = convdeintrlv(decodmsg,nrows,slope); % Deinterleave.
      qcode = quantiz(deinter,[0.001,.1,.3,.5,.7,.9,.999]);% Quantize to prepare for soft-decision decoding.
      tblen = 48; delay = tblen; % Traceback length
      decoded = vitdec(qcode,t,tblen,'cont','soft',3); % Decode.
      newerrs = biterr(msg,decoded); % Errors in this trial
      numerr = numerr + newerrs; % Total errors for this EbNo value
      ntrials = ntrials + 1; % Update trial index.
   end
   % Error rate and 98% confidence interval for this EbNo value
   [ber(jj), intv1] = berconfint(numerr,(ntrials *bits ),.98);
   intv{jj} = intv1; % Store in cell array for later use.
   disp(['EbNo = ' num2str(EbNo) ' dB, ' num2str(numerr) ...
         ' errors, BER = ' num2str(ber(jj))])
end
% Use BERFIT to plot the best fitted curve,
% interpolating to get a smooth plot.
fitEbNo = EbNomin:0.25:EbNomax; % Interpolation values
berfit(EbNovec,ber,fitEbNo);

% Also plot confidence intervals.
hold on;
grid on;
%set(gcf,'DefaultAxesColorOrder',[1 0 0;0 1 0;0 0 1])
%axes(handles.axes2);
for jj=1:numEbNos
   semilogy([EbNovec(jj) EbNovec(jj)],intv{jj},'g-+');
end
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
popup_sel_index = get(handles.modulation, 'Value');
switch popup_sel_index
    case 1
popup_sel_index = get(handles.coding, 'Value');
switch popup_sel_index
    case 1
        code1;
    case 2
        conv_code3;
    case 3
        conv_code1;

end
    case 2
popup_sel_index = get(handles.coding, 'Value');
switch popup_sel_index
    case 1
        code2;
    case 2
        conv_code4;    
    case 3
        conv_code2;
end
    case 3
        code3;
    case 4
        code4;
end


% --- Executes on button press in clr.
function clr_Callback(hObject, eventdata, handles)
% hObject    handle to clr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla

% --- Executes on button press in hlp.
function hlp_Callback(hObject, eventdata, handles)
% hObject    handle to hlp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpPath = which('help.txt');
web(helpPath);




% --------------------------------------------------------------------
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --------------------------------------------------------------------
function print_Callback(hObject, eventdata, handles)
% hObject    handle to print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


