function keep(varargin);
%KEEP keeps the caller workspace variables of your choice and clear the rest.
%       KEEP VAR1 VAR2 ... keeps the specified variables
%
% [Copied from ftp://ftp.mathworks.com/pub/contrib/v5/tools/keep2.m on 04/04/00]

% Yoram Tal 5/7/98    yoramtal@internet-zahav.net
% MATLAB version 5.2
% Based on a program by Xiaoning (David) Yang
% 15/9/99 Bug fix - empty delete sring (due to Hyrum D Johnson)
%
% Modified 04/04/00 by M. Lubinski to match functionality of
%     ftp://ftp.mathworks.com/pub/contrib/v5/tools/keep.m
%     created by Xiaoning (David) Yang xyang@lanl.gov
%     which uses caller workspace and returns if some input variables do
%     not exist

% Find variables in caller workspace
wh = evalin('caller','who');

% Check that variables exist in caller workspace
if (isempty(wh) & ~isempty(varargin)) | (~all(ismember(varargin,wh)))
  disp('     Some variables to keep do not exist, so no variables deleted');
  return
end

% Remove variables in the "keep" list
del = setdiff(wh,varargin);

% Nothing to remove - return
if isempty(del),
   return;
end

% Construct the clearing command string
str=sprintf('%s ',del{:});

% Clear
evalin('base',['clear ' str])
