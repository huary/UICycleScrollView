//
//  ViewController.m
//  UICycleScrollViewDemo
//
//  Created by captain on 16/12/21.
//  Copyright © 2016年 yzh. All rights reserved.
//

#import "ViewController.h"
#import "UICycleScrollView.h"
#import "UIImageBrowserView.h"
#import "UIView+WebCache.h"
#import "UIImageView+WebCache.h"
#import "CycleScrollViewController.h"

@interface ViewController () </*UICycleScrollViewDelegate,UIScrollViewDelegate*/ UIImageBrowserViewDelegate>

//@property (nonatomic, assign) NSInteger cnt;
//@property (nonatomic, strong) UICycleScrollView *cycleScrollView;
////@property (nonatomic, assign) NSInteger currentIndex;
//
//@property (nonatomic, strong) UIScrollView *currentView;

@property (nonatomic, strong) UIImageBrowserView *imageBrowserView;
@property (nonatomic, assign) NSInteger cnt;
@property (nonatomic, assign) NSInteger style;

@property (nonatomic, strong) NSArray *imageURLs;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setUpChildView];
    
//    [self test];
    
//    [self initData];
//    [self setUpChildViewNew];
    
    [self _setupChildView];
}

-(void)initData
{
    self.imageURLs = @[@"https://img.dlodlo.com/2016/05/05/o8NvkxwpbqT6vZc9HjuLcAtc.png",
                       @"https://img.dlodlo.com/2017/02/11/v4Cw25uxzIJVOC0m09y5dcHY.jpg",
                       @"https://img.dlodlo.com/2016/12/26/iMmINN-VSBGrWemSqyNNg7XL.png",
                       @"https://img.dlodlo.com/2017/01/20/17WgUpKWoQyw7z1NwoSiEgYE.png",
                       @"https://img.dlodlo.com/2016/12/19/XI6Uxkgjb2q0hQvmgpoV2XsG.png",
                       @"https://img.dlodlo.com/2017/01/20/H8luD3JyCqMrY2yFe4VtcTSO.jpg",
                       @"https://img.dlodlo.com/2016/05/03/YYWBlwmaKiYfMzPouAOTGz5p.png",
                       @"https://img.dlodlo.com/2017/01/19/KhvItKFY1Nu9yLMBEZYrxTjh.png",
                       @"https://img.dlodlo.com/2017/01/16/iEQTxq4tiG7Z8Xo2gjH2GQ8T.png"];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [imageView sd_view_setImageWithURL:[NSURL URLWithString:@"http://img.dlodlo.com/2016/08/11/0grer2U05_vBx9RT8Y83qBxp.jpg"] loadCompletionCallback:^(UIImage *image) {
//        NSLog(@"image=%@",image);
//    }];
    /*
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://img.dlodlo.com/2016/08/11/0grer2U05_vBx9RT8Y83qBxp.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        NSLog(@"--------image=%@",image);
    }];
     */
//    [self.view addSubview:imageView];
}

-(void)setUpChildViewNew
{
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = 1;
    btn1.frame = CGRectMake((SCREEN_BOUNDS.size.width-300)/2, 150, 300, 50);
    [btn1 setTitle:@"样式1" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:PURPLE_COLOR];
    [btn1 addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 2;
    btn2.frame = CGRectMake((SCREEN_BOUNDS.size.width-300)/2, 300, 300, 50);
    [btn2 setTitle:@"样式2" forState:UIControlStateNormal];
    [btn2 setBackgroundColor:ORANGE_COLOR];
    [btn2 addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.tag = 3;
    btn3.frame = CGRectMake((SCREEN_BOUNDS.size.width-300)/2, 450, 300, 50);
    [btn3 setTitle:@"样式3" forState:UIControlStateNormal];
    [btn3 setBackgroundColor:BROWN_COLOR];
    [btn3 addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.tag = 4;
    btn4.frame = CGRectMake((SCREEN_BOUNDS.size.width-300)/2, 600, 300, 50);
    [btn4 setTitle:@"网络图片" forState:UIControlStateNormal];
    [btn4 setBackgroundColor:[UIColor colorWithRed:0.1 green:0.4 blue:0.7 alpha:1]];
    [btn4 addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
}

-(void)action:(UIButton *)sender
{
    self.style = sender.tag;
    [self test];
}

#if 0
-(void)setUpChildView
{
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
////    imageView.center = self.view.center;
//    imageView.image =[UIImage imageNamed:@"2.jpg"];
//    [self.view addSubview:imageView];
    
    CGFloat rem = 0;
//    UICycleScrollView *cycleScrollView = [[UICycleScrollView alloc] initWithFrame:CGRectMake(rem, 0, SCREEN_WIDTH-2 * rem, SCREEN_HEIGHT)];
    CGRect frame = CGRectMake(rem, 0, SCREEN_WIDTH-2 * rem, SCREEN_HEIGHT);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-2 * rem, SCREEN_HEIGHT)];
    UICycleScrollView *cycleScrollView = [[UICycleScrollView alloc] initWithFrame:frame andSpecialScrollView:scrollView];
    cycleScrollView.delegate = self;
    cycleScrollView.pageSpace = 20;
    cycleScrollView.backgroundColor = BLACK_COLOR;
//    cycleScrollView.scrollTimeInterval = 2.0;
    cycleScrollView.autoScroll = NO;
    cycleScrollView.cycleScroll = NO;
    scrollView.bounces = YES;
    self.cnt = 4;
    [self.view addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    
}

-(NSInteger)numberOfPagesInCycleScrollView:(UICycleScrollView*)cycleScrollView
{
    return self.cnt;
}

-(UIView*)cycleScrollView:(UICycleScrollView*)cycleScrollView viewForPageAtIndexPath:(NSInteger)index
{
    NSString *imageName = [NSString stringWithFormat:@"%ld.jpg",index+1];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.cycleScrollView.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:imageName];
    
//    UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:imageView.bounds];
//    imageScrollView.backgroundColor = WHITE_COLOR;
////    imageScrollView.contentSize = imageView.bounds.size;
//    imageScrollView.minimumZoomScale = 1.0;
//    imageScrollView.maximumZoomScale = 3.0;
//    imageScrollView.delegate = self;
//    
//    [imageScrollView addSubview:imageView];
//    
//    return imageScrollView;
//
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleAction:)];
//    doubleTap.numberOfTapsRequired = 2;
//    [imageScrollView addGestureRecognizer:doubleTap];
//    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
//    [imageScrollView addGestureRecognizer:longPress];
    
    
    
    
    UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:imageView.bounds];
//    imageScrollView.backgroundColor = BLACK_COLOR;//[UIColor redColor];
    imageView.backgroundColor = PURPLE_COLOR;
////    imageView.layer.anchorPoint = CGPointMake(0, 0);
//    imageScrollView.zoomScale = 1.0;
    imageScrollView.minimumZoomScale = 0.1;
    imageScrollView.maximumZoomScale = 2.0;
    imageScrollView.delegate = self;
////    imageScrollView.bounces = YES;
////    imageScrollView.userInteractionEnabled = NO;
//    
////        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleAction:)];
////        doubleTap.numberOfTapsRequired = 2;
////        [imageScrollView addGestureRecognizer:doubleTap];
//    
////    NSLog(@"imageView.bounds.size.height=%f",imageView.bounds.size.height);
//    
//    
//    imageScrollView.contentSize = CGSizeMake(imageView.bounds.size.width, imageView.bounds.size.height + 0.01);
    imageScrollView.contentSize = CGSizeMake(imageView.bounds.size.width, imageView.bounds.size.height + 0.01);
////    imageScrollView.contentOffset = CGPointMake(0, 0.5 * imageView.bounds.size.height);
////    imageView.frame = CGRectMake(0, 0 * imageView.bounds.size.height, imageView.bounds.size.width, imageView.bounds.size.height);
    [imageScrollView addSubview:imageView];
//
    [imageScrollView.panGestureRecognizer addTarget:self action:@selector(panAction:)];
//
////    [subView addSubview:imageScrollView];
//    
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
////    [subView addGestureRecognizer:panGesture];
////    return subView;
    return imageScrollView;
}

-(void)cycleScrollView:(UICycleScrollView*)cycleScrollView didSelectedForPageAtIndex:(NSInteger)index
{
    NSLog(@"didSelect=%ld",index);
}

-(void)cycleScrollView:(UICycleScrollView *)cycleScrollView currentSelectedPageAtIndex:(NSInteger)index
{
//    self.currentIndex = index;
    NSLog(@"currentSelectedPageAtIndex=%d",index);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    NSLog(@"subviews=%@,cycleScrollView=%@",self.view.subviews,self.cycleScrollView);
//    [self.cycleScrollView removeFromSuperview];
////    self.cycleScrollView.autoCycleScroll = NO;
//    self.cycleScrollView = nil;
    ++self.cnt;
    [self.cycleScrollView reloadData];
}


-(void)doubleAction:(UITapGestureRecognizer*)sender
{
    UIScrollView *view = sender.view;
    CGFloat scale = view.zoomScale;
    
//    if (view.zoomScale > view.minimumZoomScale) {
//        scale = view.minimumZoomScale;
//    }
//    else
//    {
//        scale = view.maximumZoomScale;
//    }
    scale -= 0.1;
    
    NSLog(@"scale=%f",scale);
    [view setZoomScale:scale animated:YES];
}

//-(void)singleActioin:(UITapGestureRecognizer*)sender
//{
//    UIScrollView *view = sender.view;
//    [view setZoomScale:1 animated:YES];
//}

-(void)longPressAction:(id)sender
{
    NSLog(@"sender=%@",sender);
}


-(void)panAction:(UIPanGestureRecognizer*)sender
{
    NSLog(@"sender=%@",sender);
    CGPoint shiftOffset = [sender translationInView:sender.view];
    NSLog(@"shiftOffset=(%f,%f)",shiftOffset.x,shiftOffset.y);

    UIScrollView *scrollView = sender.view;//[[sender.view subviews] firstObject];
    
    CGFloat scale = 1 - shiftOffset.y/600;
    scale = MIN(scale, scrollView.maximumZoomScale);
    scale = MAX(scale, scrollView.minimumZoomScale);
    
    NSLog(@"scale=%f",scale);
//    [scrollView setZoomScale:scale];
    CGAffineTransform t1 = CGAffineTransformMakeScale(scale, scale);
    CGAffineTransform t2 = CGAffineTransformMakeTranslation(shiftOffset.x, shiftOffset.y/100);
    UIView *view = [scrollView.subviews firstObject];
//    view.transform = t1;//CGAffineTransformConcat(t1, t2);
//    view.center = [sender locationInView:sender.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [sender locationInView:sender.view];
        
        CGPoint pt = CGPointMake(point.x/sender.view.bounds.size.width, point.y/sender.view.bounds.size.height);
        view.layer.anchorPoint = pt;//CGPointMake(0, 0);
    }
    
    view.bounds = CGRectMake(0, 0, scrollView.bounds.size.width * scale, scrollView.bounds.size.height * scale);
    view.center = [sender locationInView:sender.view];
//    view.center = CGPointMake(scrollView.center.x + shiftOffset.x, scrollView.center.y + shiftOffset.y);

    self.cycleScrollView.alpha = scale;
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"end");
//        [scrollView.subviews firstObject].transform = CGAffineTransformMakeScale(1.0, 1.0);
//        [scrollView.subviews firstObject].center = sender.view.center;
//        [self.cycleScrollView removeFromSuperview];
    }
}

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    scrollView.contentOffset = CGPointMake(0, 0);
//}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
////    NSLog(@"x=%f,y=%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
//    
////    NSLog(@"scrollView=%@",scrollView);
////    NSLog(@"scrollgestureView=%@",scrollView.panGestureRecognizer.view);
//    
////    CGFloat shiftY = self.cycleScrollView.bounds.size.height/2 -  scrollView.contentOffset.y;
//    
////    NSLog(@"panGestureRecognizer=%@",scrollView.panGestureRecognizer);
//    
//    CGPoint shiftOffset = CGPointZero;
//    if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateBegan || scrollView.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        shiftOffset = [scrollView.panGestureRecognizer translationInView:self.cycleScrollView];
//        NSLog(@"shiftOffset=(%f,%f)",shiftOffset.x,shiftOffset.y);
//        
//        CGFloat scale = 1 - shiftOffset.y/320;
//        scale = MIN(scale, scrollView.maximumZoomScale);
//        scale = MAX(scale, scrollView.minimumZoomScale);
//        
//        NSLog(@"shiftY=%f,scale=%f",shiftOffset.y,scale);
//        //    NSLog(@"zoomScale=%f",scrollView.zoomScale);
//        //    [scrollView setZoomScale:scrollView.zoomScale animated:YES];
////        dispatch_async(dispatch_get_main_queue(), ^{
////            [scrollView setZoomScale:scale];
////        });
//    }
////    if (scrollView.panGestureRecognizer.state) {
////        <#statements#>
////    }
//    
//
//    
//
//}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
//    CGPoint shiftOffset = CGPointZero;
//    if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateBegan || scrollView.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        shiftOffset = [scrollView.panGestureRecognizer translationInView:self.cycleScrollView];
//        NSLog(@"shiftOffset=(%f,%f)",shiftOffset.x,shiftOffset.y);
//        
//        CGFloat scale = 1 - shiftOffset.y/320;
//        scale = MIN(scale, scrollView.maximumZoomScale);
//        scale = MAX(scale, scrollView.minimumZoomScale);
//        
//        NSLog(@"----------shiftY=%f,scale=%f",shiftOffset.y,scale);
//        //    NSLog(@"zoomScale=%f",scrollView.zoomScale);
//        //    [scrollView setZoomScale:scrollView.zoomScale animated:YES];
//        [scrollView setZoomScale:scale];
//    }
    scrollView.contentSize = CGSizeMake(self.cycleScrollView.bounds.size.width, self.cycleScrollView.bounds.size.height + 0.01);

}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}

#endif

-(void)test
{
    CGFloat rem = 0;
    //    UICycleScrollView *cycleScrollView = [[UICycleScrollView alloc] initWithFrame:CGRectMake(rem, 0, SCREEN_WIDTH-2 * rem, SCREEN_HEIGHT)];
    CGRect frame = CGRectMake(rem, 0, SCREEN_WIDTH-2 * rem, SCREEN_HEIGHT);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-2 * rem, SCREEN_HEIGHT)];
    
    UIImageBrowserView *imageBrowserView = [[UIImageBrowserView alloc] initWithFrame:frame andSpecialScrollView:scrollView];
    imageBrowserView.delegate = self;
    imageBrowserView.pageSpace = 20;
    imageBrowserView.backgroundColor = BLACK_COLOR;
    imageBrowserView.autoScroll = NO;
    imageBrowserView.cycleScroll = NO;
//    imageBrowserView.autoFullScale = NO;
    scrollView.bounces = YES;
    self.cnt = 17;
    [self.view addSubview:imageBrowserView];
    self.imageBrowserView = imageBrowserView;
}

-(NSInteger)numberOfPagesInImageBrowserView:(UIImageBrowserView*)imageBrowserView
{
    if (self.style == 4) {
        NSLog(@"cnt=%ld",self.imageURLs.count);
        return self.imageURLs.count;
    }
    return self.cnt;
}

//-(UIView*)imageBrowserView:(UIImageBrowserView*)imageBrowserView viewForPageAtIndexPath:(NSInteger)index
//{
//    NSString *imageName = [NSString stringWithFormat:@"%ld.jpg",index+1];
////    NSString *imageName=@"5.jpg";
//    UIImage *image = [UIImage imageNamed:imageName];
////    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.imageBrowserView.bounds];
////    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
//    CGFloat whRatio = image.size.width/image.size.height;
//    CGFloat w = imageBrowserView.bounds.size.width;
//    CGFloat h = w/whRatio;
//    
////    if (self.style == 2) {
//        if (h > imageBrowserView.bounds.size.height) {
//            h = imageBrowserView.bounds.size.height;
//            w = h * whRatio;
//        }
////    }
//    
//    CGFloat x = (imageBrowserView.bounds.size.width - w)/2;
//    CGFloat y = (imageBrowserView.bounds.size.height-h)/2;
//    y = MAX(0, y);
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    
//    imageView.image = image;
//    return imageView;
//}

-(void)imageBrowserView:(UIImageBrowserView *)imageBrowserView zoomViewCell:(UIZoomScrollViewCell *)zoomViewCell atIndexPath:(NSInteger)index showZoomImageView:(showZoomImageViewBlock)showZoomImageView
{
    
    NSString *imageName = [NSString stringWithFormat:@"%ld.jpg",index+1];
    UIImage *image = [UIImage imageNamed:imageName];
    if (image == nil) {
        imageName = [NSString stringWithFormat:@"%ld.png",index+1];
        image = [UIImage imageNamed:imageName];
    }
    
    UIImageInfo *imageInfo = [[UIImageInfo alloc] initWithImage:image imageSize:CGSizeZero];
    
    if (self.style == 1) {
        showZoomImageView(imageInfo,UIImageViewContentTypeNull,UIImageViewContentTypeNull);
    }
    else if (self.style == 2)
    {
        showZoomImageView(imageInfo,UIImageViewContentTypeScaleAspectFill,UIImageViewContentTypeScaleAspectFit);
    }
    else if (self.style == 3)
    {
        showZoomImageView(imageInfo,UIImageViewContentTypeScaleAspectFit, UIImageViewContentTypeActualFill);
    }
    else if (self.style == 4)
    {
        NSString *urlString = self.imageURLs[index];
        NSLog(@"urlString=%@",urlString);
        [zoomViewCell sd_view_setImageWithURL:[NSURL URLWithString:urlString] loadCompletionCallback:^(UIImage *image) {
            showZoomImageView(imageInfo,UIImageViewContentTypeNull, UIImageViewContentTypeNull);
        }];
    }
}

-(void)imageBrowserView:(UIImageBrowserView*)imageBrowserView didSelectedForPageAtIndex:(NSInteger)index
{
    NSLog(@"%s,didselected----index=%ld",__FUNCTION__,index);
}

-(void)imageBrowserView:(UIImageBrowserView*)imageBrowserView currentSelectedPageAtIndex:(NSInteger)index
{
    NSLog(@"currentSelectedPageAtIndex=%ld",index);
}

-(void)imageBrowserViewRemoveFromSuperView:(UIImageBrowserView *)imageBrowserView
{
    self.imageBrowserView = nil;
}




/*
 *
 */
-(UIButton*)_createBtnWithTitle:(NSString*)title frame:(CGRect)frame tag:(NSInteger)tag inView:(UIView*)inView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    button.frame = frame;
    button.backgroundColor = PURPLE_COLOR;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(_btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [inView addSubview:button];
    return button;
}

-(void)_btnAction:(UIButton*)sender
{
    if (sender.tag == 1) {
        CycleScrollViewController *cycleScrollVC = [[CycleScrollViewController alloc] init];
        [self presentViewController:cycleScrollVC animated:YES completion:nil];
    }
    else if (sender.tag == 2) {
        
    }
}

-(void)_setupChildView
{
    CGFloat w = SCREEN_WIDTH * 0.8;
    CGFloat h = 50;
    CGRect frame = CGRectMake((SCREEN_WIDTH - w)/2, 100, w, h);
    [self _createBtnWithTitle:@"轮播图" frame:frame tag:1 inView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
