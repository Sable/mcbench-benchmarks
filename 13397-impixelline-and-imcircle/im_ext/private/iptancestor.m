function p = iptancestor(h,type)
%IPTANCESTOR Get object ancestor.
%   P = IPTANCESTOR(H,TYPE) returns the handle of the ancestor of h of type
%   TYPE.
%
%   Note: IPTANCESTOR does no error checking and assumes that the sought after
%   ancestor is alive and well. If this is not guaranteed, use ANCESTOR 
%   instead.
%
%   See also ANCESTOR.

%   Copyright 2005 The MathWorks, Inc.
%   $Revision $  $Date: 2005/06/20 03:10:23 $

p = h;
while ~strcmpi(get(p,'type'),type)
  p = get(p,'parent');
end

