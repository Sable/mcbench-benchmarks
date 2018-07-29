function [w_out,ln_out] = straitln(term_mat,w,mode)
% STRAITLN Straight line approximation of bode response.
%          STRAITLN computes the straight line approximation of either the
%          magnitude response or phase response.  MODE = 1 computes the
%          magnitude response; MODE = 2 computes the phase response.

% Author: Craig Borghesani
% Date: 9/3/94
% Revised: 10/20/94
% Copyright (c) 1999, Prentice-Hall

% convert term_mat to extract lead/lag elements
term_mat = termcnvt(term_mat);
[num,den] = termextr(term_mat);
n=find(num~=0); d=find(den~=0);
dcgain = num(n(length(n)))/den(d(length(d)));
w_out = []; ln_out = [];

% pull out break frequency values and add to frequency vector
break_frq = [];
pole_zero = term_mat(find(term_mat(:,4)==4 | term_mat(:,4)==5),1);
wn = term_mat(find(term_mat(:,4)==6 | term_mat(:,4)==7),2);
break_frq = sort([abs([pole_zero(:)',wn(:)'])]);
if length(break_frq),
 break_frq = sort([break_frq,break_frq/10,break_frq*10]);
 break_frq(logical([0,diff(break_frq)==0]))=[];
end
wnew = sort([w,break_frq]);
wnew(logical([0,diff(wnew)==0]))=[];
[r,c]=size(term_mat);

lw = length(wnew);

% initialize magnitude straight line with gain
if mode == 1,
 ln_out = zeros(1,lw)+20*log10(abs(dcgain));
else
 ln_out = zeros(1,lw)-180*(term_mat(1,1)<0);
end

% handle integrators/differentiators first
first_w = wnew(1);
for k = 1:abs(term_mat(2,1)),
 if mode == 1,
  ln_out = ln_out - sign(term_mat(2,1))*20*log10(first_w);
  ln_out = ln_out - sign(term_mat(2,1))*20*(log10(wnew)-log10(first_w));
 else
  ln_out = ln_out - sign(term_mat(2,1))*90;
 end
end

% add in the rest of the terms
for k = 3:r,

% find break frequencies for both magnitude and phase plots
 if any(term_mat(k,4)==[4,5]),
  brk = find(wnew == abs(term_mat(k,1)));
 else
  brk = find(wnew == abs(term_mat(k,2)));
 end
 brk_w = wnew(brk);
 brkl = find(wnew == brk_w/10);
 brkl_w = wnew(brkl);
 brkr = find(wnew == brk_w*10);
 brkr_w = wnew(brkr);

 if any(term_mat(k,4)==[4,5]),

  if term_mat(k,4)==4,
   if mode == 1,
    ln_out(brk:lw) = ln_out(brk:lw) - 20*(log10(wnew(brk:lw))-log10(brk_w));
   else
    ln_out = ln_out - 180*(term_mat(k,1)<0);
    ln_out(brkl:brkr) = ln_out(brkl:brkr) - sign(term_mat(k,1))*45*(log10(wnew(brkl:brkr))-log10(brkl_w));
    ln_out((brkr+1):lw) = ln_out((brkr+1):lw) - 90*sign(term_mat(k,1));
   end
  else
   if mode == 1,
    ln_out(brk:lw) = ln_out(brk:lw) + 20*(log10(wnew(brk:lw))-log10(brk_w));
   else
    ln_out = ln_out - 180*(term_mat(k,1)<0);
    ln_out(brkl:brkr) = ln_out(brkl:brkr) + sign(term_mat(k,1))*45*(log10(wnew(brkl:brkr))-log10(brkl_w));
    ln_out((brkr+1):lw) = ln_out((brkr+1):lw) + 90*sign(term_mat(k,1));
   end
  end

 elseif any(term_mat(k,4)==[6,7]),
  if term_mat(k,4)==6,
   if mode == 1,
    ln_out(brk:lw) = ln_out(brk:lw) - 40*(log10(wnew(brk:lw))-log10(brk_w));
   else
    ln_out(brkl:brkr) = ln_out(brkl:brkr) - sign(term_mat(k,2))*90*(log10(wnew(brkl:brkr))-log10(brkl_w));
    ln_out((brkr+1):lw) = ln_out((brkr+1):lw) - 180*sign(term_mat(k,2));
   end
  else
   if mode == 1,
    ln_out(brk:lw) = ln_out(brk:lw) + 40*(log10(wnew(brk:lw))-log10(brk_w));
   else
    ln_out(brkl:brkr) = ln_out(brkl:brkr) + sign(term_mat(k,2))*90*(log10(wnew(brkl:brkr))-log10(brkl_w));
    ln_out((brkr+1):lw) = ln_out((brkr+1):lw) + 180*sign(term_mat(k,2));
   end
  end
 end

end

if mode == 1,

 w_out = wnew;

else

% re-adjust phase vector
 ph = phasecor(exp(i*ln_out*pi/180),[-360,0]);
 brkph=find(abs(diff(ph))>170);
 t=1; ln_out=[]; w_outt=[];
 for k=brkph,
  ln_out=[ln_out,ph(t:k),NaN];
  w_out=[w_out,wnew(t:k),NaN];
  t=k+1;
 end

 ln_out=[ln_out,ph(t:length(ph))];
 w_out=[w_out,wnew(t:length(wnew))];
end