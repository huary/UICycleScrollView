//
//  UICycleScrollView.m
//  yzh
//
//  Created by captain on 16/4/18.
//  Copyright (c) 2016年 dlodlo. All rights reserved.
//

#import "UICycleScrollView.h"
#import "NSWeakProxy.h"

static const NSInteger CYCLE_PAGE_VIEW_COUNT = 3;
static const NSInteger SCROLLVIEW_SUBVIEW_TAG = 1234;

static const CGFloat scrollTimeInterval_s = 5.0;

typedef NS_ENUM(NSInteger, UICycleScrollCellTag)
{
    UICycleScrollCellLeftTag            = 1,
    UICycleScrollCellCenterTag          = 2,
    UICycleScrollCellRightTag           = 3,
};


/*****************************************************************************
 *UICycleScrollCell
 ****************************************************************************/
@interface UICycleScrollCell  : UIView

/** <#注释#> */
@property (nonatomic, strong) UIView *contentView;

@end

@implementation UICycleScrollCell

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self _setupChildView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupChildView];
    }
    return self;
}

-(void)_setupChildView
{
    self.backgroundColor = CLEAR_COLOR;
    self.contentView = [UIView new];
    [self addSubview:self.contentView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

@end

/*****************************************************************************
 *UICycleScrollView
 ****************************************************************************/

@interface UICycleScrollView () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger numberOfPages;

@property (nonatomic, assign) NSInteger cellCnt;

@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGPoint lastContentOffset;

@end

@implementation UICycleScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _setupDefaultData];
        
        [self _setupChildViewWithFrame:frame andSpecialScrollView:nil];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame andSpecialScrollView:(UIScrollView*)scrollView
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupDefaultData];
        
        [self _setupChildViewWithFrame:frame andSpecialScrollView:scrollView];
    }
    return self;
}

-(void)_setupDefaultData
{
    _cellCnt = 0;
    _pageSpace = 0;
    _autoScroll = NO;
    _cycleScroll = YES;
    _prepareLoad = YES;
    _numberOfPages = 0;
    _currentPageIndex = -1;
    _lastContentOffset = CGPointZero;
//    self.clipsToBounds = YES;
}

-(void)_setupChildViewWithFrame:(CGRect)frame andSpecialScrollView:(UIScrollView*)scrollView;
{
    CGRect scrollViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);

    if (scrollView == nil) {
        scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    }
    
    _scrollView = scrollView;
    self.scrollView.frame = scrollViewFrame;
//    self.scrollView.bounces =  NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.pageIndicatorTintColor = LIGHT_GRAY_COLOR;//RAND_COLOR;
    self.pageControl.currentPageIndicatorTintColor = WHITE_COLOR;//RAND_COLOR;
    [self addSubview:self.pageControl];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapAction:)];
    [self addGestureRecognizer:tap];
}

-(void)_tapAction:(UITapGestureRecognizer*)tap
{
    if (self.currentPageIndex >= 0 && [self.delegate respondsToSelector:@selector(cycleScrollView:didSelectedForPageAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectedForPageAtIndex:self.currentPageIndex];
    }
}

-(BOOL)_isNoNumberPageScroll
{
    return self.numberOfPages < 0;
}

-(void)_resetupChildView
{
    NSInteger offsetPages = 1;
    NSInteger cellCnt = MIN(self.numberOfPages, CYCLE_PAGE_VIEW_COUNT);
    if ([self _isNoNumberPageScroll]) {
        self.startPageIndex = 0;
        self.cycleScroll = NO;
        return;
    }
    else {
        if (self.cycleScroll) {
            if (cellCnt == 1) {
                offsetPages = 0;
            }
            else {
                offsetPages = 1;
                cellCnt = CYCLE_PAGE_VIEW_COUNT;
            }
            
        }
        else {
            if (cellCnt == 1) {
                offsetPages = 0;
            }
            else {
                offsetPages = self.startPageIndex;
            }
        }
    }
    [self _updateCellFrameWithCellCnt:cellCnt offset:offsetPages];
}

-(void)_updateCellFrameWithCellCnt:(NSInteger)cellCnt offset:(NSInteger)offset
{
    self.cellCnt = cellCnt;
    
    if (offset >= cellCnt || offset < 0) {
        offset = 0;
    }
    
    CGSize size = self.bounds.size;

    CGFloat itemWidth = size.width + self.pageSpace;
    CGFloat itemHeight = size.height + self.pageSpace;
    if (self.scrollViewStyle == UICycleScrollViewStyleHorizontal) {
        self.scrollView.contentSize = CGSizeMake(itemWidth * cellCnt, size.height);
        self.scrollView.contentOffset = CGPointMake(itemWidth * offset, 0);
    }
    else {
        self.scrollView.contentSize = CGSizeMake(size.width, itemHeight * cellCnt);
        self.scrollView.contentOffset = CGPointMake(0, itemHeight * offset);
    }
    self.lastContentOffset = self.scrollView.contentOffset;
    
    for (NSInteger i = 0; i < CYCLE_PAGE_VIEW_COUNT; ++i) {
        UICycleScrollCell *cell = [self.scrollView viewWithTag:i + 1];
        if (i < self.cellCnt) {
            if (cell == nil) {
                cell = [[UICycleScrollCell alloc] init];
                cell.tag = i + 1;
                [self.scrollView addSubview:cell];
            }
            if (self.scrollViewStyle == UICycleScrollViewStyleHorizontal) {
                cell.frame = CGRectMake(i * itemWidth, 0, itemWidth, size.height);
            }
            else {
                cell.frame = CGRectMake(0, i * itemHeight, size.width, itemHeight);
            }
        }
        else {
            cell.frame = CGRectZero;
        }
    }
}

-(void)_initPageControl:(NSInteger)numberOfPages
{
    CGSize size = [self.pageControl sizeForNumberOfPages:numberOfPages];
    self.pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    self.pageControl.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height - size.height/2);
    self.pageControl.numberOfPages = numberOfPages;
}

-(void)_addToScrollCell:(UICycleScrollCell*)scrollCell subView:(UIView*)subView
{
    if (scrollCell == nil || subView == nil) {
        return;
    }
    [self _clearViewInScrollCell:scrollCell];
    subView.tag = SCROLLVIEW_SUBVIEW_TAG;
    [scrollCell.contentView addSubview:subView];
}

-(void)_addToScrollCellWithTag:(UICycleScrollCellTag)tag subView:(UIView*)subView
{
    if (subView == nil) {
        return;
    }
    UICycleScrollCell *cell = [self.scrollView viewWithTag:tag];
    if (cell == nil) {
        return;
    }
    [self _addToScrollCell:cell subView:subView];
}

-(void)_clearViewInScrollCell:(UICycleScrollCell*)cell
{
    UIView *reuseSubView = [cell.contentView viewWithTag:SCROLLVIEW_SUBVIEW_TAG];
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:prepareForReusedView:)]) {
        [self.delegate cycleScrollView:self prepareForReusedView:reuseSubView];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void)_clearViewInScrollCellWithTag:(UICycleScrollCellTag)tag
{
    UICycleScrollCell *cell = [self.scrollView viewWithTag:tag];
    [self _clearViewInScrollCell:cell];
}

-(void)_removeScrollCellWithTag:(UICycleScrollCellTag)tag
{
    [self _clearViewInScrollCellWithTag:tag];
    UIView *collectionView = [self.scrollView viewWithTag:tag];
    [collectionView removeFromSuperview];
}

-(void)_clearAllScrollCellSubView
{
    [self _clearViewInScrollCellWithTag:UICycleScrollCellLeftTag];
    [self _clearViewInScrollCellWithTag:UICycleScrollCellCenterTag];
    [self _clearViewInScrollCellWithTag:UICycleScrollCellRightTag];
}

-(void)_postCurrentPageIndex:(NSInteger)pageIndex andLastPassedViewWithScrollCell:(UICycleScrollCell*)scrollCell
{
//    UIView *view = [scrollCell.contentView viewWithTag:SCROLLVIEW_SUBVIEW_TAG];
//    if ([self.delegate respondsToSelector:@selector(cycleScrollView:currentPageAtIndex:andLastPassedView:)]) {
//        [self.delegate cycleScrollView:self currentPageAtIndex:pageIndex andLastPassedView:view];
//    }
}

-(NSInteger)_nextPageIndex
{
    NSInteger nextIndex = self.currentPageIndex + 1;
    if ([self _isNoNumberPageScroll]) {
        return nextIndex;
    }
    return nextIndex % self.numberOfPages;
}

-(NSInteger)_prevPageIndex
{
    NSInteger prevIndex = self.currentPageIndex - 1;
    if ([self _isNoNumberPageScroll]) {
        return prevIndex;
    }
    return (prevIndex + self.numberOfPages) % self.numberOfPages;;
}

-(void)_loadSubView
{
    [self _clearAllScrollCellSubView];
    if (self.numberOfPages == 0) {
        return;
    }
    if (![self.delegate respondsToSelector:@selector(cycleScrollView:viewForPageAtIndex:isEnd:)]) {
        return;
    }
    BOOL isEnd = NO;
    if ([self _isNoNumberPageScroll]) {
        self.currentPageIndex = self.startPageIndex;
        NSMutableArray *subViews = [NSMutableArray array];
        UIView *first = [self.delegate cycleScrollView:self viewForPageAtIndex:0 isEnd:&isEnd];
        if (first == nil) {
            return;
        }
        [subViews addObject:first];
        
        UIView *sub = nil;
        //如果0是最后的一个
        if (isEnd == YES) {
            //检测-1的是否存在
            sub = [self.delegate cycleScrollView:self viewForPageAtIndex:-1 isEnd:&isEnd];
            if (sub) {
                [subViews insertObject:sub atIndex:0];
                //如果没有结束,则检测-2的是否存在
                if (!isEnd) {
                    sub = [self.delegate cycleScrollView:self viewForPageAtIndex:-2 isEnd:&isEnd];
                    if (sub) {
                        [subViews insertObject:sub atIndex:0];
                    }
                }
            }
        }
        else {
            //如果0不是最后一个,检测1的是否存在
            sub = [self.delegate cycleScrollView:self viewForPageAtIndex:1 isEnd:&isEnd];
            if (sub) {
                [subViews addObject:sub];
                //如果1存在，检测-1是否存在
                sub = [self.delegate cycleScrollView:self viewForPageAtIndex:-1 isEnd:&isEnd];
                if (sub) {
                    [subViews insertObject:sub atIndex:0];
                }
                else {
                    //如果-1不存在，检测2是否存在
                    sub = [self.delegate cycleScrollView:self viewForPageAtIndex:2 isEnd:&isEnd];
                    if (sub) {
                        [subViews addObject:sub];
                    }
                }
            }
        }
        
        NSInteger offset = 1;
        NSInteger cellCnt = subViews.count;
        if (first == [subViews firstObject]) {
            offset = 0;
        }
        else if (first == [subViews lastObject]) {
            offset = cellCnt - 1;
        }
        [self _updateCellFrameWithCellCnt:cellCnt offset:offset];
        
        [subViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self _addToScrollCellWithTag:idx+1 subView:obj];
        }];
    }
    else {
        if (self.cellCnt == 1) {
            self.currentPageIndex = 0;
            UIView *view = [self.delegate cycleScrollView:self viewForPageAtIndex:0 isEnd:&isEnd];
            [self _addToScrollCellWithTag:UICycleScrollCellLeftTag subView:view];
            return;
        }
        else if (self.cellCnt == 2) {
            self.currentPageIndex = self.startPageIndex;
            UIView *sub = [self.delegate cycleScrollView:self viewForPageAtIndex:self.currentPageIndex isEnd:&isEnd];
            if (self.currentPageIndex == 0) {
                [self _addToScrollCellWithTag:UICycleScrollCellLeftTag subView:sub];
                if (self.prepareLoad) {
                    UIView *next = [self.delegate cycleScrollView:self viewForPageAtIndex:1 isEnd:&isEnd];
                    [self _addToScrollCellWithTag:UICycleScrollCellCenterTag subView:next];
                }
            }
            else {
                [self _addToScrollCellWithTag:UICycleScrollCellCenterTag subView:sub];
                if (self.prepareLoad) {
                    UIView *prev = [self.delegate cycleScrollView:self viewForPageAtIndex:0 isEnd:&isEnd];
                    [self _addToScrollCellWithTag:UICycleScrollCellLeftTag subView:prev];
                }
            }
            return;
        }

        BOOL addToCenter = self.cycleScroll;
        if (self.cycleScroll == NO) {
            if (self.startPageIndex > 0 && self.startPageIndex < self.numberOfPages - 1) {
                addToCenter = YES;
            }
        }
        
        self.currentPageIndex = self.startPageIndex;
        if (addToCenter) {
            for (NSInteger i = 0; i < CYCLE_PAGE_VIEW_COUNT; ++i) {
                NSInteger index = (self.startPageIndex + i) % self.numberOfPages;
                if (i == CYCLE_PAGE_VIEW_COUNT - 1) {
                    if (self.startPageIndex > 0) {
                        index = (self.startPageIndex - 1 ) % self.numberOfPages;
                    }
                    else {
                        index = self.numberOfPages - 1;
                    }
                }
                
                UIView *view = [self.delegate cycleScrollView:self viewForPageAtIndex:index isEnd:&isEnd];
                NSInteger tag = (i + 1)%CYCLE_PAGE_VIEW_COUNT + 1;
                [self _addToScrollCellWithTag:tag subView:view];
                if (self.prepareLoad == NO) {
                    break;
                }
            }
        }
        else {
            if (self.startPageIndex == 0) {
                for (NSInteger i = 0; i < CYCLE_PAGE_VIEW_COUNT; ++i) {
                    UIView *view = [self.delegate cycleScrollView:self viewForPageAtIndex:i isEnd:&isEnd];
                    NSInteger tag = i + 1;
                    [self _addToScrollCellWithTag:tag subView:view];
                    if (self.prepareLoad == NO) {
                        break;
                    }
                }
            }
            else if (self.startPageIndex == self.numberOfPages - 1) {
                for (NSInteger i = 0; i < CYCLE_PAGE_VIEW_COUNT; ++i) {
                    UIView *view = [self.delegate cycleScrollView:self viewForPageAtIndex:self.startPageIndex - i isEnd:&isEnd];
                    NSInteger tag = CYCLE_PAGE_VIEW_COUNT - i;
                    [self _addToScrollCellWithTag:tag subView:view];
                    if (self.prepareLoad == NO) {
                        break;
                    }
                }
            }
        }
    }
}

-(void)_reloadSubView
{
    if (self.numberOfPages == 0 || self.cellCnt == 1) {
        return;
    }
    if (![self.delegate respondsToSelector:@selector(cycleScrollView:viewForPageAtIndex:isEnd:)]) {
        return;
    }
    
    UIView *subView = nil;
    BOOL isEnd = NO;
    CGPoint offset = self.scrollView.contentOffset;
    //往右滚动
    NSInteger scrollDirection = 0;
    if (offset.x > self.lastContentOffset.x || offset.y > self.lastContentOffset.y) {
        scrollDirection = 1;
        self.currentPageIndex = [self _nextPageIndex];
    }
    //往左滚动
    else if (offset.x < self.lastContentOffset.x || offset.y < self.lastContentOffset.y)
    {
        scrollDirection = -1;
        self.currentPageIndex = [self _prevPageIndex];
    }
    else
    {
        return;
    }
    
    NSInteger leftIndex = [self _prevPageIndex];
    NSInteger centerIndex = self.currentPageIndex;
    NSInteger rightIndex = [self _nextPageIndex];
    UICycleScrollCell *leftCell = (UICycleScrollCell*)[self.scrollView viewWithTag:UICycleScrollCellLeftTag];
    UICycleScrollCell *centerCell = (UICycleScrollCell*)[self.scrollView viewWithTag:UICycleScrollCellCenterTag];
    UICycleScrollCell *rightCell = (UICycleScrollCell*)[self.scrollView viewWithTag:UICycleScrollCellRightTag];

    if (self.cellCnt == 2) {
        if (scrollDirection == 1) {
            subView = [centerCell.contentView viewWithTag:SCROLLVIEW_SUBVIEW_TAG];
            if (subView == nil) {
                subView = [self.delegate cycleScrollView:self viewForPageAtIndex:self.currentPageIndex isEnd:&isEnd];
                [self _addToScrollCell:centerCell subView:subView];
            }
        }
        else {
            subView = [leftCell.contentView viewWithTag:SCROLLVIEW_SUBVIEW_TAG];
            if (subView == nil) {
                subView = [self.delegate cycleScrollView:self viewForPageAtIndex:self.currentPageIndex isEnd:&isEnd];
                [self _addToScrollCell:leftCell subView:subView];
            }
        }
        self.lastContentOffset = offset;
        return;
    }
    
    if (scrollDirection == 1) {
        subView = [self.delegate cycleScrollView:self viewForPageAtIndex:self.currentPageIndex isEnd:&isEnd];
        if ((self.cycleScroll == NO && self.currentPageIndex + 1 >= self.numberOfPages) || ([self _isNoNumberPageScroll] && isEnd)) {
            self.lastContentOffset = self.scrollView.contentOffset;
            
            UIView *subViewOld = [rightCell.contentView viewWithTag:SCROLLVIEW_SUBVIEW_TAG];
            if (subViewOld == nil) {
                [self _addToScrollCell:rightCell subView:subView];
            }
            return;
        }

        //leftView
        subView = [centerCell.contentView viewWithTag:SCROLLVIEW_SUBVIEW_TAG];
        if (subView == nil) {
            if (self.prepareLoad) {
                subView = [self.delegate cycleScrollView:self viewForPageAtIndex:leftIndex isEnd:&isEnd];
            }
        }
        else
        {
            [subView removeFromSuperview];
        }
        [self _addToScrollCell:leftCell subView:subView];

        //centerView
        subView = [rightCell.contentView viewWithTag:SCROLLVIEW_SUBVIEW_TAG];
        if (subView == nil) {
            subView = [self.delegate cycleScrollView:self viewForPageAtIndex:centerIndex isEnd:&isEnd];

        }
        else
        {
            [subView removeFromSuperview];
        }
        [self _addToScrollCell:centerCell subView:subView];
        
        //RightView
        if (self.prepareLoad) {
            subView = [self.delegate cycleScrollView:self viewForPageAtIndex:rightIndex isEnd:&isEnd];
            [self _addToScrollCell:rightCell subView:subView];
        }
    }
    else {
        subView = [self.delegate cycleScrollView:self viewForPageAtIndex:self.currentPageIndex isEnd:&isEnd];
        if ((self.cycleScroll == NO && self.currentPageIndex == 0) || ([self _isNoNumberPageScroll] && isEnd)) {
            self.lastContentOffset = self.scrollView.contentOffset;
            
            UIView *subViewOld = [leftCell.contentView viewWithTag:SCROLLVIEW_SUBVIEW_TAG];
            if (subViewOld == nil) {
                [self _addToScrollCell:leftCell subView:subView];
            }
            return;
            
        }

        //RightView
        subView = [centerCell.contentView viewWithTag:SCROLLVIEW_SUBVIEW_TAG];
        if (subView == nil) {
            if (self.prepareLoad) {
                subView = [self.delegate cycleScrollView:self viewForPageAtIndex:rightIndex isEnd:&isEnd];
            }
        }
        else
        {
            [subView removeFromSuperview];
        }
        [self _addToScrollCell:rightCell subView:subView];

        //centerView
        subView = [leftCell.contentView viewWithTag:SCROLLVIEW_SUBVIEW_TAG];
        if (subView == nil) {
            subView = [self.delegate cycleScrollView:self viewForPageAtIndex:centerIndex isEnd:&isEnd];
        }
        else
        {
            [subView removeFromSuperview];
        }
        [self _addToScrollCell:centerCell subView:subView];

        //leftView
        if (self.prepareLoad) {
            subView = [self.delegate cycleScrollView:self viewForPageAtIndex:leftIndex isEnd:&isEnd];
            [self _addToScrollCell:leftCell subView:subView];
        }
    }
    
    CGFloat itemWidth = self.bounds.size.width + self.pageSpace;
    CGFloat itemHeight = self.bounds.size.height + self.pageSpace;
    if (self.scrollViewStyle == UICycleScrollViewStyleHorizontal) {
        self.scrollView.contentOffset = CGPointMake(itemWidth, 0);
    }
    else {
        self.scrollView.contentOffset = CGPointMake(0, itemHeight);
    }
    self.lastContentOffset = self.scrollView.contentOffset;
}

-(void)_layoutSubChildViews
{
    if ([self.delegate respondsToSelector:@selector(numberOfPagesInCycleScrollView:)]) {
        self.numberOfPages = [self.delegate numberOfPagesInCycleScrollView:self];
    }
    
    [self _resetupChildView];
    
    [self _loadSubView];
    
    [self startAutoCycleScroll:_autoScroll];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self _layoutSubChildViews];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self _reloadSubView];
//    if (!self.cycleScroll) {
//        if (self.currentPageIndex == self.numberOfPages-1) {
//            [self startAutoCycleScroll:NO];
//        }
//        else
//        {
//            [self startAutoCycleScroll:_autoScroll];
//        }
//    }
}

//手动关定时器
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    [self startAutoCycleScroll:NO];
//}
//
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    [self startAutoCycleScroll:_autoScroll];
//}

-(void)reloadData
{
    [self _layoutSubChildViews];
}

-(void)startAutoCycleScroll:(BOOL)autoCycleScroll
{
    if (autoCycleScroll) {
        if (self.numberOfPages > 1) {
            [self.timer invalidate];
            self.timer = nil;
            
            CGFloat timeInterval = scrollTimeInterval_s;
            if (self.scrollTimeInterval > 0) {
                timeInterval = self.scrollTimeInterval;
            }
            
            NSTimer *timer = [NSTimer timerWithTimeInterval:timeInterval target:[NSWeakProxy proxyWithTarget:self] selector:@selector(_timerAction:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
            self.timer = timer;
        }
    }
    else
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)_timerAction:(id)sender
{
    if (self.cellCnt <= 1) {
        return;
    }
    
    NSInteger shiftCellCnt = self.cellCnt-1;
    if (self.cycleScroll == NO) {
        shiftCellCnt = MIN(self.cellCnt, CYCLE_PAGE_VIEW_COUNT) - 1;
    }
    
    CGFloat itemWidth = self.bounds.size.width + self.pageSpace;
    CGFloat itemHeight = self.bounds.size.height + self.pageSpace;
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    CGPoint offset = CGPointZero;
    if (self.scrollViewStyle == UICycleScrollViewStyleHorizontal) {
        offsetX = self.lastContentOffset.x + itemWidth;
        offset = CGPointMake(MIN(offsetY, shiftCellCnt * itemWidth), offsetY);
    }
    else {
        offsetY = self.lastContentOffset.y + itemHeight;
        offset = CGPointMake(offsetX, MIN(offsetY, shiftCellCnt * itemHeight));
    }
    
    [UIView animateWithDuration:0.8 animations:^{
        self.scrollView.contentOffset = offset;
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
}

-(void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    if (autoScroll == NO) {
        [self startAutoCycleScroll:NO];
    }
}

-(void)removeFromSuperview
{
    self.autoScroll = NO;
    [super removeFromSuperview];
}

-(void)dealloc
{
    [self startAutoCycleScroll:NO];
}

@end
