% FPAT
% Schwarz, Shoelson & Amphlett
% CSSM / 2004

% let us create two objects		
        objA=zeros(10,9);
        objA(4:6,6:8)=magic(3);

        objB={
              '....v....x....v....x....v' % row 1: col finder
              'a good BRETT'              % row 2
              'a bad BrrrRETt'            % row 3
              'a wide B R E T T'          % row 4
              'a shaky B RET  T'          % row 5
              'a noisy bbB rRxy EeTTtTt'  % row 6
              'a wrapped BR'              % row 7
              'ET                   '     % row 8
              'T'                         % row 9
        };

% ...and some search templates
        tmplA=magic(3);
        tmplX='BRETT';
        tmplY='B RE';
        tmplZ='B R E';

% search for patterns
        resA=fpat(tmplA,objA,'-s');
        resX=fpat(tmplX,objB);
        resY=fpat(tmplY,objB);
        resZ=fpat(tmplZ,objB,'-mrg');

% ...and show matches
        resX
        resY
        resZ
        rowZ=resZ.row
        colZ=resZ.col
        resA
        parX=resX.par