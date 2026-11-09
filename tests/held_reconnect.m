#import "../reconnect/SessionReconnect.m"

static BOOL authenticated;
static NSUInteger requests;

@interface TestAuth : NSObject
@end
@implementation TestAuth
- (BOOL)canAutoLogin { return NO; }
- (BOOL)isLoggedIn { return authenticated; }
- (void)autoLoginWithForce:(BOOL)force {
    (void)force;
    abort();
}
@end

@interface TestLoco : NSObject
@end
@implementation TestLoco
- (void)login { requests++; }
@end

@interface MacTalkCore : NSObject
@end
@implementation MacTalkCore
+ (id)core { return [self new]; }
- (id)auth { return [TestAuth new]; }
- (id)loco { return [TestLoco new]; }
@end

int main(void) {
    @autoreleasepool {
        controller = [SessionReconnectController new];
        controller.holding = YES;
        controller.loginHookReady = YES;
        [controller reconnect:nil];
        NSCAssert(requests == 0 && !controller.reconnecting, @"No authenticated session");
        authenticated = YES;
        [controller reconnect:nil];
        [controller reconnect:nil];
        NSCAssert(requests == 1 && controller.reconnecting, @"Reconnect held session once");
    }
}
