#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, UIPageControlShowStyle)
{
    UIPageControlShowStyleNone,//default
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight,
};

typedef NS_ENUM(NSUInteger, AdTitleShowStyle)
{
    AdTitleShowStyleNone,
    AdTitleShowStyleLeft,
    AdTitleShowStyleCenter,
    AdTitleShowStyleRight,
};

@interface SliderView : UIView<UIScrollViewDelegate>
{
    UILabel * _centerAdLabel;
    CGFloat _adMoveTime;
}

@property (retain,nonatomic,readonly) UIScrollView * adScrollView;
@property (retain,nonatomic,readonly) UIPageControl * pageControl;
@property (retain,nonatomic,readonly) NSArray * imageLinkURL;
@property (retain,nonatomic,readonly) NSArray * adTitleArray;

@property (assign,nonatomic) UIPageControlShowStyle  PageControlShowStyle;

@property (assign,nonatomic,readonly) AdTitleShowStyle  adTitleStyle;


@property (nonatomic,strong) UIImage * placeHoldImage;


@property (nonatomic,assign) BOOL isNeedCycleRoll;


@property (nonatomic,assign) CGFloat  adMoveTime;

@property (nonatomic,strong,readonly) UILabel * centerAdLabel;


@property (nonatomic,strong) void (^callBack)(NSInteger index,NSString * imageURL);


@property (nonatomic,strong) void (^callBackForModel)(id model);



- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle;


- (void)setAdTitlePropertyName:(NSString *)titleName withShowStyle:(AdTitleShowStyle)adTitleStyle;


+ (id)adScrollViewWithFrame:(CGRect)frame imageLinkURL:(NSArray *)imageLinkURL placeHoderImageName:(NSString *)imageName pageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle;


+ (id)adScrollViewWithFrame:(CGRect)frame localImageLinkURL:(NSArray *)imageLinkURL pageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle;


+ (id)adScrollViewWithFrame:(CGRect)frame modelArr:(NSArray *)modelArr imagePropertyName:(NSString *)imageName pageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle;
@end
