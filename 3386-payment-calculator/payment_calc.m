function payment_calc

%PAYMENT_CALC Example loan payment calculator using Swing and MATLAB.
% note: uses financial toolbox

% make the swing class names appear as functions to MATLAB.
% see http://java.sun.com/j2se/1.3/docs/api/javax/swing/package-summary.html
import javax.swing.*;

% make the java.awt class names appear as functions to MATLAB.
% see http://www.javasoft.com/products/jdk/1.1/docs/api/Package-java.awt.html
import java.awt.*;

% create a swing window with this title
frame = JFrame('Loan Payment Calculator');
frame.setSize( 300,200)

% put the dialog in the center of the screen
% ** default sizes are approximate since we use pack below
defXSize = 300;
defYSize = 200;
% get screensize from MATLAB
ss = get(0,'ScreenSize');

% calculate x and y start points
xloc = ss(3) / 2 - defXSize / 2;
yloc = ss(4) / 2 - defYSize / 2;

% create Labels, Text Fields/Areas, and Buttons 
LabelLoan   = JLabel('Amount of Loan');
LabelYears  = JLabel('Number of Years');
LabelRate   = JLabel('Interest Rate');
TextLoan    = JTextField(9);
TextYears   = JTextField(3);
BoxRate    = JComboBox({' ','9.25','9.0','8.75',...
        '8.5','8.25','8.0','7.75',...
        '7.5','7.25','7.0','6.75',...
        '6.5','6.25'});
ButtonCalc  = JButton('Calculate');
ButtonClear = JButton('Clear');
ButtonQuit = JButton('Quit');

LabelPayment = JLabel('Monthly Payment');
TextPayment  = JTextField(8);
LabelIntPaid = JLabel('Total Interest Paid');
TextIntPaid  = JTextField(9);

% create layout
MainPanel = JPanel( GridLayout(1,2) );
InPanel   = JPanel( BoxLayout.Y_AXIS );
OutPanel  = JPanel( BoxLayout.Y_AXIS );

% add the labels to the input panel
InPanel.add( LabelLoan );
InPanel.add( TextLoan );
InPanel.add( LabelYears );
InPanel.add( TextYears );
InPanel.add( LabelRate );
InPanel.add( BoxRate );
InPanel.add( ButtonCalc );
InPanel.add( ButtonClear );

% add the labels to the output panel
OutPanel.add( LabelPayment );
OutPanel.add( TextPayment );
OutPanel.add( LabelIntPaid );
OutPanel.add( TextIntPaid );
OutPanel.add( ButtonQuit );

% add the Input and Output panels to the main panel
MainPanel.add( InPanel );
MainPanel.add( OutPanel );

% add the main panel to the main frame (a.k.a. window)
frame.getContentPane.add( MainPanel );

% force dialog location
frame.setLocation(Point(xloc,yloc));

% make dialog visible
frame.show;

set( InPanel, 'UserData', [0 0 0]);
set( frame,'WindowClosingCallback', ...
    {@Callback, InPanel},...
    'Name','quit');
set( BoxRate, 'ActionPerformedCallback',...
    {@Callback, InPanel}, ...
    'Name','rate');
set( ButtonCalc, 'ActionPerformedCallback',...
    {@Callback, InPanel}, ...
    'Name','calc');
set( ButtonClear, 'ActionPerformedCallback',...
    {@Callback, InPanel}, ...
    'Name','clear');
set( ButtonQuit, 'ActionPerformedCallback',...
    {@Callback, InPanel}, ...
    'Name','quit');
set( TextLoan, 'ActionPerformedCallback',{@Callback, InPanel}, ...
    'FocusLostCallback',{@Callback, InPanel},...
    'HorizontalAlignment',[4], ... %right justified
    'Name','loan');
set( TextYears, 'ActionPerformedCallback',{@Callback, InPanel}, ...
    'FocusLostCallback',{@Callback, InPanel},...
    'HorizontalAlignment',[4], ... %right justified
    'Name','year');
set( TextPayment, 'HorizontalAlignment',[4], ... %right justified
    'Editable','off',...
    'Background',[1 1 1]);
set( TextIntPaid, 'HorizontalAlignment',[4], ... %right justified
    'Editable','off',...
    'Background',[1 1 1]);


while ~(exist('STOP'))
    waitfor(InPanel,'ApplicationData')
    
    result = getappdata(InPanel,'QuestionAppData');
    
    if ~isnumeric(result)
        if (strcmp(result,'calc'))      % write out answers in text fields
        UData = get( ButtonCalc, 'UserData'); 
        set( TextPayment , 'Text', cur2str( UData(1) ));
        set( TextIntPaid , 'Text', cur2str( UData(2) ));
        elseif (strcmp(result,'clear')) % clear out text fields
        set( TextPayment , 'Text', '');
        set( TextIntPaid , 'Text', '');
        set( TextYears, 'Text', '' );
        set( TextLoan, 'Text', '' );
        set( BoxRate, 'SelectedItem',' ' );
        else                            % end application and close
            STOP = 1;
        end    
    end
    
    rmappdata(InPanel,'QuestionAppData'); % clear application data
end

% close the java window
frame.dispose;

%
% since this function is called via a function handle
% The args are eventSrc (the handle of object which threw 
% the event), eventData (unused in release 12), and panel
% (nargin are when the callback is created).
%
function Callback( eventSrc, eventData, panel )

UData = get( panel, 'UserData');

name = get(eventSrc,'Name');

switch name
case 'rate'    % get rate selected and save in panel
    Srate = get( eventSrc, 'SelectedItem' );
    result = str2num(Srate);
    UData = [UData(1) UData(2) result];
case 'year'    % get number of years and save in panel
    Syear = get( eventSrc, 'Text' );
    if (strcmp(Syear,''))
        result = 1;    
    else
        result = str2num(Syear);
    end
    UData = [ UData(1) result UData(3)];
case 'loan'    % get amount of loan and save in panel
    Sloan = get( eventSrc, 'Text' );
    if (strcmp(Sloan,''))
        result = 0;    
    else
        result = str2num(Sloan);
    end
    UData = [ result UData(2) UData(3)];
case 'calc'    % calculate payments and interest
    [PRINP,INTP,BAL,P] = amortize(UData(3)/1200,UData(2)*12,UData(1));
    set( eventSrc, 'UserData', [ P sum(INTP) ]);
    result = 'calc';
case 'clear'   % send command to clear text fields
    result = 'clear';
case 'quit'    % send command to stop waiting and close application
    result = 'quit';
end
set( panel, 'UserData', UData );
setappdata( panel, 'QuestionAppData', result );
