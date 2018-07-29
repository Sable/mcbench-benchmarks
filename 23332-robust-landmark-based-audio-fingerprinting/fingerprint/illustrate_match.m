function illustrate_match(DQ,SR,FL)
% illustrate_match(DQ,SR,FL)
%     Show graphically which landmarks led to a match.
%     DQ @ SR is the waveform of the query.
%     FL is cell array giving the filenames for the elements in the
%     database.
%     Runs the query, then shows specgrams of query (with
%     landmarks) and top hit (with landmarks), highlighting the
%     matches.
% 2008-12-30 Dan Ellis dpwe@ee.columbia.edu

% Run the query
[R,Lm] = match_query(DQ,SR);
% Lm returns the matching landmarks in the original track's time frame

% Recalculate the landmarks for the query
Lq = find_landmarks(DQ,SR);
% Plot them
subplot(211)
show_landmarks(DQ,SR,Lq);

% Recalculate landmarks for the match piece
tbase = 0.032;  % time base of analysis
matchtrk = R(1,1);
matchdt = R(1,3);
[d,sr] = mp3read(FL{matchtrk});
Ld = find_landmarks(d,sr);
% Plot them, aligning time to the query
subplot(212)
show_landmarks(d,sr,Ld,matchdt*tbase + [0 length(DQ)/SR]);
[p,name,e] = fileparts(FL{matchtrk});
name(find(name == '_')) = ' ';
title(['Match: ',name,' at ',num2str(matchdt*tbase),' sec']);

% Highlight the matching landmarks
show_landmarks([],sr,Lm,[],'o-g');
subplot(211)
show_landmarks([],sr,Lm-repmat([matchdt 0 0 0],size(Lm,1),1),[],'o-g');
title('Query audio')
