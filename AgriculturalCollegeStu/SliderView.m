#import "SliderView.h"
#import "UIImageView+WebCache.h"
#define kAdViewWidth  _adScrollView.bounds.size.width
#define kAdViewHeight  _adScrollView.bounds.size.height
#define HIGHT _adScrollView.bounds.origin.y

@interface SliderView ()
{
    UIImageView * _leftImageView;
    UIImageView * _centerImageView;
    UIImageView * _rightImageView;
    BOOL _isTimeUp;
}

@property (nonatomic,assign) NSUInteger centerImageIndex;
@property (nonatomic,assign) NSUInteger leftImageIndex;
@property (nonatomic,assign) NSUInteger rightImageIndex;
@property (assign,nonatomic,readonly) NSTimer *moveTimer;
@property (retain,nonatomic,readonly) UIImageView * leftImageView;
@property (retain,nonatomic,readonly) UIImageView * centerImageView;
@property (retain,nonatomic,readonly) UIImageView * rightImageView;
@property (nonatomic,strong) NSArray * models;
@end

@implementation SliderView;
@synthesize centerImageIndex;
@synthesize rightImageIndex;
@synthesize leftImageIndex;
@synthesize moveTimer;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _adMoveTime = 3.0;
        _adScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _adScrollView.bounces = NO;
        _adScrollView.delegate = self;
        _adScrollView.pagingEnabled = YES;
        _adScrollView.showsVerticalScrollIndicator = NO;
        _adScrollView.showsHorizontalScrollIndicator = NO;
        _adScrollView.backgroundColor = [UIColor whiteColor];
        _adScrollView.contentOffset = CGPointMake(kAdViewWidth, 0);
        _adScrollView.contentSize = CGSizeMake(kAdViewWidth * 3, kAdViewHeight);
        _adScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAdViewWidth, kAdViewHeight)];
        [_adScrollView addSubview:_leftImageView];
        
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAdViewWidth, 0, kAdViewWidth, kAdViewHeight)];
        _centerImageView.userInteractionEnabled = YES;
        [_centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
        [_adScrollView addSubview:_centerImageView];
        
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAdViewWidth*2, 0, kAdViewWidth, kAdViewHeight)];
        [_adScrollView addSubview:_rightImageView];
        
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _centerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _isNeedCycleRoll = YES;
        [self addSubview:_adScrollView];
    }
    return self;
}

//这个方法会在子视图添加到父视图或者离开父视图时调用
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    //解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
    if (!newSuperview)
    {
        [self.moveTimer invalidate];
        moveTimer = nil;
    }
    else
    {
        [self setUpTime];
    }
}

- (void)setUpTime
{
    if (_isNeedCycleRoll&&_imageLinkURL.count>=2)
    {
        moveTimer = [NSTimer scheduledTimerWithTimeInterval:_adMoveTime target:self selector:@selector(animalMoveImage:) userInfo:nil repeats:YES];
        _isTimeUp = NO;
    }
}

- (void)setIsNeedCycleRoll:(BOOL)isNeedCycleRoll
{
    _isNeedCycleRoll = isNeedCycleRoll;
    if (!_isNeedCycleRoll)
    {
        [moveTimer invalidate];
        moveTimer = nil;
    }
}

+ (id)adScrollViewWithFrame:(CGRect)frame imageLinkURL:(NSArray *)imageLinkURL pageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
{
    if (imageLinkURL.count==0)
        return nil;
    
    SliderView * adView = [[SliderView alloc]initWithFrame:frame];
    [adView setimageLinkURL:imageLinkURL];
    [adView setPageControlShowStyle:PageControlShowStyle];
    return adView;
}

+ (id)adScrollViewWithFrame:(CGRect)frame imageLinkURL:(NSArray *)imageLinkURL placeHoderImageName:(NSString *)imageName pageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
{
    if (imageLinkURL.count==0)
        return nil;
    
    NSMutableArray * imagePaths = [[NSMutableArray alloc]init];
    for (NSString * imageName in imageLinkURL)
    {
        NSURL * imageURL = [NSURL URLWithString:imageName];
        [imagePaths addObject:imageURL];
    }
    SliderView * adView = [SliderView adScrollViewWithFrame:frame imageLinkURL:imageLinkURL   pageControlShowStyle:PageControlShowStyle];
    adView.placeHoldImage = [UIImage imageNamed:imageName];
    return adView;
}

+ (id)adScrollViewWithFrame:(CGRect)frame localImageLinkURL:(NSArray *)imageLinkURL pageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
{
    if (imageLinkURL.count==0)
        return nil;
    
    NSMutableArray * imagePaths = [[NSMutableArray alloc]init];
    for (NSString * imageName in imageLinkURL)
    {
        NSString * path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
        NSAssert(path, @"图片名对应的图片不存在");
        NSURL * imageURL = [NSURL fileURLWithPath:path];
        [imagePaths addObject:imageURL];
    }
    SliderView * adView = [SliderView adScrollViewWithFrame:frame imageLinkURL:imagePaths   pageControlShowStyle:PageControlShowStyle];
    return adView;
}

+ (id)adScrollViewWithFrame:(CGRect)frame modelArr:(NSArray *)modelArr imagePropertyName:(NSString *)imageName pageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
{
    if (modelArr.count==0)
        return nil;
    
    NSMutableArray * imagePaths = [[NSMutableArray alloc]init];
    for (id  model in modelArr)
    {
        NSString * path = [model valueForKey:imageName];
        if (path==nil)
            path = @"";
        [imagePaths addObject:path];
    }
    SliderView * adView = [SliderView adScrollViewWithFrame:frame imageLinkURL:imagePaths   pageControlShowStyle:PageControlShowStyle];
    adView.models = modelArr;
    return adView;
}

- (void)setimageLinkURL:(NSArray *)imageLinkURL
{
    _imageLinkURL = imageLinkURL;
    leftImageIndex = imageLinkURL.count-1;
    centerImageIndex = 0;
    rightImageIndex = 1;
    if (imageLinkURL.count==1)
    {
        _adScrollView.scrollEnabled = NO;
        rightImageIndex = 0;
    }
    
    [_leftImageView sd_setImageWithURL:imageLinkURL[leftImageIndex] placeholderImage:self.placeHoldImage];
    [_centerImageView sd_setImageWithURL:imageLinkURL[centerImageIndex] placeholderImage:self.placeHoldImage];
    [_rightImageView sd_setImageWithURL:imageLinkURL[rightImageIndex] placeholderImage:self.placeHoldImage];
}

- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle
{
    _adTitleArray = adTitleArray;
    
    if(adTitleStyle == AdTitleShowStyleNone)
    {
        return;
    }
    
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, kAdViewHeight - 40, kAdViewWidth, 40)];
    vv.backgroundColor = [UIColor blackColor];
    vv.alpha = 0.2;
    [self addSubview:vv];
    [self bringSubviewToFront:_pageControl];
    
    _centerAdLabel = [[UILabel alloc]init];
    _centerAdLabel.backgroundColor = [UIColor clearColor];
    _centerAdLabel.frame = CGRectMake(8, kAdViewHeight - 40, kAdViewWidth - 20, 40);
    _centerAdLabel.textColor = [UIColor whiteColor];
    _centerAdLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_centerAdLabel];
    
    if (adTitleStyle == AdTitleShowStyleLeft)
    {
        _centerAdLabel.textAlignment = NSTextAlignmentLeft;
    }
    else if (adTitleStyle == AdTitleShowStyleCenter)
    {
        _centerAdLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        _centerAdLabel.textAlignment = NSTextAlignmentRight;
    }
    _centerAdLabel.text = _adTitleArray[centerImageIndex];
}

- (void)setAdTitlePropertyName:(NSString *)titleName withShowStyle:(AdTitleShowStyle)adTitleStyle
{
    if (!self.models)
        return;
    NSMutableArray * titleArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.models.count; i++)
    {
        id model = self.models[i];
        NSString * titleStr = [model valueForKey:titleName];
        if (titleStr==nil)
            titleStr = @"";
        [titleArr addObject:titleStr];
    }
    [self setAdTitleArray:titleArr withShowStyle:adTitleStyle];
}

- (void)setPageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
{
    if (PageControlShowStyle == UIPageControlShowStyleNone||_imageLinkURL.count<=1)
        return;
    
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = _imageLinkURL.count;
    
    if (PageControlShowStyle == UIPageControlShowStyleLeft)
    {
        _pageControl.frame = CGRectMake(0, kAdViewHeight - 20, 20 *_pageControl.numberOfPages, 20);
        
    }
    else if (PageControlShowStyle == UIPageControlShowStyleCenter)
    {
        
        _pageControl.frame = CGRectMake(0, 0, 20 * _pageControl.numberOfPages, 15);
        _pageControl.center = CGPointMake(kAdViewWidth/2.0, kAdViewHeight - 15);
        _pageControl.layer.cornerRadius = 6;
        _pageControl.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        _pageControl.alpha = 1;
        
    }
    else
    {
        _pageControl.frame = CGRectMake(kAdViewWidth - 15*_pageControl.numberOfPages, kAdViewHeight - 25, 10*_pageControl.numberOfPages, 10);
    }
    _pageControl.currentPage = 0;
    _pageControl.enabled = NO;
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:133.0/255.0 green:194.0/255.0 blue:16.0/255.0 alpha:1];
    [self addSubview:_pageControl];
}

- (void)animalMoveImage:(NSTimer *)time
{
    [_adScrollView setContentOffset:CGPointMake(kAdViewWidth * 2, 0) animated:YES];
    _isTimeUp = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_adScrollView.contentOffset.x == 0)
    {
        centerImageIndex = centerImageIndex - 1;
        leftImageIndex = leftImageIndex - 1;
        rightImageIndex = rightImageIndex - 1;
        
        if (leftImageIndex == -1) {
            leftImageIndex = _imageLinkURL.count-1;
        }
        if (centerImageIndex == -1)
        {
            centerImageIndex = _imageLinkURL.count-1;
        }
        if (rightImageIndex == -1)
        {
            rightImageIndex = _imageLinkURL.count-1;
        }
    }
    else if(_adScrollView.contentOffset.x == kAdViewWidth * 2)
    {
        centerImageIndex = centerImageIndex + 1;
        leftImageIndex = leftImageIndex + 1;
        rightImageIndex = rightImageIndex + 1;
        
        if (leftImageIndex == _imageLinkURL.count) {
            leftImageIndex = 0;
        }
        if (centerImageIndex == _imageLinkURL.count)
        {
            centerImageIndex = 0;
        }
        if (rightImageIndex == _imageLinkURL.count)
        {
            rightImageIndex = 0;
        }
    }
    else
    {
        return;
    }
    
    [_leftImageView sd_setImageWithURL:_imageLinkURL[leftImageIndex] placeholderImage:self.placeHoldImage];
    [_centerImageView sd_setImageWithURL:_imageLinkURL[centerImageIndex] placeholderImage:self.placeHoldImage];
    [_rightImageView sd_setImageWithURL:_imageLinkURL[rightImageIndex] placeholderImage:self.placeHoldImage];
    _pageControl.currentPage = centerImageIndex;
    
    if (_adTitleArray)
    {
        if (centerImageIndex<=_adTitleArray.count-1)
        {
            _centerAdLabel.text = _adTitleArray[centerImageIndex];
        }
    }
    _adScrollView.contentOffset = CGPointMake(kAdViewWidth, 0);
    
    if (!_isTimeUp) {
        [moveTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_adMoveTime]];
    }
    _isTimeUp = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [moveTimer invalidate];
    moveTimer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setUpTime];
}

-(void)tap
{
    if (_callBack)
    {
        _callBack(centerImageIndex,_imageLinkURL[centerImageIndex]);
    }
    
    if (self.models&&_callBackForModel)
    {
        _callBackForModel(self.models[centerImageIndex]);
    }
}
@end
