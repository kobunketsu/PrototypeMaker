//
//  PMDetailViewController.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/16/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMDetailViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PMPrototype.h"
#import "PMIdea.h"
#import "PMImageCollectionViewCell.h"
#import "DPiCloudDocManager.h"
#import "PMRelatedViewController.h"
#define DetailImageCountMax 5
@interface PMDetailViewController ()
<UITextFieldDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UITextViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (retain, nonatomic) UIImagePickerController *cameraImagePickerVC;
@property (assign, nonatomic) NSInteger curImageIndex;
@property (retain, nonatomic) UIBarButtonItem *tagForIdeaButton;
@property (retain, nonatomic) UIBarButtonItem *relatedProtoButton;
@end

@implementation PMDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tagForIdeaButton = [[UIBarButtonItem alloc] initWithTitle:@"Tags" style:UIBarButtonItemStyleDone target:self action:@selector(tagForIdeaButtonTouchUp:)];
    
    self.relatedProtoButton = [[UIBarButtonItem alloc] initWithTitle:@"Related" style:UIBarButtonItemStyleDone target:self action:@selector(relatedProtoButtonTouchUp:)];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.detailInfo) {
        self.titleTextField.text = self.detailInfo.title;
        self.descTextView.text = self.detailInfo.desc;
    }

    //Proto下隐藏tag
    if ([self.detailInfo isKindOfClass:[PMPrototype class]]) {
        self.navigationItem.rightBarButtonItem = self.relatedProtoButton;
    }
    else if ([self.detailInfo isKindOfClass:[PMIdea class]]) {
        self.navigationItem.rightBarButtonItem = self.tagForIdeaButton;
    }
}

- (void)dealloc{
    NSLog(@"dealloc detailVC");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

}
#pragma mark- IBAction
- (void)tagForIdeaButtonTouchUp:(id)sender{
    [self performSegueWithIdentifier:@"pushTagView" sender:self];
}

- (void)relatedProtoButtonTouchUp:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:true];
    
    [self.navigationController performSegueWithIdentifier:@"pushRelatedView" sender:self];
}

#pragma mark- Ultility
//- (NSURL *)getDocURL:(NSString *)filename {
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//}

#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.detailInfo.title = textField.text;
}

#pragma mark- UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.descTextViewEditDoneButton.hidden = false;
    return YES;
}

- (IBAction)textViewDoneButtonTouchUp:(id)sender {
    [self.descTextView resignFirstResponder];
    self.descTextViewEditDoneButton.hidden = true;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.detailInfo.desc = textView.text;
}
#pragma mark- CollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return MIN(self.detailInfo.imagePaths.count + 1, DetailImageCountMax);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    PMImageCollectionViewCell *cell = (PMImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    
    //解决cell尺寸位置和collection对不上的问题
//    cell.frame = self.imageCollectionView.frame;
//    [cell setNeedsLayout];
    
    if (self.detailInfo.imagePaths.count > indexPath.row) {
        NSString *imagePath =  [[[DPiCloudDocManager si] getDirURL:@"image"].path stringByAppendingPathComponent:self.detailInfo.imagePaths[indexPath.row]];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        cell.imageView.image = image;
    }
    else{
        //add icon
        UIImage *image = [UIImage imageNamed:@"image.jpg"];
        cell.imageView.image = image;
    }
    
    return cell;
}
#pragma mark- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DebugLog(@"collectionView didSelectItemAtIndexPath %d", indexPath.row);
    self.curImageIndex = indexPath.row;
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [controller addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self didSelectImportPhoto];
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"Take Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self didSelectImportCamera];
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.detailInfo.imagePaths removeObjectAtIndex:indexPath.row];
        [self.imageCollectionView reloadData];
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:controller animated:true completion:nil];
}

#pragma makr- Import Image
-(void) didSelectImportPhoto{
    [self startMediaBrowserFromViewController:self usingDelegate:self];
}

-(void) didSelectImportCamera{
    [self startCameraControllerFromViewController:self usingDelegate:self];
}


- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) ctrlDelegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (ctrlDelegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        imagePicker.view.backgroundColor = [UIColor whiteColor];
        
        [self presentViewController:imagePicker animated:true completion:^{
            
        }];
        
        return YES;
    }else {
        [self presentAlertControllerWithTitle:NSLocalizedString(@"NoAccessPhotoLibrary", nil) message:nil fromView:nil actionHandler:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil, nil];
        return NO;
    }
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) ctrlDelegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (ctrlDelegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    self.cameraImagePickerVC = cameraUI;
    cameraUI.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    //    cameraUI.mediaTypes =
    //    [UIImagePickerController availableMediaTypesForSourceType:
    //     UIImagePickerControllerSourceTypeCamera];
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.showsCameraControls = YES;
    
    cameraUI.delegate = ctrlDelegate;
    
    //MARK:fix iOS8 Bug
    if([UIDevice currentDevice].systemVersion.floatValue >= IOSCapVersion){
        cameraUI.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    
    [controller presentViewController:cameraUI animated:false completion:^{
    }];
    
    return YES;
}
#pragma mark- 取图片 UIImagePickerControllerDelegate
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
//    [RemoteLog logAction:@"PS_imagePickerControllerDidCancel" fromSender:picker withParameters:nil timed:NO];
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        [self dismissViewControllerAnimated:true completion:^{
            self.cameraImagePickerVC = nil;
        }];
    }
    else if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        self.cameraImagePickerVC = nil;
    }
    
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    DebugLogSystem(@"imagePickerController didFinishPickingMediaWithInfo");
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *imageToSave;
    __block UIImage *finalImage;
    
    // Handle a still image capture
    
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        
        originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
        
        //获得图像
        if (originalImage) {
            imageToSave = originalImage;
        }
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            [RemoteLog logAction:@"PS_imagePickerControllerDidFinishPickingImageFromCamera" fromSender:picker withParameters:nil timed:NO];
            // Save the new image (original or edited) to the Camera Roll
            ALAssetsLibrary* library = [[ALAssetsLibrary alloc]init];
            [library writeImageToSavedPhotosAlbum:imageToSave.CGImage orientation:(ALAssetOrientation)imageToSave.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error){
                if (error) {
                    DebugLogError(@"writeImageToSavedPhotosAlbum error");
                }
                else {
                    DebugLogWriteSuccess(@"writeImageToSavedPhotosAlbum url %@", assetURL);
                    [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
                        finalImage = [[UIImage alloc] initWithCGImage: [assetRep fullResolutionImage] scale: 1.0 orientation: UIImageOrientationRight];
                        [self importEditImage:[finalImage normalizedImage]];
                        
                    } failureBlock:^(NSError *error) {
                        DebugLogError(@"readImageFromPhotosAlbum error %@", [error localizedDescription]);
                    }];
                }
            }];
            library = nil;
            [self dismissViewControllerAnimated:true completion:^{
                self.cameraImagePickerVC = nil;
            }];
        }
        else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            [RemoteLog logAction:@"PS_imagePickerControllerDidFinishPickingImageFromPhotoLibrary" fromSender:picker withParameters:nil timed:NO];
            
            [self dismissViewControllerAnimated:true completion:^{
                if(!originalImage){
                    //TODO:iCloud未下载并只有截图的图片需要下载下来后再加载，此处暂做错误处理
                    [self presentAlertControllerWithTitle:NSLocalizedString(@"InvalidImageWarning", nil) message:nil fromView:nil actionHandler:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil, nil];
                }
                else{
                    [self importEditImage:[originalImage normalizedImage]];
                }
            }];
        }
    }
}

- (void)importEditImage:(UIImage *)image{
    DebugLogFuncStart(@"importEditImage");
    //将UIImage转换
    UIImage *validateImage = [self validateImageForTex:image];
    DebugLog(@"validateImage w %zu h %zu", CGImageGetWidth(validateImage.CGImage), CGImageGetHeight(validateImage.CGImage));
    
    //保存图片到磁盘
    NSString *fileName = [NSString stringWithFormat:@"%@_%d", self.detailInfo.identifier, self.curImageIndex];
    
    [ADUltility saveImage:validateImage withFileName:fileName ofType:@"png" inDirectory: [[[DPiCloudDocManager si] getDirURL:@"image"] path]];
    
    [DPiCloudHelper listAllFilesInDirectory:[DPiCloudHelper iCloudContainer] padding:@"--"];
    //添加或者替换
    NSString *filePath = [fileName stringByAppendingPathExtension:@"png"];
    if(self.detailInfo.imagePaths.count == self.curImageIndex){
        [self.detailInfo.imagePaths addObject:filePath];
    }
    else{
        self.detailInfo.imagePaths[self.curImageIndex] = filePath;
    }
    [self.imageCollectionView reloadData];
}

- (UIImage *)validateImageForTex:(UIImage *)image{
    UIImage * resultImage = [image imageByScalingProportionallyToMinimumSize:self.imageCollectionView.bounds.size];
    return  resultImage;
}
#pragma mark- Debug
#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif


@end
