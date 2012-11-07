/*****************************************************************
Name:             SAMPLE20.C

Description:

    OPTOTRAK Sample Program #20.

    1.  Determine the system configuration and generate the
        external NIF configuration file, system.nif.
    2.  Load the system of transputers with the appropriate
        transputer programs based on the external file,
        system.nif.
    3.  Initiate communications with the transputer system.
    4.  Disconnect the PC application program from the transputer
        system.
    5.  Set the API to use the internally generated and stored
        system NIF configuration.
    6.  Determine the system configuration and store the
        NIF information internally.
    7.  Load the system of transputers with the appropriate
        transputer programs based on the internal NIF configuration.
    8.  Initiate communications again with the transputer system.
    9.  Disconnect the PC application program from the transputer
        system again.

*****************************************************************/

/*****************************************************************
C Library Files Included
*****************************************************************/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#ifdef _MSC_VER
void sleep( unsigned int uSec );
#elif __BORLANDC__
#include <dos.h>
extern unsigned _stklen = 16000;
#elif __WATCOMC__
#include <dos.h>
#endif

/*****************************************************************
ND Library Files Included
*****************************************************************/
#include "ndtypes.h"
#include "ndpack.h"
#include "ndopto.h"

/*****************************************************************
Name:               main

Input Values:
    int
        argc        :Number of command line parameters.
    unsigned char
        *argv[]     :Pointer array to each parameter.

Output Values:
    None.

Return Value:
    None.

Description:

    Main program routine performs all steps listed in the above
    program description.

*****************************************************************/
void main( int argc, unsigned char *argv[] )
{
    char
        pszLogFileName[] = "CfgLog.txt",
        szNDErrorString[MAX_ERROR_STRING_LENGTH + 1];

    /*
     * Determine the system configuration in the default manner
     * without any error logging. This writes the file system.nif
     * in the standard ndigital directory.
     */
    fprintf( stdout, "Determining system configuration using system.nif.\n" );
    if( TransputerDetermineSystemCfg( NULL ) )
    {
        fprintf( stderr, "Error in determining the system parameters.\n" );
        goto ERROR_EXIT;
    } /* if */

    /*
     * Load the system of transputers using the file system.nif.
     */
    fprintf( stdout, "Loading & initializing transputer system...\n" );
    if( TransputerLoadSystem( NULL ) )
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Wait one second to let the system finish loading.
     */
    sleep( 1 );

    /*
     * Initialize the transputer system.
     */
    if( TransputerInitializeSystem( OPTO_LOG_ERRORS_FLAG ) )
    {
        goto ERROR_EXIT;
    } /* if */
    sleep( 1 );

    /*
     * Shutdown the transputer message passing system.
     */
    TransputerShutdownSystem();

   /*
    * Set the API to use internal storage for the system
    * configuration.
    */
    fprintf( stdout,
             "\nDetermining system configuration using internal strings.\n" );
    OptotrakSetProcessingFlags( OPTO_USE_INTERNAL_NIF );

    /*
     * Determine the system configuration again, but this time
     * with error logging.
     */
    if( TransputerDetermineSystemCfg( pszLogFileName ) )
    {
        fprintf( stderr, "Error in determining the system parameters.\n" );
        goto ERROR_EXIT;
    }

    /*
     * Load the system of transputers - the null string defaults to the
     * internal NIF configuration.
     */
    fprintf( stdout, "Loading & initializing transputer system...\n" );
    if( TransputerLoadSystem( NULL ) )
    {
        goto ERROR_EXIT;
    } /* if */
    sleep( 1 );

    /*
     * Initialize the transputer system again in the usual manner.
     */
    if( TransputerInitializeSystem( OPTO_LOG_ERRORS_FLAG ) )
    {
        goto ERROR_EXIT;
    } /* if */
    sleep( 1 );

    /*
     * Shutdown the transputer message passing system.
     */
    if( TransputerShutdownSystem() )
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Exit the program.
     */
    fprintf( stdout, "\nProgram execution complete.\n" );
    exit( 0 );

ERROR_EXIT:
    if( OptotrakGetErrorString( szNDErrorString,
                                MAX_ERROR_STRING_LENGTH + 1 ) == 0 )
    {
        fprintf( stdout, szNDErrorString );
    } /* if */
    TransputerShutdownSystem();
    exit( 1 );
}
