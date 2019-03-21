






#import <UIKit/UIKit.h>

//分享需要的宏
#define SHARE_RGBAColor(r, g, b, a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define SHARE_WindowWidth        ([[UIScreen mainScreen] bounds].size.width)

#define SHARE_WindowHeight       ([[UIScreen mainScreen] bounds].size.height)

#define SHARE_Font(font)         [UIFont systemFontOfSize:(font)]

#define SHARE_Width_Scale        [UIScreen mainScreen].bounds.size.width/375.0f



@interface SDShareItemButton : UIButton
+ (instancetype)shareButton;
- (instancetype)initWithFrame:(CGRect)frame
                    ImageName:(NSString *)imageName
                     imageTag:(NSInteger)imageTAG
                        title:(NSString *)title
                    titleFont:(CGFloat)titleFont
                   titleColor:(UIColor *)titleColor;
@end
