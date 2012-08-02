#import "FlashRuntimeExtensions.h"
#import "BaseExtension.h"
#import <CoreMotion/CoreMotion.h>
#import <AudioToolbox/AudioServices.h>
#import <UIKit/UIKit.h>

@implementation BaseExtension

@synthesize context;

static BaseExtension *sharedInstance = nil;
static bool sharedInstanceAllow = NO;

-(BaseExtension*)init
{
    if( sharedInstanceAllow )
    {
        funcList = [[NSMutableArray alloc] initWithObjects:nil];
        return self;
    }
    else
    {
        NSException* exception = [NSException
                                  exceptionWithName:@"IllegalOperation"
                                  reason:@"You must use static method 'instance' for get instance of class."
                                  userInfo:nil];
        @throw exception;

    }
}

+ (BaseExtension *)instance {
    if (sharedInstance == nil) 
    { 
        sharedInstanceAllow = YES;
        sharedInstance = [[super allocWithZone:NULL] init];
        sharedInstanceAllow = NO;
    } 
    return sharedInstance;
}

+(id)alloc
{
    if( sharedInstanceAllow )
    {
        return [super alloc];
    }
    else
    {
        NSException* exception = [NSException
                                  exceptionWithName:@"IllegalOperation"
                                  reason:@"You must use static method 'instance' for get instance of class."
                                  userInfo:nil];
        @throw exception;
    }
	return nil;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [sharedInstance retain];
}

- (id)copyWithZone:(NSZone *)zone 
{
    return self;
}

- (id)retain 
{
    return self;
}

- (NSUInteger)retainCount 
{
    return NSUIntegerMax;
}

- (void)release
{ 
}

- (id)autorelease 
{
    return self;
}

-(void) dealloc
{
    [funcList release];
    funcList = nil;
    [super dealloc]; 
}

-(NSUInteger)length
{
    return [funcList count];
}

-(void)registerFunction:(FREFunction)function withAlias:(const NSString*)alias;
{
    FRENamedFunction *f = (FRENamedFunction*)malloc(sizeof(FRENamedFunction));
    f->name             = (const uint8_t*)[alias UTF8String];
    f->functionData     = NULL;
    f->function         = function;
    [funcList addObject:[NSValue valueWithPointer:f]];
}

-(FRENamedFunction*)list
{
    FRENamedFunction* list =(FRENamedFunction*)malloc(sizeof(FRENamedFunction) * [self length]);
    int index = 0;
    for (NSValue *value in funcList)
    {
        list[index++] = *(FRENamedFunction*)[value pointerValue];
    }
    return list;
}

-(void)dispatchEvent:(NSString*) code:(NSString*) level
{
    FREDispatchStatusEventAsync(self.context, (const uint8_t*)[code UTF8String] , (const uint8_t*)[level UTF8String]);
}

-(void)dispatchEvent:(NSString*) code
{
    FREDispatchStatusEventAsync(self.context, (const uint8_t*)[code UTF8String] , (const uint8_t*)[@"" UTF8String]);
}

@end