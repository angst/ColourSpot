//
//  AppController.h
//  Colourspot
//
//  Copyright 2010 - Jesse Andrews
//
//  This file may be used under the terms of of the
//  GNU General Public License Version 2 or later (the "GPL"),
//  http://www.gnu.org/licenses/gpl.html
//
//

#import <Cocoa/Cocoa.h>

@interface AppController : NSObject {
	
	IBOutlet NSWindow *mainWindow;
	NSStatusItem *statusItem;
	NSImage *previewImage;
}

- (NSMenu *) createMenu;
- (void) appQuit:(id)sender;
- (void) updatePreview:(CGImageRef)image;
- (void) updateTitle:(CGImageRef)image;

@end
