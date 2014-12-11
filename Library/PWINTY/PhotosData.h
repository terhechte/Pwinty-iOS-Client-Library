//
//  PhotosData.h
//  PWINTY
//
//  Created by Chinara Kuzekeeva on 3/29/12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

/**
 Object containing photo information.
 */

@interface PhotosData : NSObject

/**
 Unique integer identifying the order id.
 */
@property (assign, nonatomic) int oID;

/**
 Unique integer identifying the photo.
 */
@property (assign, nonatomic) int photoID;

/**
 Number of copies of the photo to include in the order.
 */
@property (assign, nonatomic) int photoCopies;

/**
 Type of photo
 - i.e. 4x6 or 6x7 etc
*/
@property (retain, nonatomic) NSString *photoType;

/**
 Photo URL if photo should be downloaded by Pwinty (OPTIONAL)
 */
@property (retain, nonatomic) NSString *photoPath;

/**
 Current status of the photo.
 - Can be:
     1) kPhotoStatusAwaitingUrlOrData;
     2) kPhotoStatusNotYetDownloaded;
     3) kPhotoStatusOk;
     4) kPhotoStatusFileNotFoundAtUrl;
     5) kPhotoStatusInvalid;
 */
@property (retain, nonatomic) NSString *photoStatus;


/**
 - Can be:
 1)kSizingOptionCrop
     The image you upload will be cropped until it exactly fits the aspect ratio (height divided by width) of the type (e.g. 3.5x5) you have specified
 2)kSizingOptionShrinkToFit
     The image you upload will be shrunk until all the image fits on the photo. This can lead to white bars at the edge of the photo (think a widescreen movie on an old 4:3 tv)
 3)kSizingOptionShrinkToExactFit
     The image you upload will be resized until all of the image exactly fits all of the photo. This means that if the aspect ratio of the image and the photo do not match, the image will be stretched or squashed to fit the photo size
 */
@property (retain, nonatomic) NSString *photoSizing;

/**
 priceToUser optional integer- the price (in cents/pence) you'd like to charge for each copy (only available if your payment option is InvoiceRecipient)
 */

@property (assign, nonatomic) NSInteger priceToUser;

/**
 md5Hash optional an md5Hash of the file which we'll check before processing
 */
@property (retain, nonatomic) NSString* md5Hash;

/**
 Binary data of the photo. JPEG format only. (OPTIONAL)
 
 \code
   iOS:
     UIImage *img = [UIImage imageNamed:@"example.png"];
     NSData *data = UIImageJPEGRepresentation(img, 1);
 \endcode
 */
@property (retain, nonatomic) NSData *photoFile;

/**
 Uploadiong photo file name. Use for binary data uploading only. (OPTIONAL)
 */
@property (retain, nonatomic) NSString *photoFileName;


/**
  Return an array of PhotosData objects.
 */
+ (NSArray *)createArrayOfObjectsFromArray:(NSArray *)array;

/**
 Return PhotosData object created from dictionary.
 
 \param dict - NSDictionary object with specified keys.
 
 <br>Keys</br>
 - kID;
 - kOrderID;
 - kPhotoType;
 - kPhotoPath; (OPTIONAL)
 - kPhotoStatus;
 - kPhotoCopies;
 - kPhotoSizing;
 - kPhotoFile; (OPTIONAL)
 - kphotoFileName. (OPTIONAL. Use this key only if you are uploading a file, in other cases there is no need to use that key)
 
 */
+ (PhotosData *)createObjectFormDictionary:(NSDictionary *)dict;

/**
 Return NSDictionary object created from PhotosDataObject.
 
 <br>Keys</br>
 - kID;
 - kOrderID;
 - kPhotoType;
 - kPhotoPath; (OPTIONAL)
 - kPhotoStatus;
 - kPhotoCopies;
 - kPhotoSizing;
 - kPhotoFile; (OPTIONAL)
 - kphotoFileName. (OPTIONAL. Use this key only when key kPhotoFile)

 */
+ (NSDictionary *)createDictionaryFromObject:(PhotosData *)pData;
@end
