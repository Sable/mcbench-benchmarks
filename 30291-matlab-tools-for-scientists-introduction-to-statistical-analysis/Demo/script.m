%% Selected commands from the command history
% Copyright 2010 - 2011 MathWorks, Inc.

ds = dataset('xlsfile', 'Data.xls') ;
scatter(ds.LDL_BL , ds.LDL_12wk )
LDLplot(ds.LDL_BL, ds.LDL_12wk, 50, 'g')
gscatter(ds.LDL_BL , ds.LDL_12wk , ds.Group )
ds.Group = nominal(ds.Group) ;
grp1 = ds.Change_LDL(ds.Group == 'Statin' );
grp2 = ds.Change_LDL(ds.Group == 'Statin + X' );
mean(grp1)
mean(grp2)
ttest2(grp1, grp2, 0.01, 'left')
