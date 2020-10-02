//
//  DocumentBrowserViewController.h
//  DocumentBrowserScrewiness
//
//  Created by Christopher Liscio on 2020-10-01.
//

#import <UIKit/UIKit.h>

@interface DocumentBrowserViewController : UIDocumentBrowserViewController

- (void)presentDocumentAtURL:(NSURL *)documentURL;

@end
