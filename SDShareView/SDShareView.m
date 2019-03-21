







#import "SDShareView.h"
#import "SDShareItemButton.h"




//背景色
#define SHARE_BG_COLOR                        SHARE_RGBAColor(239, 240, 241, 1)
//高
#define SHARE_BG_HEIGHT                       SHARE_WindowHeight/2.6
//
#define SHARE_SCROLLVIEW_HEIGHT               (SHARE_BG_HEIGHT-40)/2
//item宽
#define SHARE_ITEM_WIDTH                      SHARE_WindowWidth*0.15
//左间距
#define SHARE_ITEM_SPACE_LEFT                 15
//间距
#define SHARE_ITEM_SPACE                      10
//第一行 item  base tag
#define ROW1BUTTON_TAG                        1000
//第二行 item base tag
#define ROW2BUTTON_TAG                        600
//item base tag
#define BUTTON_TAG                            700
//背景view tag
#define BG_TAG                                1234
//分享模糊背景view tag
#define BG_ITEM_TAG                           1235


#define FT_WEIBO_APPKEY         @"2645776991"
#define FT_WEIBO_APPSECRET      @"785818577abc810dfac71fa7c59d1957"
#define FT_WEIBO_CALLBACK_URL   @"http://sns.whalecloud.com/sina2/callback"

static id _publishContent;
static SDShareView *shareView = nil;

@interface SDShareView ()
{
    NSArray *_DataArray;
    NSMutableArray *_ButtonTypeShareArray1;
    NSMutableArray *_ButtonTypeShareArray2;
    NSArray *_typeArray1;
    NSArray *_typeArray2;
}
@end

@implementation SDShareView

/**
 *  分享
 *
 *  @param content     内容
 *  @param resultBlock 结果
 */
+ (void)showShareViewWithPublishContent:(id)content
                                 Result:(ShareResultBlock)resultBlock{
    
    [[self alloc] initPublishContent:content
                              Result:resultBlock];
}
/**
 *  分享
 *
 *  @param content     内容
 *  @param resultBlock 结果
 */
- (void)initPublishContent:(id)content
                    Result:(ShareResultBlock)resultBlock{
    
    _publishContent = content;
    if (!shareView) {
        shareView = [[SDShareView alloc] init];
    }
    [self initData];
    [self initShareUI];
    
    resultBlock = self.resultBlock;
}

#pragma mark - 初始化数据
- (void)initData{
    
    //加载 item 的标题和图片
    _DataArray = @[@{@(0):@[@{@"朋友圈":@"shareIcons.bundle/share_wechatpyq"}
                            ,@{@"微信好友":@"shareIcons.bundle/share_wechat"}
                            ,@{@"手机QQ":@"shareIcons.bundle/share_qq"}
                            ,@{@"QQ空间":@"shareIcons.bundle/share_qqzone"}
                            ,@{@"新浪微博":@"shareIcons.bundle/share_sina"}]}
                   
                   ,@{@(1):@[@{@"短信":@"shareIcons.bundle/share_sms"}
                             ,@{@"邮件":@"shareIcons.bundle/share_mail"}
                             ,@{@"复制链接":@"shareIcons.bundle/share_copy"}]}];

    _ButtonTypeShareArray1 = [NSMutableArray array];
    _ButtonTypeShareArray2 = [NSMutableArray array];
}

/**
 *  初始化视图
 */
- (void)initShareUI{
    
    CGRect orginRect = CGRectMake(0, SHARE_WindowHeight, SHARE_WindowWidth, SHARE_BG_HEIGHT);
    
    CGRect finaRect = orginRect;
    finaRect.origin.y =  SHARE_WindowHeight-SHARE_BG_HEIGHT;
    
    /***************************** 添加底层bgView ********************************************/
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHARE_WindowWidth, SHARE_WindowHeight)];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    bgView.tag = BG_TAG;
    [window addSubview:bgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:shareView action:@selector(dismissShareView)];
    [bgView addGestureRecognizer:tap1];
    
    /********************* 添加分享shareBGView ******************/
    UIVisualEffectView *shareBGView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    shareBGView.frame = orginRect;
    shareBGView.userInteractionEnabled = YES;
    shareBGView.tag = BG_ITEM_TAG;
    shareBGView.backgroundColor = [SHARE_BG_COLOR colorWithAlphaComponent:0.5];
    [bgView addSubview:shareBGView];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:shareView action:@selector(tapNoe)];
    [shareBGView.contentView addGestureRecognizer:tap2];
    
    /********************* 添加item *********************************/
    for (int i = 0; i<_DataArray.count; i++) {
        UIScrollView *rowScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, i*(SHARE_SCROLLVIEW_HEIGHT+0.5), shareBGView.width, SHARE_SCROLLVIEW_HEIGHT)];
        rowScrollView.directionalLockEnabled = YES;
        rowScrollView.showsVerticalScrollIndicator = NO;
        rowScrollView.showsHorizontalScrollIndicator = NO;
        rowScrollView.backgroundColor = [UIColor clearColor];
        [shareBGView.contentView addSubview:rowScrollView];
        
        /* add item */
        NSArray *itemArray = _DataArray[i][@(i)];
        rowScrollView.contentSize = CGSizeMake((SHARE_ITEM_WIDTH+SHARE_ITEM_SPACE_LEFT+SHARE_ITEM_SPACE)*itemArray.count, SHARE_SCROLLVIEW_HEIGHT);
        //按钮数组
        for (NSDictionary *itemDict in itemArray) {
            NSInteger index           = [itemArray indexOfObject:itemDict];
            SDShareItemButton *button = [SDShareItemButton shareButton];
            CGFloat itemHeight        = SHARE_ITEM_WIDTH+15;
            CGFloat itemY             = (SHARE_SCROLLVIEW_HEIGHT-itemHeight)/2;
            
            NSInteger imageTag = 0;
            if (i == 0) {
                [_ButtonTypeShareArray1 addObject:button];
                imageTag = ROW1BUTTON_TAG+index;
            } else {
                imageTag = ROW2BUTTON_TAG+index;
                [_ButtonTypeShareArray2 addObject:button];
            }
            button = [[SDShareItemButton alloc] initWithFrame:CGRectMake(SHARE_ITEM_SPACE_LEFT+index*(SHARE_ITEM_WIDTH+SHARE_ITEM_SPACE), itemY+SHARE_ITEM_WIDTH, SHARE_ITEM_WIDTH, itemHeight)
                                                ImageName:[itemDict allValues][0]
                                                 imageTag:imageTag
                                                    title:[itemDict allKeys][0]
                                                titleFont:10
                                               titleColor:[UIColor blackColor]];
            
            button.tag = BUTTON_TAG+imageTag;
            [button addTarget:shareView
                       action:@selector(shareTypeClickIndex:)
             forControlEvents:UIControlEventTouchUpInside];
            
            [rowScrollView addSubview:button];
            if (i == 0) {
                [_ButtonTypeShareArray1 addObject:button];
            } else {
                [_ButtonTypeShareArray2 addObject:button];
            }
            
        }
        if (i == 0) {
            /*line*/
            UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(SHARE_ITEM_SPACE_LEFT, rowScrollView.height, shareBGView.width-SHARE_ITEM_SPACE_LEFT*2, 0.5)];
            lineView.backgroundColor = SHARE_RGBAColor(210, 210, 210, 1);
            [shareBGView.contentView addSubview:lineView];
        }
    }
    /****************************** 取消 ********************************************/
    UIView *cancelView =[[UIView alloc] init];
    cancelView.frame = CGRectMake(0, shareBGView.height-40, shareBGView.width, 40);
    [shareBGView.contentView addSubview:cancelView];
    
    
    
    UIButton *cancleButton = [[UIButton alloc] init];
    cancleButton.frame = cancelView.bounds;
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = SHARE_Font(16);
    cancleButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleButton addTarget:shareView action:@selector(dismissShareView) forControlEvents:UIControlEventTouchUpInside];
    [cancelView addSubview:cancleButton];
    
    /****************************** 动画 *********************/
    shareBGView.alpha = 0;
    [UIView animateWithDuration:0.25
                     animations:^{
                         bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                         shareBGView.frame = finaRect;
                         shareBGView.alpha = 1;
                     } completion:^(BOOL finished) {
                         
                     }];
    
    
    for (SDShareItemButton *button in _ButtonTypeShareArray1) {
        NSInteger idx = [_ButtonTypeShareArray1 indexOfObject:button];
        
        [UIView animateWithDuration:0.5+idx*0.1 delay:0 usingSpringWithDamping:0.52 initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGRect buttonFrame = [button frame];
            buttonFrame.origin.y -= SHARE_ITEM_WIDTH;
            button.frame = buttonFrame;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    for (SDShareItemButton *button in _ButtonTypeShareArray2) {
        NSInteger idx = [_ButtonTypeShareArray2 indexOfObject:button];
        
        [UIView animateWithDuration:0.9+idx*0.1 delay:0 usingSpringWithDamping:0.52 initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGRect buttonFrame = [button frame];
            buttonFrame.origin.y -= SHARE_ITEM_WIDTH;
            button.frame = buttonFrame;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

#pragma mark - 分享 item 点击
- (void)shareTypeClickIndex:(UIButton *)btn{
    
    NSInteger tag = btn.tag-BUTTON_TAG;
    NSInteger intV = tag % ROW1BUTTON_TAG;
    NSInteger intV1 = tag % ROW2BUTTON_TAG;
    NSInteger countRow1 = _typeArray1.count;
    NSInteger countRow2 = _typeArray2.count;
    
    // share type
    NSUInteger typeUI = 0;
    if (intV>=0&&intV<=countRow1) {
        NSLog(@"第一行");
        typeUI = [_typeArray1[intV] unsignedIntegerValue];
        
    } else if (intV1>=0&&intV1<=countRow2){
        NSLog(@"第2行");
        typeUI = [_typeArray2[intV1] unsignedIntegerValue];
    }
    
    //built share parames
    NSDictionary *shareContent = (NSDictionary *)_publishContent;
    NSString *text             = shareContent[@"text"];
    NSString *imageName             = shareContent[@"image"];
    NSString *url              = shareContent[@"url"];
   
    NSLog(@"%zd",tag);
    
    
    
    
    [self dismissShareView];
    
    
}

#pragma mark - 消失动画
- (void)dismissShareView{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:BG_TAG];
    UIVisualEffectView *shareBGView = [window viewWithTag:BG_ITEM_TAG];
    [UIView animateWithDuration:0.3
                     animations:^{
                         blackView.alpha = 0;
                         CGRect shareBGFrame = [shareBGView frame];
                         shareBGFrame.origin.y = SHARE_WindowHeight;
                         shareBGView.frame = shareBGFrame;
                     }
                     completion:^(BOOL finished) {
                         
                         [blackView removeFromSuperview];
                         
                     }];
    
}

- (void)tapNoe{
    
}

@end
