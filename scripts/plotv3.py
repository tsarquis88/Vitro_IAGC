import numpy as np
import matplotlib.pyplot as plt

limit = 10000

ref 	= np.loadtxt( 'ref_repaired.txt' )
ref_len	= len( ref )
max 	= ref.max()
min 	= ref.min()

if( ref_len > limit ):
	ref_len = limit

ref_plt = np.zeros( round( ref_len / 2 ) )

i = 0
j = 0
while( j < ref_len - 1 ):
	ref_plt[ i ] = ref[ j ] * 256 + ref[ j + 1 ]
	i = i + 1
	j = j + 2

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
plt.plot( ref_plt, 'b', label = 'Reference signal' )
plt.xlabel( xlabel, axis_font )
plt.ylabel( ylabel, axis_font )
plt.legend()
plt.title( title, fontdict = title_font )
plt.grid( 'black' )
plt.xlim( 0, len( ref_plt ) )
ax = plt.gca()
ax.set_facecolor( 'tab:gray' )

plt.yticks( np.arange( min.round( -1 ), max, step = step ) )

plt.show()
