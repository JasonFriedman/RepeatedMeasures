%This function will draw the target in OpenGL

function render_target(v,targetNum)

targetPosition = v.target{targetNum}.position;
targetColor = v.target{targetNum}.color;

glPushMatrix();
glLoadIdentity;
glColor3f( targetColor(1), targetColor(2), targetColor(3));
glTranslatef( targetPosition(1), targetPosition(2), targetPosition(3));
if isfield(v.target{targetNum}.type,'sphere')
    glutSolidSphere ( v.target{targetNum}.type.sphere.radius, 100, 100 );
elseif isfield(v.target{targetNum}.type,'solidCube')
    glutSolidCube(v.target{targetNum}.type.solidCube.size);
elseif isfield(v.target{targetNum}.type,'wireframeCube')
    glutWireCube(v.target{targetNum}.type.wireframeCube.size);
elseif isfield(v.target{targetNum}.type,'wireframeRectangularPrism')
    wireRectangularPrism(v.target{targetNum}.type.wireframeRectangularPrism.size);
elseif isfield(v.target{targetNum}.type,'solidRectangularPrism')
    solidRectangularPrism(v.target{targetNum}.type.solidRectangularPrism.size);
elseif isfield(v.target{targetNum}.type,'arrow')
    arrow(v.target{targetNum}.type.arrow.direction,v.target{targetNum}.type.arrow.radius,v.target{targetNum}.type.arrow.height);
else
    v.target{targetNum}.type
    error('Unknown target type');
end
glPopMatrix();


