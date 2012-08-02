#import "FlashRuntimeExtensions.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseExtension.h"
#import <AudioToolbox/AudioToolbox.h>

#define FRENF(name) name(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])

BaseExtension* ext;

FREObject FRENF(vibrate)
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	return NULL;
}

FREObject FRENF(getUUID)
{
    FREObject fo;
    NSString *uuid =  [[UIDevice currentDevice] uniqueIdentifier];
    FRENewObjectFromUTF8([uuid length], (const uint8_t*)[uuid UTF8String], &fo);
	return fo;
}

FREObject FRENF(smsGoActivity)
{
    //stub
    return NULL;
}

void DeviceContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) 
{
    ext                 = [BaseExtension instance];
    ext.context         = ctx;
    [ext registerFunction:vibrate               withAlias:@"vibrate"]; 
    [ext registerFunction:getUUID               withAlias:@"getUUID"];
    [ext registerFunction:smsGoActivity         withAlias:@"goSMSActivity"];
    *numFunctionsToTest = [ext length];
    *functionsToSet     = [ext list];
}

void DeviceContextFinalizer(FREContext ctx) 
{
    ext = nil;
	return;
}

void DeviceExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) 
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &DeviceContextInitializer;
    *ctxFinalizerToSet = &DeviceContextFinalizer;
}

void DeviceExtFinalizer(void* extData) 
{
    return;
}