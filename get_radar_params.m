%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FMCW SISO RADAR PLATFORM                        -GAURAV DUGGAL 16/12/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [radar] = get_radar_params(radar)
%GET_RADAR_PARAMS takes in independent parameters of the radar and
%calculates all the other dependent parameters
%   Detailed explanation goes here
%passband sampling time (s)
radar.pts = 1/radar.pfs;
%bandwidth
radar.bw = radar.c/(2*radar.dr);
%chirp (Hz/s), change bandwidth of passband signal with this
radar.k = radar.bw/radar.tp;
%pulse repetition interval
radar.PRI = radar.tr;
%pulse repetition frequency (Hz)
radar.PRF = 1/radar.PRI;
%wavelength (m)
radar.lambda = radar.c/radar.fc;
%number of PRI in 1 CPI
radar.N = floor(radar.tf/radar.PRI);
%adjusting tf to adjust for rounding off above
radar.tf = radar.N*radar.PRI;
%doppler resolution
radar.dd = 1/(radar.tf);
%velocity resolution
radar.dv = radar.dd*radar.lambda/2;
%maximum unambiguous range (m)
radar.runambr = radar.c*radar.PRI/2;
%maximum doppler value
radar.dmax = radar.PRF/2;
%maximum velocity
radar.vmax = radar.dmax*(radar.lambda/2);
% %radar range (m)
% radar.range = [radar.r0-radar.rw/2, radar.r0+radar.rw/2];
%bandwidth of stretch processing baseband i.e. sampling of the adc is based
%on this bandwidth
radar.sbw = (2*radar.bw*radar.rmax)/(radar.tp*radar.c);
%time samples in PRI at passband /baseband
radar.M = floor(radar.PRI/radar.pts);
%time samples in tp in passband / baseband
radar.Mtp = floor(radar.tp/radar.pts);
%radar normal direction
radar.z = cross(radar.x, radar.y);
end

