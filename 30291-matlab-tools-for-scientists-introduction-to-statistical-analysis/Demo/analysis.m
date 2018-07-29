%% Efficacy of coadministration of Drug X with Statin on cholesterol reduction 
% Copyright 2010 - 2011 MathWorks, Inc.

%% Abstract
% Statins are the most common class of drugs used for treating
% hyperlipdemia. However, studies have shown that even at their maximum
% dosage of 80 mg, many patients do not reach LDL cholesterol goals
% recommended by the National Cholesterol Education Program Adult Treatment
% Panel. Combination therapy, in which a second cholesterol-reducing agent that
% acts via a complementary pathway is coadmininstered with statin, is one
% alternative of achieving higher efficacy at lower statin dosage. 
%
% In this example, we test the primary hypothesis that coadminstering drug
% X with statin is more effective at reducing cholesterol levels than
% statin monotherapy. 
%
% *NOTE The dataset used in this example is purely fictitious*.
%
% The analysis presented in this example is adapted from the following
% publication. 
% 
% *Reference* Ballantyne CM, Houri J, Notarbartolo A, Melani L, Lipka LJ,
% Suresh R, Sun S, LeBeaut AP, Sager PT, Veltri EP; _Ezetimibe Study Group.
% Effect of ezetimibe coadministered with atorvastatin in 628 patients with
% primary hypercholesterolemia: a prospective, randomized, double-blind
% trial._ Circulation. 2003 May 20;107(19):2409-15. 


%% Data 
% 650 patients were randomly assigned to one of the following 10 treatment
% groups (65 subjects per group)
% 
% * Placebo 
% * Drug X (10 mg)
% * Statin (10, 20, 40 or 80 mg)
% * Drug X (10 mg) + Statin (10, 20, 40 or 80 mg)
% 
% Lipid profile (LDL cholesterol, HDL CHolesterol and Triglycerides) was
% measured at baseline (BL) and at 12 weeks (after the start of treatment).
% In addition to the lipid profile, patients age, gender and Cardiac Heart
% Disease (CHD) risk category was also logged at baseline. 
%
% The data from the study is stored in a Microsoft Excel (R) file. Note
% that the  data could also be imported from other sources such as text
% files, any JDBC/ODBC compliant database, SAS transport files, etc. 
%
% The columns in the data are as follows:
%
% * ID     - Patient ID
% * Group  - Treatment group
% * Dose_A - Dosage of Statin (mg) 
% * Dose_X - Dosage of Drug X (mg)
% * Age    - Patient Age
% * Gender - Patient Gender
% * Risk   - Patient CHD risk category (1 is high risk, and 3 is low risk)
% * LDL_BL - HDL_BL & TC_BL - Lipid levels at baseline
% * LDL_12wks , HDL_12wks & TC_12wks - Lipid levels after treatment

%% 
% We will import the data into a dataset array that affords better data
% managemment and organization. 

% Import data from an Excel file
  ds = dataset('xlsfile', 'Data.xls') ;
 
%% Preliminary analysis
% Our primary efficacy endpoint is the level of LDL cholesterol. Let us
% compare the LDL C levels at baseline to LDL C levels after treatment

% Use custom scatter plot
  LDLplot(ds.LDL_BL, ds.LDL_12wk, 50, 'g')
  
%% 
% The mean LDL C level at baseline is around 4.2 and mean level after
% treatment is 2.5. So, at least for the data pooled across all the
% treatment groups, it seems that the treatment causes lowering of the LDL
% cholesterol levels 

% Use a grouped scatter plot
  figure 
  gscatter(ds.LDL_BL, ds.LDL_12wk, ds.Group)   

%%
% The grouped plot shows that LDL C levels before the start of treatment
% have similar means. However, the LDL C levels after treatment show
% difference across treatment groups. The Placebo group show no
% improvement. Statin monotherapy seems to outperform the Drug X
% monotherapy. There is overlap between the Statin and Statin + X groups;
% however, it the combination treatment does seem to perform better that
% the statin monotherapy. Remember that the "Statin" and "Statin + X"
% groups are further split based on Statin dose.
%
% In this example, we will use percentage change of LDL C from the baseline
% level as the primary metric of efficacy. 

% Calculate the percentage improvement over baseline level

  ds.Change_LDL = ( ds.LDL_BL - ds.LDL_12wk ) ./ ds.LDL_BL * 100 ;
  
%% 
% In the following graph, we can see that 
% 
% # In the "Statin" and "Statin + X" group, there appears to be a positive
% linear correlation between percentage improvement and statin dose 
% # Even at the smallest dose of 10 mg, monotherapy with statin seems to be
% better than the Drug X monotherapy group

% Visualize effect of treatment and statin dose on perecentage LDL reduction
  figure
  gscatter(ds.ID, ds.Change_LDL, {ds.Group, ds.Dose_S})
  legend('Location', 'Best')
  
%% Pooled comparison: Is the combination therapy better than statin monotherapy ?
%
% First, we will extract percent change in LDL C level for the Statin and
% the Statin + X groups only.  We will test the null hypothesis that the
% percent change in LDL C level for the "Statin + X" groups is greater than
% that in the "Statin + X" using pooled data. We use a 2 sample t-test to
% test this hypothesis. 

% Convert Group into a categorical variable
ds.Group = nominal(ds.Group) ;

grp1 = ds.Change_LDL(ds.Group == 'Statin')         ;
grp2 = ds.Change_LDL(ds.Group == 'Statin + X')     ;

[h, p] = ttest2(grp1, grp2, .01, 'left')

%% 
% We performed a tailed hypothesis to see if Statin + X group (grp2) is
% better than the Statin group (grp1). We test against the alternative that
% that mean LDL change of grp1 (Statin only) is less than mean LDL change
% of grp2 (Statin + X)
% 
% The null hypothesis is rejected (p < 0.01), implying that grp1 mean is
% less that grp2 mean, i.e. the Statin group is less effective at lowering
% LDL C levels than the Statin + X group. 
% 
% The pooled analysis shows that coadministering drug X with statin is more
% effective than statin monotherapy. 

%% Effect of Treatment, Statin Dose and Dose by Treatment interaction
% Our analysis so far was done on pooled data. We analysed the effect of
% treatment (statin alone (X = 0) vs. statin + 10 mg X) on the LDL C
% levels. We ignored levels of statin dose within each treatment group
% 
% Next, we will perform a 2-way ANOVA (analysis of variance) to
% simultaneously understand the effect of both factors - statin dose (4
% levels -  10 20, 40, 80 mg) and Treatment (2 level - statin only or
% Statin + 10 mg X ) - on the percentage change of LDL C levels. 
% 

% First, we filter the data to include only the Statin and Statin + X groups 
ds1       = ds(ds.Group == 'Statin' | ds.Group == 'Statin + X', :)    ;

anovan(ds1.Change_LDL , {ds1.Dose_S, ds1.Group }         , ...
        'varnames'    , {'Statin Dose', 'Treatment'}    ) ;        
                                     
                     
%% Effect of Statin Dose on incremental increase in percentage LDL reduction
% The ANOVA results indicate that statin dose is a significant factor, but
% it doesn't compare means across individual dose-treatment level
% combination. Let's look at the individual cell means. 

ds2 = grpstats(ds1 , {'Dose_X', 'Dose_S'}, '', 'DataVars', 'Change_LDL') 


%%
% Convert to wide format
ds2 = unstack(ds2, 'mean_Change_LDL' , 'Dose_X', ...
                   'NewDataVarNames' , {'Change_LDL_St', 'Change_LDL_St_X'} )

               
               
               
%%
% From the above table, we can clearly see that the average efficacy of the
% combination therapy is better than statin monotherapy at all statin
% dosages. 
% 
% In the plot of the individual means, notice that the percentage reduction
% in LDL C levels achieved in the low dose combination therapy group (~50.5
% %) is comparable to that achieved in the higher dose Statin monotherapy
% group (~ 49.4 %). Thus combination therapy with Drug X could help
% patients that cannot tolerate high statin doses.   

figure
bar([ds2.Change_LDL_St, ds2.Change_LDL_St_X])
set(gca, 'XTickLabel', [10, 20 40, 80])
colormap summer
xlabel('Statin Dose Groups(mg)')
ylabel('Percentage reduction of LDL C from Baseline (mmol/L)')
legend('Statin', 'Statin + X')

%% Regression analysis: Effect of statin dose on percent LDL C reduction 
% In the above graph, there appears to be linear improvement in the
% effectiveness metric for both treatment groups. In general it seems that
% for every doubling of the statin dose, there is a 5-6 point improvement
% in the percentage LDL C reduction. Let's fit a linear regression line to
% the entire dataset, instead of to the mean level.
% 
x = ds1.Dose_S    (  ds1.Group == 'Statin' ) ;
y = ds1.Change_LDL(  ds1.Group == 'Statin' ) ; 

x1 = ds1.Dose_S    (ds1.Group == 'Statin + X')  ;
y1 = ds1.Change_LDL(ds1.Group == 'Statin + X')  ; 

%%  

cftool

%% 
% The regression line for the Statin and the Statin + X group run almost
% parallel. This probably indicates mechanism of actions of drug X and
% statins are independent. 

% Fit 
[m1, m2] = createFit(x,y,x1, y1)

%% Secondary Analysis: Consistency of effect across subgroups, age and gender
% Finally, we will make a visual check to ensure that the efficacy of the
% Statin + X treatment at various statin doses is consistent across gender
% and age subgroups. We will perform this check for only the Statin + X
% treatment group.

idx = ds.Group == 'Statin + X' ; 
boxplot(ds.Change_LDL(idx), { ds.Dose_S(idx), ds.Gender(idx)} )

%% 
% We will convert the continuous age variable into a catergorical variable,
% with 2 categories: Age < 65 and Age >= 65 

% Convert age into a ordinal array
ds.AgeGroup = ordinal(ds.Age ,{'< 65', '>= 65'} , [] ,[0 65 100] )  ;

% Plot
boxplot(ds.Change_LDL(idx), { ds.Dose_S(idx), ds.AgeGroup(idx)} )


