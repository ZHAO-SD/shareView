





#import "SDShareItemButton.h"


@implementation SDShareItemButton

+ (instancetype)shareButton{
    
    return [self buttonWithType:UIButtonTypeCustom];
}

- (UIEdgeInsets)imageEdgeInsets{
    
    return UIEdgeInsetsMake(0,
                            15*SHARE_Width_Scale,
                            30*SHARE_Width_Scale,
                            15*SHARE_Width_Scale);
}

- (instancetype)initWithFrame:(CGRect)frame
                    ImageName:(NSString *)imageName
                     imageTag:(NSInteger)imageTAG
                        title:(NSString *)title
                    titleFont:(CGFloat)titleFont
                   titleColor:(UIColor *)titleColor

{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpShareButtonImageName:imageName
                               imageTag:imageTAG
                                  title:title
                              titleFont:titleFont
                             titleColor:titleColor];
    }
    return self;
}

- (void)setUpShareButtonImageName:(NSString *)imageName
                         imageTag:(NSInteger)imageTAG
                            title:(NSString *)title
                        titleFont:(CGFloat)titleFont
                       titleColor:(UIColor *)titleColor
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.5,0,self.width-5,self.width-5)];
    imageView.tag = imageTAG;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:imageName];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+5, self.width, 10)];
    label.textColor = titleColor;
    label.text = title;
    label.font = SHARE_Font(titleFont);
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
}


@end
