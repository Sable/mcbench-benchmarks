function str = randpraise(score)
rand('twister',sum(100*clock));

praise = {'adequate' 'not bad' 'good' 'nice' 'well done' 'great' 'super' ...
	'way to go' 'rad' 'bravo' 'excellent' 'far out' 'outstanding' ...
	'wow' 'amazing' 'awesome' 'incredible'};

a=max(min(round((  (score-3)*(1+rand/4) + rand*6 )),numel(praise)),1);
str=praise{a};