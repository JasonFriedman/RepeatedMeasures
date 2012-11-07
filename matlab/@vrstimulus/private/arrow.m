% ARROW - draw an OpenGL solid arrow (made up of a cylinder and a cone)
%
% arrow(direction,radius,height)
% direction = 1 -> up, direction = 2-> down
% radius is the radius of the cone (the cylinder has a radius 1/4 of the cone radius)
% height is the length of the arrow

function arrow(direction,radius,height)

global GL;
slices = 20; stacks = 20;

% The cylinder is drawn from z=0 to z=height, so we shift by half the height (in the z direction)
glTranslatef( 0,0,-height/2);
gluCylinder( gluNewQuadric, radius/4,radius/4,height,slices,stacks );
if direction==1 % UP
    glRotatef(180,1,0,0);
    glTranslatef( 0,0,-height*3/10);
    glutSolidCone(radius,5*height/10,slices,stacks);
else % DOWN
    %glRotatef(180,1,0,0);
    glTranslatef( 0,0,height*7/10);
    glutSolidCone(radius,5*height/10,slices,stacks);
end
