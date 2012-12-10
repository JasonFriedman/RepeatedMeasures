#define _WIN32_LEAN_AND_MEAN
#include <new>
#include <vhandtk/vhtCyberGloveEmulator.h>
#include <vhandtk/vhtTrackerEmulator.h>
#include <vhandtk/vht6DofDevice.h>
#include <vhandtk/vhtTransform3D.h>
#include <vhandtk/vhtHandMaster.h>
#include <vhandtk/vhtBaseException.h>
#include <vhandtk/vhtOglDrawer.h>
#include <vhandtk/vhtHumanHand.h>
#include <vhandtk/vhtHumanFinger.h>
#include <vhandtk/vhtPhalanx.h>
#include "mex.h"
#include <windows.h>
#ifdef OLD_VHT
    #include <GL/glut.h>
#else
    #include <Unsupported/glut/glut.h>
#endif

#define M_PI 3.14159265

//Define the local functions
bool CreateVirtualHand();
void updateGloveJointAngles(double jointAngles[23]);
void updateTrackerPosition(double position[3], double orientation[3]);
void DrawVirtualHand(double translation[3], double scaleFactor[3], double rotationAngle[3]);
void getVirtualHandFingertipLocations(double translation[3], double scaleFactor[3], double rotationAngle[3]);
bool DeleteVirtualHand();
void render_target(double position[3], double targetColor[3]);
void getFingertipPositions(double translation[3], double scaleFactor[3], double rotationAngle[3],mxArray* fingertipPositions);

// Define Global variables
static vhtCyberGloveEmulator *glove; 
static vhtHumanHand *hand;
static vhtTrackerEmulator *tracker ;

// For usage, see Glove_Rendering.m

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	unsigned int cmd; //, rowLen, i;   
	double *AngleValues, *PositionValues, *OrientationValues, *rotation, *translationarray, *scalexyz, *Colorcode;
	//Check the number of received parameters to the Mex function
	if(nrhs < 1) {
		mexErrMsgTxt("There must be at least one argument. Run help glove_rendering for usage\n");
		return;
	}
	else {
		if (nrhs >= 1 ) {
			cmd = (unsigned int) mxGetScalar(prhs[0]);
		} 
		if (cmd >0 && hand == NULL) {
			mexErrMsgTxt(" Virtual Human Hand hasn't been initiated yet...\n");
			return;
		}    
	}     
	switch((unsigned int) cmd) {
	case 0:
		//mexPrintf("Constructing the Virtual Human Hand with the tracker and glove.....\n");
		CreateVirtualHand();
		break;
	case 1: 
		if(nrhs < 2) { 
			mexErrMsgTxt("A set of joint angle values is required.....\n");
			return ;
		}   
		else if (nrhs == 2) {
			AngleValues = mxGetPr(prhs[1]);
		    //int elements=mxGetNumberOfElements(prhs[1]);
			//mexPrintf("There are %d elements in the joint angle array\n",elements);
			updateGloveJointAngles(AngleValues);
		}
		break;
	case 3:
		if(nrhs != 3) { 
			mexErrMsgTxt("A set of position and orientation values is required.....\n");
			return ;
		} 
		else {
			PositionValues = mxGetPr(prhs[1]);
			OrientationValues = mxGetPr(prhs[2]);
			updateTrackerPosition(PositionValues,OrientationValues);
		}
		break;    
		
	case 4:
		if (nrhs!=4) {
			mexErrMsgTxt("Four arguments are required\n");
			return;
		}
		translationarray = mxGetPr(prhs[1]);
		scalexyz = mxGetPr(prhs[2]);    
		rotation = mxGetPr(prhs[3]);          
		DrawVirtualHand(translationarray,scalexyz, rotation);
		
		break;         
	case 5:
		DeleteVirtualHand();
		break;
	case 6:
		if(nrhs < 2) {
			PositionValues = NULL;
			Colorcode = NULL;
		}
		else if (nrhs >= 2) {
			PositionValues = mxGetPr(prhs[1]);
			Colorcode = mxGetPr(prhs[2]);
		}
		render_target( PositionValues,Colorcode);    
		break;
        
   case 7:
		if (nrhs!=4) {
			mexErrMsgTxt("Four arguments are required\n");
			return;
		}
		translationarray = mxGetPr(prhs[1]);
		scalexyz = mxGetPr(prhs[2]);    
		rotation = mxGetPr(prhs[3]);          
        
        // Create a 1x15 (5 fingers * xyz data) array to return the data
        plhs[0] = mxCreateNumericMatrix(1, 15, mxDOUBLE_CLASS, mxREAL);
        getFingertipPositions(translationarray,scalexyz, rotation,plhs[0]);
		
		break;         
        
	case 10:
		if(nrhs != 7) { 
			mexErrMsgTxt("Seven arguments are required.....\n");
			return ;
		}   
		else {
			CreateVirtualHand();
			AngleValues = mxGetPr(prhs[1]);
			updateGloveJointAngles(AngleValues);
			PositionValues = mxGetPr(prhs[2]);
			OrientationValues = mxGetPr(prhs[3]);
			updateTrackerPosition(PositionValues,OrientationValues);
			translationarray = mxGetPr(prhs[4]);
			scalexyz = mxGetPr(prhs[5]);    
			rotation = mxGetPr(prhs[6]);
			DrawVirtualHand(translationarray,scalexyz, rotation);
			DeleteVirtualHand();
		}
		break;
	}
}

bool CreateVirtualHand()
{
	char *handedness;  

	GHM::Handedness gloveHandedness= GHM::rightHand;

	if ((handedness= getenv("VTIHANDEDNESS")) != NULL)
	{
		if (strcmp(handedness, "left") == 0)
			gloveHandedness= GHM::leftHand;
	}
	// Connect to the GloveEmulator

	try
	{
		//glove = (vhtCyberGloveEmulator *) mxMalloc(sizeof(vhtCyberGloveEmulator));
		//new (glove) vhtCyberGloveEmulator();
		//mexMakeMemoryPersistent((void *)glove); 
		glove = new vhtCyberGloveEmulator();
	}
	catch (vhtBaseException *e)
	{
		mexPrintf("???%s\n ",e->getMessage());
		mexErrMsgTxt("Error with gloveEmulator\n");
		return 0;
	}
	//if (glove->connect())
	//mexPrintf("CyberGlove has been successfully Connected.\n");  

	// Connect to the TrackerEmulator.
	try
	{
		//tracker = (vhtTrackerEmulator *) mxMalloc(sizeof(vhtTrackerEmulator));
		//new (tracker) vhtTrackerEmulator( );
		//mexMakeMemoryPersistent((void *)tracker); 
		tracker = new vhtTrackerEmulator();
	}
	catch (vhtBaseException *e)
	{
		mexPrintf("???%s\n ",e->getMessage());
		mexErrMsgTxt("Error with trackerEmulator\n ");

		return 0;
	}
	//if (tracker->connect())
	//   mexPrintf("Tracker has been successfully Connected.\n");  
	vht6DofDevice *rcvr1 = tracker->getLogicalDevice(0);


	vhtHandMaster *master = new vhtHandMaster( glove, rcvr1 );
	// Create the Virtual Human Hand.
	double scale =1.0;
	//hand = (vhtHumanHand *) mxMalloc(sizeof(vhtHumanHand));
	//new (hand) vhtHumanHand( master, scale,gloveHandedness );
	//mexMakeMemoryPersistent((void *)hand); 
	hand = new vhtHumanHand(master,scale,gloveHandedness);
	if (hand != NULL){
		//mexPrintf("The Virtual Hand has been successfully Constructed.\n");  
		return (1);
	}   
	else 
		return 0;
}   

void updateGloveJointAngles(double jointAngles[23]) {
	// This line should work but doesn't and causes weird stuff to happen
	//glove->setAngles(jointAngles);
	// So instead, set each joint individually
	for (int finger=0;finger<5;finger++)
		for (int joint=0;joint<4;joint++)
			glove->setAngle((GHM::Fingers)finger,(GHM::Joints)joint,jointAngles[finger*4+joint]);
	// Set the wrist rotations
    glove->setAngle((GHM::Fingers)5,(GHM::Joints)1,jointAngles[21]);
    glove->setAngle((GHM::Fingers)5,(GHM::Joints)2,jointAngles[22]);
    
	//mexPrintf("Joint Angles are now set ....\n");
}

void updateTrackerPosition(double position[3], double orientation[3]) {
	tracker->setTrackerPosition(position[0],position[1],position[2]);
	//mexPrintf(" %f\t%f\t%f\n", orientation[0], orientation[1], orientation[2]);
	tracker->setTrackerOrientation(orientation[0]*M_PI/180.0,orientation[1]*M_PI/180.0, orientation[2]*M_PI/180.0) ;
	//mexPrintf("Both position and orientation of the tracker are now set ....\n");
}

// Draw the actual hand
// translation[3] is the camera translation
// rotationAngle[3] is the ZYX camera rotation (first Z, then Y, then X)
void DrawVirtualHand(double translation[3], double scaleFactor[3], double rotationAngle[3])
{
	vhtOglDrawer  *drawer = new vhtOglDrawer();
	vhtTransform3D *cameraXForm = new vhtTransform3D();

	cameraXForm->setRotation(VHT_Z,rotationAngle[0]);
	cameraXForm->setRotation(VHT_Y,rotationAngle[1]);
	cameraXForm->setRotation(VHT_X,rotationAngle[2]);

	cameraXForm->setTranslation(translation[0],translation[1],translation[2]);

	static GLfloat handDiffuse[]= { 0.8f, 0.63f, 0.36f, 1.0f };
	static GLfloat handAmbient[]= { 0.00f, 0.00f, 0.00f, 1.0f };
	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, handDiffuse);
	glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, handAmbient); 

	if (hand!= NULL){
		hand->update(true);
		drawer->renderHand( cameraXForm, hand ); 
	}

} 

// Get the 3D locations of the fingertips
// translation[3] is the camera translation
// rotationAngle[3] is the ZYX camera rotation (first Z, then Y, then X)
void getFingertipPositions(double translation[3], double scaleFactor[3], double rotationAngle[3],mxArray* fingertipPositions)
{
	vhtOglDrawer  *drawer = new vhtOglDrawer();
	vhtTransform3D *cameraXForm = new vhtTransform3D();

	cameraXForm->setRotation(VHT_Z,rotationAngle[0]);
	cameraXForm->setRotation(VHT_Y,rotationAngle[1]);
	cameraXForm->setRotation(VHT_X,rotationAngle[2]);

	cameraXForm->setTranslation(translation[0],translation[1],translation[2]);
    double* pointer;
    pointer = mxGetPr(fingertipPositions);
    
	if (hand!= NULL){
        hand->update(true);
        vhtVector3d trans;
        for( int j = 0; j < 5; j++ ) {
             hand->getFinger((GHM::Fingers)j)->getDistalPhalanx()->getLM().getTranslation(trans);
             pointer[j*3] = trans.x;
             pointer[j*3+1] = trans.y;
             pointer[j*3+2] = trans.z;
        }		
	}

} 



void render_target(double position[3], double targetColor[3])
{
	glPushMatrix();
	// Draw a sphere
	glColor3d( targetColor[1], targetColor[2], targetColor[3]);
	//mexPrintf("Targetposition %f.\n",position[0] );  
	glTranslated( position[0],position[1],position[2] );
	glutSolidSphere(5,100, 100);
	// Send it to the screen.
	glFlush();
	glPopMatrix();
}

bool DeleteVirtualHand()
{
	//glove->disconnect();
	//tracker->disconnect();
	//hand->disconnect();

	//mxFree(glove); 
	//glove = NULL;
	//mxFree(tracker); //Free the memory occupied by glove
	//tracker = NULL;
	//mxFree(hand);
	//hand = NULL; 
	delete hand;
	delete glove;
	delete tracker;
	//mexPrintf("Virtual Hand has been successfully deleted.\n");  
	return 1;  
}    