function [major minor] = matlab_version()
% [major minor] = matlab_version()
%
% Returns the matlab version as two doubles.
%

	version_str = strtrim(version());
	[major version_str] = strtok(version_str, '.');
	[minor version_str] = strtok(version_str(2:end), '.');
	
	major = str2double(major);
    minor = str2double(minor);
