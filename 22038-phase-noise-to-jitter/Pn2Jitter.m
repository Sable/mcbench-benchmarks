function Jitter = Pn2Jitter(f, Lf, fc)
%
% Summary: Jitter (RMS) calculation from phase noise vs. frequency data.
%
% Calculates RMS jitter by integrating phase noise power data.
%  Phase noise data can be derived from graphical information or an
%  actual measurement data file.
%
% Usage:
%   Jitter = Pn2Jitter(f, Lf, fc)
% Inputs:
%   f:  Frequency vector (phase noise break points), in Hz, row or column.
%   Lf: Phase noise vector, in dBc/Hz, same dimensions, size(), as f.
%   fc: Carrier frequency, in Hz, a scalar.
% Output:
%   Jitter: RMS jitter, in seconds.
%
% Examples: 
%  [1]   >> f = [10^0 10^1 10^3 10^4  10^6]; Lf = [-39 -73 -122 -131 -149];
%        >> Jitter = Pn2Jitter(f, Lf, 70e6)
%             Jitter = 2.3320e-011
%       Comparing fordahl application note AN-02-3{*} and jittertime.com{+}
%         calculations at fc = 70MHz
%        Pn2Jitter.m:                    23.320ps
%        AN-02-3 (graphical method):     21.135ps
%        AN-02-3 (numerical method):     24.11ps
%        Aeroflex PN9000 computation:    24.56ps
%        JitterTime.com calculation:     23.32ps
%
%    {*} fordahl Application Note AN-02-3:
%                                        "Phase noise to Jitter conversion"
%        http://fordahl.com/images/phasenoise.pdf
%         As of 11 May 2007 it also appears here:
%          http://www.metatech.com.hk/appnote/fordahl/pdf/e_AN-02-3.pdf
%          http://www.metatech.com.tw/doc/appnote-fordahl/e-AN-02-3.pdf
%
%    {+} JitterTime Consulting LLC web calculator
%        http://www.jittertime.com/resources/pncalc.shtml
%         As of 5 May 2008
%
%  [2]   >> f =  [10^2 10^3 10^4 10^5 10^6 10^7 4.6*10^9];
%        >> Lf = [-82  -80  -77  -112 -134 -146 -146    ]; format long
%        >> Jitter = Pn2Jitter(f, Lf, 2.25e9)
%             Jitter = 1.566598599875678e-012
%       Comparing ADI application note{$} calculations at fc = 2.25GHz
%        Pn2Jitter.m:  1.56659859987568ps
%        MT-008:       1.57ps
%        Raltron {&}:  1.56659857673259ps
%        JitterTime:   1.529ps--excluding the (4.6GHz, -146) data point,
%                               as 1GHz is the maximum allowed
%    {$} Analog Devices, Inc. (ADI) application note MT-008:
%                        "Converting Oscillator Phase Noise to Time Jitter"
%        http://www.analog.com/en/content/0,2886,760%255F%255F91502,00.html
%    {&} Raltron web RMS Phase Jitter calculator:
%                                       "Convert SSB phase noise to jitter"
%        http://www.raltron.com/cust/tools/osc.asp
%           Note:  Raltron is restricted to f(min) = 10Hz;
%                  therefore it cannot be used in this example [1].
%
%  [3]   >> f = [10^2 10^3 10^4  200*10^6]; Lf = [-125 -150 -174 -174];
%        >> Jitter = Pn2Jitter(f, Lf, 100e6)
%             Jitter = 6.4346e-014
%       Comparing ADI application note{$} calculations at fc = 100MHz
%        Pn2Jitter.m: 0.064346ps
%        MT-008:      0.064ps
%        JitterTime:  0.065ps
%
% Note:
%   f and Lf must be the same length, lest you get an error and this
%         Improbable Result:  Jitter = 42 + 42i.
%
%  (A spreadsheet, noise.xls, is available from Wenzel Associates, Inc. at 
%   http://www.wenzel.com, "Allan Variance from Phase Noise."
%   It requires as input tangents to the plotted measured phase noise data,
%   with slopes of 1/(f^n)--not the actual data itself--for the
%   calculation.  The app. note from fordahl discusses this method, in
%   addition to numerical, to calculate jitter.  This graphical straight-
%   line approximation integration technique tends to underestimate total
%   RMS jitter.)
%
%  [4]   Data can also be imported directly from an Aeroflex PN9000 ASCII
%         file, after removing extraneous text.  How to do it:
%        (1) In Excel, import the PN9000 data file as Tab-delimited data,
%        (2) Remove superfluous columns and first 3 rows, leaving 2 columns
%             with frequency (Hz) and Lf (dBc/Hz) data only. 
%             (With the new PN9000 as of April 2006, only the first row
%             is to be removed, and there are only two columns.
%             I may take advantage of this in an updated version of this
%              program,thereby eliminating the need to edit the data),
%        (3) Save As -> Text (MS-DOS) (*.txt), e.g., a:\Stuff.txt, 
%        (4) At the MATLAB Command Window prompt:
%             >> load 'a:\Stuff.txt' -ascii
%            Now Stuff is a MATLAB workspace variable with the
%             phase noise data, 
%        (5) >> Pn2Jitter(Stuff(:,1), Stuff(:,2), fc);
%              (assuming fc has been defined)
%       One 10MHz carrier data set resulted in the following:
%        Pn2Jitter.m:         368.33fs
%        PN9000 calculation:  375fs
% 
% Runs at least as far back as MATLAB version 5.3 (R11.1).
%
% Copyright (c) 2005 by Arne Buck, Axolotol Design, Inc. Friday 13 May 2005
%   arne   (d 0 t)   buck   [a +]   alum   {D o +}   mit   (d 0 +}   e d  u
%   $Revision: 1.2 $  $Date: 2005/05/13 23:42:42 $
%
% License to use and modify this code is granted freely, without warranty,
%  to all as long as the original author is referenced and attributed
%  as such.  The original author maintains the right to be solely
%  associated with this work.  So there.

% Bug fixes to resolve problematic data resulting in division by 0, or
%  excessive exponents beyond MATLAB's capability of realmin (2.2251e-308)
%  and realmax (1.7977e+308); no demonstrable effect on jitter calculation
% AB 18May2005 Fix /0 bug for *exactly* -10.000dB difference in adjacent Lf
% AB 24May2005 Fix large and small exponents resulting from PN9000 data
% AB 11May2007 Improve documentation, update URLs
% AB  5May2008 Verify and update URLs
tic
%%  It's almost nine o'clock.  We've got to go to work.
L = length(Lf); 
if L == length(f)
% Fix ill-conditioned data.
I=find(diff(Lf) == -10); Lf(I) = Lf(I) + I/10^6; % Diddle adjacent Lf with
                                             % a diff=-10.00dB, avoid ai:/0
% Just say "No" to For loops.
lp = L - 1; Lfm = Lf(1:lp); LfM = Lf(2:L); % m~car+, M=cdr
fm  = f(1:lp); fM = f(2:L);  ai = (LfM-Lfm) ./ (log10(fM) - log10(fm));
% Cull out problematic fine-sieve data from the PN9000.
Iinf = find( (fm.^(-ai/10) == inf) | fm.^(-ai/10)<10^(-300)); % Find Inf

fm(Iinf) = []; fM(Iinf-1) = []; Lfm(Iinf) = []; LfM(Iinf-1) = [];
ai(Iinf) = []; f(Iinf) = []; Lf(Iinf) = [];

% Where's the beef?
Jitter = ...
    1/(2*pi*fc)*sqrt(2*sum( 10.^(Lfm/10) .* (fm.^(-ai/10)) ./ (ai/10+1)...
    .* (fM.^(ai/10+1) - fm.^(ai/10+1)) ));

else
    disp('> > Oops!');
    disp('> > > The f&Lf vector lengths are unequal.  Where''s the data?')
    Jitter = sqrt(sqrt(-12446784));
end % if L
toc