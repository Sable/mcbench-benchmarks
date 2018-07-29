
% From the article referenced by the original authors
lzwInput = uint8('/WED/WE/WEE/WEB/WET');
[lzwOutput, lzwTable] = norm2lzw(lzwInput);
fprintf('\n');
fprintf('Input:  ');
fprintf('%02x ', lzwInput);
fprintf('\n');
fprintf('Output: ');
fprintf('%04x ', lzwOutput);
fprintf('\n');
for ii = 257:length(lzwTable.codes)
	fprintf('Code: %04x, LastCode %04x+%02x Length %3d\n', ii, lzwTable.codes(ii).lastCode, lzwTable.codes(ii).c, lzwTable.codes(ii).codeLength)
end;

% Tests the special decoder case
lzwInput = uint8('abcAAAzAAAAaAAAAAdAAAAAefAAAAAAAAAAAAAAacdc');
[lzwOutput, lzwTable] = norm2lzw(lzwInput);
fprintf('\n');
fprintf('Input:  ');
fprintf('%02x ', lzwInput);
fprintf('\n');
fprintf('Output: ');
fprintf('%04x ', lzwOutput);
fprintf('\n');
for ii = 257:length(lzwTable.codes)
	fprintf('Code: %04x, LastCode %04x+%02x Length %3d\n', ii, lzwTable.codes(ii).lastCode, lzwTable.codes(ii).c, lzwTable.codes(ii).codeLength)
end;

[lzwOutputd, lzwTabled] = lzw2norm(lzwOutput);
fprintf('\n');
fprintf('Input:  ');
fprintf('%04x ', lzwOutput);
fprintf('\n');

fprintf('Output: ');
fprintf('%02x ', lzwOutputd);
fprintf('\n');

for ii = 257:length(lzwTabled.codes)
	fprintf('Code: %04x, LastCode %04x+%02x Length %3d\n', ii, lzwTabled.codes(ii).lastCode, lzwTabled.codes(ii).c, lzwTabled.codes(ii).codeLength)
end;