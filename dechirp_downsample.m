%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FMCW SISO RADAR PLATFORM                        -GAURAV DUGGAL 16/12/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y_ds,radar] = dechirp_downsample(rx,radar)
%DECHIRP_DOWNSAMPLE Summary of this function goes here
%   Detailed explanation goes here

%mixer
%to is the delay of the Central Reference Point (CRP)

mixer_signal = ones(size(rx,1),radar.N);
for n = 1:radar.N
    slow_time = ((n-1)*radar.PRI)*ones(size(radar.fast_time));
    mixer_signal(1:radar.Mtp,n) = exp(1j*2*pi*radar.fc.*(radar.fast_time + slow_time)').* ... 
        exp(1j*pi*radar.k*(radar.fast_time)'.^2);
end

%% dechirp
y = conj(mixer_signal).*rx;

%% downsample

%number of samples in PRI after downsampling
radar.M = floor(radar.PRI*radar.sbw);
%number of samples in tp after downsampling
radar.Mtp = floor(radar.tp*radar.sbw);
y_ds = zeros(radar.M,radar.N);
%iterate over all PRI's
for n = 1:radar.N
    %little bit of magic here
    %decimate by less than required amount and then interpolate
    temp = decimate(y(:,n),floor(radar.pfs/radar.sbw));
    %interpolation required because decimation is done only in integer
    %values
    y_ds(:,n) = temp;
%     y_ds(:,n) = interp1(1:length(temp),temp,1:radar.M);
end

end

