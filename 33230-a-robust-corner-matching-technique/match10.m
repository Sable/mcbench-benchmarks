function [mat time loco loct] = match10();
% from match7.m: using point_hist to reduce candidate matches
% use only top 15 (say) corners
% modification of match7.m

%put the image names manually here
Io = imread('Lena.bmp');
It = imread('Lena_r10_s0.8_sh0.012.bmp');


%%
%{
Publications:
=============
1. M. Awrangjeb and G. Lu, “Techniques for Efficient and Effective Transformed Image Identification,” Journal of Visual Communication and Image Representation, 20(8), 511-520, 2009.
2. M. Awrangjeb and G. Lu, “An Improved Curvature Scale-Space Corner Detector and a Robust Corner Matching Approach for Transformed Image Identification,” IEEE Transactions on Image Processing, 17(12), 2425–2441, 2008.
3. M. Awrangjeb and G. Lu, “A Robust Corner Matching Technique,” International Conference on Multimedia and Expo (ICME 2007), Beijing, China, 1483–1486, 2007.
4. M. Awrangjeb, G. Lu, and M. M. Murshed, “An Affine Resilient Curvature Scale-Space Corner Detector,” 32nd IEEE International Conference on Acoustics, Speech, and Signal Processing (ICASSP 2007), Hawaii, USA, 1233–1236, 2007.

Better results will be found using following corner detectors:
==============================================================
1.  M. Awrangjeb, G. Lu and C. S. Fraser, “A Fast Corner Detector Based on the Chord-to-Point Distance Accumulation Technique,” Digital Image Computing: Techniques and Applications (DICTA 2009), 519-525, 2009, Melbourne, Australia.
2.  M. Awrangjeb and G. Lu, “Robust Image Corner Detection Based on the Chord-to-Point Distance Accumulation Technique,” IEEE Transactions on Multimedia, 10(6), 1059–1072, 2008.

Source codes available:
=======================
http://www.mathworks.com/matlabcentral/fileexchange/authors/39158
%}
%%

[sxo syo] = size(Io);
[sxt syt] = size(It);

%detect corners on input images
[corner_finalo, c3o, ango, cio,nco]=arcss_info(Io);
[corner_finalt, c3t, angt, cit,nct]=arcss_info(It);

if size(Io,3)==3
    Io=rgb2gray(Io); % Transform RGB image to a Gray one. 
end
if size(It,3)==3
    It=rgb2gray(It); % Transform RGB image to a Gray one. 
end

%find histograms
histo = find_hist(Io, 32);%number of bins
histt = find_hist(It, 32);%number of bins

all = 1; %0: consider all corners; 1: consider only first limit = 15 corners
limit = 15;% consider strong n number of corners

%[cio nco]=corner_ecss_ral2_mod2(Io);
%[cit nct]=corner_ecss_ral2_mod2(It);
L = 0.95; H = 1.05; % sx = sy = (0.5 : 1.5)=>[0.6,1.35]  % sx = 1.2, sy = 0.8, shx = shy = 0.012 =>[0.986,1.024]
[co co1 cvo1 cno1 lo1 nco ango1 alo1] = parse_coners1(cio,sxo,syo,limit,all);
[ct ct1 cvt1 cnt1 lt1 nct angt1 alt1] = parse_coners1(cit,sxt,syt,limit,all);
col_o = find_collinear(co1);
col_t = find_collinear(ct1);
Thresh = 1.0; %MT = 15;
cv_diff = 0.2;
ang_diff = 20;
al_diff = [10 20];
hist_diff = 0.1;
temp_match = 3;

%tic  % start timer
it = 0; m = zeros(1,12);
flago = zeros(nco,1);
flagt = zeros(nct,1);

%%%
%while (1)
    it = it+1;   
    tic  % start timer
    m = match(co1, cno1, cvo1, ct1, cnt1, cvt1, cv_diff, ang_diff, al_diff, m, it, ango1, angt1, alo1, alt1,histo,histt,hist_diff);
    size_m = size(m,1);
    if size_m>0 % if 1        
        sadd = add_same_curve(co1, cno1, lo1, ct1, cnt1, lt1, m, it,L,H);
        %sadd = m;
        size_sadd = size(sadd);
        
        if size_sadd>2 % match others from curves of matched corners % if 2
            cand_cv_ind = find(sadd(:,10) == 0);
            sz = size(cand_cv_ind,1);
            if sz>2 % if 3
                T = struct();
                for track_i = 1:sz-2 % for 1
					i = cand_cv_ind(track_i,1);
                    for track_j = track_i+1:sz-1 % for 2
                        j = cand_cv_ind(track_j,1);
                        for track_k = track_j+1:sz % for 3              
                            k = cand_cv_ind(track_k,1);
                            
                            %exe = [i, j, k]
                            %if i == 10 & j == 11 & k == 12
                            %    here = 1;
                            %end
                            so = sort([sadd(i,7),sadd(j,7),sadd(k,7)]);
                            st = sort([sadd(i,8),sadd(j,8),sadd(k,8)]);
                            if ~col_o(so(1,1),so(1,2),so(1,3)) & ~col_t(st(1,1),st(1,2),st(1,3))
                                %[temp_match T] = match_corner(i, j, k, temp_match, T, sadd, co, ct);
                                [temp_match T flago flagt] = match_corner(i, j, k, temp_match, T, sadd, co, ct, flago, flagt);
                                %t = temp_match
                            end
                            %if (temp_match>=MT)
                                %break_all = 1;
                                %break;
                            %end
                            %exe = [i, j, k]                            
                        end % for 3
                        %if break_all
                        %    break;
                        %end
                    end % for 2
                    %if break_all
                    %    break;
                    %end
                end % for 1
              
                 for track_i = 1:sz-1 % for 5
                    %if break_all
                    %    break;
                    %end
					i = cand_cv_ind(track_i,1);
                    next_i = cand_cv_ind(track_i+1,1);
                    flag_i = 1;
                    for track_j = track_i+1:sz % for 6
                        j = cand_cv_ind(track_j,1);
                        if track_j<sz
                            next_j = cand_cv_ind(track_j+1,1);
                            flag_j = 1;
                            %[temp_match T flag_i] = find_corner_match(i, next_i, j, temp_match, T, sadd, co, ct, flag_i, col_o, col_t);
                            %[temp_match T flag_j] = find_corner_match(j, next_j, i, temp_match, T, sadd, co, ct, flag_j, col_o, col_t);
                            [temp_match T flag_i flago flagt] = find_corner_match(i, next_i, j, temp_match, T, sadd, co, ct, flag_i, col_o, col_t, flago, flagt);
                            [temp_match T flag_j flago flagt] = find_corner_match(j, next_j, i, temp_match, T, sadd, co, ct, flag_j, col_o, col_t, flago, flagt);
                        else
                            %[temp_match T flag_i] = find_corner_match(i, next_i, j, temp_match, T, sadd, co, ct, flag_i, col_o, col_t);
                            [temp_match T flag_i flago flagt] = find_corner_match(i, next_i, j, temp_match, T, sadd, co, ct, flag_i, col_o, col_t, flago, flagt);
                        end
                        %if (temp_match>=MT)
                            %break_all = 1;
                            %break;
                        %end
                    end % for 6
                 end % for 5
                
            end % if 3
        end % if 2
    end % if 1
    time = toc;
    %here = 1;
    mat=temp_match;
%end % while
%time_for_matching = toc
%T = temp_tform;
%theta = atan(T.tdata.T(2,1)/T.tdata.T(1,1))*180/pi;
%sx = sqrt(T.tdata.T(2,1)*T.tdata.T(2,1) + T.tdata.T(1,1)*T.tdata.T(1,1));
%sy = sqrt(T.tdata.T(2,2)*T.tdata.T(2,2) + T.tdata.T(1,2)*T.tdata.T(1,2));
%tx = T.tdata.T(3,1);
%ty = T.tdata.T(3,2);

%here = 1;

%show matches
loco = [];
loct = [];
for i = 1:mat
    loco = [loco; corner_finalo(flago == i,:)];
    loct = [loct; corner_finalt(flagt == i,:)];
end
show_match(Io, It, loco, loct);

%%%%%%
function col = find_collinear(c);
s = size(c,1);
col = logical(ones(s,s,s));
for i = 1:s-2
    for j = i+1:s-1
        for k = j+1:s
            %if (i == 3 & j == 16 & k == 22) | (i == 10 & j == 13 & k == 23)
            %    here = 1;
            %end
            col(i,j,k) = is_collinear(c(i,:),c(j,:),c(k,:));
        end
    end
end
%%%%%
function [temp_match T flag flago flagt] = find_corner_match(i, next, j, temp_match, T, sadd, co, ct, flag, col_o, col_t, flago, flagt);
middle = next - i - 1;
if middle>1 & flag
    for i1 = i+1:next-2
        %exe = [i i1 j]
        so = sort([sadd(i,7),sadd(i1,7),sadd(j,7)]);
        st = sort([sadd(i,8),sadd(i1,8),sadd(j,8)]);
        if ~col_o(so(1,1),so(1,2),so(1,3)) & ~col_t(st(1,1),st(1,2),st(1,3))
            [temp_match T flago flagt] = match_corner(i, i1, j, temp_match, T, sadd, co, ct, flago, flagt);
        end
        %exe = [i, i1, j]
        for i2 = i1+1:next-1
            %exe = [i i2 j]
            so = sort([sadd(i,7),sadd(i2,7),sadd(j,7)]);
            st = sort([sadd(i,8),sadd(i2,8),sadd(j,8)]);
            if ~col_o(so(1,1),so(1,2),so(1,3)) & ~col_t(st(1,1),st(1,2),st(1,3))
                [temp_match T flago flagt] = match_corner(i, i2, j, temp_match, T, sadd, co, ct, flago, flagt);
            end
            %exe = [i, i2, j]
            if sadd(i1,11) == sadd(i2,11) & sadd(i1,12) == sadd(i2,12) % if direction of matched corners is same
                %exe = [i i1 i2]
                so = sort([sadd(i,7),sadd(i1,7),sadd(i2,7)]);
                st = sort([sadd(i,8),sadd(i1,8),sadd(i2,8)]);
                if ~col_o(so(1,1),so(1,2),so(1,3)) & ~col_t(st(1,1),st(1,2),st(1,3))
                    [temp_match T flago flagt] = match_corner(i, i1, i2, temp_match, T, sadd, co, ct, flago, flagt);
                end
                %exe = [i, i1, i2]
            end
        end
    end
    flag = 0;
elseif middle>0
    for i1 = i+1:next-1
        %exe = [i i1 j]
        so = sort([sadd(i,7),sadd(i1,7),sadd(j,7)]);
        st = sort([sadd(i,8),sadd(i1,8),sadd(j,8)]);
        if ~col_o(so(1,1),so(1,2),so(1,3)) & ~col_t(st(1,1),st(1,2),st(1,3))
        	[temp_match T flago flagt] = match_corner(i, i1, j, temp_match, T, sadd, co, ct, flago, flagt);
        end
        %exe = [i, i1, j]
    end    
end


function [temp_match temp_tform flago flagt] = match_corner(i, j, k, temp_match, T, sadd, co, ct, flago, flagt); 
temp_tform = T;
%flag_o = is_collinear(sadd(i,1:2),sadd(j,1:2),sadd(k,1:2));
%flag_t = is_collinear(sadd(i,4:5),sadd(j,4:5),sadd(k,4:5));
%if (flag_o & flag_t)
    %mat = [sadd(i,1:2);sadd(j,1:2);sadd(k,1:2);sadd(i,4:5);sadd(j,4:5);sadd(k,4:5)]
    T = maketform('affine',[sadd(i,1:2);sadd(j,1:2);sadd(k,1:2)], [sadd(i,4:5);sadd(j,4:5);sadd(k,4:5)]);
    co_tfwd = tformfwd(co,T);
    [nMatch MSE flag1 flag2] = corner_match(co_tfwd, ct);                                
    if (nMatch>temp_match)
        temp_tform = T;
        temp_match = nMatch;
        flago = flag1;
        flagt = flag2;
        %temp_MSE = MSE;
        %if nMatch>nco/2 %15
        %    break_all = 1;
        %    break;
        %end
    end
%end
                            
%%%%
function visit_flag = visit_check(P1,P2,P3,Pt1,Pt2,Pt3, visit);

visit_flag = 0;
for i = 1:size(visit,1)
    if (visit(i,:) == [P1 P2 P3 Pt1 Pt2 Pt3])
        visit_flag = 1;
        break;
    end
end
%%%%

%%%%
function [nMC MSE flag flagt] = corner_match(cot, ct);
% find matched corners
nMC = 0;
SEE = 0;
%match = [0 0 0 0];
flag = zeros(size(cot,1),1);
flagt = zeros(size(ct,1),1);
for j=1:size(cot,1)
    compare_corner=ct-ones(size(ct,1),1)*cot(j,:);
    compare_corner=compare_corner.^2;
    compare_corner=compare_corner(:,1)+compare_corner(:,2);
    [mn id] = min(compare_corner);
    %fnd = match(:,1) == cot(j,1) & match(:,2) == cot(j,2) & match(:,3) == ct(id,1) & match(:,4) == ct(id,2);
    %if sum(fnd) == 0 & mn<=9 & ~flag(j)
    if mn<=9 & ~flag(j,1) & ~flagt(id,1)
        %match = [match;[cot(j,:) ct(id,:)]];
        nMC = nMC+1;
        flag(j,1) = nMC;
        flagt(id,1) = nMC;
        SEE = SEE+mn;
    end
end
if nMC~=0
    MSE = SEE/nMC;
else
    MSE = 999;
end
%%%%

%%%%%%
function flag = is_collinear(P1,P2,P3);
% using triangular inequality
d12 = sqrt((P1(1,1)-P2(1,1))*(P1(1,1)-P2(1,1)) + (P1(1,2)-P2(1,2))*(P1(1,2)-P2(1,2)));
d23 = sqrt((P3(1,1)-P2(1,1))*(P3(1,1)-P2(1,1)) + (P3(1,2)-P2(1,2))*(P3(1,2)-P2(1,2)));
d13 = sqrt((P1(1,1)-P3(1,1))*(P1(1,1)-P3(1,1)) + (P1(1,2)-P3(1,2))*(P1(1,2)-P3(1,2)));
if d12+d23 > d13+1 & d12+d13 > d23+1 & d23+d13 > d12+1
    flag = 0;
else
    flag = 1;
end
%%%%%%

%%%%%
function [co1 ct1] = normalize2p(co, ct, si, sj);

[xoi yoi] = si(1:2);
[xoj yoj] = sj(1:2);

txo = -xoi;
tyo = -yoi;
theta = atan((yoj-yoi)/(xoj-xoi))*180/pi;
s = 200/(xoj-xoi); % projection along x-axis

[xti yti] = si(4:5);
[xtj ytj] = sj(4:5);

%%%%%

%%%%
%%%%
function sadd = add_same_curve(co, cno, lo, ct, cnt, lt, m, it_no,L,H);

j = 0;
%for i=1:size(m,1)
for i=1:size(m,1)
    j = j+1;
    sadd(j,:) = m(i,:);
    io = find(cno == sadd(j,3));
    it = find(cnt == sadd(j,6));
    if size(io,1)>1 & size(it,1)>1
        indo = []; add = 0;
        for k = 1:size(io,1)
            if co(io(k,1),1:2) ~= sadd(j,1:2)
                indo = [indo; io(k,1)];
            else
                indexo = io(k,1);
            end
        end
        if size(indo,1)>0
        indt = [];
        for k = 1:size(it,1)
            if ct(it(k,1),1:2) ~= sadd(j,4:5)
                indt = [indt; it(k,1)];
            else
                indext = it(k,1);
            end
        end
        if size(indt,1)>0
        for k=1:size(indo,1)
            if indo(k,1)<indexo
                indo(k,2:3) = [sum(lo(indo(k,1)+1:indexo,2)) 1]; % 1 = before current match corner
            else
                indo(k,2:3) = [sum(lo(indexo+1:indo(k,1),2)) 2]; % 2 = after current match corner
            end
        end

        for k=1:size(indt,1)
            if indt(k,1)<indext
                indt(k,2:3) = [sum(lt(indt(k,1)+1:indext,2)) 1]; % 1 = before current match corner
            else
                indt(k,2:3) = [sum(lt(indext+1:indt(k,1),2)) 2]; % 2 = after current match corner
            end
        end

        for k=1:size(indo,1)            
            ratio = indt(:,2)/(indo(k,2)+eps);
            ratio_ind = find(ratio >= L & ratio <= H); % sx = sy = (0.5 : 1.5)=>[0.6,1.35]  % sx = 1.2, sy = 0.8, shx = shy = 0.012 =>[0.986,1.024]
            % the following code within comments
            % is to add only 3 most similar (based on affine-length ratio) candidate corners from the same curve
            
            %if size(ratio_ind,1)>3
			%	dir1 = find(indt(ratio_ind,3) == 1); % in direction 1
            %    if size(dir1,1)>3
            %        [s in1] = sort(abs(ratio(ratio_ind(dir1,1),1)-1.0));
            %        for l=1:3
            %            j = j+1;
            %            add = add+1;
            %            sadd(j,:) = [co(indo(k,1),1:2) sadd(j-1,3) ct(indt(in1(l,1),1),1:2) sadd(j-1,6) indo(k,1) indt(in1(l,1),1) it_no add indo(k,3) indt(in1(l,1),3)];
            %        end 
            %    else
            %        for l=1:size(dir1)
            %            j = j+1;
            %            add = add+1;
            %            sadd(j,:) = [co(indo(k,1),1:2) sadd(j-1,3) ct(indt(dir1(l,1),1),1:2) sadd(j-1,6) indo(k,1) indt(dir1(l,1),1) it_no add indo(k,3) indt(dir1(l,1),3)];
            %        end 
            %    end
                
            %    dir2 = find(indt(ratio_ind,3) == 2); % in other direction
            %    if size(dir2,1)>3
            %        [s in2] = sort(abs(ratio(ratio_ind(dir2,1),1)-1.0));
            %        for l=1:3
            %            j = j+1;
            %            add = add+1;
            %            sadd(j,:) = [co(indo(k,1),1:2) sadd(j-1,3) ct(indt(in2(l,1),1),1:2) sadd(j-1,6) indo(k,1) indt(in2(l,1),1) it_no add indo(k,3) indt(in2(l,1),3)];
            %        end 
            %    else
            %        for l=1:size(dir1)
            %            j = j+1;
            %            add = add+1;
            %            sadd(j,:) = [co(indo(k,1),1:2) sadd(j-1,3) ct(indt(dir2(l,1),1),1:2) sadd(j-1,6) indo(k,1) indt(dir2(l,1),1) it_no add indo(k,3) indt(dir2(l,1),3)];
            %        end 
            %    end
            %else
               for l=1:size(ratio_ind)
                    flag = find(m(:,7) == indo(k,1) & m(:,8) == indt(ratio_ind(l,1),1)); % check duplicate
                    if size(flag,1) == 0
                        j = j+1;
                        add = add+1;
                        sadd(j,:) = [co(indo(k,1),1:2) sadd(j-1,3) ct(indt(ratio_ind(l,1),1),1:2) sadd(j-1,6) indo(k,1) indt(ratio_ind(l,1),1) it_no add indo(k,3) indt(ratio_ind(l,1),3)];
                    end
               end 
            %end            
        end
        end
        end
    end
    %here = 1;
end
%%%%
%%%%

%%%%
function dc = check_diff_curve(m);

j = 0; dc = [];
for i = 2:size(m,1)
    tag = 0;
    if m(i-1,3) ~= m(i,3) & m(i-1,6) ~= m(i,6)
        tag = 1;
        dc = [dc; i-1];        
    end
end
if tag == 1
    dc = [dc; i];
end
%%%%

%%%%
function sc = check_same_curve(m);

j = 0; prevo = 0; prevt = 0; flag = 0;
for i = 2:size(m,1)
    if m(i-1,3) == m(i,3) & m(i-1,6) == m(i,6)
        if prevo == m(i-1,3) & prevt == m(i-1,6)
            sc{j} = [sc{j}; i];
        else
            j = j+1;
            sc{j} = [i-1; i];
            prevo = m(i-1,3);
            prevt = m(i-1,6);
            flag = 1;
        end
    end
end
if flag == 0
    sc{1} = [];
end
%%%%

%%%%
%function [m v] = match(co, cno, cvo, ct, cnt, cvt, max_diff, visit, prime, it);
function mat = match(co, cno, cvo, ct, cnt, cvt, cv_diff, ang_diff, al_diff, m, it, ango, angt, alo, alt,histo,histt,hist_diff);
mat = [];
for i=1:size(co,1)
    comp_cv = abs(cvt - ones(size(cvt,1),1)*cvo(i,1));
    ind_cv = find(comp_cv <= cv_diff);
    if size(ind_cv,1)>0
        %for k = 1:size(ind_cv,1)
            comp_ang = abs(angt(ind_cv,1) - ones(size(ind_cv,1),1)*ango(i,1));
            ind_ang = find(comp_ang <= ang_diff);
            if size(ind_ang,1)>0
                %for l = 1:size(ind_ang,1)
                    comp_al = compare_al(sort(alo(i,:)), alt(ind_cv(ind_ang,1),1:2));
                    ind_al = find(comp_al(:,1) <= al_diff(1,1) & comp_al(:,2) <= al_diff(1,2));
                    if size(ind_al,1)>0
                        comp_hist = compare_hist(histo(i,:), histt(ind_cv(ind_ang(ind_al,1),1),:));
                        ind_hist = find(comp_hist <= hist_diff);
                        for m = 1:size(ind_hist,1)
                            id1 = ind_cv(ind_ang(ind_al(ind_hist(m,1),1),1),1);
                            mat = [mat; [co(i,:) cno(i,:) ct(id1,:) cnt(id1,:) i id1 it 0 0 0]];  
                            % m = [m; [co(i,:) cno(i,:) ct(ind_cv(k,1),:) cnt(ind_cv(k,1),:) i ind_cv(k,1) it 0 0 0]];
                        end
                    end
                %end
            end
        %end
    end
end
here = 1;
%%%%

function comp_hist = compare_hist(histo, histt);
comp_hist = [];
for i = 1:size(histt,1)
    %e = sqrt(sum((histo-histt(i,:)).^2));
    comp_hist = [comp_hist; sqrt(sum((histo-histt(i,:)).^2))];
end
%%%%

function comp_al = compare_al(aloi, alt);
comp_al = [];
for i = 1:size(alt,1)
    if alt(i,1)<alt(i,2)
        comp_al(i,1:2) = abs([alt(i,1)-aloi(1,1) alt(i,2)-aloi(1,2)]);
    else
        comp_al(i,1:2) = abs([alt(i,2)-aloi(1,1) alt(i,1)-aloi(1,2)]);
    end
end

%%%%
function [c c1 cv1 cn1 l1 nc ang1 al1] = parse_coners1(ci,sx,sy,c_limit,all);
c = [];
cv = [];
cn = [];
l = [];
nc = 0;
ang = [];
al = [];
%%
curr_cur_no = 0;

%%
for i = 1:size(ci,2)
    sc = size(ci{i},1);
    nc = nc+sc;
    if sc>0
        curr_cur_no = curr_cur_no+1;
        for j = 1:sc
            c = [c; [ci{i}(j,2)-sy/2 sx/2-ci{i}(j,1)]];
            cv = [cv; ci{i}(j,3)];
            cn = [cn; curr_cur_no];
            l = [l; ci{i}(j,5:6)];
            ang = [ang; ci{i}(j,7)];
            al = [al; ci{i}(j,8:9)];
        end
    end    
end
%%%%
if all == 0
    [curv ind] = sort(cv,'descend');
    c1 = c(ind(1:c_limit),1:2);
    cv1 = cv(ind(1:c_limit),1);
    cn1 = cn(ind(1:c_limit),1);
    l1 = l(ind(1:c_limit),1:2);
    ang1 = ang(ind(1:c_limit),1);
    al1 = al(ind(1:c_limit),1:2);
else
    c1 = c;
    cv1 = cv;
    cn1 = cn;
    l1 = l;
    ang1 = ang;
    al1 = al;
end
%%%%
function [c cv cn l] = parse_coners(ci,sx,sy);
c = [];
cv = [];
cn = [];
l = [];
for i = 1:size(ci,2)
    for j=1:size(ci{i},1)
        c = [c; [ci{i}(j,2)-sy/2 sx/2-ci{i}(j,1)]];
        cv = [cv; ci{i}(j,3)];
        cn = [cn; ci{i}(j,4)];
        l = [l; ci{i}(j,5:6)];
    end
end
%%%%