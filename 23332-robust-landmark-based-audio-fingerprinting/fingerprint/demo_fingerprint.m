%% Robust Landmark-Based Audio Fingerprinting
%
% These routines implement a landmark-based audio fingerprinting 
% system that is very well suited to identifying small, noisy 
% excerpts from a large number of items.  It is based on the 
% ideas used in the Shazam music matching service, which can 
% identify seemingly any commercial music tracks from short 
% snippets recorded via cellphones even in very noisy conditions. 
% I don't know if my algorithm is as good as theirs, but the 
% approach, as described in the paper below, certainly seems to 
% work:
%
% Avery Wang "An Industrial-Strength Audio Search Algorithm", 
% Proc. 2003 ISMIR International Symposium on Music Information
% Retrieval, Baltimore, MD, Oct. 2003.
% http://www.ee.columbia.edu/~dpwe/papers/Wang03-shazam.pdf
%
% The basic operation of this scheme is that each audio track is
% analyzed to find prominent onsets concentrated in frequency,
% since these onsets are most likely to be preserved in noise and
% distortion.  These onsets are formed into pairs, parameterized by
% the frequencies of the peaks and the time inbetween them.  These
% values are quantized to give a relatively large number of
% distinct landmark hashes (about 1 million in my implementation).
% Parameters are tuned to give around 20-50 landmarks per second.
%
% Each reference track is described by the (many hundreds) of
% landmarks it contains, and the times at which they occur.  This
% information is held in an inverted index, which, for each of the
% 1 million distinct landmarks, lists the tracks in which they
% occur (and when they occur in those tracks).
%
% To identify a query, it is similarly converted to landmarks.
% Then, the database is queried to find all the reference tracks
% that share landmarks with the queries, and the relative time
% differences between where they occur in the query and where they
% occur in the reference tracks.  Once a sufficient number of
% landmarks have been identified as coming from the same reference
% track, with the same relative timing, a match can be confidently
% declared.  Normally, a small number of matches (e.g. 5) is
% sufficient to declare a match, since chance matches are very
% unlikely.  
%
% The beauty, and robustness, of this approach is that only a few
% of the maxima (or landmarks) have to be the same in the
% refererence and query examples to allow a match.  If the query
% example is noisy, or filtered strangely, or truncated, there's
% still a good chance that enough of the hashed landmarks will
% match to work.  In the examples below, a 5 second excerpt 
% recorded from a very low-quality playback is successfully
% matched.  

%% Example use
%
% In the example below, we'll load a small database of audio tracks
% over the internet.  You will need to have the latest version of
% my mp3read installed, which supports reading files from URLs.
% See http://labrosa.ee.columbia.edu/matlab/mp3read.html .
% <myls.m myls> also relies on having curl available to
% work (should be fine on Linux/Mac).

% Get the list of reference tracks to add (URLs in this case, but
% filenames work too)
tks= myls(['http://labrosa.ee.columbia.edu/~dpwe/tmp/Nine_Lives/*.mp3']);
% Initialize the hash table database array 
clear_hashtable
% Calculate the landmark hashes for each reference track and store
% it in the array (takes a few seconds per track).
add_tracks(tks);
% Load a query waveform (recorded from playback on a laptop)
[dt,srt] = mp3read('Q-full-circle.mp3');
% Run the query
R = match_query(dt,srt);
% R returns all the matches, sorted by match quality.  Each row
% describes a match with three numbers: the index of the item in
% the database that matches, the number of matching hash landmarks,
% and the time offset (in 32ms steps) between the beggining of the
% reference track and the beggining of the query audio.
R(1,:)
% 5 11 4 means tks{5} was matched with 11 matching landmarks, at a
% time offset of 4 frames (query starts ~ 0.13s after beginning of
% reference track).
%
% Plot the matches
illustrate_match(dt,srt,tks);
colormap(1-gray)
% This re-runs the match, then plots spectrograms of both query and
% the matching part of the reference, with the landmark pairs
% plotted on top in red, and the matching landmarks plotted in
% green.

%% Implementation notes
%
% The main work in finding the landmarks is done by 
% <find_landmarks.m find_landmarks>.  This contains a number of
% parameters which can be tuned to control the density of
% landmarks.  In general, denser landmarks result in more robust
% matching (since there are more opportunities to match), but
% greater load on the database. 
%
% The scheme relies on just a few landmarks being common to both
% query and reference items.  The greater the density of landmarks,
% the more like this is to occur (meaning that shorter and noisier
% queries can be tolerated), but the greater the load on the
% database holding the hashes.
%
% The factors influencing the number of landmarks returned are:
%
% 1. The number of local maxima found, which in turn depends on the
% spreading width applied to the masking skirt from each found
% peak, the decay rate of the masking skirt behind each peak, and
% the high-pass filter applied to the log-magnitude envelope.
%
% 2. The number of landmark pairs made with each peak.  All maxes within 
% a "target region" following the seed max are made into pairs,
% so the larger this region is (in time and frequency), the
% more maxes there will be.  The target region is defined by a
% freqency half-width, and a time duration.
%
% Landmarks, which are 4-tuples of start time, start frequency, end
% frequency, and time difference, are converted into hashes with a
% start time and a 20 bit value describing the two frequencies and
% time difference, by <landmark2hash.m landmark2hash>.
% <hash2landmark.m hash2landmark> undoes this quantization.
%
% The matching relies on the "inverted index" hash table, 
% implemented by <clear_hashtable.m clear_hashtable>,
% <save_hashes.m save_hashes>, and <get_hash_hits.m get_hash_hits>.
% Currently, it's implemented as a single Matlab array, HashTable, 
% stored in a global of 16 x 10^20 uint32s (about 100MB of core).
% This can record just 8 occurrences of each landmark hash, but as 
% the reference database grows, this may fill up.  You can change 
% the size it is initialized to in clear_hashtable.m, but really
% it should be replaced with a real key/value database system.
%
% Other functions included are <add_tracks.m add_tracks>, which
% simply ties together find_landmarks, landmarks2hash, and
% save_hashes to enter a new reference track into the database, 
% <match_query.m match_query>, which extracts landmarks from a
% query audio and matches them against the reference database to
% returned ranked matches, <show_landmarks.m show_landmarks>, a
% utility to plot the actual landmarks on top of the spectrogram of
% a sound, and <illustrate_match.m illustrate_match>, which uses
% match_query and show_landmarks to show exactly which landmarks
% matched for a particular query's top match.  Utility function 
% <myls.m myls> is used by this demo script, 
% <demo_fingerprint.m demo_fingerprint> to build a list of files,
% including possibly over http.

%% For Windows Users
%
% Robert Macrae of C4DM Queen Mary Univ. London sent me some 
% notes on <windows-notes.txt running this code under Windows>.

%% Download
%
% You can download all the code and data for these examples here:
% <fingerprint.tgz fingerprint.tgz>.
% For the demo code above, you will also need
% <http://www.ee.columbia.edu/~dpwe/resources/matlab/mp3read.html mp3 read/write>.

%% Acknowledgment
%
% This material is based in part upon work supported by the
% National Science Foundation under Grant No. IIS-0713334. Any
% opinions, findings and conclusions or recomendations expressed in
% this material are those of the author(s) and do not necessarily
% reflect the views of the National Science Foundation (NSF).  
%
% Last updated: $Date: 2009/05/26 13:18:12 $
% Dan Ellis <dpwe@ee.columbia.edu>


