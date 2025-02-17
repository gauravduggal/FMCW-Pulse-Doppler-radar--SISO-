%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FMCW SISO RADAR PLATFORM                        -GAURAV DUGGAL 16/12/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [theta, phi] = get_theta_phi_point_scatterer(target_index,target_time_sample,target,radar)

M = [radar.x;radar.y;radar.z];
%point scatterer in world coordinates
u = [target.position(target_time_sample,target_index:target_index+2)]';
%point scatterer in local coordinates
p = M*u - radar.position';
%angle between vector of projection of point on x-y plane in radar local coordinates and
%radar local coordinate x axis
theta = atan2d(p(2),p(1));
%angle between the vector of the point in radar coordinates and the radar
%coordinate z axis
phi = atan2d((sum([p(1),p(2)].^2)).^0.5,p(3));
end

