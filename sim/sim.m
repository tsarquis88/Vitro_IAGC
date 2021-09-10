#!/usr/bin/octave

%% just octave
pkg load signal;
pkg load control;

%% constants
fs        = 10e9;               % sample frequency
fsu       = 100e6 / 1;              % undersample frequency
t1        = 1.562400e-3;
t2        = 1.563100e-3;
s_amp     = 1;                  % signal amplitude
s_pha     = 0.0 * ( pi / 180 ); % signal phase in radians
s_fre     = 30e6;               % signal frequency
p_fre     = 640;                % pulse frequency
p_dut     = 0.032;              % pulse duty: Ton = 0.5 us

%% dependent constants
T         = ( 1 / p_fre ) * 2; 
dT        = 1 / fs;
dTu       = 1 / fsu;
t         = ( t1 : dT : t2 );
tu        = ( t1 : dTu : t2 );
N         = size( t, 2 );
Nu        = size( tu, 2 );
df        = fs / N;
dfu       = fsu / Nu;
f         = -fs / 2 : df : fs / 2 - df;
fu        = -fsu / 2 : dfu : fsu / 2 - dfu;

%% pulse generation (oversampled)
pulse     = square( 2 * pi * p_fre * t, p_dut ) >= 0;

%% signal generation (oversampled)
signal    = s_amp * [ pulse .* sin( 2 * pi * s_fre * t + s_pha ) ];
signal_f  = fftshift( fft ( signal ) );

%% pulse generation (undersampled)
pulseu    = square( 2 * pi * p_fre * tu, p_dut ) >= 0;

%% signal generation (undersampled)
signalu   = s_amp * [ pulseu .* sin( 2 * pi * s_fre * tu + s_pha ) ];
signalu_f = fftshift( fft ( signalu ) );

%% plot
hfigure = figure('Color', 'w');
rows        = 2;
cols        = 1;

subplot( rows, cols, 1 );
plt_1 = plot( t, signal, "linewidth", 2, 'r' );
grid on;
hold
plt_2 = plot( tu, signalu, "linewidth", 3, 'b' );
grid on;
hlegend1 = legend( plt_1, "Oversampled", "Location", "SouthWest" );
new_handle = copyobj( hlegend1, hfigure );
legend( plt_2, "Undersampled", "Location", "SouthEast" );
set(gca, "linewidth", 4, "fontsize", 12)
xlabel( 'Time' );
ylabel( 'Amplitude' );
title( 'Time domain' );

subplot( rows, cols, 2 );
plt_3 = plot( f, signal_f, "linewidth", 2, 'r' );
grid on;
hold
plt_4 = plot( fu, signalu_f, "linewidth", 3, 'b' );
grid on;
hlegend1 = legend( plt_3, "Oversampled", "Location", "NorthWest" );
new_handle = copyobj( hlegend1, hfigure );
legend( plt_4, "Undersampled", "Location", "NorthEast" );
set(gca, "linewidth", 4, "fontsize", 12)
xlabel( 'Frequency' );
ylabel( 'Amplitude' );
axis( [ -50e6, 50e6, -10, 25 ] );
title( 'Frequency domain' );

s = axes( 'visible', 'off', 'title', sprintf( 'Undersampling at %d GHz\n', fsu / 1e6 ) );