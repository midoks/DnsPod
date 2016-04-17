//
//  MDTableViewHAFPullRefresh.h
//  MDTableViewHAFPullRefreshDemo
//
//  Created by midoks on 14/12/29.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol MDTableViewHAFDelegate;

typedef enum{
    MDHAFRefreshHNormal = 0, //下拉正常状态
    MDHAFRefreshHPull,       //下拉中..
    MDHAFRefreshHLoading,    //下拉刷新中...
    
    MDHAFRefreshFNormal,     //上拉正常状态
    MDHAFRefreshFUp,         //上拉中...
    MDHAFRefreshFLoading,    //上拉刷新中...
} MDHAFRefreshState;

@interface MDTableViewHAFPullRefresh : UIView{
    __unsafe_unretained id _delegate;
    MDHAFRefreshState _state;
    
    UILabel *_lastUpdateLabel;
    UILabel *_statusLabel;
    CALayer *_arrowImage;
    UIActivityIndicatorView *_activityView;
    
    UIView *_bView;
    UILabel *_bLastUpdateLabel;
    UILabel *_bStatusLabel;
    CALayer *_bArrowImage;
    UIActivityIndicatorView *_bActivityView;
    
    double _currentY;
    UIScrollView *_scrollView;
    BOOL _bRunning;
    BOOL _bFinished;
    
    BOOL _isLoadFoot;
}

@property (nonatomic, strong) UIView *view;
@property (nonatomic, assign) float contetnInsetHeight;
@property (nonatomic, assign) id <MDTableViewHAFDelegate> delegate;


- (void)mdRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)mdRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
-(void)headPosReload:(CGRect)frame;
-(void)mdHeadOK;
-(void)mdFootOK;
-(void)mdFootFinish;

-(void)setLoadFoot:(BOOL)yesorno;
@end





@protocol MDTableViewHAFDelegate
- (void)mdRefreshTableHeadTriggerRefresh:(MDTableViewHAFPullRefresh *)view;
- (void)mdRefreshTableFootTriggerRefresh:(MDTableViewHAFPullRefresh *)view;
@optional

//- (NSDate *)mdRefreshTableHAFDateSourceLastUpdated:(MDTableViewHAFPullRefresh *)view;

@end