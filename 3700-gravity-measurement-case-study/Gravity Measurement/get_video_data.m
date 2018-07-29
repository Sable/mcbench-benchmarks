% get_video_data.m

% Copyright 2003-2010 The MathWorks, Inc.

imaqreset
hw=imaqhwinfo('winvideo');      %create video object

if length(hw.DeviceIDs)>0
  msg='Grab live data from camera or load captured data from file?';
  button=questdlg(msg,'Data source','Grab','Load','Load');
  switch button
    case 'Grab'
      setup_live_capture
    case 'Load'
      load_captured_data
    otherwise
      error('user aborted program')
  end
else
  load_captured_data
end
