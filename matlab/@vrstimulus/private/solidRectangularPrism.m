% SOLIDRECTANGULARPRISM - draw an OpenGL solid rectangular prism (like a cube but with rectangle sides)
%
% solidRectangularPrism(thesize)
% thesize is 1x3 vector - width, depth, height
%
% based on OpenGlut glutSolidCube
% http://openglut.cvs.sourceforge.net/viewvc/openglut/openglut/lib/src/og_geometry.c?view=markup

function solidRectangularPrism(thesize)

global GL;

x = thesize(1)/2;
y = thesize(2)/2;
d = thesize(3)/2;

glBegin(GL.QUADS);
glNormal3d( 1, 0, 0 ); glVertex3d( x,-y, d); glVertex3d( x,-y,-d); glVertex3d( x, y,-d); glVertex3d( x, y, d);
glNormal3d( 0, 1, 0 ); glVertex3d( x, y, d); glVertex3d( x, y,-d); glVertex3d(-x, y,-d); glVertex3d(-x, y, d);
glNormal3d( 0, 0, 1 ); glVertex3d( x, y, d); glVertex3d(-x, y, d); glVertex3d(-x,-y, d); glVertex3d( x,-y, d);
glNormal3d( -1, 0, 0 ); glVertex3d(-x,-y, d); glVertex3d(-x, y, d); glVertex3d(-x, y,-d); glVertex3d(-x,-y,-d);
glNormal3d( 0, -1, 0 ); glVertex3d(-x,-y, d); glVertex3d(-x,-y,-d); glVertex3d( x,-y,-d); glVertex3d( x,-y, d);
glNormal3d( 0, 0, -1 ); glVertex3d(-x,-y,-d); glVertex3d(-x, y,-d); glVertex3d( x, y,-d); glVertex3d( x,-y,-d);
glEnd();
