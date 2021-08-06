import numpy as np
import matplotlib.pyplot as plt

ref = np.loadtxt( 'ref.txt' )
err = np.loadtxt( 'err.txt' )

# labels
title   = 'ADC1410 IF samples'
xlabel  = 'Sample'
ylabel  = 'Amplitude [1/255]'

# fonts
title_font = { 'weight': 'light', 'size': 36, }
axis_font  = { 'weight': 'bold', 'size': 10, }

# Y axis step
step = 5

# Configuras el tamaño
plt.figure( figsize = ( 16, 8 ) )
plt.plot( ref, 'b', label = 'Reference signal' )
plt.plot( err, 'r', label = 'Error signal' )
plt.xlabel( xlabel, axis_font )
plt.ylabel( ylabel, axis_font )
plt.legend()
plt.title( title, fontdict = title_font )
plt.grid( 'black' )
plt.xlim( 0, len( err ) )
ax = plt.gca()
ax.set_facecolor( 'tab:gray' )

if( ref.max() > err.max() ):
        max = ref.max()
else:
        max = err.max()

if( ref.min() < err.min() ):
        min = ref.min()
else:
        min = err.min()

plt.yticks( np.arange( min.round( -1 ), max, step = step ) )

plt.show()
