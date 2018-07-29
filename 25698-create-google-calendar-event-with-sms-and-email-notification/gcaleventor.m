function result=gcaleventor(userName, password, title, content, location, smsMe, emailMe, DelayInMin)
% author: Ofir Bibi
% This script uses the GData interface for the Google Calendar.
% Using this script you can create a new event in your calendar.
% userName - your google username (including gmail.com domain)
% password - your google password
% title - The title of the event
% content - The content of the event
% location - the location of the event
% smsMe - true if you want an sms reminder
% emailMe - true if you want an email reminder
% DelayInMin - gap in minutes from now to the time of the event.
% returns 0 if the event was created, negative number for errors.

import java.io.*;
import java.net.*;
import java.lang.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

MSMIN=60000;
MAXITER=10;
result=0;

eventpre=['<entry xmlns=''http://www.w3.org/2005/Atom''' ...
' xmlns:gd=''http://schemas.google.com/g/2005''>' ...
'<category scheme=''http://schemas.google.com/g/2005#kind''' ...
' term=''http://schemas.google.com/g/2005#event''></category>' ...
'<title type=''text''>' title '</title>' ...
'<content type=''text''>' content '</content>' ...
'<gd:transparency value=''http://schemas.google.com/g/2005#event.opaque''>' ...
'</gd:transparency><gd:eventStatus' ...
' value=''http://schemas.google.com/g/2005#event.confirmed''>' ...
'</gd:eventStatus><gd:where valueString=''' location '''></gd:where>' ...
'<gd:when startTime='''];
eventmid=''' endTime=''';
eventend='''>';
if (smsMe)
   eventend=[eventend '<gd:reminder method=''sms'' minutes=''0''/>'];
end
if (emailMe)
    eventend=[eventend '<gd:reminder method=''email'' minutes=''0''/>'];
end
eventend=[eventend '</gd:when></entry>'];
posturlString = ['http://www.google.com/calendar/feeds/' userName '/private/full'];

[authorized, aToken]=connectNAuthorize(userName, password);
if (~authorized)
    result=-1;
    return;
end
success=false;
try
    % try to create new event
    safeguard=0;
    while (~success && safeguard<MAXITER)
        safeguard=safeguard+1;
        url = URL( posturlString );
        con = url.openConnection();
        con.setInstanceFollowRedirects(false);
        % set up url connection to get retrieve information back
        con.setRequestMethod( 'POST' );
        con.setDoOutput( true );
        con.setDoInput( true );
        con.setRequestProperty('content-type','application/atom+xml;charset=UTF-8');
        % stuff the Authorization request header
        con.setRequestProperty('Authorization',String('GoogleLogin ').concat(aToken));
        now = Date();
        now.setTime(now.getTime()+MSMIN*(1+DelayInMin));
        df = SimpleDateFormat('yyyy-MM-dd HH:mm:ss');
        time=df.format(now);
        time=time.replace(' ', 'T');
        event=[eventpre char(time) eventmid char(time) eventend];
        ps = PrintStream(con.getOutputStream());
        ps.print(event);
        ps.close();
        % pull the information back from the URL
        is = con.getInputStream();
        if (con.getResponseCode()==302)
            posturlString = con.getHeaderField('Location');
            con.disconnect();
            continue;
        end
        con.disconnect();
        success=true;
    end
catch ME
    disp(ME.message);
    disp(['from line: ' num2str(ME.stack.line)]);
    result = -2;
    return;
end
if (~success)
    result = -3;
end

end


function [authorized, aToken]=connectNAuthorize(userName, password)
import java.io.*;
import java.net.*;
import java.lang.*;
loginurlString = 'https://www.google.com/accounts/ClientLogin';
params = {'Email', 'Passwd', 'source', 'service'};
vals = {userName,password,'OPB-MatlabCal-1','cl'};
authorized = true;
try
    % open url connection
    url = URL( loginurlString );
    con = url.openConnection();
    % set up url connection to get retrieve information back
    con.setRequestMethod( 'POST' );
    con.setDoOutput( true );
    con.setRequestProperty('content-type','application/x-www-form-urlencoded');
    ps = PrintStream(con.getOutputStream());
    for i=1:length(params)
        if (i > 0)
            ps.print('&');
        end
        param = URLEncoder.encode(params{i}, 'UTF-8');
        value = URLEncoder.encode(vals{i}, 'UTF-8');
        ps.print(param.concat('=').concat(value));
    end
    ps.close();
    % pull the information back from the URL
    is = con.getInputStream();
    buf = java.lang.StringBuffer();
    c = int32(is.read());
    while( c ~= -1 )
        buf.append( char(c) );
        c = int32(is.read());
    end
    con.disconnect();
    % get the Authorization Token
    aToken=java.lang.String('auth').concat(buf.substring(buf.lastIndexOf('Auth')+4,buf.length()-1));
catch ME
    disp(['from line: ' num2str(ME.stack.line)]);
    error(ME.message);
end

end