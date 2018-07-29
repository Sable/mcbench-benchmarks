function [q,tq,dist_p_q] = project_1_point_to_a_line(p0,p1,p)
%
%   Deshan Yang, PhD
%	Department of radiation oncology
%	Washington University in Saint Louis
%   01/16/2011, Saint Louis, MO, USA
%
%	[q,tq,dist_p_q] = project_1_point_to_a_line(p0,p1,p)
%
%	To project the point p onto the line determined by points p0 and p1, gives the projection point q and distance ratio
%	tq
%
%	Input:	p0 = [x,y,z]
%			p1 = [x,y,z]
%			p = [x,y,z]
%
%	Line function: q = p0+t(p1-p0)
%	The projection point q should be:	(p-q).(p1-p0)=0
%	We need to compute the t and q, or
%	(p0+tq(p1-p0)-p).(p1-p0)=0
%	p0.p1+tq(p1.p1-p0.p1)-p0.p0-tq(p1.p0-p0.p0)-p.p1+p.p0=0
%	tq(p1.p1-p0.p1-p1.p0+p0.p0)=p0.p0-p1.p1+p.p1-p.p0
%	tq(p1.p1+p0.p0-2*p1.p0)=p0.p0-p0.p1+p.p1-p.p0
%	tq = (p0.p0-p0.p1+p.p1-p.p0)/(p1.p1+p0.p0-2*p1.p0)
%	q = p0+tq(p1-p0)

% tq = (dot(p0,p0)-dot(p0,p1)+dot(p,p1)-dot(p,p0))/(dot(p1,p1)+dot(p0,p0)+2*dot(p1,p0));
tq = dot(p1-p0,p-p0)/dot(p1-p0,p1-p0);
q = p0 + tq*(p1-p0);

if nargout>2
	dist_p_q = norm(p-q);
end

