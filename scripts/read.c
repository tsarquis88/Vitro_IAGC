#include <stdio.h>
#include <signal.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int sigint;

void
sig_term_handler( int signum, siginfo_t *info, void *ptr )
{
    sigint = 1;
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

	init:
	device = fopen( argv[ 1 ], "r" );
	if( device == NULL )
	{
		perror( "" );
		return 0;
	}

	while( sigint == 0 )
	{
		uint8_t buffer, i, ok;
		int reception[ 5 ];

		for( i = 0; i < 4; i++ )
		{
			if( fread( ( void* ) &buffer, sizeof( buffer ), 1, device ) )
				reception[ i ] = ( int ) buffer;
			else
				break;
		}

		if( i == 4 && reception[ 1 ] < 32 && reception[ 3 ] < 32 )
		{	
			char space[ 32 ];
			int spaces, ref_amp, err_amp, rel;
			float ref_vol, err_vol;

			ref_amp = reception[ 0 ] + ( reception[ 1 ] << 8 ); 
			err_amp = reception[ 2 ] + ( reception[ 3 ] << 8 );
			ref_vol = ( float ) ref_amp * 0.13e-3;
			err_vol = ( float ) err_amp * 0.13e-3;

			if( ref_amp >= 1000 )
				spaces = 1;
			else if( ref_amp >= 100 )
				spaces = 2;
			else if( ref_amp >= 10 )
				spaces = 3;
			else
				spaces = 4;

			for( i = 0; i < spaces; i++ )
				space[ i ] = ' ';
			space[ spaces ] = '\0';

			printf( "REFERENCIA = %d (%0.3f [V])%s| ERROR = %d (%0.3f [V])\n", ref_amp, ref_vol, space, err_amp, err_vol );
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
	}

	fclose( device );

	return 0;
}
