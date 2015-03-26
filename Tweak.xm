#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

bool enabled;
NSString *someString;


static void loadPreferences() {
    CFPreferencesAppSynchronize(CFSTR("com.greeny.jellylockclock8"));
    //In this case, you get the value for the key "enabled"
    //you could do the same thing for any other value, just cast it to id and use the conversion methods
    //if the value doesn't exist (i.e. the user hasn't changed their preferences), it is set to the value after the "?:" (in this case, YES and @"default", respectively
    enabled = [(id)CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR("com.greeny.jellylockclock8")) boolValue];
    someString = [(id)CFPreferencesCopyAppValue(CFSTR("someString"), CFSTR("com.greeny.jellylockclock8")) stringValue];
}

%hook SBFLockScreenDateView
- (void)_addLabels{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    NSLog(@"User's current time in their preference format:%@",currentTime);
    //User's current time in their preference format:7:56 pm

    CGRect randFrame = CGRectMake(0, -50, kScreenWidth, 50);

    UILabel *mainTime = [[UILabel alloc] initWithFrame:randFrame];
    
    mainTime.text = currentTime;
    NSLog(@"Hey, we've been called! BATMAN! %@", currentTime);
    mainTime.numberOfLines = 1;
    mainTime.font = [UIFont fontWithName:@"Avenir-Heavy" size:26];
    mainTime.textColor = [UIColor whiteColor];
    mainTime.textAlignment = NSTextAlignmentCenter;

    [self addSubview:mainTime];


}
%end

void getSystemTime(){
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    [dateFormatter release];
    NSLog(@"User's current time in their preference format:%@",currentTime);
    //User's current time in their preference format:7:56 pm
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                NULL,
                                (CFNotificationCallback)loadPreferences,
                                CFSTR("com.greeny.jellylockclock8/prefsChanged"),
                                NULL,
                                CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPreferences();
    getSystemTime();
}

/* THANK YOU STACK OVERFLOW

// get current date/time
NSDate *today = [NSDate date];
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
// display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
NSString *currentTime = [dateFormatter stringFromDate:today];
[dateFormatter release];
NSLog(@"User's current time in their preference format:%@",currentTime);

*/

/* CODE FROM PROTEAN - COULD BE OF SOME HELP

@interface SBStatusBarStateAggregator : NSObject
-(void)_updateTimeItems;
@end

int current = 1;
NSDate *now;
NSDate *previous = [NSDate date];


%hook SBStatusBarStateAggregator

-(id)init {

    self = %orig;

    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateTimeItems) name:NSSystemClockDidChangeNotification object:nil];
    }

    return self;
}

-(void)_updateTimeItems {
    now = [NSDate date];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *nowComps = [calendar components: NSMinuteCalendarUnit fromDate:now];
    NSInteger nowMin = [nowComps minute];

    //NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *prevComps = [calendar components: NSMinuteCalendarUnit fromDate:previous];
    NSInteger prevMin = [prevComps minute];

    if (nowMin>prevMin) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *defaultDateString = [dateFormatter stringFromDate:[NSDate date]];
        NSString *currentItem;
        if (current == 1) {
            currentItem = @"Messages";
            current += 1;
        } else {
            currentItem = @"Twitter";
            current = 1;
        }
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"'%@' - '%@'",defaultDateString,currentItem]];
        MSHookIvar<NSDateFormatter *>(self, "_timeItemDateFormatter") = dateFormatter;
        dateFormatter = nil;
    }
    
    %orig;
    previous = now;
    [self performSelector:@selector(_updateTimeItems) withObject:self afterDelay:2.0];

}

%end

*/