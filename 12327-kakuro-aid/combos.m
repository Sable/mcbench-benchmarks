function [total,digit,solution] = combos(maxdigit)
% Aid for Kakuro puzle solving. Creates an Excell spreadsheet with
% all possible combinations of the digits 1-9 that sum (without repeats) to
% any value that could appear in a Kakuro puzzle. The output file,
% 'KakuroAid.xls' can be sorted in Excell by number of cells or total sum.
% For examples of Kakuro, see e.g. http://www.kakuro.com/
%
% Usage: [total,digit,solution] = combos(maxdigit); or
%        combos(maxdigit); or
%        combos();
%       maxdigit is the maximum number of digits to sum (default and
%               maximum are 9)
%       Returns the sums, number of digits summed, and particular
%           set of digits (in ascending order) in each solution found.
%       total: vector of sums, one entry per solution
%       digit: vector of the number of digits summed, one entry per solution
%       solution: cell array of the digits summed to provide the sum in
%           the corresponding entry of total.
%
%   File depenancies:
%   combos.m This file
%   findsum.m contains the meat of the processing to identify the
%       solutions. Finds all possbile solutions for a particular total and
%       number of digits.
%   partitions.m funtion by John D'Errico that calculates all possible ways
%       to partition an number. Available from the File Exchange.
%   Provided for amusment purposes only by Christopher Poletto, PhD. 2006
%   Version 1.0
%   Only the barest nod is given to efficiency. I made something quick and
%   dirty here that takes a minute to run, but it works.
%% set up problem
mindigit=2;%we don't want singletons
reptfnm = 'KakuroAid.xls';%name of the Excell workbook new spreadsheet will be created in.
if nargin<1
    maxdigit = 9; %default maximum number of digits to sum
end
if maxdigit >9
    maxdigit = 9; %there are only 9 digits, don't hurt anything trying to sum more than there are
end
maxtotal = sum(1:maxdigit);%largest possible total
mintotal =sum(1:mindigit);%smallest possible total
total =[];
digit=[];
solution = {};
N=0;
%% find solutions
for tot = mintotal:maxtotal%for each possible total
    for d = mindigit:maxdigit%for each number of digits
        s=findsum(tot,d);%find all solutions
        if ~isempty(s)%if there were any solutions
            N=N+1;%add one more row
            total = [total;tot];
            digit = [digit;d];
            solution(N) = {s};
        end
    end%for d
end %for tot

%% build output cell array
maxsoln = 0;%the total with the most solutions determines our page width
for n = 1:length(solution)
    maxsoln=max(maxsoln, length(solution{n}));
end
pagecell = cell(N,maxsoln);
for r = 1:N %for each row
    pagecell{r,1}=total(r);%first column is total sum
    pagecell{r,2}=digit(r);%second column is number of digits

    for c = 1:length(solution{r})%build columns out as needed, one per solution 
        soln=solution{r}{c};
        solnstr='';
        for d=1:length(soln)
            solnstr=[solnstr,num2str(soln(d))];
        end

        pagecell(r,2+c)={solnstr};
    end
end

%% write output file
blank = {''};
headercell = [{'Total','Digits','Solution'},repmat(blank,1,maxsoln-1)];%column labels, adjusted for maximum number of solutions
pagecell = [headercell;pagecell];%combine column header text with data in cell array
xlswrite(reptfnm, pagecell, 'All combos') ;%write the summary data cell array as a new worksheet in excell document.

