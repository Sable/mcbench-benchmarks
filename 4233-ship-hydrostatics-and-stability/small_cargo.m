%SMALL_CARGO    Data of small cargo ship used in Subsection 7.2.2.
%   For details see Subsection 7.2.2 in the book. 
%   Companion file to Biran, A. (2003), Ship Hydrostatics and Stability,
%   Oxford: Butterworth-Heinemann.

sname = 'Small cargo ship';         % ship name
% Write now character array of weight groups.
names     = char('Lightship', 'Crew', 'Provisions', 'Fuel', 'Lube oil',...
'Fresh water', 'Ballast water', 'Cargo in holds', 'Cargo on deck', 'Fruit cargo');

% write now the weight data in the format
%   [ mass  vcg lcg ]
wdata = [
        1247.66  5.93  32.04            
       3.60  9.60  11.00
       5.00  7.30   3.50
     177.21  1.56  30.88
       4.50  4.65   8.45
     103.09  4.61  27.19
       0.00  0.00   0.00
     993.94  4.35  42.62
       0.00  0.00   0.00
      90.00  6.08  38.66 ];
 

    