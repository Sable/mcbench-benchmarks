function ret = matlab_version_at_least(major, minor)
% ret = matlab_version_at_least(major, minor)
%
% Returns true if the matlab version is at least major.minor
%

	[matlab_major matlab_minor] = matlab_version();
	
	ret = matlab_major > major || (matlab_major == major && matlab_minor >= minor);
