% GLOVE_RENDERING - render the glove using the Virtualhand toolkit
%
% Glove_Rendering(0)  - constructing the Human Hand (no other arguments)
%
% Glove_Rendering(1,jointangles) - set the joint angles (should be a vector of size 20)
%
% Glove_Rendering(3,positions,orientations) - set the position and orientation of the wrist (usually from the tracker). 
%                                            Both are vectors of size 3
%
% Glove_Rendering(4,cameraTranslation,scale,cameraRotation) - Render the hand (using the values set above). The 3 values for the camera are
%                                                            vectors of size 3. The camera rotation is in ZYX Euler angles
%
% Glove_Rendering(5) - delete the human hand and free the memory (no other arguments)
%
% Glove_Rendering(6,position,colour) - render the target, where position is
% a vector of length 3, and colour is a vector of length 3 (red, green, blue components)
%
% fingertiplocations = Glove_Rendering(7,cameraTranslation,scale,cameraRotation) - Return the location of the fingertips
%
% Glove_Rendering(10,jointangles,positions,orientations,cameraTranslation,scale,cameraRotation)
%           - if using this, the hand is constructed (and destroyed) every call, so do not call any of the other options first.
%             It uses the same arguments as described above.
function Glove_Rendering(~,~,~)

error(['This function should not be run - the mex file for this platform is missing.'...
       ' It can be compiled using ''compilecode.m''.'...
       ' The hand rendering only works with Windows with the Virtualhand toolkit installed.']);