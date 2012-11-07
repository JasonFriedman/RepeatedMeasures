/*****************************************************************
Name:             SAMPLE1.C

Description:

    OPTOTRAK Sample Program #1.

    1.  Load the system of transputers with the appropriate
        transputer programs.
    2.  Initiate communications with the transputer system.
    3.  Load the appropriate camera parameters.
    4.  Request/receive/display the current OPTOTRAK system status.
        Pass NULL for those status variables that are not
        requested.
    5.  Disconnect the PC application program from the transputer
        system.

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
    int
        nNumSensors,
        nNumOdaus,
        nMarkers;
    char
        szNDErrorString[MAX_ERROR_STRING_LENGTH + 1];

    /*
     * Load the system of transputers.
     */
    if( TransputerLoadSystem( "system" ) )
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
    if( TransputerInitializeSystem( OPTO_LOG_ERRORS_FLAG ))
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Load the standard camera parameters.
     */
    if( OptotrakLoadCameraParameters( "standard" ) )
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Request and receive the OPTOTRAK status.
     */
    if( OptotrakGetStatus(
            &nNumSensors,    /* Number of sensors in the OPTOTRAK system. */
            &nNumOdaus,      /* Number of ODAUs in the OPTOTRAK system. */
            NULL,            /* Number of rigid bodies being tracked by the O/T. */
            &nMarkers,       /* Number of markers in the collection. */
            NULL,            /* Frequency that data frames are being collected. */
            NULL,            /* Marker firing frequency. */
            NULL,            /* Dynamic or Static Threshold value being used. */
            NULL,            /* Minimum gain code amplification being used. */
            NULL,            /* Stream mode indication for the data buffers */
            NULL,            /* Marker Duty Cycle being used. */
            NULL,            /* Voltage being used when turning on markers. */
            NULL,            /* Number of seconds data is being collected. */
            NULL,            /* Number of seconds data is being pre-triggered. */
            NULL ) )         /* Configuration flags. */
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Display elements of the status received.
     */
    fprintf( stdout, "Sensors in system       :%3d\n", nNumSensors );
    fprintf( stdout, "ODAUs in system         :%3d\n", nNumOdaus );
    fprintf( stdout, "Default OPTOTRAK Markers:%3d\n", nMarkers );

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
} /* main */
