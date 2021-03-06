#import <substrate.h>
#import <UIKit/UIKit.h>

@interface SpringBoard
- (void)setNextAssistantRecognitionStrings:(id)arg1;
@end

@interface SBAssistantController
+ (id)sharedInstance;
- (void)_activateSiriForPPT;
@end

@interface SBUIPluginManager
+ (id)sharedInstance;
- (void)handleButtonUpEventFromSource:(int)source;
@end

// Keep this import here, otherwise..
// error: 'LAActivator' may not respond to 'handleButtonUpEventFromSource:' [-Werror]
#import <libactivator/libactivator.h>

@interface SiriTaggerListener : NSObject <LAListener>
@end

static SpringBoard *springBoard = nil;
static SBAssistantController *assistantController = nil;

@implementation SiriTaggerListener

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
    if (springBoard == nil || assistantController == nil)
        return;
    NSArray *myStrings = [NSArray arrayWithObjects:@"What's this song", nil];
    [springBoard setNextAssistantRecognitionStrings:myStrings];
    [assistantController _activateSiriForPPT];
    // Thanks Ryan!
    [[%c(SBUIPluginManager) sharedInstance] handleButtonUpEventFromSource:1];
    [event setHandled:YES];
}

+ (void)load
{
    @autoreleasepool {
        [LASharedActivator registerListener:[self new] forName:@"com.mohammadag.sirimusictagger"];
    }
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
    return @"What's this song, Siri?";
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
    return @"Invokes Siri's music tagging feature";
}
- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
    return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
}

@end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)fp8 {
    %orig;
    springBoard = self;
}

%end

%hook SBAssistantController

- (void)init {
    %orig;
    assistantController = self;
}

%end