function [txt_han,txt_lft] = coefdisp(txt_lft,txt_btm,coeffs,paren,data)
% COEFDISP Display of coefficients.

% Author: Craig Borghesani
% Date: 11/15/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

len_coeff = length(coeffs);
txtct = 1;
ers = 'norm';
fontname = 'times';

for loc_coeff = 1:len_coeff,

 cur_coeff = coeffs(loc_coeff);
 power = len_coeff - loc_coeff;

 if cur_coeff~=0,
  coeff_str = num2str(abs(cur_coeff));
  if power > 0 & abs(cur_coeff) == 1,
   coeff_str = [];
  end

  if cur_coeff > 0 & loc_coeff > 1,
   coeff_str = ['+',coeff_str];
  elseif cur_coeff < 0,
   coeff_str = ['-',coeff_str];
  end

  if power > 0,
   cur_str = [coeff_str,'s'];
  else
   cur_str = coeff_str;
  end

  if paren,
   if loc_coeff == 1,
    cur_str = ['(',cur_str];
   elseif loc_coeff == len_coeff,
    cur_str = [cur_str,')'];
   end
  end

  txt_han(txtct) = text(txt_lft,txt_btm,cur_str,'erase',ers,...
              'horizontalalignment','left','verticalalignment','bottom',...
              'fontname',fontname);
  set(txt_han(txtct),'userdata',data);
  txt_ext = get(txt_han(txtct),'extent');
  txt_lft = txt_lft + txt_ext(3);
  txtct=txtct+1;

  if power > 1,
   sup_btm = txt_btm + txt_ext(4)/3;
   pow_str = num2str(power);
   txt_han(txtct) = text(txt_lft,sup_btm,pow_str,'erase',ers,...
      'horizontalalignment','left','verticalalignment','bottom',...
      'fontsize',8,'fontname',fontname);
   set(txt_han(txtct),'userdata',data);
   txt_ext = get(txt_han(txtct),'extent');
   txt_lft = txt_lft + txt_ext(3);
   txtct=txtct+1;
  end
 end
end
