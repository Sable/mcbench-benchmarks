function [rank,description,usedcards,unusedcards] = rankp(hands,handsize)
% A function that evaluates poker hands and returns a numerical rank and
% text description for each. The list of cards used to make the best
% possible hand is returned in 'usedcards'. If handsize is smaller than
% the length of hands given, then the cards not used in the best possible
% hand are returned in 'unusedcards'. Rank of 1 is best (Royal Flush),
% higher numbers are worse. Rank values are not contiguous across all
% hands, but are correctly ordered.
% 
% The hand matrix expected is an mxn list of m hands with n cards.  The
% cards are numbered from 1 to 52.  Suit doesn't matter for ranking. Order
% of the cards in the input vector does not matter. Numbering starts with
% the Ace at position 1. Here is a suggested card assignment:
% 
% A | K | Q | J | 10| 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | Suit
% -------------------------------------------------------------
% 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10| 11| 12| 13| Spades
% 14| 15| 16| 17| 18| 19| 20| 21| 22| 23| 24| 25| 26| Hearts
% 27| 28| 29| 30| 31| 32| 33| 34| 35| 36| 37| 38| 39| Clubs
% 40| 41| 42| 43| 44| 45| 46| 47| 48| 49| 50| 51| 52| Diamonds
% 
% Example call to the function:
% trick = [33,3,43,1,25,4,19;
%          6,36,20,10,35,21,38;
%          45,31,51,40,37,22,26;
%          28,49,46,32,17,16,39]; 
% [ranks,descriptions,usedcards,unusedcards] = rankp(trick,2); 
% 
% revision 5
% - fixed a conditional error in the numerical ranking section,
%   thanks to Tim C. for testing it
% revision 4
% - fixed a hole in the condition to wipe low aces if not used
% revision 3
% - made rankp "toolbox neutral" by using nchoosek instead of combnk,
%   thanks to James for pointing that out
% - fixed a hole in the conditional statements for unusedcards
% revision 2
% - added handsize input, usedcards and unusedcards outputs
% - improved speed of classification with help from Doug
% revision 1
% - written for Doug's LazyWeb by Rob

%% Setup variables

handlen = size(hands,2);
numhands = size(hands,1);

% quality check on handsize argument
if nargin > 1
    handsize = min([handsize handlen 5]);
else
    handsize = min([handlen 5]);
end

rank = zeros(numhands,1);
description = cell(numhands,1);
usedcards = zeros(numhands,handsize);
if handlen > handsize
    unusedcards = zeros(numhands,(handlen-handsize));
else
    unusedcards = [];
end

%% Main process loop

% test each hand, keep max rank
for i = 1:numhands
    handcombs = nchoosek(hands(i,:),handsize);
    a = zeros(size(handcombs,1),1);
    b = cell(size(a));
    for j = 1:size(handcombs,1)
        [a(j),b{j}] = rankhand(handcombs(j,:));
    end
    [a,ix] = sort(a);
    rank(i) = a(1);
    description{i} = b(ix(1));
    usedcards(i,:) = handcombs(ix(1),:);
    if handlen > handsize
        unusedcards(i,:) = setxor(usedcards(i,:),hands(i,:));
    end
end

%% Sub function

function [r,handclass] = rankhand(hand)

% Setup variables
if nargin < 1 || length(hand) > 5
    r = 0;
    handclass = 'Hand must have 1 to 5 cards!';
    return;
end

len = length(hand);
cards = zeros(13,4);
cards(hand) = 1;
cards(14,:) = cards(1,:);

colsum = sum(cards);
rowsum = sum(cards,2);
rownames = {'Ace';'King';'Queen';'Jack';'10';'9';'8';'7';'6';'5';'4'; ...
    '3';'2';'Ace'};

handclass = 'High';
done = false;

%% Classify the hand

% test for Straight and Straight-flush, wipe low Ace if not used
if len==5
    if any(sum(logical([rowsum(1:5) rowsum(2:6) rowsum(3:7) rowsum(4:8)...
            rowsum(5:9) rowsum(6:10) rowsum(7:11) rowsum(8:12)...
            rowsum(9:13) rowsum(10:14)]))==5)
        if sum(logical(colsum))==1
            handclass = 'Straigh Flush';
        else
            handclass = 'Straight';
        end
        if sum(logical(rowsum(10:14))) == 5
            cards(1,:) = 0;
        else
            cards(14,:) = 0;
        end
        colsum = sum(cards);
        rowsum = sum(cards,2);
        done = true;
    end
end
if ~done
    cards(14,:) = 0;
    colsum = sum(cards);
    rowsum = sum(cards,2);
end

% test for Four of a Kind
if len >= 4
    if ~done && sum(rowsum==4)==1
        handclass = 'Four';
        done = true;
    end
end

% test for full house
if len == 5
    if ~done && sum(rowsum==3)==1 && sum(rowsum==2)==1
        handclass = 'Full House';
        done = true;
    end
% test for Flush
    if ~done && sum(colsum==5)==1
        handclass = 'Flush';
        done = true;
    end
end

% test for 3 of a kind
if len >= 3
    if ~done && sum(rowsum==3)==1
        handclass = 'Three';
        done = true;
    end
end

% test for 2 pairs
if len >= 4
    if ~done && sum(rowsum==2)==2
        handclass = 'Two Pairs';
        done = true;
    end
end

% test for 1 pair
if len >= 2
    if ~done && sum(rowsum==2)==1
        handclass = 'Pair';
    end
end

% if nothing else, handclass stays 'High'

%% Numerically rank the hand within its class

switch handclass
    case 'Straigh Flush'
        r = find(rowsum,1,'first');
    case 'Four'
        r = 1e1*find(rowsum==4);
        if len == 5
            r = r + find(rowsum==1);
        end
    case 'Full House'
        r = 2e2*find(rowsum==3) + find(rowsum==2);
    case 'Flush'
        a = find(rowsum);
        r = 3e3*a(1)+1e2*a(2)+1e2/2*a(3)+1e1*a(4)+a(5);
    case 'Straight'
        r = 4e4*find(rowsum,1,'first');
    case 'Three'
        r = 5e5*find(rowsum==3);
        if len > 3
            a = find(rowsum==1);
            r = r+1e4*a(1);
            if len==5
                r = r+1e3*a(2);
            end
        end
    case 'Two Pairs'
        a = find(rowsum==2);
        r = 7e6*a(1)+1e5*a(2);
        if len == 5
            b = find(rowsum==1);
            r = r+1e4*b(1);
        end
    case 'Pair'
        a = find(rowsum==2);
        r = 2e8*a(1);
        if len > 2
            b = find(rowsum==1);
            r = r+1e6*b(1);
            if len > 3
                r = r+1e5*b(2);
                if len == 5
                    r = r+1e4*b(3);
                end
            end
        end
    case 'High'
        a = find(rowsum);
        r = 5e9*a(1);
        if len > 1
            r = r+1e7*a(2);
            if len > 2
                r = r+1e6*a(3);
                if len > 3
                    r = r+1e5*a(4);
                    if len == 5
                        r = r+a(5);
                    end
                end
            end
        end
    otherwise
        disp('There was an error classifying this hand!');
        return;
end

%% Generate text output to describe the hand

switch handclass
    case 'Straigh Flush'
        if r == 1
            handclass = 'Royal Flush!';
        else
            handclass = [handclass,' to the ',rownames{find(rowsum,1,'first')}];
        end
    case 'Four'
        handclass = [handclass,' ',rownames{find(rowsum==4)},'''s'];
        if len == 5
            handclass = [handclass,' and a ',rownames{find(rowsum==1)}];
        end
    case 'Full House'
        handclass = [handclass,', ',rownames{find(rowsum==3)},'''s and ',...
            rownames{find(rowsum==2)},'''s'];
    case 'Flush'
        handclass = [handclass,' with ',rownames{a(1)},', ',rownames{a(2)},...
            ', ',rownames{a(3)},', ',rownames{a(4)},', and ',rownames{a(5)}];
    case 'Straight'
        handclass = [handclass,' to the ',rownames{find(rowsum,1,'first')}];
    case 'Three'
        handclass = [handclass,' ',rownames{find(rowsum==3)},'s'];
        if len > 3
            handclass = [handclass,' with ',rownames{a(1)}];
            if len == 5
                handclass = [handclass,', and ',rownames{a(2)}];
            end
        end
    case 'Two Pairs'
        handclass = [handclass,', ',rownames{a(1)},'''s and ',rownames{a(2)},'''s'];
        if len == 5
            handclass = [handclass,' with a(n) ',rownames{b(1)}];
        end
    case 'Pair'
        handclass = [handclass,' of ',rownames{a(1)},'''s'];
        if len > 2
            handclass = [handclass,' with ',rownames{b(1)}];
            if len > 3
                handclass = [handclass,', ',rownames{b(2)}];
                if len == 5
                    handclass = [handclass,', and ',rownames{b(3)}];
                end
            end
        end
    case 'High'
        handclass = [rownames{a(1)},' ',handclass,' with ',rownames{a(2)}];
        if len > 2
            handclass = [handclass,', ',rownames{a(3)}];
            if len > 3
                handclass = [handclass,', ',rownames{a(4)}];
                if len == 5
                    handclass = [handclass,', and ',rownames{a(5)}];
                end
            end
        end
    otherwise
        disp('There was an error generating text for this hand.');
end

