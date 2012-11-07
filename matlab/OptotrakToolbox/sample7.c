/*****************************************************************
Name:             SAMPLE7.C

Description:

    OPTOTRAK Sample Program #7.
    1.  Load the system of transputers with the appropriate
        transputer programs.
    2.  Initiate communications with the transputer system.
    3.  Load the appropriate camera parameters.
    4.  Set up an OPTOTRAK collection.
    5.  Activate the IRED markers.
    6.  Initialize a file for spooling OPTOTRAK 3D data.
    7.  Start the OPTOTRAK spooling when Marker 1 is seen.
    8.  Spool 3D data to file while at the same time requesting and
        examining 3D data.
    9.  Stop the spool once Marker 1 goes out of view or after 100
        seconds of data has been spooled.
    10. De-activate the markers.
    11. Disconnect the PC application program from the transputer
        system.

*****************************************************************/

/*****************************************************************
C Library Files Included
*****************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
Defines:
*****************************************************************/

#define NUM_MARKERS     6
#define FRAME_RATE      (float)50.0
#define COLLECTION_TIME (float)100.0

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
    unsigned int
        uFlags,
        uElements,
        uFrameNumber,
        uSpoolStatus,
        uSpoolComplete,
        uRealtimeDataReady;
    static Position3d
        p3dData[ NUM_MARKERS];
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
    if( TransputerInitializeSystem( OPTO_LOG_ERRORS_FLAG ) )
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
     * Set up a collection for the OPTOTRAK.
     */
    if( OptotrakSetupCollection(
            NUM_MARKERS,        /* Number of markers in the collection. */
            FRAME_RATE,         /* Frequency to collect data frames at. */
            (float)2500.0,      /* Marker frequency for marker maximum on-time. */
            30,                 /* Dynamic or Static Threshold value to use. */
            160,                /* Minimum gain code amplification to use. */
            1,                  /* Stream mode for the data buffers. */
            (float)0.4,         /* Marker Duty Cycle to use. */
            (float)7.5,         /* Voltage to use when turning on markers. */
            COLLECTION_TIME,    /* Number of seconds of data to collect. */
            (float)0.0,         /* Number of seconds to pre-trigger data by. */
            0 ) )
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Wait one second to let the collection finish setting up.
     */
    sleep( 1 );

    /*
     * Activate the markers.
     */
    if( OptotrakActivateMarkers() )
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Initialize a file for spooling of the OPTOTRAK 3D data.
     */
    if( DataBufferInitializeFile( OPTOTRAK, "C#001.S07" ) )
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Initialize the necessary spooling variables and a file for spooling
     * of the OPTOTRAK data.
     */
    uSpoolStatus       =
    uSpoolComplete     =
    uRealtimeDataReady = 0;

    /*
     * Loop until marker 1 comes into view.
     */
    fprintf( stdout, "Waiting for marker 1...\n" );
    do
    {
        /*
         * Get a frame of 3D data.
         */
        if( DataGetLatest3D( &uFrameNumber, &uElements, &uFlags, p3dData ) )
        {
            goto ERROR_EXIT;
        } /* if */
    } /* do */
    while( p3dData[ 0].x < MAX_NEGATIVE );

    /*
     * Start the OPTOTRAK spooling data to us.
     */
    if( DataBufferStart() )
    {
        goto ERROR_EXIT;
    } /* if */
    fprintf( stdout, "Collecting data file...\n" );

    /*
     * Loop around spooling data to file until marker 1 goes out of view.
     */
    do
    {
        /*
         * Get a frame of 3D data.
         */
        if( DataGetLatest3D( &uFrameNumber, &uElements, &uFlags, p3dData ) )
        {
            goto ERROR_EXIT;
        } /* if */

        /*
         * Check to see if marker 1 is out of view and stop the OPTOTRAK from
         * spooling data if this is the case.
         */
        if( p3dData[ 0].x < MAX_NEGATIVE )
        {
            if( DataBufferStop() )
            {
                goto ERROR_EXIT;
            } /* if */
        } /* if */

        /*
         * Write data if there is any to write.
         */
        if( DataBufferWriteData( &uRealtimeDataReady, &uSpoolComplete,
                                 &uSpoolStatus, NULL ) )
        {
            goto ERROR_EXIT;
        } /* if */
    } /* do */
    while( !uSpoolComplete );

    fprintf( stdout, "Spool Status: 0x%04x\n", uSpoolStatus );

    /*
     * De-activate the markers.
     */
    if( OptotrakDeActivateMarkers() )
    {
        goto ERROR_EXIT;
    } /* if */

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
    OptotrakDeActivateMarkers();
    TransputerShutdownSystem();
    exit( 1 );

} /* main */
