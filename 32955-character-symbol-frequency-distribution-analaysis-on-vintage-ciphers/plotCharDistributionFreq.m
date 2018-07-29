function plotCharDistributionFreq( textContents, fileTarget )
%PLOTCHARDISTRIBUTIONFREQ 
characters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
characters = lower(characters);

relativeLetterFreqOfEnglishLanguage = [
0.0817, 0.0150, 0.0278, 0.0425, 0.1270, 0.0223, 0.0202, ...
0.0609, 0.0697, 0.0015, 0.0077, 0.0403, 0.0241, ...
0.0675, 0.0751, 0.0193, 0.0010, 0.0599, 0.0633, ...
0.0906, 0.0276, 0.0098, 0.0236, 0.0015, 0.0197, 0.0007];

hold on;
plot(relativeLetterFreqOfEnglishLanguage, 'b');

charDistributionOfContents = histc(textContents, characters);
charDistributionOfContentsPercentages = charDistributionOfContents/ sum(charDistributionOfContents);

plot(charDistributionOfContentsPercentages, 'r');

legend('Reference statistics', ['Content target : ' fileTarget]); % , 'your content (without whitespaces)');
hold on;

end
