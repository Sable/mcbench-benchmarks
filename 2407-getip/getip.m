function ip = getip(hostname)
%GETIP Get ip address of a computer by name.
%
% ip = getip returns ip for the computer on which MATLAB is running.
%
% ip = getip('hostname') returns ip for the 'hostname'

%   Copyright (C) Peter Volegov 2002, Albuquerque, NM, USA
%
%   Based on the article contributed by Jeff Lundgren
%   (http://www.codeguru.com/network/local_hostname.shtml) and
%   tcp_udp_ip toolbox by Peter Rydesäter (Peter.Rydesater@mh.se)

error('You need to compile getip.c to an mex file for your platform. Read header of getip.c');
