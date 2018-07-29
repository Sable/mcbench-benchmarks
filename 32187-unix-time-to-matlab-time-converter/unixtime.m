function [outputtime] = unixtime(inputtime) 

% input:
% either
% a matrix with matlab datevectors
% or
% a vertical vector with unix timestamps
% dependent on the input, this function converts one timeformat into the
% other

% unixtime is seconds since 1.1.1970
% matlabtime is days after 1.1.000

if size(inputtime,1) == 0
   outputtime = [];
else
    if size(inputtime,2) == 6
        unixstart = zeros(size(inputtime,1),6);
        for count = 1:size(inputtime,1)
            unixstart(count,:) = [1970,1,1,0,0,0];
        end
        outputtime = etime(inputtime,unixstart);
    elseif size(inputtime,2) == 1
        secs = floor(inputtime);
        nanosecs = inputtime - secs;
        unixstart = [1970,1,1,0,0,0];
        matlabtime = datenum(unixstart) + secs/86400;
        outputtime = datevec(matlabtime);
        outputtime(:,6) = outputtime(:,6) + nanosecs;
    else
        error('wrong format of input matrix');
    end
end
