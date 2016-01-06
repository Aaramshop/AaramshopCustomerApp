
#define GAITrackingID @"UA-67676419-2"




#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)





#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define kRobotoBold											@"Roboto-Bold"
#define kRobotoRegular									@"Roboto-Regular"
#define kRobotoMedium									@"Roboto-Medium"
#define kCurrencySymbol                                 @"CurrencySymbol"
#define kCountryCode									@"countryCode"
#define kCurrencyCode                                   @"CurrencyCode"
#define kFontHandSean										@"Sean"


#pragma mark - Alert titles and Internet alerts

#define kAlertTitle												@"AaramShop"
#define kAlertBtnOK											@"OK"
#define kAlertBtnYES										@"YES"
#define kAlertBtnNO										@"NO"
#define kAlertCheckInternetConnection			@"Please make sure that your device is connected to the internet"
#define kRequestTimeOutMessage					@"We can't establish a connection to AaramShop servers. Please make sure that your device is connected to the internet and try again"

#define kAlertServiceFailed								@"Failed. Try again" //new

#define kAlertValidEmail									@"Please enter a valid email address"
#define kAlertPasswordLength							@"Your password should have at least 6 digits"
#define kLogoutSuccessfulNotificationName	@"LogoutSuccessful"
#define kLoginSuccessfulNotificationName		@"LoginSuccessful"
#define kProductsCount									@"productsCount"
#define kURLLogout											@"logout"

#pragma mark - Common keys

#define APP_DELEGATE (AppDelegate*)[[UIApplication sharedApplication]delegate]
#define kBaseURL													@"baseUrl"
//#define kBaseURL												@"http://www.aaramshop.co.in/api/index.php/user/"
//#define kBaseURL												@"http://52.74.220.25/api/index.php/user/"
//#define kBaseURL												@"http://52.74.220.25/index.php/user/"


//#define kGOOGLE_API_KEY                                     @"AIzaSyAzMfO-tlOmsM47CG35YF-yHmleevA0LpM" // this key is for ios, & it is not working

#define kGOOGLE_API_KEY                                       @"AIzaSyC1rKSg6IVmDlntN1LFMVnkvK5Lpj5lFIY" // this key is also for web


#define kIsLoggedIn											@"isLoggedIn"
#define kDevice													@"1"
#define kDeviceType											@"deviceType"
#define kDeviceId												@"deviceId"
#define kUsername											@"username"
#define kpassword												@"password"
#define kLatitude												@"latitude"
#define kLongitude											@"longitude"
#define kSessionToken										@"sessionToken"
#define kUserId													@"userId"
#define kOption													@"option"
#define kSessionToken										@"sessionToken"
#define kMobile													@"mobile"
#define kstatus													@"status"
#define kCountryName										@"countryName"
#define kPhoneNumbers									@"phoneNumbers"
#define kFullname												@"fullname"

#define kDate														@"date"

#pragma mark - Existing User Keys

#define kExisting_user										@"existing_user"
#define kAddress												@"address"
#define kUser_address										@"user_address"
#define kAdultFemale										@"adultFemale"
#define kAdultMale											@"adultMale"
#define kChatUsername										@"chatUsername"
#define kCity														@"city"
#define kLocality												@"locality"
#define kPincode												@"pincode"
#define kTitle														@"title"
#define kDob														@"dob"
#define kEmail													@"email"
#define kFemaleChild											@"femaleChild"
#define kGender													@"gender"
#define kIncome													@"income"
#define kMaleChild											@"maleChild"
#define kMessage												@"message"
#define kMobile_verified									@"mobile_verified"
#define kProfileImage										@"profileImage"
#define kQualification										@"qualification"
#define kState														@"state"
#define kToddlers												@"toddlers"
#define kNewUserURL										@"newUser"
#define kOtpValidateURL									@"otpValidate"
#define kResendOtpURL									@"resendOtp"
#define kForgotPasswordURL							@"forgotPassword"
#define kUpdateAddressURL							@"updateAddress"
#define kGetHomeStoreBannerURL					@"getHomeStoreBanner"
#define kGetHomeStoreDetailsURL					@"getHomeStoreDetails"
#define kExistingUserURL								@"existingUser"
#define kUserMobileDataURL							@"userMobileData"
#define kMakeHomeStoreURL							@"makeHomeStore"
#define kGetStoresURL										@"getStores"
#define kGetStoresfromCategoryIdURL			@"getStoresfromCategoryId"
#define kGetStoresPaginationURL					@"getStoresPagination"
#define kGetStoreProductCategoriesURL		@"getStoreProductCategories"
#define kPOSTGetStoreProductSubCategoryURL	@"getStoreProductSubCategory"
#define kSearchStoreProductCategoriesURL	@"searchStoreProductCategories"
#define kPOSTGetStoreProductsURL				@"getStoreProducts"
#define kGetUserAddressURL							@"getUserAddress"

#define kImage_url_100									@"image_url_100"
#define kImage_url_320									@"image_url_320"
#define kImage_url_640									@"image_url_640"

#pragma mark - AaramShopValues

#define kStoreListURL										@"storeList"
#define kRadius													@"radius"
#define kCity_name											@"city_name"
#define kDelivers												@"delivers"
#define kLocality_name										@"locality_name"
#define kMinimum_order									@"minimum_order"
#define kState_name											@"state_name"
#define kStore_address										@"store_address"
#define kStore_category									@"store_category"
#define kStore_category_name							@"store_category_name"
#define kStore_category_image							@"store_category_image"
#define kStore_closing_days								@"store_closing_days"
#define kStore_code											@"store_code"
#define kStore_distance										@"store_distance"
#define kStore_email											@"store_email"
#define kStore_id												@"store_id"
#define kUser_address_id									@"user_address_id"
#define kUser_address_title								@"user_address_title"
#define kBanner													@"banner"
#define kBanner_2x											@"banner_2x"
#define kBanner_3x											@"banner_3x"
#define kStore_image											@"store_image"
#define kStore_data											@"store_data"
#define kStore_latitude										@"store_latitude"
#define kStore_longitude									@"store_longitude"
#define kStore_mobile										@"store_mobile"
#define kStore_name											@"store_name"
#define kStore_person										@"store_person"
#define kStore_phone										@"store_phone"
#define kStore_pincode										@"store_pincode"
#define kStore_terms											@"store_terms"
#define kStore_working_from							@"store_working_from"
#define kStore_working_status							@"store_working_status"
#define kStore_working_to								@"store_working_to"
#define kData														@"data"
#define kChat_username									@"chat_username"
#define kHome_delivery									@"home_delivery"
#define kIs_favorite											@"is_favorite"
#define kIs_home_store										@"is_home_store"
#define kIs_open												@"is_open"
#define kStore_category_icon							@"store_category_icon"
#define kStore_mobile										@"store_mobile"
#define kTotal_orders										@"total_orders"
#define kStore_rating											@"store_rating"
#define kStore_category_name							@"store_category_name"
#define kStore_category_id								@"store_category_id"

#define kStore_main_category_name				@"store_main_category_name"
#define kStore_main_category_id						@"store_main_category_id"
#define kStore_main_category_banner_1			@"store_main_category_banner_1"
#define kStore_main_category_banner_2			@"store_main_category_banner_2"
#define kCategory_id											@"category_id"
#define kCategory_banner									@"category_banner"
#define kCategory_image									@"category_image"
#define kCategroy_image_active						@"categroy_image_active"
#define kCategroy_image_inactive					@"categroy_image_inactive"
#define kCategory_name									@"category_name"

#define kSub_category_id									@"sub_category_id"
#define kSub_category_name							@"sub_category_name"
#define kProduct_id											@"product_id"
#define kProduct_image									@"product_image"
#define kProduct_name										@"product_name"
#define kProduct_price										@"product_price"
#define kProduct_sku_id									@"product_sku_id"
#define kIsAvailable											@"isAvailable"

#define kPopup_message									@"popup_message"
#pragma mark -

#define kSearch_term										@"search_term"

#pragma mark UpdateMobile


#define kTextFieldDigitRange							@"0123456789"


#pragma mark - New User Keys

#define kIsValid													@"isValid"

#pragma mark - OTP Validation Keys

#define kOtp														@"otp"
#define kBroadcastNotification							@"broadcastNotification"
#define kBroadcastNotificationAvailable			@"broadcastNotificationAvailable"
//==================Sign Up============

#define kFileType												@"fileType"


/////////////////////////////////////////////
//Search The List of user ///////////////////

#define kSeachUrl												@"search"
#define kFriendSearch										@"friendSearch"
#define kItemCount											@"itemCount"
#define kSearchCount										10
#define kPageNumber										@"pageNumber"
#define kSearchString											@"searchString"
#define kProfilePic												@"profilePic"
//====================NetworkService.h=======================

#define NULLVALUE(m) (m == [NSNULL null]? @"":m)

#define SUCCESS												@"status"
#define DATA														@"data"

#define KPost														@"POST"
#define KGet														@"GET"
#define KPut														@"PUT"

#define kParameter											@"Parameter"
#define kDataDic												@"DataDic"
#define kBodyStr												@"BodyStr"

//========= uploading Image =====
#define kMyUpload											@"myUpload"
#define kProfilePhoto										@"profilePhoto"
#define kBoundry												@"Boundry"
#define kServerUserNameId								@"userNameId"


#pragma mark -

#define kContactsAccessPermission					@"contactsAccessPermission"
#define kType														@"type"

#pragma mark -
#define kAddressForLocation								@"addressForLocation"

//==========Last Min Pick=========
#define kURLGetPaymentPageData					@"getPaymentPageData"
#define kPayment_page_info								@"payment_page_info"

//==========Order History========
#define kURLOrderHistory								@"orderHistory"
#define kAlertCallFacilityNotAvailable				@"Call facility is not available!!!"
#define kStore_city											@"store_city"
#define kDelivery_time										@"delivery_time"
#define kOrder_time											@"order_time"
#define kQuantity												@"quantity"
#define kTotal_cart_value									@"total_cart_value"
#define kOrder_id												@"order_id"
#define kDelivery_slot										@"delivery_slot"
#define kDeliveryboy_name								@"deliveryboy_name"
#define kPayment_mode									@"payment_mode"
#define kStore_chatUserName							@"store_chatUserName"
#define kDelivered_timing								@"delivered_timing"
#define kPacked_timing										@"packed_timing"
#define kDispached_timing								@"dispached_timing"
#define kCustomer_latitude								@"customer_latitude"
#define kCustomer_longitude							@"customer_longitude"
#define kDatetime												@"datetime"

#define DATE_FORMATTER_yyyy_mm_dd	@"yyyy-MM-dd"

#define kGetPaymentPageDataURL					@"getPaymentPageData"
#define kDelivery_charges									@"delivery_charges"
#define kTotal_amount										@"total_amount"
#define kPayment_page_info								@"payment_page_info"
#define KGetDeliverySlotURL							@"getDeliverySlot"
#define kcheckoutURL										@"checkout"

#define kTotalPrice											@"totalPrice"
#define kSubTotalPrice										@"subTotalPrice"
#define kDeliveryCharges									@"deliveryCharges"
#define kDiscount												@"discount"

//========== Payment Modes==========
#define kPaymentModeURL								@"paymentModes"
#define kPaymentMode_Id								@"payment_mode_id"
#define kPayment_modes									@"payment_modes"
#define kPaymentMode_Name							@"payment_mode"

//================== Offers =================
#define kURLGetOffers										@"getOffers"
#define kURLGetComboDetails							@"getComboDetails"
#define kURLGetUserScans								@"getUserScans"
#define kPage_no												@"page_no"
#define kTotal_page											@"total_page"
#define kTotal_pages										@"total_pages"
#define kOfferType											@"offerType"
#define kProduct_actual_price							@"product_actual_price"
#define kOffer_price											@"offer_price"
#define kIsBroadcast											@"isBroadcast"
#define kOfferTitle											@"offerTitle"
#define kOffer_id												@"offer_id"
#define kOfferId												@"offerId"
#define kOverall_purchase_value						@"overall_purchase_value"
#define kDiscount_percentage							@"discount_percentage"
#define kFree_item											@"free_item"
#define kCombo_mrp										@"combo_mrp"
#define kCombo_offer_price							@"combo_offer_price"
#define kOfferDetail											@"offerDetail"
#define kOfferDescription									@"offerDescription"
#define kOfferImage											@"offerImage"
#define kStart_date											@"start_date"
#define kEnd_date												@"end_date"

//================= Change Password==============
#define kURLChangePassword							@"changePassword"
#define kOld_password										@"old_password"
#define kNew_password									@"new_password"

//================ Send order status==============
#define kURLSentOrderStatus							@"sentOrderStatus"

//================= Account settings =============
#define kURLUpdateUsers								@"updateUsers"


//================= Preferences============
#define kURLGetPreferences							@"getPreferences"
#define kURLSavePreference								@"savePreference"
#define kURLGetUserAddress							@"getUserAddress"
#define kOffers_notification								@"offers_notification"
#define kDelivery_status_notification				@"delivery_status_notification"
#define kChat_notification									@"chat_notification"

//================= SHOPPING LIST MODULE =============

#define KURLSerachStoreProducts					@"serachStoreProducts"
#define kURLCreateShoppingList						@"createShoppingList"
#define kURLGetShoppingList                         @"getShoppingList"
#define kURLDeleteShoppingList						@"deleteShoppingList"
#define kURLGetShoppingListProducts			@"getShoppingListProducts"
#define kURLUpdateShoppingListProducts              @"updateShoppingListProducts"
#define kURLGetStores										@"getStores"
#define kURLSetShoppingListReminder			@"setShoppingListReminder"

#define kURLRemoveShoppingListReminder              @"removeShoppingListReminder"

#define kURLGetStoreforShoppingList				@"getStoreforShoppingList"
#define KURLGetShoppingListProductByStoreId		@"getShoppingListProductByStoreId"
#define kURLShareShoppingList						@"shareShoppingList"
#define kURLGetShoppingListShareWith			@"getShoppingListShareWith"

#define kShoppingListID                       @"shoppingListID"


//=========== Get Wallet =================================
#define kURLGetWallet										@"getWallet"
#define kURLGetPoints										@"getPoints"
#define kURLGetWalletOffers							@"getWalletOffers"
#define kURLGetBrandPoints								@"getBrandPoints"
#define kURLGetBonusPoints							@"getBonusPoints"
#define kURLGetAaramPoints							@"getAaramPoints"
#define kOrder_code										@"order_code"
#define kPoint													@"point"
#define kOrder_amount									@"order_amount"
#define kBrandPointsDetails								@"BrandPointsDetails"
#define kBonus_points										@"bonus_points"
#define kBrand_name										@"brand_name"
#define kAaramPointsDetails							@"AaramPointsDetails"


#define kGetMoney											@"getMoney"
#define kOrder_date											@"order_date"

//=========== Cart =================================
#define kCartData												@"cart"

//=========== Get BroadCast =============
#define kURLGetBroadCast								@"getBroadCast"


//=========== SEARCH STORES =================================

#define kURLSearchStores                                @"searchStores"

//================ Get Coupons ==============================
#define kURLGetCoupons									@"getCoupons"
#define kCoupons												@"coupons"

//=========== make Favorite =============
#define kURLMakeFavorite								@"makeFavorite"

//=========== getMinimumOrderValue =============
#define kURLGetMinimumOrderValue				@"getMinimumOrderValue"

//===========  validateCoupons =============
#define kURLValidateCoupons							@"validateCoupons"

//============== Global Search ==============================
#define kURLGlobalSearch								@"globalSearch"
#define ssNotificationStatusBarTouched			@"StatusBarTouched"
#define kGetStorefromProductId						@"getStorefromProductId"


//============== User Review ==============================

#define kURLUserReview                                      @"userReview"

//=============== Invite Friends on Facebook==============
#define kFBAccessToken                              @"FBAccessToken"
#define kFBUserImageURL                         @"userImageURL"
#define kURLGetFBFriends									@"getFBFriends"
#define kAccessToken										@"accessToken"


//=============== Ordered Product Details ==============

#define kURLOrderDetail                                     @"orderDetail"
#define kURLUpdateProductfromOrderId                        @"updateProductfromOrderId"
#define kURLReOrder                                         @"reOrder"


