#import "headers.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

bool enabled;
NSString *someString;
CGFloat timeFontSize;

static void loadPreferences() {
    CFPreferencesAppSynchronize(CFSTR("com.greeny.jellylockclock8"));
    //In this case, you get the value for the key "enabled"
    //you could do the same thing for any other value, just cast it to id and use the conversion methods
    //if the value doesn't exist (i.e. the user hasn't changed their preferences), it is set to the value after the "?:" (in this case, YES and @"default", respectively
    enabled = [(id)CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR("com.greeny.jellylockclock8")) boolValue];
    timeFontSize = [(id)CFPreferencesCopyAppValue(CFSTR("timeFontSize"), CFSTR("com.greeny.jellylockclock8")) floatValue];
    someString = [(id)CFPreferencesCopyAppValue(CFSTR("someString"), CFSTR("com.greeny.jellylockclock8")) stringValue];
}

//Function to replace the existing time : with a |
NSString* fixTimeString(NSString *timeString) {
    return [timeString stringByReplacingOccurrencesOfString:@":" withString:@" | "];
}

%hook SBFLockScreenDateView

// The following 3 functions are hooked for updating the label - need to minimize how many

- (void)updateFormat {    
    %orig();

    // Use the legibility label, not sure for the black colored time
    _UILegibilityLabel *mainTime = MSHookIvar<_UILegibilityLabel*>(self, "_legibilityTimeLabel");
    // Change the text
    mainTime.string = fixTimeString(mainTime.string);
    // The following is used for adjusting the size of the time since the extended text is longer than 5 chars (max)
    CGSize stringSize = [mainTime.string sizeWithAttributes:@{NSFontAttributeName:[self _timeFont]}];
    CGRect mainTimeFrame = mainTime.frame;
    mainTimeFrame.size.width = stringSize.width;
    mainTimeFrame.origin.x = (kScreenWidth-stringSize.width)/2;
    mainTime.frame = mainTimeFrame;
    //Same for the next 2
}

- (void)layoutSubviews {
    %orig();

    _UILegibilityLabel *mainTime = MSHookIvar<_UILegibilityLabel*>(self, "_legibilityTimeLabel");
    mainTime.string = fixTimeString(mainTime.string);
    CGSize stringSize = [mainTime.string sizeWithAttributes:@{NSFontAttributeName:[self _timeFont]}];
    CGRect mainTimeFrame = mainTime.frame;
    mainTimeFrame.size.width = stringSize.width;
    mainTimeFrame.origin.x = (kScreenWidth-stringSize.width)/2;
    mainTime.frame = mainTimeFrame;
}

-(void)_updateLabels {
    %orig();

    _UILegibilityLabel *mainTime = MSHookIvar<_UILegibilityLabel*>(self, "_legibilityTimeLabel");
    mainTime.string = fixTimeString(mainTime.string);
    CGSize stringSize = [mainTime.string sizeWithAttributes:@{NSFontAttributeName:[self _timeFont]}];
    CGRect mainTimeFrame = mainTime.frame;
    mainTimeFrame.size.width = stringSize.width;
    mainTimeFrame.origin.x = (kScreenWidth-stringSize.width)/2;
    mainTime.frame = mainTimeFrame;
 }

// Hide the date label perm
-(double)dateAlphaPercentage {
    return 0;
}

// When the layout is called
-(void)_layoutTimeLabel {
    %orig;
    _UILegibilityLabel *mainTime = MSHookIvar<_UILegibilityLabel*>(self, "_legibilityTimeLabel");
    CGSize stringSize = [mainTime.string sizeWithAttributes:@{NSFontAttributeName:[self _timeFont]}];
    CGRect mainTimeFrame = mainTime.frame;
    mainTimeFrame.size.width = stringSize.width;
    mainTimeFrame.origin.x = (kScreenWidth-stringSize.width)/2;
    mainTime.frame = mainTimeFrame;
}

// Change the font
-(id)_timeFont {
    return [UIFont fontWithName:@"Avenir-Heavy" size:timeFontSize];
}

%end

void getSystemTime() {
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