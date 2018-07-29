function katcherr(err_mode,err_typ)
% KATCHERR Catch error function.

% Author: Craig Borghesani
% Date: 11/15/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

f = gcf;
ui_han = get(f,'userdata');
stat_bar = get(ui_han(43),'userdata');

if err_mode == 1,
 set(stat_bar,'string','An Error has occurred in TERMIMPL');
elseif err_mode == 2,
 if err_typ == 1, typ_str = 'Gain';
 elseif err_typ == 2, typ_str = 'Integrator';
 elseif err_typ == 3, typ_str = 'Differentiator';
 elseif err_typ == 4, typ_str = 'Real Pole';
 elseif err_typ == 5, typ_str = 'Real Zero';
 elseif err_typ == 6, typ_str = 'Complex Pole';
 elseif err_typ == 7, typ_str = 'Complex Zero';
 elseif err_typ == 8, typ_str = 'Lead/Lag';
 elseif err_typ == 9, typ_str = 'Num/Den';
 elseif err_typ == 10, typ_str = 'Delay';
 elseif err_typ == 11, typ_str = 'Design Point'; end
 if err_typ ~= 9,
  set(stat_bar,'string',['Incorrect type of input for ',typ_str,' element.  Please re-enter.']);
 else
  set(stat_bar,'string',['Coefficients must be in brackets. i.e. [1,2,3]']);
 end
elseif err_mode == 3,
 if err_typ == 1, typ_str = 'Proportional Gain';
 elseif err_typ == 2, typ_str = 'Integral Gain';
 elseif err_typ == 3, typ_str = 'Derivative Gain';
 elseif err_typ == 4, typ_str = 'Design Point'; end
 set(stat_bar,'string',['Incorrect type of input for ',typ_str,' element.  Please re-enter.']);
elseif err_mode == 4,
 if err_typ == 1,
  typ_str = 'Gain';
  opt_str = 'Please re-enter.';
 elseif err_typ == 4,
  typ_str = 'Real Pole';
  opt_str = 'Please use an Integrator.';
 elseif err_typ == 5,
  typ_str = 'Real Zero';
  opt_str = 'Please use a Differentiator.';
 elseif any(err_typ == [6,7,11]),
  typ_str = 'wn';
  if err_typ == 6,
   opt_str = 'Please use an Integrator.';
  elseif err_typ == 7,
   opt_str = 'Please use a Differentiator.';
  else
   opt_str = 'Please re-enter.';
  end
 end
 set(stat_bar,'string',[typ_str,' cannot be zero  ',opt_str]);
elseif err_mode == 5,
 set(stat_bar,'string','Phase value must be < 88 degrees or > -88 degrees');
elseif err_mode == 6,
 set(stat_bar,'string','Corner frequency cannot be zero');
end