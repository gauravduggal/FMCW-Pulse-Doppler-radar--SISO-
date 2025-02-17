%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FMCW SISO RADAR PLATFORM                        -GAURAV DUGGAL 16/12/2018
% Stretch Processing in
% Mark A. Richards - Fundamentals of Radar Signal Processing (2005, McGraw-Hill)
% Chapter 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear all
clc

%% radar independent paramaters
radar = struct();
%radar location world coordinates (x,y,z) in metres
radar.position = [0,0,0];
%radar x axis orientation vector in world coordinate system
radar.x = [1,0,0];
%radar y axis orientation vector in world coordinate system
radar.y = [0,1,0];
%carrier frequency (Hz)
radar.fc = 77e9;
%passband sampling frequency (Hz)
radar.pfs =  1.6e9;
%duration of chirp,
radar.tp = 3e-5;
%tr
radar.tr = 3e-5+3e-6;
%range resolution
radar.dr = 0.1;
%CPI
radar.tf = 3e-3;
%max range
radar.rmax = 100;
%speed of light
radar.c = 3e8;
%transmitted power (Watts)
radar.ptx = 10^3;
%Antenna Pattern
radar.ap = import_antenna_pattern("6x1_pattern_phi90_77ghz.txt",3,362);
figure;
theta = fftshift(radar.ap(:,1));
theta = mod(theta,360);
gain = fftshift(radar.ap(:,3));
polarpattern(theta,gain)
title("Antenna Radiation Pattern");


%% get radar dependent parameters
radar = get_radar_params(radar);
%display parameters
disp(radar)


%% tx signal

[tx,radar] = gen_tx_waveform(radar);


%% target parameters

target = struct();

%target position in world coordinates (x1,y1,z1,x2,y2,z2....)
%point scatterers coordinates in columns (x,y,z) , time samples in rows
target.position = [23,0,0,30,0,0,20,0,0];
%target radial distance sampled at CPI time over rows
%over columns is multiple point scatterers
%each row represents one CPI time
target = get_range_from_position(target,radar);
%target radial velocity sampled at CPI time
%over columns is multiple point scatterers
%each row represents one CPI time
target.v = [-15,8,6.1];


%target rcs is sampled at CPI time
%over columns is multiple point scatterers
%each row represents one CPI time
target.rcs = [1,1,1];

%basic error checking
if (length(target.v) == length(target.r) && (length(target.r) == length(target.rcs)))
    
else
    disp("length of rcs, range and velocity should be the same")
end

%target time sampled at CPI time
target.t = [0];

%% received signal

target_time_sample = 1;
% [rx] = rxsignalgen(target_time_sample,radar,target);


%% dechirping and downsampling

% this function generates passband received signal but that is not
% necessary
% [y,radar] = dechirp_downsample(rx,radar);
radar.M = radar.tr*radar.sbw;
radar.Mtp = radar.tp*radar.sbw;
%This function directly generates the baseband received signal
[y,radar] = rxsignalgen_bb(target_time_sample,radar,target);

%% axes and plots
p = struct();
p = get_axes_plots(p,radar,target);

%% Radar Processing

%Range Plot
figure;
plot(p.range_axis,10*log10(abs(fft(y(:,1),radar.Mtp))/radar.Mtp));
xlabel("range (m)");
title("range plot for 1 PRI");

%Range Doppler
%fft2 works on columns first
% rd = fft(y,radar.M,1);
rd = fftshift(fft2(y,radar.Mtp,radar.N),2)/(radar.Mtp*radar.N);
rd = 10*log10(abs(rd));

figure;
colormap(jet(256))
m = max(max(rd));
imagesc(p.velocity_axis,p.range_axis,rd,[m-50,m]);
xlim([p.velocity_axis(1),p.velocity_axis(end)]);
ylim([p.range_axis(end), p.range_axis(1)]);
title("range doppler plot");
xlabel("doppler (m/s)");
ylabel("range (m)");
colorbar