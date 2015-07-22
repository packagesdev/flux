
#import "RSSFluxSettings.h"

NSString * const RSSFlux_Settings_StandardSetKey=@"Standard set";

NSString * const RSSFlux_Settings_NumberOfFluxFieldsKey=@"Flux count";
NSString * const RSSFlux_Settings_NumberOfParticlesPerFluxFieldKey=@"Particle count";
NSString * const RSSFlux_Settings_ParticleTrailLengthKey=@"Trail count";
NSString * const RSSFlux_Settings_ParticleSizeKey=@"Size";
NSString * const RSSFlux_Settings_GeometryTypeKey=@"Geometry";

NSString * const RSSFlux_Settings_GeometrySphereComplexityKey=@"Complexity";
NSString * const RSSFlux_Settings_ExpansionRateKey=@"Expansion";
NSString * const RSSFlux_Settings_RotationRateKey=@"Rotation";
NSString * const RSSFlux_Settings_RandomizationFrequencyKey=@"Randomize";
NSString * const RSSFlux_Settings_CrossWindSpeedKey=@"Crosswind";
NSString * const RSSFlux_Settings_InstabilityKey=@"Instability";

NSString * const RSSFlux_Settings_MotionBlurKey=@"Blur";

@implementation RSSFluxSettings

- (id)initWithDictionaryRepresentation:(NSDictionary *)inDictionary
{
	self=[super init];
	
	if (self!=nil)
	{
		NSNumber * tNumber=inDictionary[RSSFlux_Settings_StandardSetKey];
		
		if (tNumber==nil)
			_standardSet=RSSFluxSetRegular;
		else
			_standardSet=[tNumber unsignedIntegerValue];
		
		if (_standardSet==RSSFluxSetCustom)
		{
			_numberOFluxFields=[inDictionary[RSSFlux_Settings_NumberOfFluxFieldsKey] unsignedIntegerValue];
			_numberOfParticlesPerFluxField=[inDictionary[RSSFlux_Settings_NumberOfParticlesPerFluxFieldKey] unsignedIntegerValue];
			_particleSize=[inDictionary[RSSFlux_Settings_ParticleSizeKey] unsignedIntegerValue];
			_particleTrailLength=[inDictionary[RSSFlux_Settings_ParticleTrailLengthKey] unsignedIntegerValue];
			_geometryType=[inDictionary[RSSFlux_Settings_GeometryTypeKey] unsignedIntegerValue];
			_geometrySphereComplexity=[inDictionary[RSSFlux_Settings_GeometrySphereComplexityKey] unsignedIntegerValue];
			
			_randomizationFrequency=[inDictionary[RSSFlux_Settings_RandomizationFrequencyKey] unsignedIntegerValue];
			_expansionRate=[inDictionary[RSSFlux_Settings_ExpansionRateKey] unsignedIntegerValue];
			_rotationRate=[inDictionary[RSSFlux_Settings_RotationRateKey] unsignedIntegerValue];
			_crossWindSpeed=[inDictionary[RSSFlux_Settings_CrossWindSpeedKey] unsignedIntegerValue];
			_instability=[inDictionary[RSSFlux_Settings_InstabilityKey] unsignedIntegerValue];
			 
			_motionBlur=[inDictionary[RSSFlux_Settings_MotionBlurKey] unsignedIntegerValue];
		}
		else if (_standardSet!=RSSFluxSetRandom)
		{
			[self resetSettingsToStandardSet:_standardSet];
		}
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary * tMutableDictionary=[NSMutableDictionary dictionary];
	
	if (tMutableDictionary!=nil)
	{
		tMutableDictionary[RSSFlux_Settings_StandardSetKey]=@(_standardSet);
		
		tMutableDictionary[RSSFlux_Settings_NumberOfFluxFieldsKey]=@(_numberOFluxFields);
		tMutableDictionary[RSSFlux_Settings_NumberOfParticlesPerFluxFieldKey]=@(_numberOfParticlesPerFluxField);
		tMutableDictionary[RSSFlux_Settings_ParticleSizeKey]=@(_particleSize);
		tMutableDictionary[RSSFlux_Settings_ParticleTrailLengthKey]=@(_particleTrailLength);
		tMutableDictionary[RSSFlux_Settings_GeometryTypeKey]=@(_geometryType);
		tMutableDictionary[RSSFlux_Settings_GeometrySphereComplexityKey]=@(_geometrySphereComplexity);
		
		tMutableDictionary[RSSFlux_Settings_RandomizationFrequencyKey]=@(_randomizationFrequency);
		tMutableDictionary[RSSFlux_Settings_ExpansionRateKey]=@(_expansionRate);
		tMutableDictionary[RSSFlux_Settings_RotationRateKey]=@(_rotationRate);
		tMutableDictionary[RSSFlux_Settings_CrossWindSpeedKey]=@(_crossWindSpeed);
		tMutableDictionary[RSSFlux_Settings_InstabilityKey]=@(_instability);
		 
		tMutableDictionary[RSSFlux_Settings_MotionBlurKey]=@(_motionBlur);
	}
	
	return [tMutableDictionary copy];
}

#pragma mark -

- (void)resetSettings
{
	_standardSet=RSSFluxSetRegular;
	
	[self resetSettingsToStandardSet:_standardSet];
}

- (void)resetSettingsToStandardSet:(RSSFluxSet)inSet;
{
	switch(inSet)
	{
		case RSSFluxSetRegular:
			
			_numberOFluxFields=1;
			_numberOfParticlesPerFluxField=20;
			_particleSize=15;
			_particleTrailLength=40;
			_geometryType=RSSFluxGeometryTypeLights;
			_geometrySphereComplexity=1;
			
			_randomizationFrequency=0;
			_expansionRate=40;
			_rotationRate=30;
			_crossWindSpeed=20;
			_instability=20;
			_motionBlur=0;
			
			break;
			
		case RSSFluxSetHypnotic:
			
			_numberOFluxFields=2;
			_numberOfParticlesPerFluxField=10;
			_particleSize=15;
			_particleTrailLength=40;
			_geometryType=RSSFluxGeometryTypeLights;
			_geometrySphereComplexity=1;
			
			_randomizationFrequency=80;
			_expansionRate=20;
			_rotationRate=0;
			_crossWindSpeed=40;
			_instability=10;
			_motionBlur=30;
			
			break;
			
		case RSSFluxSetInsane:
			
			_numberOFluxFields=4;
			_numberOfParticlesPerFluxField=30;
			_particleSize=25;
			_particleTrailLength=8;
			_geometryType=RSSFluxGeometryTypeLights;
			_geometrySphereComplexity=1;
			
			_randomizationFrequency=0;
			_expansionRate=80;
			_rotationRate=60;
			_crossWindSpeed=40;
			_instability=100;
			_motionBlur=10;
			
			break;
			
		case RSSFluxSetSparklers:
			
			_numberOFluxFields=3;
			_numberOfParticlesPerFluxField=20;
			_particleSize=20;
			_particleTrailLength=6;
			_geometryType=RSSFluxGeometryTypeSpheres;
			_geometrySphereComplexity=3;
			
			_randomizationFrequency=85;
			_expansionRate=60;
			_rotationRate=30;
			_crossWindSpeed=20;
			_instability=30;
			_motionBlur=0;
			
			break;
			
		case RSSFluxSetParadigm:
			
			_numberOFluxFields=1;
			_numberOfParticlesPerFluxField=40;
			_particleSize=5;
			_particleTrailLength=40;
			_geometryType=RSSFluxGeometryTypeLights;
			_geometrySphereComplexity=1;
			
			_randomizationFrequency=90;
			_expansionRate=30;
			_rotationRate=20;
			_crossWindSpeed=10;
			_instability=5;
			_motionBlur=10;
			
			break;
			
		case RSSFluxSetGalactic:
			
			_numberOFluxFields=1;
			_numberOfParticlesPerFluxField=2;
			_particleSize=10;
			_particleTrailLength=1500;
			_geometryType=RSSFluxGeometryTypeLights;
			_geometrySphereComplexity=1;
			
			_randomizationFrequency=0;
			_expansionRate=5;
			_rotationRate=25;
			_crossWindSpeed=0;
			_instability=5;
			_motionBlur=0;
			
			break;
			
		default:
			
			NSLog(@"This should not be invoked for set: %u",(unsigned int)inSet);
			
			break;
	}
}

@end
