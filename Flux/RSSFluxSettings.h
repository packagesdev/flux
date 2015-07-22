
#import "RSSSettings.h"

typedef NS_ENUM(NSUInteger, RSSFluxSet)
{
	RSSFluxSetCustom=0,
	RSSFluxSetRandom=1,
	RSSFluxSetRegular=1027,
	RSSFluxSetHypnotic=1028,
	RSSFluxSetInsane=1029,
	RSSFluxSetSparklers=1030,
	RSSFluxSetParadigm=1031,
	RSSFluxSetGalactic=1032
};

typedef NS_ENUM(NSUInteger, RSSFluxParticleGeometryType)
{
	RSSFluxGeometryTypePoints=0,
	RSSFluxGeometryTypeSpheres=1,
	RSSFluxGeometryTypeLights=2,
};

@interface RSSFluxSettings : RSSSettings

@property RSSFluxSet standardSet;


@property NSUInteger numberOFluxFields;

@property NSUInteger numberOfParticlesPerFluxField;

@property NSUInteger particleSize;

@property NSUInteger particleTrailLength;

@property RSSFluxParticleGeometryType geometryType;

@property NSUInteger geometrySphereComplexity;


@property NSUInteger randomizationFrequency;

@property NSUInteger expansionRate;

@property NSUInteger rotationRate;

@property NSUInteger crossWindSpeed;

@property NSUInteger instability;

@property NSUInteger motionBlur;


- (void)resetSettingsToStandardSet:(RSSFluxSet)inSet;

@end
