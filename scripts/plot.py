import numpy as np
import matplotlib.pyplot as plt

limit = 10000

ref_l = np.loadtxt( 'ref_l.txt' )
ref_h = np.loadtxt( 'ref_h.txt' )

if( len( ref_l ) < len( ref_h ) ):
	ref_len = len( ref_l )
else:
	ref_len = len( ref_h )

if( ref_len > limit ):
	ref_len = limit;

ref   = np.zeros( ref_len )

i = 0
while i < ref_len:
    ref[ i ] = ref_l[ i ] + ref_h[ i ] * 256
    i += 1

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
# plt.plot( err, 'r', label = 'Error signal' )
plt.xlabel( xlabel, axis_font )
plt.ylabel( ylabel, axis_font )
plt.legend()
plt.title( title, fontdict = title_font )
plt.grid( 'black' )
plt.xlim( 0, len( ref ) )
ax = plt.gca()
ax.set_facecolor( 'tab:gray' )

#if( ref.max() > err.max() ):
max = ref.max()
#else:
#        max = err.max()

#if( ref.min() < err.min() ):
min = ref.min()
#else:
#        min = err.min()

plt.yticks( np.arange( min.round( -1 ), max, step = step ) )

plt.show()
