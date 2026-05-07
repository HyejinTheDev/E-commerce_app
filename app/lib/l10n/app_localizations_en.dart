// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Lucent';

  @override
  String get home => 'Home';

  @override
  String get explore => 'Explore';

  @override
  String get cart => 'Cart';

  @override
  String get orders => 'Orders';

  @override
  String get profile => 'Profile';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search products, brands...';

  @override
  String get categories => 'Categories';

  @override
  String get allCategories => 'All';

  @override
  String get featuredProducts => 'Featured';

  @override
  String get newArrivals => 'New Arrivals';

  @override
  String get seeAll => 'See all';

  @override
  String get springCollection => 'Spring\nCollection';

  @override
  String get shopNow => 'Shop Now';

  @override
  String get browseAndAdd => 'Browse products and add to cart';

  @override
  String get shopNowBtn => 'Shop Now';

  @override
  String get productDetail => 'Product Detail';

  @override
  String get selectSize => 'Select size';

  @override
  String get selectColor => 'Select color';

  @override
  String get description => 'Description';

  @override
  String get reviews => 'Reviews';

  @override
  String get writeReview => 'Write a review';

  @override
  String get submitReview => 'Submit Review';

  @override
  String get reviewHint => 'Share your thoughts about this product...';

  @override
  String get total => 'Total';

  @override
  String get addToCart => 'Cart';

  @override
  String get buyNow => 'Buy Now';

  @override
  String get addedToCart => 'has been added to cart';

  @override
  String get stock => 'Stock';

  @override
  String get inStock => 'In Stock';

  @override
  String get outOfStock => 'Out of Stock';

  @override
  String get chatWithSeller => 'Chat with seller';

  @override
  String get reviewSuccess => 'Review submitted!';

  @override
  String get reviewFailed => 'Failed to submit review';

  @override
  String get cartTitle => 'Shopping Cart';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartEmptyDesc => 'Add products to start shopping';

  @override
  String get checkout => 'Checkout';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get shipping => 'Shipping';

  @override
  String get freeShipping => 'Free';

  @override
  String get orderTotal => 'Order Total';

  @override
  String get removeItem => 'Remove';

  @override
  String get tax => 'Tax';

  @override
  String get proceedToCheckout => 'Proceed to Checkout';

  @override
  String nItems(int count) {
    return '$count items';
  }

  @override
  String get voucherCode => 'Voucher Code';

  @override
  String get voucherHint => 'Enter voucher code';

  @override
  String discountLabel(String code) {
    return 'Discount ($code)';
  }

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get shippingAddress => 'Shipping Address';

  @override
  String get paymentMethod => 'Payment';

  @override
  String get placeOrder => 'Place Order';

  @override
  String get placingOrder => 'Placing order...';

  @override
  String placeOrderWithTotal(String total) {
    return 'Place Order — $total';
  }

  @override
  String get orderSuccess => 'Order placed successfully!';

  @override
  String get orderSuccessDesc => 'Your order has been placed successfully.';

  @override
  String get continueShopping => 'Continue Shopping';

  @override
  String get orderFailed => 'Order failed. Please try again.';

  @override
  String get cod => 'Cash on Delivery';

  @override
  String get bankTransfer => 'Bank Transfer';

  @override
  String get voucher => 'Voucher Code';

  @override
  String get applyVoucher => 'Apply';

  @override
  String get change => 'Change';

  @override
  String get deliveryLabel => 'Delivery';

  @override
  String get deliveryStandard => 'Standard (5-7 days)';

  @override
  String get deliveryFast => 'Express (2-3 days)';

  @override
  String get stepShipping => 'Shipping';

  @override
  String get stepPayment => 'Payment';

  @override
  String get stepConfirm => 'Confirm';

  @override
  String get ordersTitle => 'My Orders';

  @override
  String get orderTracking => 'Order Tracking';

  @override
  String get trackOrder => 'Track';

  @override
  String get orderStatus => 'Status';

  @override
  String orderIdLabel(String id) {
    return 'Order #$id';
  }

  @override
  String get pending => 'Pending';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get processing => 'Processing';

  @override
  String get shippingStatus => 'Shipping';

  @override
  String get delivered => 'Delivered';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get noOrders => 'No orders yet';

  @override
  String get noOrdersDesc => 'Your orders will appear here after you place one';

  @override
  String get profileTitle => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get addresses => 'Addresses';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get notifications => 'Notifications';

  @override
  String get messages => 'Messages';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get logout => 'Log out';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get welcomeBack => 'Welcome\nBack';

  @override
  String get loginSubtitle => 'Sign in to continue shopping';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get fillAllFields => 'Please fill in all fields';

  @override
  String get createAccount => 'Create\nAccount';

  @override
  String get registerSubtitle => 'Sign up for free and start shopping';

  @override
  String get registerFailed => 'Registration failed';

  @override
  String get createAccountBtn => 'Create Account';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameHint => 'John Doe';

  @override
  String get passwordHint => 'At least 6 characters';

  @override
  String get phoneOptional => 'Phone (optional)';

  @override
  String get fillRequired => 'Please fill in all required fields';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get login => 'Log in';

  @override
  String get loginBtn => 'Log In';

  @override
  String get register => 'Sign up';

  @override
  String get registerBtn => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone number';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get forgotPasswordTitle => 'Reset Password';

  @override
  String get forgotPasswordDesc =>
      'Enter your email and we\'ll send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send Link';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get resetLinkSent => 'Link sent! Please check your email.';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get sellerDashboard => 'My Shop';

  @override
  String get sellerProducts => 'Products';

  @override
  String get sellerOrders => 'Orders';

  @override
  String get sellerVouchers => 'Vouchers';

  @override
  String get registerSeller => 'Register as Seller';

  @override
  String get deliveryDashboard => 'Delivery';

  @override
  String get deliveryShipments => 'Shipments';

  @override
  String get deliveryHistory => 'History';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get adminUsers => 'Users';

  @override
  String get adminShops => 'Shops';

  @override
  String get adminDrivers => 'Drivers';

  @override
  String get adminStats => 'Statistics';

  @override
  String get adminOverview => 'Overview';

  @override
  String get chatTitle => 'Messages';

  @override
  String get chatEmpty => 'No messages yet';

  @override
  String get chatEmptyDesc => 'Start chatting with sellers from product pages';

  @override
  String get chatInputHint => 'Type a message...';

  @override
  String get startChat => 'Start a conversation!';

  @override
  String get online => 'Online';

  @override
  String get justNow => 'Just now';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get noNotificationsDesc =>
      'You\'ll get notified when your order status changes';

  @override
  String get readAll => 'Read all';

  @override
  String minutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get success => 'Success';

  @override
  String get noData => 'No data';

  @override
  String get items => 'items';

  @override
  String get required => 'Required';

  @override
  String get orderNotFound => 'Order not found';

  @override
  String get products => 'Products';

  @override
  String get shippingInfo => 'Shipping Info';

  @override
  String get driverDelivering => 'Driver delivering';

  @override
  String statusLabel(String status) {
    return 'Status: $status';
  }

  @override
  String get summary => 'Summary';

  @override
  String get orderCode => 'Order ID';

  @override
  String itemCountLabel(int count) {
    return '$count items';
  }

  @override
  String get paymentMethodLabel => 'Method';

  @override
  String get orderStatusTitle => 'Order Status';

  @override
  String get orderCancelled => 'Order has been cancelled';

  @override
  String get stepPlaced => 'Placed';

  @override
  String get stepPlacedDesc => 'Order has been created';

  @override
  String get stepConfirmed => 'Confirmed';

  @override
  String get stepConfirmedDesc => 'Seller has confirmed';

  @override
  String get stepShippingDesc => 'On the way';

  @override
  String get stepComplete => 'Complete';

  @override
  String get stepCompleteDesc => 'Delivered successfully';

  @override
  String get statusDelivered => 'Delivered successfully';

  @override
  String get statusShipping => 'Shipping';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusProcessing => 'Processing';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusPending => 'Pending confirmation';

  @override
  String get subtitleDelivered => 'Thank you for your purchase!';

  @override
  String get subtitleShipping => 'Your order is on its way';

  @override
  String get subtitleConfirmed => 'Seller is preparing your order';

  @override
  String get subtitleCancelled => 'This order has been cancelled';

  @override
  String get subtitlePending => 'Waiting for seller confirmation';

  @override
  String get shipAssigned => 'Assigned to driver';

  @override
  String get shipPickingUp => 'Picking up';

  @override
  String get shipPickedUp => 'Picked up';

  @override
  String get shipInTransit => 'In transit';

  @override
  String get shipDelivered => 'Delivered';

  @override
  String get shipFailed => 'Delivery failed';

  @override
  String get shipUnknown => 'Unknown';

  @override
  String get product => 'Product';

  @override
  String get searchProducts => 'Search products...';

  @override
  String get suggestedForYou => 'Suggested for you';

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String get clearAll => 'Clear All';

  @override
  String nResults(int count) {
    return '$count results';
  }

  @override
  String get noProductsFound => 'No products found';

  @override
  String get tryDifferentKeyword => 'Try a different keyword or remove filters';

  @override
  String get loadMore => 'Load More';

  @override
  String get sortBy => 'Sort: ';

  @override
  String get sortNewest => 'Newest';

  @override
  String get sortPriceAsc => 'Price low to high';

  @override
  String get sortPriceDesc => 'Price high to low';

  @override
  String get sortBestRated => 'Best rated';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get myOrders => 'My Orders';

  @override
  String get shippingAddresses => 'Shipping Addresses';

  @override
  String get paymentMethods2 => 'Payment Methods';

  @override
  String get messagesMenu => 'Messages';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get languageMenu => 'Language';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get services => 'Services';

  @override
  String get sellerChannel => 'Seller Center';

  @override
  String get sellerChannelDesc => 'Manage shop & orders';

  @override
  String get deliveryChannel => 'Delivery Center';

  @override
  String get deliveryChannelDesc => 'Accept deliveries & earn income';

  @override
  String get adminPanelDesc => 'System management & approvals';

  @override
  String get preferences => 'Preferences';

  @override
  String get darkModeToggle => 'Dark Mode';

  @override
  String get pushNotifToggle => 'Push Notifications';

  @override
  String get emailUpdatesToggle => 'Email Updates';

  @override
  String get signOut => 'Sign Out';

  @override
  String get ordersCount => 'Orders';

  @override
  String get addressesCount => 'Addresses';

  @override
  String get sessionExpired => 'Session expired. Please log in again.';

  @override
  String connectionError(String error) {
    return 'Connection error: $error';
  }

  @override
  String get startSelling => 'Start Selling';

  @override
  String get openShopFree =>
      'Open your shop for free, start your business now!';

  @override
  String get shopNameLabel => 'Shop Name *';

  @override
  String get shopNameHint => 'e.g. Fashion Store ABC';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get shopDescHint => 'Premium fashion...';

  @override
  String get openShop => 'Open Shop';

  @override
  String get shopNameRequired => 'Please enter a shop name';

  @override
  String get shopCreatedSuccess => '🎉 Shop created successfully!';

  @override
  String get registerDelivery => 'Register as Driver';

  @override
  String get deliveryRegistrationDesc =>
      'Accept delivery orders, earn extra income!';

  @override
  String get vehicleTypeLabel => 'Vehicle Type *';

  @override
  String get vehicleTypeHint => 'e.g. Motorbike, Car';

  @override
  String get licensePlateOptional => 'License Plate (optional)';

  @override
  String get licensePlateHint => 'e.g. 59A1-12345';

  @override
  String get startDelivery => 'Start Delivering';

  @override
  String get vehicleRequired => 'Please enter vehicle type';

  @override
  String get deliveryRegisteredSuccess => '🚀 Driver registration successful!';

  @override
  String get paymentMethodsTitle => 'Payment Methods';

  @override
  String get codLabel => 'Cash on Delivery (COD)';

  @override
  String get ewalletLabel => 'E-wallet';

  @override
  String get creditCardLabel => 'Credit / Debit Card';

  @override
  String get bankTransferLabel => 'Bank Transfer';

  @override
  String get notifMenuTitle => 'Notifications';

  @override
  String get helpChatSupport => 'Chat with support';

  @override
  String get helpEmail => 'Email: support@lucent.vn';

  @override
  String get helpHotline => 'Hotline: 1900 1234';

  @override
  String get helpFaq => 'FAQ';

  @override
  String get helpPrivacy => 'Privacy Policy';

  @override
  String get helpTerms => 'Terms of Service';

  @override
  String get addressTitle => 'Shipping Addresses';

  @override
  String get addNewAddress => 'Add New Address';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get streetLabel => 'Street';

  @override
  String get wardLabel => 'Ward';

  @override
  String get districtLabel => 'District';

  @override
  String get cityLabel => 'City / Province';

  @override
  String get saveAddress => 'Save Address';

  @override
  String get fillAllInfo => 'Please fill in all fields';

  @override
  String get addressAdded => 'Address added';

  @override
  String get addressDeleted => 'Address deleted';

  @override
  String get noAddresses => 'No addresses yet';

  @override
  String get addAddress => '+ Add Address';

  @override
  String get defaultLabel => 'Default';

  @override
  String get editProfileFullName => 'Full Name';

  @override
  String get nameRequired => 'Name cannot be empty';

  @override
  String get updateSuccess => 'Updated successfully!';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get sellerOverview => 'Overview';

  @override
  String get sellerProductsNav => 'Products';

  @override
  String get sellerOrdersNav => 'Orders';

  @override
  String get shopLabel => 'Shop';

  @override
  String get shopActive => 'Active';

  @override
  String get shopPending => 'Pending Approval';

  @override
  String get backToShopping => 'Back to shopping';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get productsLabel => 'Products';

  @override
  String get ordersLabel => 'Orders';

  @override
  String get pendingLabel => 'Pending';

  @override
  String get managementSection => 'Management';

  @override
  String get addNewProduct => 'Add New Product';

  @override
  String get addNewProductDesc => 'List a product in your shop';

  @override
  String get noProducts => 'No products yet';

  @override
  String get addFirstProduct => 'Add your first product';

  @override
  String nProductsShort(int count) {
    return '$count items';
  }

  @override
  String stock2(int count) {
    return 'Stock: $count';
  }

  @override
  String get deleteProduct => 'Delete product?';

  @override
  String get deleteProductConfirm =>
      'This product will be permanently deleted.';

  @override
  String get deleteAction => 'Delete';

  @override
  String get noSellerOrders => 'No orders yet';

  @override
  String get customerLabel => 'Customer';

  @override
  String nProductsDot(int count) {
    return '$count products';
  }

  @override
  String get rejectAction => 'Reject';

  @override
  String get confirmAction => 'Confirm';

  @override
  String get shipAction => 'Ship';

  @override
  String get addProductTitle => 'Add Product';

  @override
  String get productImages => 'Product Images';

  @override
  String get uploading => 'Uploading...';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String nPhotosHint(int count) {
    return '$count photos · tap to add';
  }

  @override
  String get basicInfo => 'Basic Info';

  @override
  String get productNameLabel => 'Product Name *';

  @override
  String get productNameHint => 'Premium cotton T-shirt';

  @override
  String get productDescLabel => 'Product Description *';

  @override
  String get productDescHint => '100% cotton material...';

  @override
  String get categoryLabel => 'Category *';

  @override
  String get selectCategory => 'Select category';

  @override
  String get priceAndStock => 'Price & Stock';

  @override
  String get originalPrice => 'Original Price (₫) *';

  @override
  String get salePrice => 'Sale Price (₫)';

  @override
  String get stockQuantity => 'Stock Quantity *';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get publishProduct => 'Publish Product';

  @override
  String get productPublished => '🎉 Product published successfully!';

  @override
  String get waitForUpload => 'Uploading images, please wait...';

  @override
  String get selectProductImage => 'Select Product Image';

  @override
  String get photoLibrary => 'Photo Library';

  @override
  String get chooseFromCollection => 'Choose from collection';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get useCamera => 'Use camera to capture';

  @override
  String get enterUrl => 'Enter URL';

  @override
  String get pasteImageUrl => 'Paste image URL';

  @override
  String get addImageFromUrl => 'Add Image from URL';

  @override
  String get addAction => 'Add';

  @override
  String imagePickError(String error) {
    return 'Image pick error: $error';
  }

  @override
  String uploadFailed(String error) {
    return 'Upload failed: $error';
  }

  @override
  String get driverTitle => 'Driver';

  @override
  String get deliveryOverview => 'Overview';

  @override
  String get deliveryShipmentsNav => 'Shipments';

  @override
  String get deliveryHistoryNav => 'History';

  @override
  String get acceptingOrders => 'Accepting Orders';

  @override
  String get notAcceptingOrders => 'Not Accepting Orders';

  @override
  String get acceptingOrdersDesc => 'You will receive new delivery orders';

  @override
  String get enableAcceptingDesc => 'Turn on to accept deliveries';

  @override
  String get totalShipments => 'Total';

  @override
  String get activeShipments => 'Active';

  @override
  String get completedShipments => 'Completed';

  @override
  String get currentShipments => 'Current Shipments';

  @override
  String get noShipments => 'No shipments yet';

  @override
  String get deliveryHistoryTitle => 'Delivery History';

  @override
  String get noHistory => 'No history yet';

  @override
  String get shipAssignedShort => 'Assigned';

  @override
  String get pickUpAction => 'Pick Up';

  @override
  String get pickedUpAction => 'Picked Up';

  @override
  String get deliveringAction => 'Delivering';

  @override
  String get deliveredAction => 'Delivered';

  @override
  String get failedAction => 'Failed';

  @override
  String shipmentId(String id) {
    return 'Order #$id';
  }

  @override
  String nShipments(int count) {
    return '$count orders';
  }

  @override
  String get exitAdmin => 'Exit Admin';

  @override
  String get adminTotalRevenue => 'Total Revenue';

  @override
  String get adminUsersLabel => 'Users';

  @override
  String get adminOrdersLabel => 'Orders';

  @override
  String get adminProductsLabel => 'Products';

  @override
  String get adminShopsLabel => 'Shops';

  @override
  String get adminDriversLabel => 'Drivers';

  @override
  String get adminPendingLabel => 'Pending';

  @override
  String get adminOrderStatus => 'Order Status';

  @override
  String manageUsers(int count) {
    return 'Manage Users ($count)';
  }

  @override
  String manageShops(int count) {
    return 'Manage Shops ($count)';
  }

  @override
  String manageDrivers(int count) {
    return 'Manage Drivers ($count)';
  }

  @override
  String get approveAction => 'Approve';

  @override
  String get rejectShopAction => 'Reject';

  @override
  String get shopApproved => 'Shop approved!';

  @override
  String get shopRejected => 'Shop rejected!';

  @override
  String errorLabel(String error) {
    return 'Error: $error';
  }

  @override
  String get onboardingTitle1 => 'Discover Premium Products';

  @override
  String get onboardingSubtitle1 =>
      'Browse thousands of curated products from trusted sellers, handpicked just for you.';

  @override
  String get onboardingTitle2 => 'Lightning-Fast Delivery';

  @override
  String get onboardingSubtitle2 =>
      'Track your orders in real-time. From doorstep to doorbell, we\'ve got you covered.';

  @override
  String get onboardingTitle3 => 'Secure & Trusted';

  @override
  String get onboardingSubtitle3 =>
      'Safe payments, verified sellers, and hassle-free returns. Shopping with confidence.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get rememberMe => 'Remember me';
}
