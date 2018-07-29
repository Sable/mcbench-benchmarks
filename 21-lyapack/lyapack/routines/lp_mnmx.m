function p = lp_mnmx(rw,l0)
%
%  Suboptimal solution of the ADI minimax problem. The delivered parameter
%  set is closed under complex conjugation. 
%
%  Calling sequence:
%
%    p = lp_mnmx(rw,l0)
%
%  Input:
%
%    rw        a vector containing numbers in the open left half plane, which
%              approximate the spectrum of the corresponding matrix, e.g.,
%              a set of Ritz values. The set must be closed w.r.t. complex
%              conjugation;
%    l0        desired number of shift parameters (length(rw) >= l0)
%              (The algorithm delivers either l0 or l0+1 parameters!).
%
%  Output:
%
%    p         an l0- or l0+1-vector of suboptimal ADI parameters;
%
%  Remarks:
%
%   
%  LYAPACK 1.0 (Thilo Penzl, October 1999)

% Input data not completely checked!

if length(rw)<l0
  error('length(rw) must be at least l0.');
end

max_rr = +Inf;                       % Choose initial parameter (pair)

for i = 1:length(rw)
  max_r = lp_s(rw(i),rw); 
  if max_r < max_rr
    p0 = rw(i);
    max_rr = max_r;
  end
end  

if imag(p0)
  p = [ p0; conj(p0) ];
else
  p = p0;                            
end  

[max_r,i] = lp_s(p,rw);         % Choose further parameters.

while size(p,1) < l0 
   
  p0 = rw(i);
  if imag(p0)
    p = [ p; p0; conj(p0) ];
  else
    p = [ p; p0]; 
  end
  
  [max_r,i] = lp_s(p,rw);
    
end

