#ifndef __FLUX__
#define __FLUX__

#define NUMCONSTS 8
#define PIx2 6.28318530718f
#define DEG2RAD 0.0174532925f
#define LIGHTSIZE 64

class flux;
class particle;

enum
{
	GeometryTypePoints=0,
	GeometryTypeSpheres=1,
	GeometryTypeLights=2
} FluxParticleGeometryType;

class scene
{
	private:
	
		flux *_fluxes;
	
		unsigned char _lightTexture[LIGHTSIZE][LIGHTSIZE];
	
	public:
	
		int fluxesCount;
		int particlesPerFluxCount;
		int particleTrailLength;
		int particleSize;
		int geometryType;
		int sphereGeometryComplexity;
	
		int randomizationFrequency;
		int expansionrate;
		int rotationRate;
		int crossWindSpeed;
		int instability;
		int motionBlur;
	
		float lumdiff;
		
		float cameraAngle;
		float cosCameraAngle,sinCameraAngle;
	
	
		scene();
		virtual ~scene();
	
		void create();
		void resize(int inWidth,int inHeight);
		void draw();
};


// This class is poorly named.  It's actually a whole trail of particles.

class particle
{
    public:
    
        int trail;
    
        float **vertices;
        int counter;
        float offset[3];
    
        particle();
        virtual ~particle();
	
		void initWithScene(int inTrailLength,float inLocationPercentage);
        void updateWithScene(float *c,scene * inScene);
};

class flux
{
    public:
    
        particle *particles;
        int randomize;
        float c[NUMCONSTS];     // constants
        float cv[NUMCONSTS];    // constants' change velocities
        int currentSmartConstant;
        float oldDistance;
    
        flux();
        virtual ~flux();
	
		void initWithScene(scene * inScene);
        void updateWithScene(scene * inScene);
};

#endif