%% PIVOT AND UNPIVOT: a user's guide
% The scope of these two functions is to organize a _flat_ dataset into a PIVOT table (and eventually undo it). 
% This guide will illustrate how to use them.

%% CONCEPT: flat dataset
% A _flat_ dataset usually contains a column of values and "n" columns of features. So, each row 
% hs its value with its features.
%
% *1. A _flat_ dataset with two features (Region and Year)*
load Demodata.mat
display([{'Year','Region','People'}; Demodata.ex1])
%% CONCEPT: pivot table
% A pivot table as intended by the T-SQL command _pivot_ or as implemented by spreadsheet softwares is a data 
% visualization tool which groups a _flat_ dataset by two chosen dimension.
%
% *2. Format Demodata.ex1 into a _pivot_ table*
warning off warnPivot:funGroup      % we'll come back later on the warning 
display(Pivot(Demodata.ex1))
%% PIVOT input constraints
% $$Pivot(In, Fun, noHeaders, Pad)$$
%
% Not every type of input is supported by PIVOT. Only a _flat_ dataset with max three columns is supported. The first 
% column should be the grouping dimension which will appear as the column  header and the second column the dimension 
% that will appear as the row header. The last column should contain the values that will be "intersected" and grouped.
%
% Here are listed all the constraints to the inputs (please mail me if something is left out): 
%  
    %% 
    %
    % * IN should have 3 columns
    % * IN can be numeric or a cell array of scalars or strings if headers (no mixing)
    % * Nested cells are not allowed
    % * NaNs or empty cells in the first two columns of IN are not allowed
    % * If IN is a cell the column with the values must be a cell array of scalars
    % * FUN must be a function handle
    % * FUN applied to a vector must return a scalar
       
try Pivot([1,3;2,4]); catch; err = lasterror; display(err.message); end %#ok
try Pivot('try'); catch; err = lasterror; display(err.message); end %#ok
try Pivot({'1999',1,2;1999,1,2}); catch; err = lasterror; display(err.message); end %#ok
try Pivot({1,2,3;1,{2},3}); catch; err = lasterror; display(err.message); end %#ok
try Pivot({NaN,1,9;1,3,4}); catch; err = lasterror; display(err.message); end %#ok
try Pivot([1,NaN,9;1,3,4]); catch; err = lasterror; display(err.message); end %#ok
try Pivot({[],23,9;1,3,4}); catch; err = lasterror; display(err.message); end %#ok
try Pivot({23,[],9;1,3,4}); catch; err = lasterror; display(err.message); end %#ok
try Pivot({23,1,9;1,3,'9'}); catch; err = lasterror; display(err.message); end %#ok
try Pivot(Demodata.ex1(2:end,:),'sum'); catch; err = lasterror; display(err.message); end %#ok
try Pivot(Demodata.ex1(2:end,:),@diff); catch; err = lasterror; display(err.message); end %#ok
%% PIVOT examples
% How to use this function:
%
% *1. IN numeric or cellarray of scalars. No grouping involved. Padded by default with NaN*
disp(Pivot(Demodata.ex2))
disp(Pivot(num2cell(Demodata.ex2))) % OUT will be automatically converted to numeric
%%
% *2. Grouping involved using default FUN (@sum) or @min*
disp(Pivot(Demodata.ex3))
disp(Pivot(Demodata.ex3,@min))
%%
% *3. OUT without headers*
disp(Pivot(Demodata.ex3,[],true))
%%
% *4. Pad with zeros or with '#' and no headers (OUT will be cell).*
disp(Pivot(Demodata.ex3,[],false,0))
disp(Pivot(Demodata.ex3,[],1,'#'))
%%
% *5. The same syntaxes could be used with IN headers as cellarrays of strings*
disp(Pivot(Demodata.ex4))
disp(Pivot(Demodata.ex4,@max))
disp(Pivot(Demodata.ex4,@max,1))
disp(Pivot(Demodata.ex4,@max,1,'???'))
%% 
% *6. Full output*
[Out,colHeader,rowHeader,Settings] = Pivot(Demodata.ex4,@max,1,'???');
disp([{'colHeader','rowHeader'};[colHeader,rowHeader]])
disp('    Settings')
disp(Settings)
%% PIVOT warning
% We set *warning off warnPivot:funGroup* before. This was meant to avoid the following message
disp(lastwarn)
    %% 
    % being thrown each time PIVOT is applied to a dataset which has multiple values on the 
    % same intersection between the two grouping dimensions. The warning is meant 
    % to remember the user that some values are being grouped 
%% UNPIVOT input constraints
% $$unPivot(In, dim, rmPad)$$
%
% Only _pivot_ tables are accepted as inputs. The first elements of IN should be NaN. The first row and the 
% first column (except the IN(1) element) are the headers/features that will define the values in
% IN(2:end,2:end).
%
% Here are listed all the constraints to the inputs (please mail me if something is left out): 
%  
    %% 
    %
    % * IN should be a _pivot_ table
    % * IN(1) must be NaN
    % * Nested cells are not allowed
    % * DIM can be 1 or 2 or empty
    % * RMPAD can be a char or a scalar
try unPivot([1,3]); catch; err = lasterror; display(err.message); end %#ok
try unPivot({'G1',1999;'G2',24}); catch; err = lasterror; display(err.message); end %#ok
try unPivot({NaN,1999;'G2',{24}}); catch; err = lasterror; display(err.message); end %#ok
try unPivot(Demodata.ex5,3); catch; err = lasterror; display(err.message); end %#ok
try unPivot(Demodata.ex5,'1'); catch; err = lasterror; display(err.message); end %#ok
try unPivot(Demodata.ex5,[],{23}); catch; err = lasterror; display(err.message); end %#ok
%% UNPIVOT examples
% How to use this function:
%
% *1. Simplest case*
    %%    
    % IN numeric or cellarray of scalars. Removes by default the NaNs. Sorts by default
    % according the column headers (second column in the _unPivoted_ table)
A = unPivot(Demodata.ex5); disp(A) 
B = unPivot(Demodata.ex5,[]);
C = unPivot(Demodata.ex5,1);
if isequal(A,B,C); fprintf('A, B and C are equivalent'); else error('something''s wrong'); end
%%
% *2. Sort by row header (first column in the _unPivoted_ table)*
disp(unPivot(Demodata.ex5,2))
%%
% *3. Remove padded value other than NaN*
disp(unPivot(Demodata.ex5,1,3174))
%%
% *4. Same syntaxes can be applied to a cell array. Empty cells removed by default.*
disp(unPivot(Demodata.ex6))
disp(unPivot(Demodata.ex6,2))
disp(unPivot(Demodata.ex6,[],20))
disp(unPivot(Demodata.ex6,2,'???'))
%% Performance issues
% Lets test the performances of PIVOT and UNPIVOT.
    %%
    % First we create our Test input (which isn't included in Demodata since its about 35 MB)
    Nums1 = ceil(rand(100,1)*100);
    Nums2 = num2str(ceil(rand(100,1)*100));
    Test = [cellstr(strcat('Year', num2str(Nums1+1900))),...
            cellstr(strcat('Group', Nums2)),...
            num2cell(Nums1)];
    Test = repmat(Test,1000,1);
    %% 
    % Then using the profile...
    profile on 
    Testpivoted = Pivot(Test,[],[],' ');
    Testback = unPivot(Testpivoted,1,' ');
    profile off
    stats = profile('info');
    stats = [{stats.FunctionTable.FunctionName}',{stats.FunctionTable.TotalTime}'];
    disp(stats([strmatch('Pivot',stats(:,1)); strmatch('unPivot',stats(:,1))],:))
    %%
    % While UNPIVOT is fast enough PIVOT is slowed down by cell2mat like behaviour.
    % Here is implemented cell2floatmod which is a compact version of the cell2float by Jos(10584)
    %%
    % Also notice that the Test that was originally created is different from the unpivoted
    % version of the same Test because of the grouping.
    fprintf('Are they equal: ''%d''', isequalwithequalnans(Test, Testback))
%% Other Pivot-like functions
% *Statistics Toolbox owners:*
%%
% pivoting could be accomplished on a dataset obj by the functions _stack_ and _unstack_.
% These functions use a similar engine approach to Pivot and unPivot and the performances 
% lie on the same scale but the syntax is different.
%%
% *FEX submission 20963-reshape-a-matrix by Dimitri Shvorob (ID:17777):*
%%
% The functions are called _wide2tall_ and _tall2wide_ and are probably the foundations for the
% statistics TB functions because of the syntax and the names. Has drawbacks on performance.