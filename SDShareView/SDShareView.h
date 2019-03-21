






#import <UIKit/UIKit.h>

typedef void(^ShareResultBlock)(BOOL isSuccess);

@interface SDShareView : UIView

/** 分享结果 */
@property (nonatomic, copy) ShareResultBlock resultBlock;

/**
 *  分享
 *
 *  @param content     @{@"text":@"",@"image":@"",@"url":@""}
 *  @param resultBlock 结果
 */
+ (void)showShareViewWithPublishContent:(id)content
                                 Result:(ShareResultBlock)resultBlock;
/**
 *  分享
 *
 *  @param content     @{@"text":@"",@"image":@"",@"url":@""}
 *  @param resultBlock 结果
 */
- (void)initPublishContent:(id)content
                    Result:(ShareResultBlock)resultBlock;

@end
