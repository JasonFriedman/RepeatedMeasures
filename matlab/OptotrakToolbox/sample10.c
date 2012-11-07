/*****************************************************************
Name:             SAMPLE10.C

Description:

    OPTOTRAK Sample Program #10.

    1.  Load the system of transputers with the appropriate
        transputer programs.
    2.  Initiate communications with the transputer system.
    3.  Load the appropriate camera parameters.
    4.  Set up an OPTOTRAK collection.
    5.  Activate the IRED markers.
    6.  Add a rigid body to the OPTOTRAK System tracking list using
        a .RIG file.
    7.  Change the default settings for the rigid body just added.
    8.  Request/receive/display 10 frames of rigid body transforms
        in Quaternion format; also display the attached 3D marker
        position data.
    9.  De-activate the IRED markers.
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

/*
 * Constants for identifying the rigid bodies.
 */
#define RIGID_BODY_1        0
#define NUM_RIGID_BODIES    1

/*****************************************************************
Static Structures and Types:
*****************************************************************/


/*
 * Type definition to retreive and access rigid body transformation
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
        uMarkerCnt,
        uFrameNumber;
    RigidBodyDataType
        RigidBodyData;
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
     * Add rigid body 1 for tracking to the OPTOTRAK system from a .RIG file.
     */
    if( RigidBodyAddFromFile(
            RIGID_BODY_1,   /* ID associated with this rigid body. */
            1,              /* First marker in the rigid body.*/
            "plate",        /* RIG file containing rigid body coordinates.*/
            0 ) )           /* flags */
    {
        goto ERROR_EXIT;
    } /* if */

    /*
     * Change the default settings for this rigid body 1.
     */
    if( RigidBodyChangeSettings(
            RIGID_BODY_1,   /* ID associated with this rigid body. */
            4,              /* Minimum number of markers which must be seen
                               before performing rigid body calculations.*/
            60,             /* Cut off angle for marker inclusion in calcs.*/
            (float)0.25,    /* Maximum 3-D marker error for this rigid body. */
            (float)1.0,     /* Maximum raw sensor error for this rigid body. */
            (float)1.0,     /* Maximum 3-D RMS marker error for this rigid body. */
            (float)1.0,     /* Maximum raw sensor RMS error for this rigid body. */
            OPTOTRAK_QUATERN_RIGID_FLAG | OPTOTRAK_RETURN_QUATERN_FLAG ) )
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
         * Print out the rigid body transformation data.
         */
        fprintf( stdout, "\n" );
        fprintf( stdout, "Rigid Body Transformation Data\n\n" );
        fprintf( stdout, "Frame Number: %8u\n", uFrameNumber );
        fprintf( stdout, "Transforms  : %8u\n", uElements );
        fprintf( stdout, "Flags       :   0x%04x\n", uFlags );
        for( uRigidCnt = 0; uRigidCnt < uElements; ++uRigidCnt )
        {
            fprintf( stdout, "Rigid Body %u\n",
                     RigidBodyData.pRigidData[ uRigidCnt].RigidId );
            fprintf( stdout, "XT = %8.2f YT = %8.2f ZT = %8.2f\n",
                     RigidBodyData.pRigidData[ uRigidCnt].transformation.
                         quaternion.translation.x,
                     RigidBodyData.pRigidData[ uRigidCnt].transformation.
                         quaternion.translation.y,
                     RigidBodyData.pRigidData[ uRigidCnt].transformation.
                         quaternion.translation.z );
            fprintf( stdout, "Q0 = %8.2f QX = %8.2f QY = %8.2f QZ = %8.2f\n",
                     RigidBodyData.pRigidData[ uRigidCnt].transformation.
                         quaternion.rotation.q0,
                     RigidBodyData.pRigidData[ uRigidCnt].transformation.
                         quaternion.rotation.qx,
                     RigidBodyData.pRigidData[ uRigidCnt].transformation.
                         quaternion.rotation.qy,
                     RigidBodyData.pRigidData[ uRigidCnt].transformation.
                         quaternion.rotation.qz );
        } /* for */

        /*
         * Print out the 3D data.
         */
        fprintf( stdout, "\nAssociated 3D Marker Data\n\n" );
        for( uMarkerCnt = 0; uMarkerCnt < NUM_MARKERS; ++uMarkerCnt )
        {
            fprintf( stdout, "Marker %u X %f Y %f Z %f\n",
                     uMarkerCnt + 1,
                     RigidBodyData.p3dData[ uMarkerCnt].x,
                     RigidBodyData.p3dData[ uMarkerCnt].y,
                     RigidBodyData.p3dData[ uMarkerCnt].z );
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
