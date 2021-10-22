import numpy as np

ref = np.loadtxt( 'ref.txt' )

print( "Tamaño de ref: " + str( len( ref ) ) )

i       = 2
repairs = 0
broken  = 0

ref_file = open( 'ref_repaired.txt', 'w' )

while i < len( ref ):
    if( ref[ i ] != 255 ):
        broken = 1
        if( ref[ i + 1 ] == 255 ):
            repairs = repairs + 1
            i       = i + 1
        elif( ref[ i + 2 ] == 255 ):
            repairs = repairs + 1
            i       = i + 2
        elif( ref[ i + 3 ] == 255 ):
            repairs = repairs + 1
            i       = i + 3
        else:
            print( "Irrecuperable" )
            break
    else:
        if( broken == 0 ):
            ref_file.write( str( round( ref[ i - 2 ] ) ) + '\n' + str( round( ref[ i - 1 ] ) ) + '\n' )
        broken = 0
        i = i + 3

ref_file.close()

print( "Reparaciones: " + str( repairs ) )