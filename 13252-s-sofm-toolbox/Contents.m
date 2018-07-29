% S-SOFM Toolbox
% Version 1.0(beta) 23-Mar-2006
%
% Tested under Matlab 7.0.0.19920 (R14)
%
% This toolbox contains a set of functions and a GUI which can be used to
% create glyphs from spherical Self-Organizing Feature Maps (SOFMs). It is
% freely distributable for educational and research purposes.
%
%
% Example:
%
% load henon-1024-4.mat                   % loads the data to be visualized
% load c4-24.mat                          %loads the S-SOFM structure
% [w,g,r]=trainGlyph(P,X,C,0.5,20,'plot');%trains the S-SOFM
% glyph(X,r);                             % plots the S-SOFM
%
%
%  Graphical User Interface
%     ssofm           - Displays the mail GUI window.
%     ssofmAbout      - Displays the copyright infoprmation.
%
%  List of functions.
%    trig             - Creates/Plots a tessellated shpere.
%    glyph            - Creates/Plots a glyph.
%    trainSphSOFM     - Create/Train a Spherical SOFM.
%    adaptSphSOFM     - Adapt a Spherical SOFM.
%    updateSphSOFM    - Update the weights of a Spherical SOFM.
%    Lcurve           - Estimates the L-curve of Spherical SOFMs. 
%    sphereneigh      - Tracks neighboring points on a tessellated shpere.
%    stdrc            - Auxiliary function for range/color calculation.
%    colorscatter     - Plots a 2D or 3D colored scatter diagram.
%
%  Structure files. (mat)
%    c0-1             - Nodes and neighborhood related to trig(0)
%    c1-3             - Nodes and neighborhood related to trig(1)
%    c2-6             - Nodes and neighborhood related to trig(2)
%    c3-12            - Nodes and neighborhood related to trig(3)
%    c4-24            - Nodes and neighborhood related to trig(4)
%
%  Data files. (mat)
%    henon-1024-4     - Henon map on 4 dimensions, 1024 vectors
%    henon-2048-4     - Henon map on 4 dimensions, 2048 vectors
%    henon-ikeda-1024 - Coupled Henon-Ikeda map, 1024 vectros
%    henon-ikeda-4096 - Coupled Henon-Ikeda map, 4096 vectros
%    ikeda-1024-4     - Ikeda map on 4 dimensions, 1024 vectors
%    ikeda-4096-4     - Ikeda map on 4 dimensions, 4096 vectors
%    logistic-1024-4  - Logistic map on 4 dimensions, 1024 vectors
%    logistic-4096-4  - Logistic map on 4 dimensions, 4096 vectors
%
%  Images. (jpg)
%    Icosahedron0     - The original Icosahedron 
%    Icosahedron1     - The original Icosahedron subdivided 1 time
%    Icosahedron2     - The original Icosahedron subdivided 2 times
%    Icosahedron3     - The original Icosahedron subdivided 3 times
%    Icosahedron4     - The original Icosahedron subdivided 4 times
%
%
%
% Authors:
%
% Archana P. Sangole, PhD., P.E. (TX chapter)
% School of Physical & Occupational Therapy
% McGill University
% 3654 Promenade Sir-William-Osler
% Montreal, PQ, H3G 1Y5
% e-mail: archana.sangole@mail.mcgill.ca
%
% CRIR, Rehabilitation Institute of Montreal
% 6300 Ave Darlington
% Montreal, PQ, H3S 2J5
% Tel: 514.340.2111 x2188
% Fax: 514.340.2154
%
%
%
% Alexandros Leontitsis, PhD
% Department of Education
% University of Ioannina
% 45110 - Dourouti
% Ioannina
% Greece
%
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% Alexandros Leontitsis is grateful to the Greek State Scholarships
% Foundation (IKY) for supporting his work.
