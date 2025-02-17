%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FMCW SISO RADAR PLATFORM                        -GAURAV DUGGAL 16/12/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [rx] = rxsignalgen(target_time_sample,radar,target)
%RXSIGNALGEN Summary of this function goes here
%   generates the received signal for target.n point scatterers,
% uses the target moving at a constant velocity in CPI time with range
% changing as range = r0 + v*t
% finds the received signal by superposition of signals due to individual
% point scatterers
% also adds the channel attenuation (2 way), Gain of the tx,rx antenna in the
% direction of the pint scatterer

%received signal
rx = zeros(radar.M,radar.N);

%iterate over all point scatterers in 1 time sample
for i=1:target.n
 
    %antenna gain lookup from antenna pattern table
    target_index = (i-1)*3+1;
    [theta,phi] = get_theta_phi_point_scatterer(target_index,target_time_sample,target,radar);
    antenna_pattern_row_index = (radar.ap(:,1)==floor(theta));
    
    %gain
    rx_gain = 10^(radar.ap(antenna_pattern_row_index,3)/10);
    %transmitter and receiver are co-located
    tx_gain = rx_gain;
    
    %received power at receiver according to the friiz radar equation
    prx = radar.ptx*tx_gain*rx_gain*radar.lambda^2*target.rcs(target_time_sample,i)...
        / ((4*pi)^3*(target.r(target_time_sample,i)^4));
    prx = 1;
    %received signal due to ith point scatterer
    rxp = zeros(radar.M,radar.N);

    %range delay is fixed for CPI time
    range_delay = (2*target.r(target_time_sample,i)/radar.c);
  
    for n=1:radar.N
        %doppler delay changes for every PRI
        doppler_delay = (-2*target.v(target_time_sample,i)*(n-1)*radar.PRI)/radar.c;
        slow_time = (n-1)*radar.PRI*ones(size(radar.fast_time));
        phase_delay = (range_delay + doppler_delay)*ones(size(radar.fast_time));
        tau_ix = floor((range_delay+doppler_delay)/radar.pts);
        disp(tau_ix);
        rxp(tau_ix+1:radar.Mtp+tau_ix,n) = (prx)^0.5*exp(1j*2*pi*radar.fc*(radar.fast_time+slow_time-phase_delay)').*exp(1j*pi*radar.k*(radar.fast_time)'.^2);
    end
    %superposition step
    rx = rx + rxp;

end
%calculated resultant power of received signal
disp("rx power is:");
power = sum(sum(rx.*conj(rx)))/(radar.M*radar.N)
end

