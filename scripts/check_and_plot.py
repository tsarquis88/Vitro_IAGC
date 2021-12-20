import numpy as np
import matplotlib.pyplot as plt
from os.path import exists

###
### CHEQUEO DE ERRORES EN ENVIO REF
###

ref_exists = exists( 'ref.txt' )

if ref_exists:
	ref_raw = np.loadtxt( 'ref.txt' )

	i       	= 2
	j		= 0
	repairs 	= 0
	broken  	= 0
	error 		= 0
	ref_raw_len 	= len( ref_raw )

	ref = np.zeros( round( ref_raw_len / 3 ) )

	print( "Inicio de chequeo y reparacion" )

	print( "Longitud de recepcion (ref): " + str( ref_raw_len ) )

	while i < ref_raw_len:
	    if( ref_raw[ i ] != 255 ):
	        broken = 1
	        if( ref_raw[ i + 1 ] == 255 ):
	            repairs = repairs + 1
	            i       = i + 1
	        elif( ref_raw[ i + 2 ] == 255 ):
	            repairs = repairs + 1
	            i       = i + 2
	        elif( ref_raw[ i + 3 ] == 255 ):
	            repairs = repairs + 1
	            i       = i + 3
	        else:
	            error = 1
	            break
	    else:
	        if( broken == 0 ):
                    ref[ j ] = ref_raw[ i - 2 ] * 256 + ref_raw[ i - 1 ]
                    if( ref[ j ] >= ( 1 << 15 ) ):
                        ref[ j ] = ref[ j ] - ( 1 << 16 )
                    j = j + 1
	        broken = 0
	        i = i + 3

	if( error ):
		print( "Error en etapa de chequeo" )
		exit

	print( "Chequeo terminado: " + str( repairs ) + " tramas borradas debido a error" )
else:
	print( "Ref.txt no existe" )


###
### CHEQUEO DE ERRORES EN ENVIO ERR
###

err_exists = exists( 'err.txt' )

if( err_exists ):
	err_raw = np.loadtxt( 'err.txt' )

	i       	= 2
	j		= 0
	repairs 	= 0
	broken  	= 0
	error 		= 0
	err_raw_len 	= len( err_raw )

	err = np.zeros( round( err_raw_len / 3 ) )

	print( "Inicio de chequeo y reparacion" )

	print( "Longitud de recepcion: " + str( err_raw_len ) )

	while i < err_raw_len:
	    if( err_raw[ i ] != 255 ):
	        broken = 1
	        if( err_raw[ i + 1 ] == 255 ):
	            repairs = repairs + 1
	            i       = i + 1
	        elif( err_raw[ i + 2 ] == 255 ):
	            repairs = repairs + 1
	            i       = i + 2
	        elif( err_raw[ i + 3 ] == 255 ):
	            repairs = repairs + 1
	            i       = i + 3
	        else:
	            error = 1
	            break
	    else:
                if( broken == 0 ):
                    err[ j ] = err_raw[ i - 2 ] * 256 + err_raw[ i - 1 ]
                    if( err[ j ] >= ( 1 << 15 ) ):
                        err[ j ] = err[ j ] - ( 1 << 16 )
                    j = j + 1
                broken = 0
                i = i + 3

	if( error ):
		print( "Error en etapa de chequeo" )
		exit

	print( "Chequeo terminado: " + str( repairs ) + " tramas borradas debido a error" )
else:
	print( "Err.txt no existe" )

###
### PLOTEO DE RECEPCION
###

if ref_exists:
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
	step = 1000

	plt.figure( figsize = ( 16, 8 ) )
	plt.plot( ref, 'b', label = 'Reference signal' )
	if err_exists:
		plt.plot( err, 'r', label = 'Error signal' )
	plt.xlabel( xlabel, axis_font )
	plt.ylabel( ylabel, axis_font )
	plt.legend()
	plt.title( title, fontdict = title_font )
	plt.grid( 'black' )
	# plt.xlim( 0, ref_len )
	# plt.ylim( 4000, 13000 )
	ax = plt.gca()
	ax.set_facecolor( 'tab:gray' )

	plt.yticks( np.arange( -9000, 9000, step = step ) )

	plt.show()
