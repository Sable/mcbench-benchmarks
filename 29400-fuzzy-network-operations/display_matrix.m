function boolMatToDisp = display_matrix(boolRB, inputLTCounts, outputLTCounts)

% This function displays to the screen a rule base represented in a Boolean
% matrix form.
% 
% It is called as follows:
%
% [boolMatToDisp] = display_matrix(boolRB, inputLTCounts, outputLTCounts)
% 
%  where: 
%
%  - boolMatToDisp is the displayed rule base. It contains row and column
%  labels.
%
%  - boolRB is the Boolean matrix representation of the rule base that is
%  to be displayed.
%  - inputLTCounts is an array that contains the counts of the linguistic
%  terms for each input to the rule base that is to be displayed.
%  - outputLTCounts is an array that contains the counts of the linguistic
%  terms for each output from the rule base that is to be displayed.

% © Nedyalko Petrov, University of Portsmouth, UK
% email: nedyalko.petrov@port.ac.uk

inpPerms = generate_permutations(inputLTCounts);
outPerms = generate_permutations(outputLTCounts);

inpPermsStr = zeros(1, length(inpPerms));
outPermsStr = zeros(1, length(outPerms));

for i = 1 : length(inpPerms)
    inpPermsStr(1, i) = str2double(strrep(num2str(inpPerms{i}), ' ' ,''));
end

for i = 1 : length(outPerms)
    outPermsStr(1, i) = str2double(strrep(num2str(outPerms{i}), ' ' ,''));
end

boolMatToDisp = zeros(length(inpPerms) + 1, length(outPerms) + 1);
boolMatToDisp(1,2:end) = outPermsStr';
boolMatToDisp(2:end,1) = inpPermsStr;
boolMatToDisp(2:end, 2:end) = boolRB;
disp(boolMatToDisp);
