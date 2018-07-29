function movie = analyze (movie)
% ANALYZE extracts the necessary header information

% File Labels
JUNK         = [74 85 78 75];
RIFF			 = [82 73 70 70];
AVI          = [65 86 73 32];
avih		    = [97 118 105 104];
strf			 = [115 116 114 102];
movi         = [109 111 118 105];
idx1 			 = [105 100 120 49];
db				 = [48 48 100 98];

movie.fid = fopen(movie.filename, 'r');
if movie.fid < 3
   error(['#AVI Error: ', movie.filename, ' not found.']);
end
xx = uint8(fread(movie.fid, movie.num_input, 'uint8'));  
if xx(1:4)'~= RIFF;								%check for: 'RIFF'
   error(['#AVI Error: ', movie.filename, ' is not a valid RIFF file.']);
elseif xx(9:12)' ~= AVI;					%check for: 'AVI '
   error(['#AVI Error: ', movie.filename, ' is not a valid AVI file.']);
end
fclose (movie.fid);

%-------------------------------------------------------------------------
% Extracting AVI header information
%-------------------------------------------------------------------------

%Search for 'avih'
%-------------------------------------------------------------------------
avih_loc=1;
while 1;
   avih_loc=avih_loc+1;
   if xx(avih_loc:(avih_loc+3))' == avih;
      break;
   elseif (avih_loc >= movie.num_input - 3)
      error ('#AVI Error: avih not found');
   end 		 
end

%Analyze 'avih'
%-------------------------------------------------------------------------
b_temp 				 = parse (xx((avih_loc+20):(avih_loc+23)));
b_temp = dec2bin (b_temp);
if (b_temp(length(b_temp)-3)==1)
   movie.idx1 = 1;
end

movie.num_frames   = parse (xx((avih_loc+24):(avih_loc+27)));
movie.columns      = parse (xx((avih_loc+40):(avih_loc+43)));
movie.lines        = parse (xx((avih_loc+44):(avih_loc+47)));
movie.rate			 = parse (xx((avih_loc+48):(avih_loc+51)));

%Search for 'strf'
%-------------------------------------------------------------------------
strf_loc = avih_loc;
while 1;
   strf_loc=strf_loc+1;
   if xx(strf_loc:(strf_loc+3))' == strf;
      break;
   elseif (strf_loc >= movie.num_input - 3)
      error ('#AVI Error: strf not found');
   end 		 
end

%Analyze 'strf'
%-------------------------------------------------------------------------
movie.color_depth=double(xx(strf_loc+22))+double(xx(strf_loc+23))*256;
switch movie.color_depth
   case 8
      movie.bytes=1;
   case 16
      movie.bytes=2;
   case 24 
      movie.bytes=3;
   otherwise
      movie.bytes=4;
end

%Search for 'movi'
%-------------------------------------------------------------------------
movi_loc = strf_loc;
while 1;
   movi_loc = movi_loc+1;
   if xx(movi_loc:(movi_loc+3))' == movi;
      break;
   elseif (movi_loc >= movie.num_input - 3)
      error ('#AVI Error: movi not found');
   end 		
end

%Analyze 'movi'
%-------------------------------------------------------------------------
movie.movi_loc 	 = movi_loc;
movie.frame_length = parse (xx((movi_loc+8):(movi_loc+11)));

if (movie.idx1 == 1)
	%Search for 'idx1'
	%-------------------------------------------------------------------------
	movie.fid = fopen(movie.filename, 'r');
	fseek (movie.fid, -10000, 1);
	idxData = uint8(fread(movie.fid, 10000, 'uint8'));
	idx1_loc = 0;
	while 1;
 	  idx1_loc = idx1_loc + 1;
	   if idxData(idx1_loc:(idx1_loc+3))' == idx1;
 	     break;
 	  elseif idx1_loc+3 >= 10000;
 	     error ('#AVI Error: idx1 not found');
	   end;
	end;
	fclose (movie.fid);

	%Analyze 'idx1'
	%-------------------------------------------------------------------------
	idxPos = idx1_loc;
	idxLoop = 1;
	while idxPos < length(idxData)-3;
	   idxPos = idxPos + 1;
   	if (idxData(idxPos:(idxPos+3))' == db);
	      movie.index(idxLoop) = parse (idxData((idxPos+8):(idxPos+11)));
   	   if parse (idxData((idxPos+12):(idxPos+15))) ~= 0;
	         idxLoop = idxLoop + 1;
      	end;
   	end
	end;
	
	if (length (movie.index) ~= movie.num_frames)
	   disp ('#AVI Error: formatting is off, but program will continue');
   	movie.num_frames = length(movie.index);
	end
end

%Check for Compressed AVIs
%-------------------------------------------------------------------------
if ((movie.lines*movie.columns)~=(movie.frame_length/movie.bytes));
   error('#AVI Error: Compressed AVI not supported !');
end;   
