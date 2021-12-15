#include <stdio.h>
#include <signal.h>
#include <stdint.h>
#include <string.h>

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
		printf( "Usage %s <device>\n", argv[ 0 ] );
		return 0;
	}

	sigint = 0;

	static struct sigaction _sigact;
    	memset(&_sigact, 0, sizeof(_sigact));
    	_sigact.sa_sigaction = sig_term_handler;
	_sigact.sa_flags = SA_SIGINFO;
	sigaction(SIGINT, &_sigact, NULL);

	FILE *device;

	device = fopen( argv[ 1 ], "r" );
	if( device == NULL )
	{
		perror( "" );
		return 0;
	}

	while( sigint == 0 )
	{
		uint8_t buffer;

		if( fread( ( void* ) &buffer, sizeof( buffer ), 1, device ) )
			printf( "%d\n", buffer );

	}

	fclose( device );

	return 0;
}
