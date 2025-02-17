function [rx,radar] = rxsignalgen_bb(target_time_sample,radar,target)
%RXSIGNALGEN_BB Summary of this function goes here
%   Detailed explanation goes here
for i=1:target.n
 
    %received signal due to ith point scatterer
    rxp = zeros(radar.M,radar.N);

    %range delay is fixed for CPI time
    range_delay = (2*target.r(target_time_sample,i)/radar.c);
  
    for n=1:radar.N
        %doppler delay changes for every PRI
        doppler_delay = (-2*target.v(target_time_sample,i)*(n-1)*radar.PRI)/radar.c;
%         slow_time = (n-1)*radar.PRI*ones(radar.M,1);
%         phase_delay = (range_delay + doppler_delay)*ones(size(radar.M,1));
        tau_ix = floor((range_delay+doppler_delay)*radar.sbw);
%         disp(tau_ix);

        tau = range_delay+doppler_delay;
        disp(doppler_delay);
        p1 = exp(-1j*2*pi*radar.k*(tau)*(0:radar.Mtp-1)/radar.sbw);
        p2 = exp(1j*pi*radar.k*(tau)^2);
        p3 = exp(1j*2*pi*(2*target.v(target_time_sample,i)/radar.lambda)*(n-1)*radar.PRI);
        rxp(tau_ix+1:radar.Mtp+tau_ix,n) =  p1*p2.*p3;
    end
    %superposition step
    rx = rxp;

end
end

