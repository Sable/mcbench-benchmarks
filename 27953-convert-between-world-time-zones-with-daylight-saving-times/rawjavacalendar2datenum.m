function [ matlabdatenum ] = rawjavacalendar2datenum( cal )
%   Converts a java.util.Calendar date local time into a Matlab datenum.
%   Keeps the original local time, does not try to convert to UTC.
    javaSerialDate = cal.getTimeInMillis() + cal.get(cal.ZONE_OFFSET) + cal.get(cal.DST_OFFSET);
    matlabdatenum = datenum([1970 1 1 0 0 javaSerialDate / 1000]);
end

%http://www.mathworks.co.uk/support/solutions/en/data/1-9B9H2S/index.html?product=ML&solution=1-9B9H2S