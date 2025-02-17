%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FMCW SISO RADAR PLATFORM                        -GAURAV DUGGAL 16/12/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p] = get_axes_plots(p,radar,target)
%GET_AXES_PLOTS Summary of this function goes here
%   Detailed explanation goes here


% differential range axis (range is with respect to CRP, closer to radar is -ve
p.differential_range_axis = radar.rmax/2:-radar.dr:-radar.rmax/2+radar.dr;
% range axis
p.range_axis = radar.rmax/2*ones(size(p.differential_range_axis)) + p.differential_range_axis;
% p.range_axis = radar.dr:radar.dr:radar.rmax;
% doppler axis
p.doppler_axis = -radar.dmax:radar.dd:radar.dmax-radar.dd;

% velocity axis
p.velocity_axis = p.doppler_axis*(radar.lambda/2);


end

