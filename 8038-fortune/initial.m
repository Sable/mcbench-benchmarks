txtfil = 'clean_fortunes.txt';

fort_import(txtfil);
clear txtfil;
save clean_fortunes.mat;

clear;
txtfil = 'off_fortunes.txt';
cd off;
fort_import(txtfil);
clear txtfil;
save('../offensive_fortunes.mat');
clear;