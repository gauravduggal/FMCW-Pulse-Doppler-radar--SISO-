%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FMCW SISO RADAR PLATFORM                        -GAURAV DUGGAL 16/12/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tx,radar] = gen_tx_waveform(radar)
%GEN_TX_WAVEFORM Summary of this function goes here
%   Detailed explanation goes here

%fast time
radar.fast_time = -radar.tp/2:radar.pts:radar.tp/2-radar.pts;
% radar.fast_time = 0:radar.pts:radar.tp-radar.pts;

tx = zeros(radar.M,radar.N);

%iterate over all PRI
for n = 1:radar.N
    slow_time = (n-1)*radar.PRI*ones(size(radar.fast_time));
    %transmit signal for 1 PRI
%     tx(:,n) = exp(1j*2*pi*radar.fc.*(radar.fast_time + slow_time)').* ... 
%         exp(1j*pi*radar.k*radar.fast_time.^2)';
%carrier has been removed just for plotting spectrum
    tx(1:radar.Mtp,n) = exp(1j*pi*radar.k*radar.fast_time.^2)';
end

%Spectrum of transmit signal for one PRI
%frequency axis
f = -radar.pfs/2:1/radar.tp:radar.pfs/2-1/radar.tp;
figure;
plot(f,abs(fftshift(fft(tx(:,1),length(f)))));
xlabel("frequency (Hz)");
ylabel("magnitude");
title("Spectrum of transmit signal");
end

