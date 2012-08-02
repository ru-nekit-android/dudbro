#import "FlashRuntimeExtensions.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BaseExtension:NSObject
{
    FREContext context;
@private
    NSMutableArray* funcList;
}

+ (BaseExtension *)instance;

-(void)registerFunction:(FREFunction)function withAlias:(const NSString*)alias;
-(uint)length;
-(BaseExtension*)init;

-(FRENamedFunction*)list;
-(void)dispatchEvent:(NSString*) code:(NSString*) level;
-(void)dispatchEvent:(NSString*) code;

@property FREContext context;

@end