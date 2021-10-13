import numpy as np
import matplotlib.pyplot as plt

limit = 10000

ref_l = np.loadtxt( 'ref_l.txt' )
ref_h = np.loadtxt( 'ref_h.txt' )

print( "Tamaño de ref_l: " + str( len( ref_l ) ) )
print( "Tamaño de ref_h: " + str( len( ref_h ) ) )

if( len( ref_l ) < len( ref_h ) ):
	ref_len = len( ref_l )
else:
	ref_len = len( ref_h )

if( ref_len > limit ):
	ref_len = limit;

ref   = np.zeros( ref_len )

i = 0
end = ref_len;
while i < ref_len:
    ref[ i ] = ref_l[ i ] + ref_h[ i ] * 256
    if( ref[ i ] == 0 ):
       end = i - 1;
       i = ref_len;
    else:
        i += 1

# labels
title   = 'ADC1410 IF samples'
xlabel  = 'Sample'
ylabel  = 'Amplitude'

# fonts
title_font = { 'weight': 'light', 'size': 36, }
axis_font  = { 'weight': 'bold', 'size': 10, }

# Y axis step
step = 500

plt.figure( figsize = ( 16, 8 ) )
plt.plot( ref, 'b', label = 'Reference signal' )
# plt.plot( err, 'r', label = 'Error signal' )
plt.xlabel( xlabel, axis_font )
plt.ylabel( ylabel, axis_font )
plt.legend()
plt.title( title, fontdict = title_font )
plt.grid( 'black' )
plt.xlim( 0, end )
plt.ylim( 4000, 13000 )
ax = plt.gca()
ax.set_facecolor( 'tab:gray' )

plt.yticks( np.arange( 3500, 12500, step = step ) )

plt.show()
