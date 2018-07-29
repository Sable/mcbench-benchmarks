function [bar] = kPa2bar(kPa)
% Convert pressure from kilopascals to bar.  It's interesting how we tend
% to say "bar" as the plural for "bar".  I've heard people say "millibars"
% but I've also heard "millibar" as its plural.  The same does not seem to 
% be true for other units of pressure.  We'd say "5 atmospheres".  For some
% reason, I often hear people talk about singular form of animals as their
% plural, too.  Of course there's deer and fish, but I'm not talking about
% those.  I've actually heard people say "Look at those alpaca" or "we saw
% some bear" or "There are lots of squirrel out today".  Strange. 
% Chad A. Greene 2012
bar = kPa/100;