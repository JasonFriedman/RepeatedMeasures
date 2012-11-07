/*****************************************************************
Name:             SAMPLE8.C

Description:

    OPTOTRAK Sample Program #8.

    1.  Load the system of transputers with the appropriate
        transputer programs.
    2.  Initiate communications with the transputer system.
    3.  Load the appropriate camera parameters.
    4.  Set up an OPTOTRAK collection.
    5.  Activate the IRED markers.
    6.  Initialize a file for spooling OPTOTRAK raw data.
    7.  Spool the OPTOTRAK raw data to file.
    8.  De-activate the IRED markers.
    9.  Convert the OPTOTRAK raw data file to a 3D data file.
    10. Disconnect the PC application program from the transputer
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
#define COLLECTION_TIME (float)5.0

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
        uSpoolStatus = 0;
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
            OPTOTRAK_BUFFER_RAW_FLAG ) )
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Activate the markers.
     */
    if( OptotrakActivateMarkers() )
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Initialize a file for spooling of the OPTOTRAK raw data.
     */
    if( DataBufferInitializeFile( OPTOTRAK, "R#001.S08" ) )
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Spool data to the previously initialized file.
     */
    fprintf( stdout, "Collecting data file...\n" );
    if( DataBufferSpoolData( &uSpoolStatus ) )
    {
        goto ERROR_EXIT;
    } /* if */
    fprintf( stdout, "Spool Status: 0x%04x\n", uSpoolStatus );

    /*
     * De-activate the markers.
     */
    if( OptotrakDeActivateMarkers() )
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Convert the raw data in the file 'R#001.S08' and write the
     * 3D data to the file 'C#001.S08'.
     */
    fprintf( stdout, "Converting OPTOTRAK raw data file...\n" );
    if( FileConvert( "R#001.S08", "C#001.S08", OPTOTRAK_RAW ) )
    {
        goto ERROR_EXIT;
    } /* if */
    fprintf( stdout, "File conversion complete.\n" );

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
