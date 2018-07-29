function chx = bbp_pi(d)
% BBP_PI  Bailey-Borwein-Plouffe algorithm for a few hex digits of pi.
% bbp_pi(d) is a char string of hex digits d+1 through d+13 in the
%   hexadecimal expantsion of pi.
% Does not require extended precision arithmetic or symbolic computation.
% Usually accurate to about 11 or 12 of the 13 digits.
% Derived from C program by David H. Bailey dated 2006-09-08,
% http://www.experimentalmath.info/bbp-codes/piqpr8.c 
% See Cleve's Corner, "Computing Pi",
% http://www.mathworks.com/company/newsletters/news_notes/2011
% For many other references: Google "BBP Pi".

% Copyright 2011 MathWorks, Inc.

   s1 = series (1, d);
   s2 = series (4, d);
   s3 = series (5, d);
   s4 = series (6, d);
   P = 4. * s1 - 2. * s2 - s3 - s4;
   P = P - floor(P) + 1.; 
   chx = hexchar (P, 13);

% ------------------------------

   function s = series(m,d)
      % s = series(m,d) = sum_k 16^(d-k)/(8*k+m)
      % using the modular powering technique.

      s = 0;
      k = 0;
      t = Inf;
      while k < 13 || t > eps
         ak = 8 * k + m;
         if k < d
            t = powmod(16, d - k, ak) / ak;
         else
            t = 16^(d - k) / ak; 
         end
         s = mod(s + t, 1);
         k = k + 1;
      end
   end % series

% ------------------------------

   function r = powmod(b, p, a)
      % powmod(b,p,a) computes mod(b^p,a) without computing b^p.

      persistent twop
      if isempty(twop)
         twop = 2.^(0:25)';
      end
      if a == 1
         r = 0;
         return
      end
      n = find(p <= twop, 1, 'first');
      pt = twop(n);
      r = 1;
      for j = 1:n
         if p >= pt
            r = mod(b * r, a);
            p = p - pt;
         end
         pt = 0.5 * pt;
         if pt >= 1
            r = mod(r * r, a);
         end
      end
   end % powmod

% ------------------------------

   function chx = hexchar(s,n);
      % chx(s,n) = string of the first n hex digits of s.

      hx = '0123456789ABCDEF';
      s = abs(s);
      for j = 1:n
         s = 16. * mod(s, 1);
         chx(j) = hx(floor(s) + 1);
      end
   
   end  % hexchar

end  % bbp_pi
