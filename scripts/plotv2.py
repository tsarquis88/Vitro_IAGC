import numpy as np
import matplotlib.pyplot as plt

# sample limit
limit = 10000

# file load
ref_l = np.loadtxt( 'ref_l.txt' )
ref_h = np.loadtxt( 'ref_h.txt' )

# size print
print( "Tamaño de ref_l: " + str( len( ref_l ) ) )
print( "Tamaño de ref_h: " + str( len( ref_h ) ) )

# data parse
if( len( ref_h ) > len( ref_l ) ):
	len = len( ref_l )
else:
	len = len( ref_h )

i = 0
ref_H = np.zeros( len )
ref_L = np.zeros( len )
ref   = np.zeros( len )
while i < len:
    ref_H[ i ] = ref_h[ i ] * 256
    ref_L[ i ] = ref_l[ i ] + 8192 - 64
    ref[ i ]   = ref_H[ i ] + ref_L[ i ] - 8192
    i += 1

# labels
title   = 'ADC1410 IF samples'
xlabel  = 'Sample'
ylabel  = 'Amplitude'

# fonts
title_font = { 'weight': 'light', 'size': 36, }
axis_font  = { 'weight': 'bold', 'size': 10, }

# Y axis step
step = ref_H.max() / 30

plt.figure( figsize = ( 16, 8 ) )
plt.plot( ref, 'y', label = 'efdrence signal' )
plt.plot( ref_H, 'b', label = 'Reference signal' )
plt.plot( ref_L, 'r', label = 'eference signal' )
plt.xlabel( xlabel, axis_font )
plt.ylabel( ylabel, axis_font )
plt.legend()
plt.title( title, fontdict = title_font )
plt.grid( 'black' )
plt.xlim( 0, len )
plt.ylim( ref_H.min() - 100, ref_H.max() + 100 )
ax = plt.gca()
ax.set_facecolor( 'tab:gray' )

max = ref_H.max()
min = ref_H.min()

plt.yticks( np.arange( min.round( -1 ), max, step = step ) )

plt.show()
