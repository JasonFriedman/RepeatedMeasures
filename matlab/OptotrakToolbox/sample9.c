/*****************************************************************
Name:             SAMPLE9.C

Description:

    OPTOTRAK Sample Program #9.

    1.  Load the system of transputers with the appropriate
        transputer programs.
    2.  Initiate communications with the transputer system.
    3.  Set the optional processing flags to do on-host 3D conversions
        and 6D transformations.
    4.  Load the appropriate camera parameters.
    5.  Set up an OPTOTRAK collection.
    6.  Add a rigid body to the OPTOTRAK System tracking list
        using a .RIG file.
    7.  Activate the IRED markers.
    8.  Request/receive/display 10 frames of rigid body transformations.
    9.  De-activate the IRED markers.
   10.  Disconnect the PC application program from the transputer
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

/*
 * Constants for identifying the rigid bodies.
 */
#define NUM_RIGID_BODIES    1
#define RIGID_BODY_ID       0

/*****************************************************************
Static Structures and Types:
*****************************************************************/

/*
 * Type definition to retrieve and access rigid body transformation
 * data.
 */
typedef struct RigidBodyDataStruct
{
    struct OptotrakRigidStruct  pRigidData[ NUM_RIGID_BODIES];
    Position3d                  p3dData[ NUM_MARKERS];
} RigidBodyDataType;

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
        uRigidCnt,
        uFrameNumber;
    RigidBodyDataType
        RigidBodyData;
    char
        szNDErrorString[MAX_ERROR_STRING_LENGTH + 1];

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
     * Add a rigid body for tracking to the OPTOTRAK system from a .RIG file.
     */
    if( RigidBodyAddFromFile(
            RIGID_BODY_ID,  /* ID associated with this rigid body.*/
            1,              /* First marker in the rigid body.*/
            "plate",        /* RIG file containing rigid body coordinates.*/
            0 ) )           /* Flags. */
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
     * Get and display ten frames of rigid body data.
     */
    fprintf( stdout, "Rigid Body Data Display\n" );
    for( uFrameCnt = 0; uFrameCnt < 10; ++uFrameCnt )
    {
        /*
         * Get a frame of data.
         */
        if( DataGetLatestTransforms( &uFrameNumber, &uElements, &uFlags,
                                     &RigidBodyData ) )
        {
            goto ERROR_EXIT;
        } /* if */

        /*
         * Check the returned flags member for improper transforms.
         */
        if( RigidBodyData.pRigidData->flags & OPTOTRAK_UNDETERMINED_FLAG )
        {
            fprintf( stdout, "\nUndetermined transform!" );
            if( RigidBodyData.pRigidData->flags & OPTOTRAK_RIGID_ERR_MKR_SPREAD )
            {
                fprintf( stdout, " Marker spread error." );
            } /* if */
            continue;
        } /* if */

        /*
         * Print out the valid data.
         */
        fprintf( stdout, "\n" );
        fprintf( stdout, "Frame Number: %8u\n", uFrameNumber );
        fprintf( stdout, "Transforms  : %8u\n", uElements );
        fprintf( stdout, "Flags       :   0x%04x\n", uFlags );
        for( uRigidCnt = 0; uRigidCnt < uElements; ++uRigidCnt )
        {
            fprintf( stdout, "Rigid Body %u\n",
                     RigidBodyData.pRigidData[ uRigidCnt].RigidId );
            fprintf( stdout, "XT = %8.2f YT = %8.2f ZT = %8.2f\n",
                     RigidBodyData.pRigidData[ uRigidCnt].transformation.
                         euler.translation.x,
                     RigidBodyData.pRigidData[ uRigidCnt].transformation.
                         euler.translation.y,
                     RigidBodyData.pRigidData[ uRigidCnt].transformation.
                         euler.translation.z );
            fprintf( stdout, "Y  = %8.2f P  = %8.2f R  = %8.2f\n",
                     RigidBodyData.pRigidData[ uRigidCnt].transformation.
                         euler.rotation.yaw,
                     RigidBodyData.pRigidData[ uRigidCnt].transformation.
                         euler.rotation.pitch,
                     RigidBodyData.pRigidData[ uRigidCnt].transformation.
                         euler.rotation.roll );
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
