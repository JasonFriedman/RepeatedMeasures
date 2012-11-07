/*****************************************************************
Name:             SAMPLE2.C

Description:

    OPTOTRAK Sample Program #2.

    1.  Load the system of transputers with the appropriate
        transputer programs.
    2.  Initiate communications with the transputer system.
    3.  Set the optional processing flags to do the 3D conversions
        on the host computer.
    4.  Load the appropriate camera parameters.
    5.  Set up an OPTOTRAK collection.
    6.  Activate the IRED markers.
    7.  Request/receive/display 10 frames of real-time 3D data.
    8.  De-activate the markers.
    9.  Disconnect the PC application program from the transputer
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
Defines:
*****************************************************************/

#define NUM_SENSORS 3
#define NUM_MARKERS 6

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
        uFrameCnt,
        uMarkerCnt,
        uFrameNumber;
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
     * Set optional processing flags (this overides the settings in OPTOTRAK.INI).
     */
    if( OptotrakSetProcessingFlags( OPTO_LIB_POLL_REAL_DATA |
                                    OPTO_CONVERT_ON_HOST |
                                    OPTO_RIGID_ON_HOST ) )
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
            (float)100.0,   /* Frequency to collect data frames at. */
            (float)2500.0,  /* Marker frequency for marker maximum on-time. */
            30,             /* Dynamic or Static Threshold value to use. */
            160,            /* Minimum gain code amplification to use. */
            0,              /* Stream mode for the data buffers. */
            (float)0.35,    /* Marker Duty Cycle to use. */
            (float)7.0,     /* Voltage to use when turning on markers. */
            (float)1.0,     /* Number of seconds of data to collect. */
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
     * Get and display ten frames of 3D data.
     */
    fprintf( stdout, "\n\n3D Data Display\n" );
    for( uFrameCnt = 0; uFrameCnt < 10; ++uFrameCnt )
    {
        /*
         * Get a frame of data.
         */
        fprintf( stdout, "\n" );
        if( DataGetLatest3D( &uFrameNumber, &uElements, &uFlags, p3dData ) )
        {
            goto ERROR_EXIT;
        } /* if */

        /*
         * Print out the data.
         */
        fprintf( stdout, "Frame Number: %8u\n", uFrameNumber );
        fprintf( stdout, "Elements    : %8u\n", uElements );
        fprintf( stdout, "Flags       : 0x%04x\n", uFlags );
        for( uMarkerCnt = 0; uMarkerCnt < 6; ++uMarkerCnt )
        {
            fprintf( stdout, "Marker %u X %f Y %f Z %f\n", uMarkerCnt + 1,
                     p3dData[ uMarkerCnt].x, p3dData[ uMarkerCnt].y,
                     p3dData[ uMarkerCnt].z );
        } /* for */
    } /* for */

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
