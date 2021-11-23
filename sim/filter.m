#!/usr/bin/octave

%% just octave
pkg load signal;
pkg load control;

%% constants
fs        = 10e9;               % sample frequency
t1        = 1.562400e-3;
t2        = 1.563100e-3;
ref_amp   = 1;
noi_amp   = 0.2;
ref_pha   = 0.0 * ( pi / 180 );
noi_pha   = 0.0 * ( pi / 180 );
ref_fre   = 5e6;
noi_fre   = 20e6;
p_fre     = 640;                % pulse frequency
p_dut     = 0.032;              % pulse duty: Ton = 0.5 us

%% dependent constants
T         = ( 1 / p_fre ) * 2; 
dT        = 1 / fs;
t         = ( t1 : dT : t2 );
N         = size( t, 2 );
df        = fs / N;
f         = -fs / 2 : df : fs / 2 - df;

%% pulse generation
pulse     = square( 2 * pi * p_fre * t, p_dut ) >= 0;

%% signal generation
ref_s     = ref_amp * [ pulse .* sin( 2 * pi * ref_fre * t + ref_pha ) ];
noi_s     = noi_amp * [ pulse .* sin( 2 * pi * noi_fre * t + noi_pha ) ];
sig_s     = ref_s + noi_s;
fil_s     = zeros( 1, length( ref_s ) );
for i = 2:length( ref_s )
  aux = 0;
  cant= 400;
  for j = i-cant:i 
    if j > 0
      aux = aux + sig_s( j );
    endif
  endfor
  
  fil_s( i ) = aux / cant;
endfor

%% plot
hfigure = figure( 'Color', 'w' );
cols    = 1;
rows    = 2;
subplot( rows, cols, 1 ); ##
plt_1 = plot( t, sig_s, "linewidth", 2, 'r' );
grid on;
set( gca, "linewidth", 4, "fontsize", 12)
xlabel( 'Tiempo' );
ylabel( 'Amplitud' );
title( 'Referencia original' );
subplot( rows, cols, 2 ); ##
plt_3 = plot( t, fil_s , "linewidth", 2, 'r' );
grid on;
hold on;
plt_4 = plot( t, ref_s , "linewidth", 2, 'b' );
set( gca, "linewidth", 4, "fontsize", 12)
xlabel( 'Tiempo' );
ylabel( 'Amplitud' );
title( 'Referencia original' );