/*****************************************************************
Name:             SAMPLE5.C

Description:

    OPTOTRAK Sample Program #5.
    1.  Load the system of transputers with the appropriate
        transputer programs.
    2.  Initiate communications with the transputer system.
    3.  Load the appropriate camera parameters.
    4.  Set up an OPTOTRAK collection.
    5.  Activate the IRED markers.
    6.  Initialize a data file for spooling OPTOTRAK data.
    7.  Start the OPTOTRAK spooling raw sensor data.
    8.  Spool raw data to file while at the same time request
        and display real-time 3D data.
    9.  De-activate the markers.
    10. Disconnect the PC application program from the transputer
        system.

*****************************************************************/

/*****************************************************************
C Library Files Included
*****************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*****************************************************************
ND Library Files Included
*****************************************************************/
#include "ndtypes.h"
#include "ndpack.h"
#include "ndopto.h"

#ifdef _MSC_VER
void sleep( unsigned int uSec );
#elif __BORLANDC__
#include <dos.h>
#elif __WATCOMC__
#include <dos.h>
#endif

/*****************************************************************
Defines:
*****************************************************************/

#define NUM_MARKERS     6

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
        uMarkerCnt,
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
            NUM_MARKERS,    /* Number of markers in the collection. */
            (float)50.0,    /* Frequency to collect data frames at. */
            (float)2500.0,  /* Marker frequency for marker maximum on-time. */
            30,             /* Dynamic or Static Threshold value to use. */
            160,            /* Minimum gain code amplification to use. */
            1,              /* Stream mode for the data buffers. */
            (float)0.4,     /* Marker Duty Cycle to use. */
            (float)7.5,     /* Voltage to use when turning on markers. */
            (float)4.0,     /* Number of seconds of data to collect. */
            (float)0.0,     /* Number of seconds to pre-trigger data by. */
            OPTOTRAK_BUFFER_RAW_FLAG | OPTOTRAK_GET_NEXT_FRAME_FLAG ) )
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Wait one second to let the camera adjust.
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
     * Initialize the necessary spooling variables and a file for spooling
     * of the OPTOTRAK data.
     */
    uSpoolStatus       =
    uSpoolComplete     =
    uRealtimeDataReady = 0;
    if( DataBufferInitializeFile( OPTOTRAK, "R#001.S05" ) )
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Start the OPTOTRAK spooling data to us.
     */
    if( DataBufferStart() )
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Request a frame of realtime 3D data.
     */
    if( RequestLatest3D() )
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Loop around spooling data to file and displaying realtime 3d data.
     */
    do
    {
        /*
         * Write data if there is any to write.
         */
        if( DataBufferWriteData( &uRealtimeDataReady, &uSpoolComplete,
                                 &uSpoolStatus, NULL ) )
        {
            goto ERROR_EXIT;
        } /* if */

        /*
         * Display realtime if there is any to display.
         */
        if( uRealtimeDataReady )
        {
            /*
             * Receive the 3D data.
             */
            if( DataReceiveLatest3D( &uFrameNumber, &uElements, &uFlags,
                                     p3dData ) )
            {
                goto ERROR_EXIT;
            } /* if */

            /*
             * Print out 3D data.
             */
            fprintf( stdout, "Frame Number: %8u\n", uFrameNumber );
            fprintf( stdout, "Elements    : %8u\n", uElements );
            fprintf( stdout, "Flags       : 0x%04x\n", uFlags );
            for( uMarkerCnt = 0; uMarkerCnt < NUM_MARKERS; ++uMarkerCnt )
            {
                fprintf( stdout, "Marker %u X %f Y %f Z %f\n",
                         uMarkerCnt + 1,
                         p3dData[ uMarkerCnt].x,
                         p3dData[ uMarkerCnt].y,
                         p3dData[ uMarkerCnt].z );
            } /* for */

            /*
             * Request a new frame of realtime 3D data.
             */
            if( RequestLatest3D() )
            {
                goto ERROR_EXIT;
            } /* if */
            uRealtimeDataReady = 0;
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
