#!/usr/bin/octave

%% just octave
pkg load signal;
pkg load control;

%% constants
fs        = 10e9;               % sample frequency
t1        = 1.562400e-3;
t2        = 1.563100e-3;
ref_amp   = 1;
err_amp   = 1;
ref_pha   = 0.0 * ( pi / 180 );
err_pha   = 0.0 * ( pi / 180 );
ref_fre   = 30e6;
err_fre   = 30e6;
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
err_s     = err_amp * [ pulse .* sin( 2 * pi * err_fre * t + err_pha ) ];
err_s_dp  = err_amp * [ pulse .* sin( 2 * pi * err_fre * t + err_pha + pi ) ]; # error desfasado

%% signal quotient
amp_var   = ( -0.25 : 1.5 / ( N - 1 ) : 1.25 );
quo_s     = ( amp_var .* err_s ) ./ ref_s;
quo_s_dp  = ( amp_var .* err_s_dp ) ./ ref_s;

%% plot
all_plots = 0;
hfigure = figure( 'Color', 'w' );
cols    = 1;
if( all_plots )
  rows  = 4;
else
  rows  = 2;
endif
subplot( rows, cols, 1 ); ##
if( all_plots )
  plt_1 = plot( t, ref_s, "linewidth", 2, 'r' );
  grid on;
  hold;
  plt_2 = plot( t, err_s .* 0.8, "linewidth", 2, 'b' );
  set( gca, "linewidth", 4, "fontsize", 12)
  xlabel( 'Tiempo' );
  ylabel( 'Amplitud' );
  title( 'Referencia (r) y error (b) - Ganancia fija y en fase' );
  subplot( rows, cols, 2 ); ##
  plt_3 = plot( t, ref_s, "linewidth", 2, 'r' );
  grid on;
  hold;
  plt_4 = plot( t, err_s_dp .* 0.8 , "linewidth", 2, 'b' );
  set( gca, "linewidth", 4, "fontsize", 12)
  xlabel( 'Tiempo' );
  ylabel( 'Amplitud' );
  title( 'Referencia (r) y error (b) - Ganancia fija y en desfase' );
endif
plt_5 = plot( amp_var, quo_s, "linewidth", 2, 'r' );
subplot( rows, cols, rows - 1 ); ##
grid on;
hold
plt_6 = plot( amp_var, quo_s_dp, "linewidth", 2, 'b' );
grid on;
set( gca, "linewidth", 4, "fontsize", 12)
xlabel( 'Ganancia del error' );
ylabel( 'Relacion Err/Ref' );
title( 'Relacion entre ambas señales, variando ganancia en error - Fase (r) y desfase (b)' );
subplot( rows, cols, rows ); ##
plt_7 = semilogx( amp_var, quo_s, "linewidth", 2, 'r' );
grid on;
hold
plt_8 = semilogx( amp_var, quo_s_dp, "linewidth", 2, 'b' );
grid on;
set( gca, "linewidth", 4, "fontsize", 12)
xlabel( 'Ganancia del error' );
ylabel( 'Relacion Err/Ref' );
title( 'Relacion (dB) entre ambas señales, variando ganancia en error - Fase (r) y desfase (b)' );