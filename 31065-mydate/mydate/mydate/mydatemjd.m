function mjd = mydatemjd (epoch)
    jd = mydatejd (epoch);
    mjd = jd - 2400000.5;
    % Definition (from [2]): 
    % "The Modified Julian Day or MJD is defined as:
    %     MJD = JD - 2400000.5
    % so that MJD = 0.0 corresponds to November 17.0, 1858. 
    % The MJD begins at Greenwich mean midnight..."
    % [2] Peter Baum, "Date algorithms"
    % <http://mysite.verizon.net/aesir_research/date/date0.htm>
    % <http://vsg.cape.com/~pbaum/date/date0.htm>
end

%!test
%! myassert (mydatemjd([1858 11 17  0 0 0]), 0)

