import numpy as np
import matplotlib.pyplot as plt

limit = 10000

ref 	= np.loadtxt( 'ref.txt' )
ref_len	= len( ref )
max 	= ref.max()
min 	= ref.min()

print( "Tamaño de ref: " + str( ref_len ) )

if( ref_len > limit ):
	ref_len = limit;

i = 0;
while( i < ref_len ):
	ref[ i ] = ref[ i ] * 64
	i = i + 1

# labels
title   = 'ADC1410 IF samples'
xlabel  = 'Sample'
ylabel  = 'Amplitude'

# fonts
title_font = { 'weight': 'light', 'size': 36, }
axis_font  = { 'weight': 'bold', 'size': 10, }

# Y axis step
step = ( ref.max() - 8192 ) / 4

plt.figure( figsize = ( 16, 8 ) )
plt.plot( ref, 'b', label = 'Reference signal' )
plt.xlabel( xlabel, axis_font )
plt.ylabel( ylabel, axis_font )
plt.legend()
plt.title( title, fontdict = title_font )
plt.grid( 'black' )
plt.xlim( 0, len( ref ) )
ax = plt.gca()
ax.set_facecolor( 'tab:gray' )

plt.yticks( np.arange( min.round( -1 ), max, step = step ) )

plt.show()
