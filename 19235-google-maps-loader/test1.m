% Simple Google Map Loader in MATLAB.
% Programming By: Alireza Fasih
% Email: ar_fasih@yahoo.com
% Key:
% Please, go to below link and then set your IP address in format of 
% (http://xxx.xxx.xxx.xxx) for getting a KEY!
% http://code.google.com/apis/maps/signup.html


clc
clear all
key='ABQIAAAAteHND9YP6ctZEpCJsGZpWxRQWo9-sWXbVvdU2wQSDpuKctuXhBQYpf8Mm2875572Jwd2ge0XshBKBg';

pos='http://maps.google.com/staticmap?center=47.238336,8.827171&zoom=15&size=512x512';

address=strcat(pos,'&key=',key);
[I map]=imread(address,'gif');
RGB=ind2rgb(I,map);
imshow(RGB);