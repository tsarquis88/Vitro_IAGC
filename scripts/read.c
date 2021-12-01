#include <stdio.h>
#include <signal.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <math.h>

#define RECEPTION_SIZE 7

int sigint;

void
sig_term_handler( int signum, siginfo_t *info, void *ptr )
{
    sigint = 1;
}

float
fixedpoint_to_decimal( int fix_as_int )
{
	float fix_as_float;
	int i, j, bin[ 8 ];

	fix_as_float = 0.0;

	for( i = 0; i < 8; i++ )
		bin[ i ] = 0;

	for( i = 0; fix_as_int > 0; i++ )
	{
		bin[ i ]   = fix_as_int % 2;
		fix_as_int = fix_as_int / 2;
	}

	for( j = 0; j < 8; j++ )
		fix_as_float = fix_as_float + bin[ 7 - j ] * pow( 2, -( j + 1 ) );

	return fix_as_float;
}

int
main( int argc, char **argv )
{
	if( argc <= 1 )
	{
		printf( "Uso %s <dispositivo>\n", argv[ 0 ] );
		return 0;
	}

	sigint = 0;

	static struct sigaction _sigact;
    	memset(&_sigact, 0, sizeof(_sigact));
    	_sigact.sa_sigaction = sig_term_handler;
	_sigact.sa_flags = SA_SIGINFO;
	sigaction(SIGINT, &_sigact, NULL);

	FILE *device;
	int  counter;

	init:
	device  = fopen( argv[ 1 ], "r" );
	counter = 0;
	if( device == NULL )
	{
		perror( "" );
		return 0;
	}

	while( sigint == 0 )
	{
		uint8_t buffer, i, ok;
		int reception[ RECEPTION_SIZE ];

		for( i = 0; i < RECEPTION_SIZE; i++ )
		{
			if( fread( ( void* ) &buffer, sizeof( buffer ), 1, device ) )
				reception[ i ] = ( int ) buffer;
			else
				break;
		}

		if( i == RECEPTION_SIZE && reception[ 1 ] < 32 && reception[ 3 ] < 32 && reception[ 4 ] < 3 )
		{
			int   ref_amp, err_amp, quotient, fractional;
			float ref_vol, err_vol, relation;
			char  on_phase[ 3 ];

			ref_amp    = reception[ 0 ] + ( reception[ 1 ] << 8 );
			err_amp    = reception[ 2 ] + ( reception[ 3 ] << 8 );
			ref_vol    = ( float ) ref_amp * 0.13e-3;
			err_vol    = ( float ) err_amp * 0.13e-3;
			quotient   = reception[ 4 ];
			fractional = reception[ 5 ];
			relation   = quotient + fixedpoint_to_decimal( fractional );

			if( reception[ 6 ] )
				sprintf( on_phase, "%s", "SI" );
			else
				sprintf( on_phase, "%s", "NO" );

			printf( "REFERENCIA = %d (%0.3f [V]) | ERROR = %d (%0.3f [V]) | RELACION = %0.3f | EN FASE: %s\n",
				ref_amp, ref_vol, err_amp, err_vol, relation, on_phase );
		}
		else
		{
			if( sigint == 0 )
			{
				printf( "ERROR EN LA RECEPCION\n" );
				fclose( device );
				usleep( 250000 );
				goto init;
			}
		}

		if( counter > 10 )
		{
			fclose( device );
			usleep( 250000 );
			goto init;
		}

		counter++;
	}

	fclose( device );

	return 0;
}
