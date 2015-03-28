#import <Preferences/Preferences.h>
#import <spawn.h>

#define kWidth [[UIApplication sharedApplication] keyWindow].frame.size.width

#define kTintColor [UIColor colorWithRed:86.0/256.0 green:86.0/256.0 blue:92.0/256.0 alpha:1.0]

@interface SpringBoard : UIApplication
- (void)_relaunchSpringBoardNow;
- (void)reboot;
- (void)powerDown;
@end

@interface JellyLockClock8ListController: PSListController {
}
@end

@implementation JellyLockClock8ListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"JellyLockClock8" target:self] retain];
	}
	return _specifiers;
}
- (id)initForContentSize:(CGSize)size {
    self = [super initForContentSize:size];

    UIBarButtonItem *respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(respringWasTouched)];
    [self.navigationItem setRightBarButtonItem:respringButton];

    return self;
}

-(void) respringWasTouched {
	pid_t pid;
    int status;
    const char* args[] = { "killall", "-9", "SpringBoard", NULL };
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);
	//[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] keyWindow].tintColor = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] keyWindow].tintColor = kTintColor;
}

-(void)setTitle:(id)title {
    [super setTitle:nil];
}

@end

@interface JellyLockClock8Header : PSTableCell{
  UILabel *header;
  UILabel *footer;
  UILabel *easterEggText;
  UILabel *easterEggText2;
  UILabel *easterEggText3;
  UILabel *easterEggText4;
  UIImageView *_cellImageView;
}
@end
 
@implementation JellyLockClock8Header
    - (id)initWithSpecifier:(PSSpecifier *)specifier{     
      self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JellyLockClock8Header" specifier:specifier];
     if (self) {
        CGRect frame = CGRectMake(0, -570, 500, 720);
        CGRect randFrame = CGRectMake(0, 25, kWidth, 60);
        CGRect randFrame2 = CGRectMake(0, 70, kWidth, 60);
        CGRect centeredText = CGRectMake(0,-200, kWidth,60);
        CGRect centeredText2 = CGRectMake(0,-300, kWidth,60);
        CGRect centeredText3 = CGRectMake(0,-400, kWidth,60);
        CGRect centeredText4 = CGRectMake(0,-500, kWidth,100);

        UIImage *image = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/JellyLockClock8.bundle/Pingu_final.png"];
        _cellImageView = [[UIImageView alloc] initWithImage:image];
        _cellImageView.frame = CGRectMake(0,-650,359,392);
        [self addSubview:_cellImageView];

        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = kTintColor;

        header = [[UILabel alloc] initWithFrame:randFrame];
        [header setNumberOfLines:1];
        header.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:36];
        [header setText:@"JellyLockClock8"];
        [header setBackgroundColor:[UIColor clearColor]];
        header.textColor = [UIColor whiteColor];
        header.textAlignment = NSTextAlignmentCenter;

        footer = [[UILabel alloc] initWithFrame:randFrame2];
        [footer setNumberOfLines:1];
        footer.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        [footer setText:@"Enjoy :)"];
        [footer setBackgroundColor:[UIColor clearColor]];
        footer.textColor = [UIColor whiteColor];
        footer.textAlignment = NSTextAlignmentCenter;

        easterEggText = [[UILabel alloc] initWithFrame:centeredText];
        [easterEggText setNumberOfLines:1];
        easterEggText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        easterEggText.text = @"something";
        [easterEggText setBackgroundColor:[UIColor clearColor]];
        easterEggText.textColor = [UIColor whiteColor];
        easterEggText.textAlignment = NSTextAlignmentCenter;

        easterEggText2 = [[UILabel alloc] initWithFrame:centeredText2];
        [easterEggText2 setNumberOfLines:1];
        easterEggText2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        easterEggText.text = @"something else";
        [easterEggText2 setBackgroundColor:[UIColor clearColor]];
        easterEggText2.textColor = [UIColor whiteColor];
        easterEggText2.textAlignment = NSTextAlignmentCenter;

        easterEggText3 = [[UILabel alloc] initWithFrame:centeredText3];
        [easterEggText3 setNumberOfLines:1];
        easterEggText3.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        easterEggText3.text = @"something else else";
        [easterEggText3 setBackgroundColor:[UIColor clearColor]];
        easterEggText3.textColor = [UIColor whiteColor];
        easterEggText3.textAlignment = NSTextAlignmentCenter;

        easterEggText4 = [[UILabel alloc] initWithFrame:centeredText4];
        [easterEggText4 setNumberOfLines:3];
        easterEggText4.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        [easterEggText4 setText:@"something something else else"];
        [easterEggText4 setBackgroundColor:[UIColor clearColor]];
        easterEggText4.textColor = [UIColor whiteColor];
        easterEggText4.textAlignment = NSTextAlignmentCenter;

        //[self addSubview:backgroundView];
        [self addSubview:view];
        [self addSubview:easterEggText];
        [self addSubview:easterEggText2];
        [self addSubview:easterEggText3];
        [self addSubview:easterEggText4];
        [self addSubview:header];
        [self addSubview:footer];

    }
    return self;
}
 
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
    return 150.f;
}
@end
// vim:ft=objc
