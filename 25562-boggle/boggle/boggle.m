%boggle.m
%Ryan Kinnett

%Potential future improvements:
% Adjust letters to board size
% Multiplayer, via udp
% Automatic best word finder
% Automatic all possible word finder


clear; clc; clf;
figure(1); clf; axis([0 1 0 1],'square','equal');
clear global layout
global layout
disp('Loading dictionary..');
load BoggleScores.mat
load BoggleMdict.mat
clc;

r=input('Timed? (y/n): ','s');
if r=='y' || r=='Y',
	timed=1;
	timeout=3*60;
else
	timed=0;
	timeout=inf;
end;
h=0;

playername=input('Enter player name: ','s');

newround=1;
while newround
	clf;
	shake;
	points=0;
	word='';
	usedwords={''};
	bestscore=0;
	bestword='';
	tic;
	while 1,
		word=upper(input('Enter word (q to quit): ','s'));
		if ~isempty(find(get(gca,'Children')==h)),
			delete(h);
		end;
		if timed && toc>timeout,
			disp('Time''s up!');
			break;
		elseif sum(strcmp(word,{'-1','X','Q'}))
			break;
		else

			%check if word exists in puzzle or already used:
			[newpoints,connecti,connectj]=checkword(word);
			if length(word)<3, %do nothing..
			elseif sum(strcmp(usedwords,word))
				disp('   ..word already used.');
			elseif ~newpoints,
				disp('   ..word not found on board.');
			else			
				h=plot(connecti/4-.125,connectj/4-.125,'ro-');
				usedwords{end+1}=word;
				
				%Check if word is in dictionary:
				a=int8(upper(word(1)))-64; %get # of first letter
				ok=0;
				for b=1:size(boggleM_dict,1)
					if size(boggleM_dict{b,a})==size(word)
						if strcmp(word,boggleM_dict{b,a}) || (word(end)=='S' && strcmp(word(1:end-1),boggleM_dict{b,a}))
							ok=1;
							points=points + newpoints;
							delete(h)
							h=plot(connecti/4-.125,connectj/4-.125,'go-');
							disp([num2str(newpoints) ' pts.   ' randpraise(newpoints) '!  ' ]);
							
							if newpoints>bestscore,
								bestscore=newpoints;
								bestword=word;
							end;							
						end
					end
				end;
				if ~ok, disp(['  ' word ' not in dictionary.']); 
				end;
			end;
			title(sprintf('Total: %3i pts,   Time remaining: %i sec',points,round(timeout-toc)));
		end;		
	end;
	disp(sprintf('\n   %3i points.  Best word: %s.\n   %s!\n',points,bestword,randpraise(points/9)));

	%Check for high score:
	indicator = {'','*'};
	if points>bestScores(timed+1).scores(5) || length(bestScores(timed+1).scores)<5,
		bestScores(timed+1).scores(5)		= points;
		bestScores(timed+1).names{5}		= playername;
		[bestScores(timed+1).scores,order]	= sort(bestScores(timed+1).scores,'descend');
		bestScores(timed+1).names			= bestScores(timed+1).names(order);
		disp('     HIGH SCORES:');
		for n=1:length(bestScores(timed+1).scores)
			disp(sprintf('%2i) %8s\t%6i %s',n,bestScores(1).names{n},bestScores(1).scores(n),indicator{(order(n)==5)+1}));
		end;
	end;
	
	%Check for best words:
	if bestscore>bestWords(timed+1).points(5) || length(bestWords(timed+1).points)<5,
		bestWords(timed+1).points(5)		= bestscore;
		bestWords(timed+1).words{5}			= lower(bestword);
		bestWords(timed+1).names{5}			= playername;
		[bestWords(timed+1).points,order]	= sort(bestWords(timed+1).points,'descend');
		bestWords(timed+1).words			= bestWords(timed+1).words(order);
		bestWords(timed+1).names			= bestWords(timed+1).names(order);
		disp('     BEST WORDS:');
		for n=1:length(bestWords(timed+1).points)
			disp(sprintf('%2i) %8s\t%12s\t(%2i pts) %s',n,bestWords(1).names{n},bestWords(1).words{n},bestWords(1).points(n),indicator{(order(n)==5)+1}))
		end;
	end;
	
	if strcmp(input(['    New round? (y/n): '],'s'),'n'),
		newround=0;
	end;	
end;

save BoggleScores.mat bestScores bestWords;



