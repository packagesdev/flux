
#import "RSSFluxConfigurationWindowController.h"

#import "RSSFluxSettings.h"

#import "RSSCollectionView.h"

#import "RSSCollectionViewItem.h"

@interface RSSFluxConfigurationWindowController ()
{
	IBOutlet RSSCollectionView *_settingsCollectionView;
	
	IBOutlet NSSlider * _numberOfFluxFieldsSlider;
	IBOutlet NSTextField * _numberOfFluxFieldsLabel;
	
	IBOutlet NSSlider * _numberOfParticlesPerFluxSlider;
	IBOutlet NSTextField * _numberOfParticlesPerFluxLabel;
	
	IBOutlet NSSlider * _particleSizeSlider;
	IBOutlet NSTextField * _particleSizeLabel;
	
	IBOutlet NSSlider * _particleTrailLengthSlider;
	IBOutlet NSTextField * _particleTrailLengthLabel;
	
	
	IBOutlet NSPopUpButton * _geometryTypePopupButton;
	
	IBOutlet NSTextField * _sphereGeometryComplexityLeftLabel;
	IBOutlet NSSlider * _sphereGeometryComplexitySlider;
	IBOutlet NSTextField * _sphereGeometryComplexityLabel;
	
	
	IBOutlet NSSlider * _randomizationFrequencySlider;
	IBOutlet NSTextField * _randomizationFrequencyLabel;
	
	IBOutlet NSSlider * _rotationRateSlider;
	IBOutlet NSTextField * _rotationRateLabel;
	
	IBOutlet NSSlider * _expansionRateSlider;
	IBOutlet NSTextField * _expansionRateLabel;
	
	IBOutlet NSSlider * _crosswindSpeedSlider;
	IBOutlet NSTextField * _crosswindSpeedLabel;
	
	IBOutlet NSSlider * _instabilitySlider;
	IBOutlet NSTextField * _instabilityLabel;
	
	IBOutlet NSSlider * _motionBlurSlider;
	IBOutlet NSTextField * _motionBlurLabel;
	
	
	NSNumberFormatter * _numberFormatter;
}

- (void)_selectCollectionViewItemWithTag:(NSInteger)inTag;

- (void)_setAsCustomSet;

- (void)_updateSphereComplexityUI;

- (IBAction)setNumberOfFluxFields:(id)sender;
- (IBAction)setNumberOfParticlesPerFlux:(id)sender;
- (IBAction)setParticleSize:(id)sender;
- (IBAction)setParticleSTrailLength:(id)sender;

- (IBAction)setGeometryType:(id)sender;
- (IBAction)setSphereGeometryComplexity:(id)sender;

- (IBAction)setRandomizationFrequency:(id)sender;
- (IBAction)setRotationrate:(id)sender;
- (IBAction)setExpansionRate:(id)sender;
- (IBAction)setCrosswindSpeed:(id)sender;
- (IBAction)setInstability:(id)sender;
- (IBAction)setMotionBlur:(id)sender;

@end

@implementation RSSFluxConfigurationWindowController

- (void)dealloc
{
	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

- (Class)settingsClass
{
	return [RSSFluxSettings class];
}

- (void)windowDidLoad
{
	[super windowDidLoad];
	
	_numberFormatter=[[NSNumberFormatter alloc] init];
	
	if (_numberFormatter!=nil)
	{
		_numberFormatter.hasThousandSeparators=YES;
		_numberFormatter.localizesFormat=YES;
	}
	
	NSBundle * tBundle=[NSBundle bundleForClass:[self class]];
	
	NSArray * tStandardSettingsArray=@[@{
										   RSSCollectionViewRepresentedObjectThumbnail : @"regular_thumbnail",
										   RSSCollectionViewRepresentedObjectTag : @(RSSFluxSetRegular),
										   RSSCollectionViewRepresentedObjectName : NSLocalizedStringFromTableInBundle(@"Regular",@"Localized",tBundle,@"")
										   },
									   @{
										   RSSCollectionViewRepresentedObjectThumbnail : @"hypnotic_thumbnail",
										   RSSCollectionViewRepresentedObjectTag : @(RSSFluxSetHypnotic),
										   RSSCollectionViewRepresentedObjectName : NSLocalizedStringFromTableInBundle(@"Hypnotic",@"Localized",tBundle,@"")
										   },
									   @{
										   RSSCollectionViewRepresentedObjectThumbnail : @"insane_thumbnail",
										   RSSCollectionViewRepresentedObjectTag : @(RSSFluxSetInsane),
										   RSSCollectionViewRepresentedObjectName : NSLocalizedStringFromTableInBundle(@"Insane",@"Localized",tBundle,@"")
										   },
									   @{
										   RSSCollectionViewRepresentedObjectThumbnail : @"sparklers_thumbnail",
										   RSSCollectionViewRepresentedObjectTag : @(RSSFluxSetSparklers),
										   RSSCollectionViewRepresentedObjectName : NSLocalizedStringFromTableInBundle(@"Sparklers",@"Localized",tBundle,@"")
										   },
									   @{
										   RSSCollectionViewRepresentedObjectThumbnail : @"paradigm_thumbnail",
										   RSSCollectionViewRepresentedObjectTag : @(RSSFluxSetParadigm),
										   RSSCollectionViewRepresentedObjectName : NSLocalizedStringFromTableInBundle(@"Paradigm",@"Localized",tBundle,@"")
										   },
									   @{
										   RSSCollectionViewRepresentedObjectThumbnail : @"galactic_thumbnail",
										   RSSCollectionViewRepresentedObjectTag : @(RSSFluxSetGalactic),
										   RSSCollectionViewRepresentedObjectName : NSLocalizedStringFromTableInBundle(@"Galactic",@"Localized",tBundle,@"")
										   },
									   @{
										   RSSCollectionViewRepresentedObjectThumbnail : @"random_thumbnail",
										   RSSCollectionViewRepresentedObjectTag : @(RSSFluxSetRandom),
										   RSSCollectionViewRepresentedObjectName : NSLocalizedStringFromTableInBundle(@"Random",@"Localized",tBundle,@"")
										   },
									   @{
										   RSSCollectionViewRepresentedObjectThumbnail : @"custom_thumbnail",
										   RSSCollectionViewRepresentedObjectTag : @(RSSFluxSetCustom),
										   RSSCollectionViewRepresentedObjectName : NSLocalizedStringFromTableInBundle(@"Custom",@"Localized",tBundle,@"")
										   }];
	
	[_settingsCollectionView setContent:tStandardSettingsArray];
	
	/*[[NSDistributedNotificationCenter defaultCenter] addObserver:self
														selector:@selector(preferredScrollerStyleDidChange:)
															name:NSPreferredScrollerStyleDidChangeNotification
														  object:nil
											  suspensionBehavior:NSNotificationSuspensionBehaviorDeliverImmediately];*/
}

- (void)restoreUI
{
	NSString * tFormattedString;
	
	[super restoreUI];
	
	RSSFluxSettings * tFluxSettings=(RSSFluxSettings *) sceneSettings;
	
	[self _selectCollectionViewItemWithTag:tFluxSettings.standardSet];
	
	
	[_numberOfFluxFieldsSlider setIntegerValue:tFluxSettings.numberOFluxFields];
	[_numberOfFluxFieldsLabel setIntegerValue:tFluxSettings.numberOFluxFields];
	
	[_numberOfParticlesPerFluxSlider setIntegerValue:tFluxSettings.numberOfParticlesPerFluxField];
	tFormattedString=[_numberFormatter stringFromNumber:[NSNumber numberWithUnsignedInteger:tFluxSettings.numberOfParticlesPerFluxField]];
	[_numberOfParticlesPerFluxLabel setStringValue:tFormattedString];
	
	
	[_particleSizeSlider setIntegerValue:tFluxSettings.particleSize];
	[_particleSizeLabel setIntegerValue:tFluxSettings.particleSize];
	
	[_particleTrailLengthSlider setIntegerValue:tFluxSettings.particleTrailLength];
	tFormattedString=[_numberFormatter stringFromNumber:[NSNumber numberWithUnsignedInteger:tFluxSettings.particleTrailLength]];
	[_particleTrailLengthLabel setStringValue:tFormattedString];
	
	
	
	[_geometryTypePopupButton selectItemWithTag:tFluxSettings.geometryType];
	
	[_sphereGeometryComplexitySlider setIntegerValue:tFluxSettings.geometrySphereComplexity];
	[_sphereGeometryComplexityLabel setIntegerValue:tFluxSettings.geometrySphereComplexity];
	
	[self _updateSphereComplexityUI];
	
	
	[_randomizationFrequencySlider setIntegerValue:tFluxSettings.randomizationFrequency];
	[_randomizationFrequencyLabel setIntegerValue:tFluxSettings.randomizationFrequency];
	
	[_rotationRateSlider setIntegerValue:tFluxSettings.rotationRate];
	[_rotationRateLabel setIntegerValue:tFluxSettings.rotationRate];
	
	[_expansionRateSlider setIntegerValue:tFluxSettings.expansionRate];
	[_expansionRateLabel setIntegerValue:tFluxSettings.expansionRate];
	
	[_crosswindSpeedSlider setIntegerValue:tFluxSettings.crossWindSpeed];
	[_crosswindSpeedLabel setIntegerValue:tFluxSettings.crossWindSpeed];
	
	[_instabilitySlider setIntegerValue:tFluxSettings.instability];
	[_instabilityLabel setIntegerValue:tFluxSettings.instability];
	
	[_motionBlurSlider setIntegerValue:tFluxSettings.motionBlur];
	[_motionBlurLabel setIntegerValue:tFluxSettings.motionBlur];
}

#pragma mark -

- (void)_selectCollectionViewItemWithTag:(NSInteger)inTag
{
	[_settingsCollectionView.content enumerateObjectsUsingBlock:^(NSDictionary * bDictionary,NSUInteger bIndex,BOOL * bOutStop){
		NSNumber * tNumber=bDictionary[RSSCollectionViewRepresentedObjectTag];
		
		if (tNumber!=nil)
		{
			if (inTag==[tNumber integerValue])
			{
				[_settingsCollectionView RSS_selectItemAtIndex:bIndex];
				
				*bOutStop=YES;
			}
		}
	}];
}

- (void)_setAsCustomSet
{
	RSSFluxSettings * tFluxSettings=(RSSFluxSettings *) sceneSettings;
	
	if (tFluxSettings.standardSet!=RSSFluxSetCustom)
	{
		tFluxSettings.standardSet=RSSFluxSetCustom;
		
		[self _selectCollectionViewItemWithTag:tFluxSettings.standardSet];
	}
}

- (void)_updateSphereComplexityUI
{
	RSSFluxSettings * tFluxSettings=(RSSFluxSettings *) sceneSettings;
	
	if (tFluxSettings.geometryType!=RSSFluxGeometryTypeSpheres)
	{
		[_sphereGeometryComplexityLeftLabel setTextColor:[NSColor secondaryLabelColor]];
		
		[_sphereGeometryComplexitySlider setEnabled:NO];
		
		[_sphereGeometryComplexityLabel setHidden:YES];
	}
	else
	{
		[_sphereGeometryComplexityLeftLabel setTextColor:[NSColor labelColor]];
		
		[_sphereGeometryComplexitySlider setEnabled:YES];
		
		[_sphereGeometryComplexityLabel setHidden:NO];
	}
}

- (IBAction)setNumberOfFluxFields:(id)sender
{
	RSSFluxSettings * tFluxSettings=(RSSFluxSettings *) sceneSettings;
	
	if (tFluxSettings.numberOFluxFields!=[sender integerValue])
	{
		tFluxSettings.numberOFluxFields=[sender integerValue];
		
		[_numberOfFluxFieldsLabel setIntegerValue:tFluxSettings.numberOFluxFields];
		
		[self _setAsCustomSet];
	}
}

- (IBAction)setNumberOfParticlesPerFlux:(id)sender
{
	RSSFluxSettings * tFluxSettings=(RSSFluxSettings *) sceneSettings;
	
	if (tFluxSettings.numberOfParticlesPerFluxField!=[sender integerValue])
	{
		tFluxSettings.numberOfParticlesPerFluxField=[sender integerValue];
		
		NSString * tFormattedString=[_numberFormatter stringFromNumber:[NSNumber numberWithUnsignedInteger:tFluxSettings.numberOfParticlesPerFluxField]];
		
		[_numberOfParticlesPerFluxLabel setStringValue:tFormattedString];
		
		[self _setAsCustomSet];
	}
}

- (IBAction)setParticleSize:(id)sender
{
	RSSFluxSettings * tFluxSettings=(RSSFluxSettings *) sceneSettings;
	
	if (tFluxSettings.particleSize!=[sender integerValue])
	{
		tFluxSettings.particleSize=[sender integerValue];
		
		[_particleSizeLabel setIntegerValue:tFluxSettings.particleSize];
		
		[self _setAsCustomSet];
	}
}

- (IBAction)setParticleSTrailLength:(id)sender
{
	RSSFluxSettings * tFluxSettings=(RSSFluxSettings *) sceneSettings;
	
	if (tFluxSettings.particleTrailLength!=[sender integerValue])
	{
		tFluxSettings.particleTrailLength=[sender integerValue];
		
		NSString * tFormattedString=[_numberFormatter stringFromNumber:[NSNumber numberWithUnsignedInteger:tFluxSettings.particleTrailLength]];
		
		[_particleTrailLengthLabel setStringValue:tFormattedString];
		
		[self _setAsCustomSet];
	}
}


- (IBAction)setGeometryType:(id)sender
{
	RSSFluxSettings * tFluxSettings=(RSSFluxSettings *) sceneSettings;
	
	if (tFluxSettings.geometryType!=[sender selectedTag])
	{
		tFluxSettings.geometryType=[sender selectedTag];
		
		[self _updateSphereComplexityUI];
		
		[self _setAsCustomSet];
	}
}

- (IBAction)setSphereGeometryComplexity:(id)sender
{
	RSSFluxSettings * tFluxSettings=(RSSFluxSettings *) sceneSettings;
	
	if (tFluxSettings.geometrySphereComplexity!=[sender integerValue])
	{
		tFluxSettings.geometrySphereComplexity=[sender integerValue];
		
		[_sphereGeometryComplexityLabel setIntegerValue:tFluxSettings.geometrySphereComplexity];
		
		[self _setAsCustomSet];
	}
}

- (IBAction)setRandomizationFrequency:(id)sender
{
	RSSFluxSettings * tFluxSettings=(RSSFluxSettings *) sceneSettings;
	
	if (tFluxSettings.randomizationFrequency!=[sender integerValue])
	{
		tFluxSettings.randomizationFrequency=[sender integerValue];
		
		[_randomizationFrequencyLabel setIntegerValue:tFluxSettings.randomizationFrequency];
		
		[self _setAsCustomSet];
	}
}

- (IBAction)setRotationrate:(id)sender
{
	RSSFluxSettings * tFluxSettings=(RSSFluxSettings *) sceneSettings;
	
	if (tFluxSettings.rotationRate!=[sender integerValue])
	{
		tFluxSettings.rotationRate=[sender integerValue];
		
		[_rotationRateLabel setIntegerValue:tFluxSettings.rotationRate];
		
		[self _setAsCustomSet];
	}
}

- (IBAction)setExpansionRate:(id)sender
{
	RSSFluxSettings * tFluxSettings=(RSSFluxSettings *) sceneSettings;
	
	if (tFluxSettings.expansionRate!=[sender integerValue])
	{
		tFluxSettings.expansionRate=[sender integerValue];
		
		[_expansionRateLabel setIntegerValue:tFluxSettings.expansionRate];
		
		[self _setAsCustomSet];
	}
}

- (IBAction)setCrosswindSpeed:(id)sender
{
	RSSFluxSettings * tFluxSettings=(RSSFluxSettings *) sceneSettings;
	
	if (tFluxSettings.crossWindSpeed!=[sender integerValue])
	{
		tFluxSettings.crossWindSpeed=[sender integerValue];
		
		[_crosswindSpeedLabel setIntegerValue:tFluxSettings.crossWindSpeed];
		
		[self _setAsCustomSet];
	}
}

- (IBAction)setInstability:(id)sender
{
	RSSFluxSettings * tFluxSettings=(RSSFluxSettings *) sceneSettings;
	
	if (tFluxSettings.instability!=[sender integerValue])
	{
		tFluxSettings.instability=[sender integerValue];
		
		[_instabilityLabel setIntegerValue:tFluxSettings.instability];
		
		[self _setAsCustomSet];
	}
}

- (IBAction)setMotionBlur:(id)sender
{
	RSSFluxSettings * tFluxSettings=(RSSFluxSettings *) sceneSettings;
	
	if (tFluxSettings.motionBlur!=[sender integerValue])
	{
		tFluxSettings.motionBlur=[sender integerValue];
		
		[_motionBlurLabel setIntegerValue:tFluxSettings.motionBlur];
		
		[self _setAsCustomSet];
	}
}


#pragma mark -

- (BOOL)RSS_collectionView:(NSCollectionView *)inCollectionView shouldSelectItemAtIndex:(NSInteger)inIndex
{
	RSSCollectionViewItem * tCollectionViewItem=(RSSCollectionViewItem *)[_settingsCollectionView itemAtIndex:inIndex];
	
	if (tCollectionViewItem!=nil)
	{
		NSInteger tTag=tCollectionViewItem.tag;
		
		if (tTag==RSSFluxSetCustom)
			return NO;
	}
	
	return YES;
}

- (void)RSS_collectionViewSelectionDidChange:(NSNotification *)inNotification
{
	if (inNotification.object==_settingsCollectionView)
	{
		NSIndexSet * tIndexSet=[_settingsCollectionView selectionIndexes];
		NSUInteger tIndex=[tIndexSet firstIndex];
		
		RSSCollectionViewItem * tCollectionViewItem=(RSSCollectionViewItem *)[_settingsCollectionView itemAtIndex:tIndex];
		
		if (tCollectionViewItem!=nil)
		{
			NSInteger tTag=tCollectionViewItem.tag;
			RSSFluxSettings * tFluxSettings=(RSSFluxSettings *) sceneSettings;
			
			if (tFluxSettings.standardSet!=tTag)
			{
				tFluxSettings.standardSet=tTag;
				
				if (tTag!=RSSFluxSetRandom)
				{
					[tFluxSettings resetSettingsToStandardSet:tTag];
					
					[self restoreUI];
				}
			}
		}
	}
}

@end
