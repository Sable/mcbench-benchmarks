function test_SolarAzEl()
%% Purpose:
% Demonstrate the utility of the SolarAzEl.m function.
% Just run this test function to reproduce the MATLAB plot.
%
%% Begin Code Sequence
%% Winter season in northern hemisphere
mDateVec = datenum([2001,12,20,0,0,0]);
mDateVec = mDateVec + (0:1440)'./1440;
  [wAz,wEl] = SolarAzEl(mDateVec,zeros(size(mDateVec,1),1)+33.8492,zeros(size(mDateVec,1),1)-118.3875,zeros(size(mDateVec,1),1));
  figure('color',[1 1 1]);
  subplot(1,2,1);
  plot(wAz,wEl,'.b'); hold on;
  text(max(wAz),min(wEl),'\leftarrow winter');
%% Summer season in northern hemisphere
mDateVec = datenum([2002,06,20,0,0,0]);
mDateVec = mDateVec + (0:1440)'./1440;
%Convert to UTC character array for demonstration purposes
UTC = datestr(mDateVec,'yyyy/mm/dd HH:MM:SS');
  [sAz,sEl] = SolarAzEl(UTC,zeros(size(UTC,1),1)++33.8492,zeros(size(UTC,1),1)-118.3875,zeros(size(UTC,1),1));
  plot(sAz,sEl,'.r');
  text(max(sAz),min(sEl),'\leftarrow summer');
  xlabel('Solar Azimuth (deg)');
  ylabel('Solar Elevation (deg)');
  grid on; title('Solar Azimuth and Elevation Angle - Redondo Beach, CA');
  ylim([-90 90]);
  subplot(1,2,2);
  plot(mod((0:1440)-420,1440),wEl,'.b'); hold on;
  plot(mod((0:1440)-420,1440),sEl,'.r');
  xlabel('Time from Midnight PST (min)');
  ylabel('Solar Elevation Angle (deg)');
  grid on; title('Solar Elevation Angle vs Time - Redondo Beach, CA');
  ylim([-90 90])
end