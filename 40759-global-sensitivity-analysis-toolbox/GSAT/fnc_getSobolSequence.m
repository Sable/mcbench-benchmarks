%% fnc_getSobolSequence: give a set of sobol quasi-random 
%
% Usage:
%   X = fnc_getSobolSequence(dim, N, dbpath)
%
% Inputs:
%    dim                number of variables, the MAX number of variables is 40
%    N                  number of samples
%
% Output:
%     X                matrix [N x dim] with the quasti-random samples
%
% ------------------------------------------------------------------------
%
%
% Author : Flavio Cannavo'
% e-mail: flavio(dot)cannavo(at)gmail(dot)com
% Release: 1.0
% Date   : 01-02-2011
%
% History:
% 1.0  01-02-2011  First release.
%
%
%  Credits: 
%    This code is based on the one developed by John Burkardt
%    (http://people.sc.fsu.edu/~jburkardt/m_src/sobol_dataset/sobol_dataset.html)
%    and previously by Bennett Fox
%
%%

function X = fnc_getSobolSequence(dim, N)

p = fileparts(mfilename('fullpath'));
dbpath = [p,'/SobolSets'];

if exist(dbpath,'dir')    
    nf = dir([dbpath,'/*.mat']);
    for i=1:length(nf)
        [DIM, remain] = strtok(nf(i).name(2:end), 'N');
        if (str2double(DIM) == dim)
            NN = strtok(remain(2:end), '.');
            if (str2double(NN) == N)
                load([dbpath,'/',nf(i).name]);
                return
            end
        end
    end
end

nextseed = 2^floor(log2(N)+1);

X = nan(N,dim);
MeM = InitSobol(dim);

for j = 1:N
    [X(j,:), nextseed, MeM]  = getNewSobolVector(dim, nextseed, MeM);
end

if exist(dbpath,'dir')    
    save([dbpath,'/S',num2str(dim),'N',num2str(N),'.mat'],'X');
end

%% ------------------------------------------------------------------------

    function [ qrv, nextseed, MeM ] = getNewSobolVector (dim, seed, MeM)

        seed = max(floor(seed),0);

        if ( seed == 0 )
            l = 1;
            MeM.lastq = zeros(1,dim);
        elseif ( seed == (MeM.seed_save + 1) )
            l = smallest0bit(seed);
        elseif ( seed <= MeM.seed_save )
            MeM.seed_save = 0;
            l = 1;
            MeM.lastq(1:dim) = 0;

            for seed_temp = MeM.seed_save : seed - 1
                l = smallest0bit(seed_temp);
                for i = 1:dim
                    MeM.lastq(i) = bitxor(MeM.lastq(i), MeM.v(i,l));
                end
            end

            l = smallest0bit(seed);

        elseif ((MeM.seed_save + 1) < seed)

            for seed_temp = (MeM.seed_save + 1):(seed - 1)
                l = smallest0bit(seed_temp);
                for i = 1 : dim
                    MeM.lastq(i) = bitxor(MeM.lastq(i),MeM.v(i,l) );
                end
            end

            l = smallest0bit(seed);

        end

        qrv = nan(1,dim);

        for i = 1 : dim
            qrv(i) = MeM.lastq(i) * MeM.recipd;
            MeM.lastq(i) = bitxor ( MeM.lastq(i), MeM.v(i,l) );
        end

        MeM.seed_save = seed;
        nextseed = seed + 1;

%% -------------------------------------------------------------------------

function i = smallest0bit(b)

  i = 0;
  b = floor(b);

 while (true)
    i = i + 1;
    halfb = floor(b/2);
    if (b == 2*halfb)
      break;
    end

    b = halfb;
 end

 
%% ----------------------------------------------------------------------
    function MeM = InitSobol(dim)

    MeM.seed_save = -1;
    MeM.v = zeros(40,30);

    MeM.v(1:40,1) = 1;
    MeM.v(3:40,2) = [ ...
            1, 3, 1, 3, 1, 3, 3, 1, ...
      3, 1, 3, 1, 3, 1, 1, 3, 1, 3, ...
      1, 3, 1, 3, 3, 1, 3, 1, 3, 1, ...
      3, 1, 1, 3, 1, 3, 1, 3, 1, 3 ]';

    MeM.v(4:40,3) = [ ...
               7, 5, 1, 3, 3, 7, 5, ...
      5, 7, 7, 1, 3, 3, 7, 5, 1, 1, ...
      5, 3, 3, 1, 7, 5, 1, 3, 3, 7, ...
      5, 1, 1, 5, 7, 7, 5, 1, 3, 3 ]';

    MeM.v(6:40,4) = [ ...
                     1, 7, 9,13,11, ...
      1, 3, 7, 9, 5,13,13,11, 3,15, ...
      5, 3,15, 7, 9,13, 9, 1,11, 7, ...
      5,15, 1,15,11, 5, 3, 1, 7, 9 ]';
  
    MeM.v(8:40,5) = [ ...
                           9, 3,27, ...
     15,29,21,23,19,11,25, 7,13,17, ...
      1,25,29, 3,31,11, 5,23,27,19, ...
     21, 5, 1,17,13, 7,15, 9,31, 9 ]';

    MeM.v(14:40,6) = [ ...
              37,33, 7, 5,11,39,63, ...
     27,17,15,23,29, 3,21,13,31,25, ...
      9,49,33,19,29,11,19,27,15,25 ]';

    MeM.v(20:40,7) = [ ...
                                         13, ...
     33,115, 41, 79, 17, 29,119, 75, 73,105, ...
      7, 59, 65, 21,  3,113, 61, 89, 45,107 ]';

    MeM.v(38:40,8) = [ ...
                                7, 23, 39 ]';
    MeM.poly(1:40)= [ ...
        1,   3,   7,  11,  13,  19,  25,  37,  59,  47, ...
       61,  55,  41,  67,  97,  91, 109, 103, 115, 131, ...
      193, 137, 145, 143, 241, 157, 185, 167, 229, 171, ...
      213, 191, 253, 203, 211, 239, 247, 285, 369, 299 ];

    MeM.v(1,:) = 1;
    for i = 2 : dim
      j = MeM.poly(i);
      m = 0;

      while ( 1 )

        j = floor ( j / 2 );

        if ( j <= 0 )
          break;
        end

        m = m + 1;
      end

      j = MeM.poly(i);
      for k = m : -1 : 1
        j2 = floor ( j / 2 );
        includ(k) = ( j ~= 2 * j2 );
        j = j2;
      end

      for j = m + 1 : 30
        newv = MeM.v(i,j-m);
        l = 1;
        for k = 1 : m
          l = 2 * l;
          if ( includ(k) )
            newv = bitxor ( newv, l * MeM.v(i,j-k) );
          end
        end
        MeM.v(i,j) = newv;
      end
    end

    l = 1;
    for j = 29 : -1 : 1
      l = 2 * l;
      MeM.v(:,j) = MeM.v(:,j) * l;
    end

    MeM.recipd = 1.0 / ( 2 * l );
    MeM.lastq(1:dim) = 0;

  