@interface _UILegibilityView : UIView
@end 

@interface _UILegibilityLabel : _UILegibilityView {

    BOOL _usesSecondaryColor;
    NSString* _string;
    UIFont* _font;

}

@property (nonatomic,copy) NSString * string;                        //@synthesize string=_string - In the implementation block
@property (nonatomic,retain) UIFont * font;                          //@synthesize font=_font - In the implementation block
@property (nonatomic,readonly) BOOL usesSecondaryColor;              //@synthesize usesSecondaryColor=_usesSecondaryColor - In the implementation block
@property (nonatomic,readonly) double baselineOffset; 
-(void)dealloc;
-(CGSize)sizeThatFits:(CGSize)arg1 ;
-(NSString *)string;
-(void)setFont:(UIFont *)arg1 ;
-(UIFont *)font;
-(double)baselineOffset;
-(void)setString:(NSString *)arg1 ;
-(void)updateImage;
-(BOOL)usesSecondaryColor;
-(id)initWithSettings:(id)arg1 strength:(double)arg2 string:(id)arg3 font:(id)arg4 options:(long long)arg5 ;
-(id)initWithSettings:(id)arg1 strength:(double)arg2 string:(id)arg3 font:(id)arg4 ;
@end

@interface SBFLockScreenDateView : UIView
-(void)_layoutTimeLabel;
-(id)_timeFont;
@end