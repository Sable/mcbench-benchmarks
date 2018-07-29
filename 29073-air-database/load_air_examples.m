%--------------------------------------------------------------------------
% Examples for <load_air.m> function
%
% The provided impulse responses are only a subset of the AIR database.
% The full database is available here: http://www.ind.rwth-aachen.de/air
%--------------------------------------------------------------------------
% (c) 2009-2011 RWTH Aachen University, Germany,
%     Marco Jeub, jeub@ind.rwth-aachen.de
%--------------------------------------------------------------------------
% Version 1.3
%--------------------------------------------------------------------------
clear all;close all;clc

airpar.fs = 48e3;
%--------------------------------------------------------------------------
% Example 1
%--------------------------------------------------------------------------
% Binaural RIR of lecture room
% Distance: 8.86m
% With dummy head
% left channel
airpar.rir_type = 1;
airpar.room = 4;
airpar.channel = 1;
airpar.head = 1;
airpar.rir_no = 5;

[h_air,air_info] = load_air(airpar);
figure,plot(h_air)

%--------------------------------------------------------------------------
% Example 2
%--------------------------------------------------------------------------
% Binaural RIR of Stairway
% Distance: 2m
% With dummy head
% left and right channel
% 15° Azimuth angle
airpar.rir_type = 1;
airpar.room = 5;
airpar.head = 1;
airpar.rir_no = 2;
airpar.azimuth = 15;

airpar.channel = 0;
[h_left,air_info] = load_air(airpar);
airpar.channel = 1;
[h_right,air_info] = load_air(airpar);

figure,
subplot 211,plot(h_left)
subplot 212,plot(h_right)
%--------------------------------------------------------------------------
% Example 3
%--------------------------------------------------------------------------
% Mock-up phone in hand-held position at corridor location
airpar.rir_type = 2;
airpar.room = 8;
airpar.phone_pos = 1;
airpoar.channel = 1;
h_air = load_air(airpar);
figure,plot(h_air)

%--------------------------------------------------------------------------
% Example 4
%--------------------------------------------------------------------------
% Mock-up phone in hands-free position in office room
airpar.rir_type = 2;
airpar.room = 2;
airpar.phone_pos = 2;
airpoar.channel = 1;
h_air = load_air(airpar);
figure,plot(h_air)

%--------------------------------------------------------------------------
% Example 5
%--------------------------------------------------------------------------
% BRIR of Aula Carolina
airpar.rir_type = 1;
airpar.room = 11;
airpar.head = 1;
airpar.rir_no = 3;
airpar.azimuth = 45;

airpar.channel = 1;
[h_left,air_info] = load_air(airpar);
airpar.channel = 0;
[h_right,air_info] = load_air(airpar);

figure,
subplot 211,plot(h_left)
subplot 212,plot(h_right)

%--------------------------------------------------------------------------
