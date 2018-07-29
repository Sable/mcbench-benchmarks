function [] = remindme(time,msg)
%REMINDME  Will issue a remider at the specified time.
% REMINDME(time,message) issues the user a pop-up reminder (message) at the
% specified time (time).  If the user hits snooze, the message will be
% given again 10 minutes later.  The user may hit snooze three times, then
% the reminders will stop. The second argument, is not necessary, and if 
% omitted, a default message will be displayed: 'This is your reminder.'
%
% Example:   
%
%       remindme('1:20','There is more to life than Matlab.')
%       %Will issue the message to the user at the next occurence of 1:20.
%
% The maximum usable time is 12 hours, but who works longer anyway?
%
% See also timer, questdlg
%
% Author:  Matt Fig
% Contact: popkenai@yahoo.com
% Updated: 7/25/2008

if nargin < 2
    msg = '  This is your reminder.';
end

current = clock;
crnt = mod(current(4),12)+current(5)/60+current(6)/3600;   % Current time.

if length(time)==4   % hrs is the number of hours till remind.
    hrs = str2double(time(1))+str2double(time(3:4))/60;  
elseif length(time)==5
    hrs = str2double(time(1:2))+str2double(time(4:5))/60;
else
    error('Time must be in the format hh:mm or h:mm only.');
end

nmhrs = max([mod(12,hrs-crnt) mod(hrs-crnt,12)]);  % Hours to delay. 

tmr = timer('Name','Reminder',...
      'Period',10*60,...  % 10 minute snooze time.                
      'StartDelay',round(nmhrs*3600),... % alarm time in seconds.
      'TasksToExecute',3,...  % number of snoozes allowed.
      'ExecutionMode','fixedSpacing',...
      'TimerFcn',{@reminder, msg},...   % Function def. below.
      'StopFcn',@deleter);   % Function def. below.       

start(tmr);


function reminder(obj,edata,msg) %#ok  M-Lint doesn't know callback fmt.
% Callback for timerfcn.

load train   % Here make a mix of sounds to go with the reminder.
yt = y;   %#ok  M-Lint doesn't know that y came from train.
load gong
yg = y;
load laughter
y = [yt;yg;y];
sound(y,Fs);

if get(obj, 'TasksExecuted') == 3  % Completed three snoozes
  btn = questdlg({datestr(now), msg},...   % question
        sprintf('Reminder: Final'),...  % title
        'O.k. (Stop)',...   % button1
        'O.k. (Stop)');   % default    
else
  btn = questdlg({datestr(now),msg},...   % question                                        
        sprintf('Reminder: #%d',get(obj,'TasksExecuted')),... % title        
        'O.k. (Stop)',...   % button1                                                         
        sprintf('Snooze (%0.2g min)',get(obj,'Period')/60),...  % button2                 
        'O.k. (Stop)');   % default                                                      
end

clear playsnd;

if isequal(btn,'O.k. (Stop)')
   set(obj, 'TasksToExecute', get(obj, 'TasksExecuted')); 
end


function deleter(obj,edata)   %#ok   M-Lint doesn't know the callback fmt.
% Callback for stopfcn.
wait(obj);
delete(obj);