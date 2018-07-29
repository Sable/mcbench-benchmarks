function residisp(term_mat,tf_ext)
% RESIDISP Residue display.
%          RESIDISP graphically displays the residues of the current
%          transfer function.

% Author: Craig Borghesani
% Date: 10/28/94
% Revised: 11/11/94
% Copyright (c) 1999, Prentice-Hall

ers = 'norm';
fontname = 'times';
[num,den] = termextr(term_mat);

[res,poles,direct] = residue(num,den);

if ~length(poles),
 direct = term_mat(1,1)*direct;
end

% flip the direct terms
direct = fliplr(direct);

% initial locations
line_yloc = 0.5;
num_btm = line_yloc+0.01;
den_btm = line_yloc-tf_ext(4)-0.01;
txt_lft = sum(tf_ext([1,3]))+0.01;

first = 1;

% delay time
if term_mat(1,2)~=0,
 first = 0;
 txt = text(txt_lft,line_yloc,'d','erase',ers,...
           'horizontalalignment','left','verticalalignment','middle',...
           'fontname','symbol','tag','9','color','k');
 txt_ext = get(txt,'extent');
 txt_lft = txt_lft + txt_ext(3);
 delay_str = num2str(abs(term_mat(1,2)));
 if term_mat(1,2) > 0, delay_str = ['(t - ',delay_str,')'];
 else delay_str = ['(t + ',delay_str,')']; end
 txt = text(txt_lft,line_yloc,delay_str,'erase',ers,...
           'horizontalalignment','left','verticalalignment','middle',...
           'fontname',fontname,'tag','9','color','k');
 txt_ext = get(txt,'extent');
 txt_lft = txt_lft + txt_ext(3);
end

% direct terms
if length(direct),
 first = 0;
 for k = length(direct):-1:1,
  if direct(k) ~= 0,

% round direct with 5 place accuracy
   tmp = sprintf('%5.5f',direct(k));
   direct(k) = str2num(tmp);

   if abs(direct(k)) ~= 1,
    k_str = num2str(abs(direct(k)));
    if k ~= length(direct),
     if direct(k) > 0, k_str = [' + ',k_str];
     else k_str = [' - ',k_str]; end
    end
   elseif direct(k) == -1,
    k_str = ' - ';
   else
    if k ~= length(direct), k_str = ' + ';
    else k_str = ''; end
   end
   if k ~= 1,
    txt = text(txt_lft,line_yloc,k_str,'erase',ers,...
              'horizontalalignment','left','verticalalignment','middle',...
              'fontname',fontname,'tag','9','color','k');
    txt_ext = get(txt,'extent');
    txt_lft = txt_lft + txt_ext(3);
    txt = text(txt_lft,den_btm,'dt','erase',ers,...
              'horizontalalignment','left','verticalalignment','bottom',...
              'fontname',fontname,'tag','9','color','k');
    txt_ext = get(txt,'extent');
    tmp_lft = txt_lft;
    if k > 2,
     tmp_lft = tmp_lft + txt_ext(3);
     sup_btm = den_btm + txt_ext(4)/3;
     txt = text(tmp_lft,sup_btm,int2str(k-1),'erase',ers,...
               'horizontalalignment','left','verticalalignment','bottom',...
               'fontname',fontname,'fontsize',8,'tag','9','color','k');
     txt_ext = get(txt,'extent');
    end
    new_lft = tmp_lft+txt_ext(3);
    lin_lft = txt_lft; lin_rht = new_lft;
    lin = line([lin_lft,lin_rht],[line_yloc,line_yloc],'erase',ers,'color','k');
    txt_mid = txt_lft + (lin_rht-lin_lft)/2;
    txt = text(txt_mid,num_btm,'d','erase',ers,...
             'horizontalalignment','center','verticalalignment','bottom',...
             'fontname',fontname,'tag','9','color','k');
    if k > 2,
     txt_ext = get(txt,'extent');
     tmp_lft = sum(txt_ext([1,3]));
     sup_btm = num_btm + txt_ext(4)/3;
     text(tmp_lft,sup_btm,int2str(k-1),'erase',ers,...
           'horizontalalignment','left','verticalalignment','bottom',...
           'fontname',fontname,'fontsize',8,'tag','9','color','k');
    end
    txt_lft = new_lft;
    txt = text(txt_lft,line_yloc,'d','erase',ers,...
              'horizontalalignment','left','verticalalignment','middle',...
              'fontname','symbol','tag','9','color','k');
    txt_ext = get(txt,'extent');
    txt_lft = txt_lft + txt_ext(3);
    txt = text(txt_lft,line_yloc,'(t)','erase',ers,...
              'horizontalalignment','left','verticalalignment','middle',...
              'fontname',fontname,'tag','9','color','k');
    txt_ext = get(txt,'extent');
    txt_lft = txt_lft + txt_ext(3);
   else
    txt = text(txt_lft,line_yloc,k_str,'erase',ers,...
              'horizontalalignment','left','verticalalignment','middle',...
              'fontname',fontname,'tag','9','color','k');
    txt_ext = get(txt,'extent');
    txt_lft = txt_lft + txt_ext(3);
    txt = text(txt_lft,line_yloc,'d','erase',ers,...
              'horizontalalignment','left','verticalalignment','middle',...
              'fontname','symbol','tag','9','color','k');
    txt_ext = get(txt,'extent');
    txt_lft = txt_lft + txt_ext(3);
    txt = text(txt_lft,line_yloc,'(t)','erase',ers,...
              'horizontalalignment','left','verticalalignment','middle',...
              'fontname',fontname,'tag','9','color','k');
    txt_ext = get(txt,'extent');
    txt_lft = txt_lft + txt_ext(3);
   end
  end
 end
end % end of direct terms

% now handle the residues and poles.
% first, round all poles and residues.  then sort and make sure that poles
% are grouped in the following order: zeros, real poles, complex poles.
% also, make sure to keep track of the associated residues

for k = 1:length(poles),
 poles(k)  = str2num(sprintf('%0.4f',real(poles(k)))) + ...
             str2num(sprintf('%0.4f',imag(poles(k))))*i;
 res(k)    = str2num(sprintf('%0.3f',real(res(k)))) + ...
             str2num(sprintf('%0.3f',imag(res(k))))*i;
end

if length(poles),
   zero_loc = find(length(poles) & poles==0);
   zero_poles = poles(zero_loc);
   zero_res = res(zero_loc);
else
   zero_loc = [];
   zero_poles = [];
   zero_res = [];
end

if length(poles),
   real_loc = find(imag(poles)==0 & real(poles)~=0 & length(poles));
   real_poles = poles(real_loc);
   real_res = res(real_loc);
   [real_poles,sort_real] = sort(real_poles);
   real_res = real_res(sort_real);
else
   real_loc = [];
   real_poles = [];
   real_res = [];
end

if length(poles),
   comp_loc = find(imag(poles)~=0 & length(poles));
   comp_poles = poles(comp_loc);
   comp_res = res(comp_loc);
   [comp_poles,sort_comp] = sort(comp_poles);
   comp_res = comp_res(sort_comp);
else
   comp_loc = [];
   comp_poles = [];
   comp_res = [];
end

if length(zero_poles),

 n = length(zero_poles)-1;
 for nct = 0:n,
%  zero_res(nct+1)  = str2num(sprintf('%5.3f',zero_res(nct+1)));
  if zero_res(nct+1) ~= 0,
   res_val = abs(zero_res(nct+1))/prod([1:nct]);
   res_str = num2str(res_val);
   if ~first,
    if res_val == 1, res_str = ''; end
    if zero_res(nct+1) > 0, res_str = [' + ',res_str];
    else res_str = [' - ',res_str]; end
   else
    if res_val == 1, res_str = ''; end
    if zero_res(nct+1) < 0, res_str = [' - ',res_str]; end
    first = 0;
   end

   if length(res_str),
    txt = text(txt_lft,line_yloc,res_str,'erase',ers,...
           'horizontalalignment','left','verticalalignment','middle',...
           'fontname',fontname,'tag','9','color','k');
    txt_ext = get(txt,'extent');
    txt_lft = txt_lft + txt_ext(3);
   end

   if nct > 0,
    txt = text(txt_lft,line_yloc,'t','erase',ers,...
              'horizontalalignment','left','verticalalignment','middle',...
              'fontname',fontname,'tag','9','color','k');
    txt_ext = get(txt,'extent');
    txt_lft = txt_lft + txt_ext(3);
    if nct > 1,
     txt = text(txt_lft,num_btm,int2str(nct),'erase',ers,...
             'horizontalalignment','left','verticalalignment','bottom',...
             'fontname',fontname,'tag','9','color','k');
     txt_ext = get(txt,'extent');
     txt_lft = txt_lft + txt_ext(3);
    end
   end
  end
 end
end

k = 1;
while k <= length(real_poles),

% obtain all occurrences of the current pole
 rep_loc = find(real_poles==real_poles(k));
 rep_pole = real_poles(rep_loc);
 rep_res  = real_res(rep_loc);

 n = length(rep_pole)-1;

 for nct = 0:n,

% round pole and residue
%  rep_pole(nct+1) = str2num(sprintf('%5.4f',rep_pole(nct+1)));
%  rep_res(nct+1)  = str2num(sprintf('%5.3f',rep_res(nct+1)));

  res_val = abs(rep_res(nct+1))/prod([1:nct]);
  if res_val ~= 0,
   pol_val = rep_pole(nct+1);
   res_str = num2str(res_val);
   pol_str = num2str(pol_val);
   if ~first,
    if res_val == 1, res_str = ''; end
    if pol_val == 1, pol_str = '';
    elseif pol_val == -1, pol_str = '-'; end
    if rep_res(nct+1) > 0, res_str = [' + ',res_str];
    else res_str = [' - ',res_str]; end
   else
    if res_val == 1, res_str = ''; end
    if pol_val == 1, pol_str = '';
    elseif pol_val == -1, pol_str = '-'; end
    if rep_res(nct+1) < 0, res_str = [' - ',res_str]; end
    first = 0;
   end

   if length(res_str),
    txt = text(txt_lft,line_yloc,res_str,'erase',ers,...
             'horizontalalignment','left','verticalalignment','middle',...
             'fontname',fontname,'tag','9','color','k');
    txt_ext = get(txt,'extent');
    txt_lft = txt_lft + txt_ext(3);
   end

   if nct > 0,
    txt = text(txt_lft,line_yloc,'t','erase',ers,...
              'horizontalalignment','left','verticalalignment','middle',...
              'fontname',fontname,'tag','9','color','k');
    txt_ext = get(txt,'extent');
    txt_lft = txt_lft + txt_ext(3);
    if nct > 1,
     txt = text(txt_lft,num_btm,int2str(nct),'erase',ers,...
             'horizontalalignment','left','verticalalignment','bottom',...
             'fontname',fontname,'tag','9','color','k');
     txt_ext = get(txt,'extent');
     txt_lft = txt_lft + txt_ext(3);
    end
   end

   txt = text(txt_lft,line_yloc,'e','erase',ers,...
             'horizontalalignment','left','verticalalignment','middle',...
             'fontname',fontname,'tag','9','color','k');
   txt_ext = get(txt,'extent');
   txt_lft = txt_lft + txt_ext(3);

   txt = text(txt_lft,num_btm,[pol_str,'t'],'erase',ers,...
             'horizontalalignment','left','verticalalignment','bottom',...
             'fontname',fontname,'tag','9','color','k');
   txt_ext = get(txt,'extent');
   txt_lft = txt_lft + txt_ext(3);
  end
  k = k + 1;
 end
end

k = 1;
while k <= length(comp_poles),

% obtain all occurrences of the current pole
 des_pol = real(comp_poles(k)) + abs(imag(comp_poles(k)))*i;
 rep_loc = find(comp_poles==des_pol);
 rep_pole = comp_poles(rep_loc);
 rep_res  = comp_res(rep_loc);

 n = length(rep_pole)-1;

 for nct = 0:n,

  res_val = 2*abs(rep_res(nct+1));
  ang_val = angle(rep_res(nct+1));
  alpa_val = real(rep_pole(nct+1));
  beta_val = imag(rep_pole(nct+1));
  res_str = num2str(res_val);
  alpa_str = num2str(alpa_val);
  beta_str = num2str(beta_val);
  ang_str = num2str(abs(ang_val));
  if ~first,
   if res_val == 1, res_str = ''; end
   res_str = [' + ',res_str];
   if alpa_val == 1, alpa_str = '';
   elseif alpa_val == -1, alpa_str = '-'; end
   if beta_val == 1, beta_str = '';
   elseif beta_val == -1, beta_str = '-'; end
   if ang_val > 0, ang_str = [' + ',ang_str];
   else ang_str = [' - ',ang_str]; end
  else
   if res_val == 1, res_str = ''; end
   if alpa_val == 1, alpa_str = '';
   elseif alpa_val == -1, alpa_str = '-'; end
   if beta_val == 1, beta_str = '';
   elseif beta_val == -1, beta_str = '-'; end
   if ang_val > 0, ang_str = [' + ',ang_str];
   else ang_str = [' - ',ang_str]; end
   first = 0;
  end

  if length(res_str),
   txt = text(txt_lft,line_yloc,res_str,'erase',ers,...
            'horizontalalignment','left','verticalalignment','middle',...
            'fontname',fontname,'tag','9','color','k');
   txt_ext = get(txt,'extent');
   txt_lft = txt_lft + txt_ext(3);
  end

  if nct > 0,
   txt = text(txt_lft,line_yloc,'t','erase',ers,...
             'horizontalalignment','left','verticalalignment','middle',...
             'fontname',fontname,'tag','9','color','k');
   txt_ext = get(txt,'extent');
   txt_lft = txt_lft + txt_ext(3);
   if nct > 1,
    txt = text(txt_lft,num_btm,int2str(nct),'erase',ers,...
            'horizontalalignment','left','verticalalignment','bottom',...
            'fontname',fontname,'tag','9','color','k');
    txt_ext = get(txt,'extent');
    txt_lft = txt_lft + txt_ext(3);
   end
  end

  txt = text(txt_lft,line_yloc,'e','erase',ers,...
            'horizontalalignment','left','verticalalignment','middle',...
            'fontname',fontname,'tag','9','color','k');
  txt_ext = get(txt,'extent');
  txt_lft = txt_lft + txt_ext(3);

  txt = text(txt_lft,num_btm,[alpa_str,'t'],'erase',ers,...
            'horizontalalignment','left','verticalalignment','bottom',...
            'fontname',fontname,'tag','9','color','k');
  txt_ext = get(txt,'extent');
  txt_lft = txt_lft + txt_ext(3);

  cos_str = ['cos(',beta_str,'t',ang_str,')'];
  txt = text(txt_lft,line_yloc,cos_str,'erase',ers,...
            'horizontalalignment','left','verticalalignment','middle',...
            'fontname',fontname,'tag','9','color','k');
  txt_ext = get(txt,'extent');
  txt_lft = txt_lft + txt_ext(3);
  k = k + 2;
 end
end
