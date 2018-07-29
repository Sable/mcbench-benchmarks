function [score,iletter,jletter] = checkword(word0)
global layout;

word=upper(word0);
score=0;
iletter=[];
jletter=[];


N=0;
letter={};
while N<length(word),
	N=N+1;
	if word(N)=='Q',
		letter{end+1}='Qu';
		word(N+1)='';
	else,
		letter{end+1}=word(N);
	end;
	match(N).nwrong=-1;
	match(N).i=[];
	match(N).j=[];
end;
if N<=2,
	return;
end;

a=0;
anchor='';
for i=1:4,
	for j=1:4,
		if strcmp(letter{1},layout{i,j})
			anchor(a+1).i=i;
			anchor(a+1).j=j;
			a=a+1;
		end;
	end;
end;

for a=1:length(anchor),
	used=anchor(a).i+(anchor(a).j-1)*4;
	match(1).i=anchor(a).i;
	match(1).j=anchor(a).j;
	wrongroutes=[];
	wrongturn=[];
	n=2;
	while n<=N,
		foundnext=0;	
		for i=max(match(n-1).i-1,1):min(match(n-1).i+1,4)
			for j=max(match(n-1).j-1,1):min(match(n-1).j+1,4)
				slot=grid2n(i,j,4);
				if match(n-1).i==i && match(n-1).j==j,
					%(do nothing)
				elseif badroute([used,slot],wrongroutes),
					% (do nothing)
				elseif strcmp(letter{n},layout{i,j}) && isempty(find(slot==used))
					foundnext=1;
					match(n).i=i;
					match(n).j=j;
					used(end+1)=slot;
					if n==length(letter) && foundnext,
						score=N;
						iletter=[match(:).i];
						jletter=[match(:).j];
						return;
					end;
					n=n+1;
					break;
				end;
			end;
			if foundnext,
				break; 
			end;
		end;
		if ~foundnext,
			wrongroutes = [wrongroutes; used,zeros(1,N-length(used))];
			used(end)=[];
			if n>2, n=n-1;
			else break;
			end;
		end;
	end;
end;