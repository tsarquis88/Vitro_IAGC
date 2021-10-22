import numpy as np
import matplotlib.pyplot as plt

###
### CHEQUEO DE ERRORES EN ENVIO
###

reception = np.loadtxt( 'ref.txt' )

i       = 2
j		= 0
repairs = 0
broken  = 0
err 	= 0
rec_len = len( reception )

ref = np.zeros( round( rec_len / 3 ) )

print( "Inicio de chequeo y reparacion" )

print( "Longitud de recepcion: " + str( rec_len ) )

while i < rec_len:
    if( reception[ i ] != 255 ):
        broken = 1
        if( reception[ i + 1 ] == 255 ):
            repairs = repairs + 1
            i       = i + 1
        elif( reception[ i + 2 ] == 255 ):
            repairs = repairs + 1
            i       = i + 2
        elif( reception[ i + 3 ] == 255 ):
            repairs = repairs + 1
            i       = i + 3
        else:
            err = 1
            break
    else:
        if( broken == 0 ):
            ref[ j ] =  reception[ i - 2 ] * 256 + reception[ i - 1 ]
            j = j + 1
        broken = 0
        i = i + 3

if( err ):
	print( "Error en etapa de chequeo" )
	exit

print( "Chequeo terminado: " + str( repairs ) + " tramas borradas debido a error" )

###
### PLOTEO DE RECEPCION
###

print( "Iniciando ploteo de recepcion" )

ref_len	= j - 1
max 	= ref.max()
min 	= ref.min()

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
plt.xlim( 0, ref_len )
plt.ylim( 4000, 13000 )
ax = plt.gca()
ax.set_facecolor( 'tab:gray' )

plt.yticks( np.arange( 4000, 13000, step = step ) )

plt.show()
