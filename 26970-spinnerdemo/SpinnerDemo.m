function hFigOut = SpinnerDemo
% SpinnerDemo - Demonstrates usage of Java Spinners in Matlab
%
% SpinnerDemo demonstrates the usage of Java spinner controls
% (javax.swing.JSpinner) in a Matlab application. The demo includes three
% spinners with different data models: List (cell array of strings), Number
% and Date. The spinners are interconnected using their StateChangedCallback
% so that modifying one spinner automatically affects the others.
%
% In addition, this utility demonstrates how to assign keyboard mnemonics
% (hot-keys) to a label and attach it to the spinner control. HTML tooltips
% are also demonstrated (on the labels).
%
% This utility also demonstrates how to set-up the useful feature of closing
% a figure window with the <ESC> key.
%
% This utility was inspired by the official Java demostration of JSpinner:
% <a href="http://bit.ly/b1gg56">http://java.sun.com/docs/books/tutorial/uiswing/components/spinner.html</a>
%
% Bugs and suggestions:
%    Please send to Yair Altman (altmany at gmail dot com)
%
% Release history:
%    1.0 2010-03-16: initial version

% License to use and modify this code is granted freely to all interested, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.

% Programmed and Copyright by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.0 $  $Date: 2010/03/16 15:57:23 $

   error(javachk('swing',mfilename)) % ensure that Swing components are available

   % Create the demo figure
   hFig = figure('pos',[200,400,180,150], 'Name','SpinnerDemo', 'NumberTitle','off', 'MenuBar','none', 'ToolBar','none');
   color = get(hFig,'Color');
   colorStr = mat2cell(color,1,[1,1,1]);
   jColor = java.awt.Color(colorStr{:});

   % Prepare the data values/limits
   dateVecData = datevec(now);
   currentYear = dateVecData(1);
   minYear = currentYear - 1;
   maxYear = currentYear + 5;
   years = minYear : maxYear;
   months = {'January', 'February', 'March', ...
             'April', 'May', 'June', ...
             'July', 'August', 'September', ...
             'October', 'November', 'December'};
   dates = {};
   for year = years
      for monthIdx = 1 : 12
         dates{end+1} = sprintf('%02d/%d',monthIdx,year);
      end
   end
   calendar = java.util.Calendar.getInstance;
   currentDate = calendar.getTime;
   calendar.set(minYear,0,-1,12,0);  % Jan 1st
   minDate = calendar.getTime;
   calendar.set(maxYear,11,1,12,0);  % Jan 1st
   maxDate = calendar.getTime;

   % Display the spinner & label controls
   monthsModel = javax.swing.SpinnerListModel(months);
   jhSpinnerM = addLabeledSpinner('&Month',monthsModel,[70,110,80,20], @monthYearChangedCallback);
   jhSpinnerM.setValue(datestr(now,'mmmm'));
   
   yearsModel = javax.swing.SpinnerNumberModel(currentYear,minYear,maxYear,1);
   jhSpinnerY = addLabeledSpinner('&Year', yearsModel, [70,80,80,20], @monthYearChangedCallback);
   jEditor = javaObject('javax.swing.JSpinner$NumberEditor',jhSpinnerY, '#');
   jhSpinnerY.setEditor(jEditor);

   datesModel = javax.swing.SpinnerDateModel(currentDate,minDate,maxDate,calendar.MONTH);
   jhSpinnerD = addLabeledSpinner('&Date', datesModel, [70,50,80,20], @dateChangedCallback);
   jEditor = javaObject('javax.swing.JSpinner$DateEditor',jhSpinnerD, 'MM/yyyy');
   jhSpinnerD.setEditor(jEditor);

   % Enable exit upon pressing <ESC> key
   enableCloseOnEsc;

   if nargout,  hFigOut = hFig;  end

   % Add a label attached to a spinner
   function jhSpinner = addLabeledSpinner(label,model,pos,callbackFunc)
      % Set the spinner control
      jSpinner = com.mathworks.mwswing.MJSpinner(model);
      %jTextField = jSpinner.getEditor.getTextField;
      %jTextField.setHorizontalAlignment(jTextField.RIGHT);  % unneeded
      jhSpinner = javacomponent(jSpinner,pos,hFig);
      jhSpinner.setToolTipText('<html>This spinner is editable, but only the<br/>preconfigured values can be entered')
      set(jhSpinner,'StateChangedCallback',callbackFunc);

      % Set the attached label
      jLabel = com.mathworks.mwswing.MJLabel(label);
      jLabel.setLabelFor(jhSpinner);
      jLabel.setBackground(jColor);
      if jLabel.getDisplayedMnemonic > 0
          hotkey = char(jLabel.getDisplayedMnemonic);
          jLabel.setToolTipText(['<html>Press <b><font color="blue">Alt-' hotkey '</font></b> to focus on<br/>adjacent spinner control']);
      end
      pos = [20,pos(2),pos(1)-20,pos(4)];
      jhLabel = javacomponent(jLabel,pos,hFig);
   end  % addLabeledSpinner

   % Enable exit upon pressing <ESC> key
   function enableCloseOnEsc
      drawnow;
      try
         jFrame = javax.swing.SwingUtilities.windowForComponent(jhSpinnerD);
         jFrame.setCloseOnEscapeEnabled(true);
      catch
         % never mind...
      end
   end  % enableCloseOnEsc

   % Month or Year changed callback
   function monthYearChangedCallback(jSpinner,jEventData)
      persistent inCallback
      try
         if ~isempty(inCallback),  return;  end
         inCallback = 1;  %#ok used
         newMonthStr = jhSpinnerM.getValue;
         newMonthIdx = find(strcmpi(months,newMonthStr));
         newYear = jhSpinnerY.getValue;
         calendar.set(newYear,newMonthIdx-1,1,12,0);
         jhSpinnerD.setValue(calendar.getTime);
      catch
          a=1; % never mind...
      end
      inCallback = [];
   end  % monthChangedCallback

   % Date changed callback
   function dateChangedCallback(jSpinner,jEventData)
      persistent inCallback
      try
         if ~isempty(inCallback),  return;  end
         inCallback = 1;  %#ok used
         newDate = jSpinner.getValue;
         jhSpinnerM.setValue(months{newDate.getMonth+1});
         jhSpinnerY.setValue(newDate.getYear + 1900);
      catch
          a=1; % never mind...
      end
      inCallback = [];
   end  % dateChangedCallback
end