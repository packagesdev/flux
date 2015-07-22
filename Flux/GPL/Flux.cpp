/*
 * Copyright (C) 2002  Terence M. Welsh
 *
 * Flux is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as 
 * published by the Free Software Foundation.
 *
 * Flux is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */


/* 2015 (S.Sudre): Make the code a bit more object-oriented */

// Flux screen saver

#include "Flux.h"

#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#include "rgbhsl.h"



// Useful random number macros
// Don't forget to initialize with srand()

static int myRandi(int x)
{
	return((rand() * x) / RAND_MAX);
}

static float myRandf(float x)
{
	return(((double) rand() * x) / RAND_MAX);
}


scene::scene()
{
	srand((unsigned)time(NULL));
	rand(); rand(); rand(); rand(); rand();
	rand(); rand(); rand(); rand(); rand();
	rand(); rand(); rand(); rand(); rand();
	rand(); rand(); rand(); rand(); rand();
	
	cameraAngle=0;
}

scene::~scene()
{
	if (glIsList(1))
		glDeleteLists(1, 1);
	
	if (_fluxes!=NULL)
		delete[] _fluxes;
}

#pragma mark -

void scene::resize(int inWidth,int inHeight)
{
	// Window initialization
	
	glViewport(0,0, inWidth,inHeight);
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective(100.0, (inWidth*1.0)/inHeight, 0.01, 200);
	glTranslatef(0.0, 0.0, -2.5);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
}

void scene::create()
{
	if(geometryType == GeometryTypePoints)
	{
		glEnable(GL_POINT_SMOOTH);
		if (glIsList(1)) glDeleteLists(1, 1);
		//glHint(GL_POINT_SMOOTH_HINT, GL_NICEST);
	}
	else
	{
		glDisable(GL_POINT_SMOOTH);
	}
	
	glFrontFace(GL_CCW);
	glEnable(GL_CULL_FACE);
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	if(geometryType == GeometryTypeSpheres)
	{  // Spheres and their lighting
		glNewList(1, GL_COMPILE);
		GLUquadricObj *qobj = gluNewQuadric();
		gluSphere(qobj, 0.005f * float(particleSize), sphereGeometryComplexity + 2, sphereGeometryComplexity + 1);
		gluDeleteQuadric(qobj);
		glEndList();
		
		glEnable(GL_LIGHTING);
		glEnable(GL_LIGHT0);
		float ambient[4] = {0.0f, 0.0f, 0.0f, 0.0f};
		float diffuse[4] = {1.0f, 1.0f, 1.0f, 0.0f};
		float specular[4] = {1.0f, 1.0f, 1.0f, 0.0f};
		float position[4] = {500.0f, 500.0f, 500.0f, 0.0f};
		glLightfv(GL_LIGHT0, GL_AMBIENT, ambient);
		glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuse);
		glLightfv(GL_LIGHT0, GL_SPECULAR, specular);
		glLightfv(GL_LIGHT0, GL_POSITION, position);
		glEnable(GL_COLOR_MATERIAL);
		glColorMaterial(GL_FRONT, GL_AMBIENT_AND_DIFFUSE);
	}
	else
	{
		glDisable(GL_LIGHTING);
		glDisable(GL_COLOR_MATERIAL);
		
		if (glIsList(1))
			glDeleteLists(1, 1);
	}
	
	if(geometryType == GeometryTypeLights)
	{  // Init lights
		for(int i=0; i<LIGHTSIZE; i++)
		{
			for(int j=0; j<LIGHTSIZE; j++)
			{
				float x, y, temp;
				
				x = float(i - LIGHTSIZE / 2) / float(LIGHTSIZE / 2);
				y = float(j - LIGHTSIZE / 2) / float(LIGHTSIZE / 2);
				
				temp = 1.0f - float(sqrt((x * x) + (y * y)));
				
				if(temp > 1.0f)
				{
					temp = 1.0f;
				}
				else
				{
					if(temp < 0.0f)
						temp = 0.0f;
				}
				
				_lightTexture[i][j] = (unsigned char) ( 255.0f * temp * temp);
			}
		}
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, 1);
		glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexImage2D(GL_TEXTURE_2D, 0, 1, LIGHTSIZE, LIGHTSIZE, 0,
					 GL_LUMINANCE, GL_UNSIGNED_BYTE, _lightTexture);
		
		float temp = float(particleSize) * 0.005f;
		glNewList(1, GL_COMPILE);
		glBindTexture(GL_TEXTURE_2D, 1);
		glBegin(GL_TRIANGLES);
		glTexCoord2f(0.0f, 0.0f);
		glVertex3f(-temp, -temp, 0.0f);
		glTexCoord2f(1.0f, 0.0f);
		glVertex3f(temp, -temp, 0.0f);
		glTexCoord2f(1.0f, 1.0f);
		glVertex3f(temp, temp, 0.0f);
		glTexCoord2f(0.0f, 0.0f);
		glVertex3f(-temp, -temp, 0.0f);
		glTexCoord2f(1.0f, 1.0f);
		glVertex3f(temp, temp, 0.0f);
		glTexCoord2f(0.0f, 1.0f);
		glVertex3f(-temp, temp, 0.0f);
		glEnd();
		glEndList();
	}
	else
	{
		glDisable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, 0);
	}
	
	// Initialize luminosity difference
	lumdiff = 1.0f / float(particleTrailLength);
	
	// Initialize flux fields
	_fluxes = new flux[fluxesCount];
	
	if (_fluxes!=NULL)
	{
		for(int i=0;i<fluxesCount;i++)
		{
			_fluxes[i].initWithScene(this);
		}
	}
}

void scene::draw()
{
	// clear the screen
	glLoadIdentity();
	
	if(motionBlur)
	{  // partially
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		glEnable(GL_BLEND);
		glDisable(GL_DEPTH_TEST);
		glColor4f(0.0f, 0.0f, 0.0f, 0.5f - (float(sqrt(sqrt(double(motionBlur)))) * 0.15495f));
		glBegin(GL_TRIANGLE_STRIP);
		glVertex3f(-5.0f, -4.0f, 0.0f);
		glVertex3f(5.0f, -4.0f, 0.0f);
		glVertex3f(-5.0f, 4.0f, 0.0f);
		glVertex3f(5.0f, 4.0f, 0.0f);
		glEnd();
	}
	else  // completely
	{
		glClear(GL_COLOR_BUFFER_BIT);
	}
	
	cameraAngle += 0.01f * float(rotationRate);
	if(cameraAngle >= 360.0f)
		cameraAngle -= 360.0f;
	
	if(geometryType == GeometryTypeSpheres)  // Only rotate for spheres
	{
		glRotatef(cameraAngle, 0.0f, 1.0f, 0.0f);
	}
	else
	{
		cosCameraAngle = cos(cameraAngle * DEG2RAD);
		sinCameraAngle = sin(cameraAngle * DEG2RAD);
	}
	
	// set up blend modes for rendering particles
	switch(geometryType)
	{
		case GeometryTypePoints:  // Blending for points
			glBlendFunc(GL_SRC_ALPHA, GL_ONE);
			glEnable(GL_BLEND);
			glEnable(GL_POINT_SMOOTH);
			glHint(GL_POINT_SMOOTH_HINT, GL_NICEST);
			break;
		case GeometryTypeSpheres:  // No blending for spheres, but we need z-buffering
			glDisable(GL_BLEND);
			glEnable(GL_DEPTH_TEST);
			glClear(GL_DEPTH_BUFFER_BIT);
			break;
		case GeometryTypeLights:  // Blending for lights
			glBlendFunc(GL_ONE, GL_ONE);
			glEnable(GL_BLEND);
	}
	
	// Update particles
	for(int i=0; i<fluxesCount; i++)
		_fluxes[i].updateWithScene(this);
}

#pragma mark -

particle::particle()
{
	trail=0;
	
	vertices=NULL;
	
	counter = 0;
}

particle::~particle()
{
	if (vertices!=NULL)
	{
		for(int i=0; i<trail; i++)
			delete[] vertices[i];
    
		delete[] vertices;
	}
}

#pragma mark -

void particle::initWithScene(int inTrailLength,float inLocationPercentage)
{
	// Offsets are somewhat like default positions for the head of each
	// particle trail.  Offsets spread out the particle trails and keep
	// them from all overlapping.
	
	offset[0] = cos(PIx2 * inLocationPercentage);
	offset[1] = inLocationPercentage - 0.5f;
	offset[2] = sin(PIx2 * inLocationPercentage);
	
	// Initialize memory and set initial positions out of view of the camera
	
	trail=inTrailLength;
	
	vertices = new float*[trail];
	
	for(int i=0; i<trail; i++)
	{
		vertices[i] = new float[5];  // 0,1,2 = position, 3 = hue, 4 = saturation
		vertices[i][0] = 0.0f;
		vertices[i][1] = 3.0f;
		vertices[i][2] = 0.0f;
		vertices[i][3] = 0.0f;
		vertices[i][4] = 0.0f;
	}
}

#pragma mark -

void particle::updateWithScene(float *c,scene * inScene)
{
	int i, p, growth;
	float rgb[3];
	float cx, cy, cz;  // Containment variables
	float luminosity;
	float expander = 1.0f + 0.0005f * float(inScene->expansionrate);
	float blower = 0.001f * float(inScene->crossWindSpeed);
	float depth=0;

	// Record old position
	int oldc = counter;

	counter ++;
	if(counter >= inScene->particleTrailLength)
		counter = 0;

	// Here's the iterative math for calculating new vertex positions
	// first calculate limiting terms which keep vertices from constantly
	// flying off to infinity
	cx = vertices[oldc][0] * (1.0f - 1.0f / (vertices[oldc][0] * vertices[oldc][0] + 1.0f));
	cy = vertices[oldc][1] * (1.0f - 1.0f / (vertices[oldc][1] * vertices[oldc][1] + 1.0f));
	cz = vertices[oldc][2] * (1.0f - 1.0f / (vertices[oldc][2] * vertices[oldc][2] + 1.0f));
	// then calculate new positions
	vertices[counter][0] = vertices[oldc][0] + c[6] * offset[0] - cx
		+ c[2] * vertices[oldc][1]
		+ c[5] * vertices[oldc][2];
	vertices[counter][1] = vertices[oldc][1] + c[6] * offset[1] - cy
		+ c[1] * vertices[oldc][2]
		+ c[4] * vertices[oldc][0];
	vertices[counter][2] = vertices[oldc][2] + c[6] * offset[2] - cz
		+ c[0] * vertices[oldc][0]
		+ c[3] * vertices[oldc][1];

	// Pick a hue
	vertices[counter][3] = cx * cx + cy * cy + cz * cz;
	if(vertices[counter][3] > 1.0f)
		vertices[counter][3] = 1.0f;
	vertices[counter][3] += c[7];
	// Limit the hue (0 - 1)
	if(vertices[counter][3] > 1.0f)
		vertices[counter][3] -= 1.0f;
	if(vertices[counter][3] < 0.0f)
		vertices[counter][3] += 1.0f;
	// Pick a saturation
	vertices[counter][4] = c[0] + vertices[counter][3];
	// Limit the saturation (0 - 1)
	if(vertices[counter][4] < 0.0f)
		vertices[counter][4] = -vertices[counter][4];
	vertices[counter][4] -= float(int(vertices[counter][4]));
	vertices[counter][4] = 1.0f - (vertices[counter][4] * vertices[counter][4]);

	// Bring particles back if they escape
	if(!counter)
    {
		if((vertices[0][0] > 1000000000.0f) || (vertices[0][0] < -1000000000.0f)
			|| (vertices[0][1] > 1000000000.0f) || (vertices[0][1] < -1000000000.0f)
			|| (vertices[2][2] > 1000000000.0f) || (vertices[0][2] < -1000000000.0f)){
			vertices[0][0] = myRandf(2.0f) - 1.0f;
			vertices[0][1] = myRandf(2.0f) - 1.0f;
			vertices[0][2] = myRandf(2.0f) - 1.0f;
		}
	}

	// Draw every vertex in particle trail
	p = counter;
	growth = 0;
	luminosity = inScene->lumdiff;
	for(i=0; i<inScene->particleTrailLength; i++)
    {
		p ++;
		if(p >= inScene->particleTrailLength)
			p = 0;
		growth++;

		if(vertices[p][0] * vertices[p][0]
		   + vertices[p][1] * vertices[p][1]
		   + vertices[p][2] * vertices[p][2] < 40000.0f)
		{
			// assign color to particle
			hsl2rgb(vertices[p][3], vertices[p][4], luminosity, rgb[0], rgb[1], rgb[2]);
			glColor3fv(rgb);

			glPushMatrix();
			if(inScene->geometryType == GeometryTypeSpheres)  // Spheres
			{
				glTranslatef(vertices[p][0], vertices[p][1], vertices[p][2]);
			}
			else
			{  // Points or lights
				depth = inScene->cosCameraAngle * vertices[p][2] - inScene->sinCameraAngle * vertices[p][0];
				glTranslatef(inScene->cosCameraAngle * vertices[p][0] + inScene->sinCameraAngle
					* vertices[p][2], vertices[p][1], depth);
			}
			
			if(inScene->geometryType!=GeometryTypePoints)
			{  // Spheres or lights
				switch(inScene->particleTrailLength - growth)
				{
					case 0:
						glScalef(0.259f, 0.259f, 0.259f);
						break;
					case 1:
						glScalef(0.5f, 0.5f, 0.5f);
						break;
					case 2:
						glScalef(0.707f, 0.707f, 0.707f);
						break;
					case 3:
						glScalef(0.866f, 0.866f, 0.866f);
						break;
					case 4:
						glScalef(0.966f, 0.966f, 0.966f);
				}
			}
			
			switch(inScene->geometryType)
			{
				case GeometryTypePoints:  // Points
					switch(inScene->particleTrailLength - growth)
					{
						case 0:
							glPointSize(float(inScene->particleSize * (depth + 200.0f) * 0.001036f));
							break;
						case 1:
							glPointSize(float(inScene->particleSize * (depth + 200.0f) * 0.002f));
							break;
						case 2:
							glPointSize(float(inScene->particleSize * (depth + 200.0f) * 0.002828f));
							break;
						case 3:
							glPointSize(float(inScene->particleSize * (depth + 200.0f) * 0.003464f));
							break;
						case 4:
							glPointSize(float(inScene->particleSize * (depth + 200.0f) * 0.003864f));
							break;
						default:
							glPointSize(float(inScene->particleSize * (depth + 200.0f) * 0.004f));
					}
					
					glBegin(GL_POINTS);
						glVertex3f(0.0f,0.0f,0.0f);
					glEnd();
					break;
				case GeometryTypeSpheres:  // Spheres
				case GeometryTypeLights:  // Lights
					glCallList(1);
			}
			
			glPopMatrix();
		}
		
		vertices[p][0] *= expander;
		vertices[p][1] *= expander;
		vertices[p][2] *= expander;
		vertices[p][2] += blower;
		luminosity += inScene->lumdiff;
	}
}

#pragma mark -

// This class is a set of particle trails and constants that enter
// into their equations of motion.

flux::flux()
{
	currentSmartConstant = 0;
	oldDistance = 0.0f;
	
	randomize = 1;
}

flux::~flux()
{
	delete[] particles;
}

#pragma mark -

void flux::initWithScene(scene * inScene)
{
	particles = new particle[inScene->particlesPerFluxCount];
	
	for(int i=0;i<inScene->particlesPerFluxCount;i++)
	{
		particles[i].initWithScene(inScene->particleTrailLength,float(i)/float(inScene->particlesPerFluxCount));
	}
	
	for(int i=0; i<NUMCONSTS; i++)
	{
		c[i] = myRandf(2.0f) - 1.0f;
		cv[i] = myRandf(0.000005f * float(inScene->instability) * float(inScene->instability))+ 0.000001f * float(inScene->instability) * float(inScene->instability);
	}
}

void flux::updateWithScene(scene * inScene)
{
	// randomize constants
	if(inScene->randomizationFrequency)
    {
		randomize --;
        
		if(randomize <= 0)
        {
			for(int i=0; i<NUMCONSTS; i++)
				c[i] = myRandf(2.0f) - 1.0f;
                
			int temp = 101 - inScene->randomizationFrequency;
			temp = temp * temp;
			randomize = temp + myRandi(temp);
		}
	}

	// update constants
	for(int i=0; i<NUMCONSTS; i++)
    {
		c[i] += cv[i];
		if(c[i] >= 1.0f){
			c[i] = 1.0f;
			cv[i] = -cv[i];
		}
		if(c[i] <= -1.0f){
			c[i] = -1.0f;
			cv[i] = -cv[i];
		}
	}

	// update all particles in this flux field
	
	for(int i=0; i<inScene->particlesPerFluxCount; i++)
		particles[i].updateWithScene(c,inScene);
}