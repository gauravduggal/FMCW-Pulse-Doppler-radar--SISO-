%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FMCW SISO RADAR PLATFORM                        -GAURAV DUGGAL 16/12/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [target] = get_range_from_position(target,radar)
%GET_CUSTOM_TARGET Summary of this function goes here
%   Detailed explanation goes here

number_time_samples = size(target.position,1);
number_point_scatterers = size(target.position,2)/3;
target.r = zeros(number_time_samples,number_point_scatterers);
%number of point scatterers in target
target.n = size(target.r,2);
for n = 1:number_time_samples
    for i=1:3:number_point_scatterers*3
        range_index_point_scatterer = floor(i/3)+1;
        target.r(n,range_index_point_scatterer) = ...
            ((target.position(i) - radar.position(1))^2 + ...
            (target.position(i+1) - radar.position(2))^2 + ...
            (target.position(i+2) - radar.position(3))^2).^0.5;
    end
end
    
end

