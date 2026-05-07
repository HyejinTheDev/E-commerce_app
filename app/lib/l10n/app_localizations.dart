import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @appName.
  ///
  /// In vi, this message translates to:
  /// **'Lucent'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get home;

  /// No description provided for @explore.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá'**
  String get explore;

  /// No description provided for @cart.
  ///
  /// In vi, this message translates to:
  /// **'Giỏ hàng'**
  String get cart;

  /// No description provided for @orders.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng'**
  String get orders;

  /// No description provided for @profile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get profile;

  /// No description provided for @search.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm sản phẩm, thương hiệu...'**
  String get searchHint;

  /// No description provided for @categories.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get categories;

  /// No description provided for @allCategories.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get allCategories;

  /// No description provided for @featuredProducts.
  ///
  /// In vi, this message translates to:
  /// **'Nổi Bật'**
  String get featuredProducts;

  /// No description provided for @newArrivals.
  ///
  /// In vi, this message translates to:
  /// **'Hàng mới về'**
  String get newArrivals;

  /// No description provided for @seeAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get seeAll;

  /// No description provided for @springCollection.
  ///
  /// In vi, this message translates to:
  /// **'Bộ Sưu Tập\nXuân'**
  String get springCollection;

  /// No description provided for @shopNow.
  ///
  /// In vi, this message translates to:
  /// **'Mua Ngay'**
  String get shopNow;

  /// No description provided for @browseAndAdd.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt sản phẩm và thêm vào giỏ'**
  String get browseAndAdd;

  /// No description provided for @shopNowBtn.
  ///
  /// In vi, this message translates to:
  /// **'Mua Sắm Ngay'**
  String get shopNowBtn;

  /// No description provided for @productDetail.
  ///
  /// In vi, this message translates to:
  /// **'Chi Tiết Sản Phẩm'**
  String get productDetail;

  /// No description provided for @selectSize.
  ///
  /// In vi, this message translates to:
  /// **'Chọn size'**
  String get selectSize;

  /// No description provided for @selectColor.
  ///
  /// In vi, this message translates to:
  /// **'Chọn màu'**
  String get selectColor;

  /// No description provided for @description.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả'**
  String get description;

  /// No description provided for @reviews.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá'**
  String get reviews;

  /// No description provided for @writeReview.
  ///
  /// In vi, this message translates to:
  /// **'Viết đánh giá'**
  String get writeReview;

  /// No description provided for @submitReview.
  ///
  /// In vi, this message translates to:
  /// **'Gửi Đánh Giá'**
  String get submitReview;

  /// No description provided for @reviewHint.
  ///
  /// In vi, this message translates to:
  /// **'Hãy chia sẻ nhận xét của bạn về sản phẩm...'**
  String get reviewHint;

  /// No description provided for @total.
  ///
  /// In vi, this message translates to:
  /// **'Tổng'**
  String get total;

  /// No description provided for @addToCart.
  ///
  /// In vi, this message translates to:
  /// **'Giỏ'**
  String get addToCart;

  /// No description provided for @buyNow.
  ///
  /// In vi, this message translates to:
  /// **'Mua Ngay'**
  String get buyNow;

  /// No description provided for @addedToCart.
  ///
  /// In vi, this message translates to:
  /// **'đã được thêm vào giỏ hàng'**
  String get addedToCart;

  /// No description provided for @stock.
  ///
  /// In vi, this message translates to:
  /// **'Kho'**
  String get stock;

  /// No description provided for @inStock.
  ///
  /// In vi, this message translates to:
  /// **'Còn hàng'**
  String get inStock;

  /// No description provided for @outOfStock.
  ///
  /// In vi, this message translates to:
  /// **'Hết hàng'**
  String get outOfStock;

  /// No description provided for @chatWithSeller.
  ///
  /// In vi, this message translates to:
  /// **'Chat với người bán'**
  String get chatWithSeller;

  /// No description provided for @reviewSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá thành công!'**
  String get reviewSuccess;

  /// No description provided for @reviewFailed.
  ///
  /// In vi, this message translates to:
  /// **'Gửi đánh giá thất bại'**
  String get reviewFailed;

  /// No description provided for @cartTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giỏ Hàng'**
  String get cartTitle;

  /// No description provided for @cartEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Giỏ hàng trống'**
  String get cartEmpty;

  /// No description provided for @cartEmptyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Thêm sản phẩm để bắt đầu mua sắm'**
  String get cartEmptyDesc;

  /// No description provided for @checkout.
  ///
  /// In vi, this message translates to:
  /// **'Thanh Toán'**
  String get checkout;

  /// No description provided for @subtotal.
  ///
  /// In vi, this message translates to:
  /// **'Tạm tính'**
  String get subtotal;

  /// No description provided for @shipping.
  ///
  /// In vi, this message translates to:
  /// **'Vận chuyển'**
  String get shipping;

  /// No description provided for @freeShipping.
  ///
  /// In vi, this message translates to:
  /// **'Miễn phí'**
  String get freeShipping;

  /// No description provided for @orderTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng cộng'**
  String get orderTotal;

  /// No description provided for @removeItem.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get removeItem;

  /// No description provided for @tax.
  ///
  /// In vi, this message translates to:
  /// **'Thuế'**
  String get tax;

  /// No description provided for @proceedToCheckout.
  ///
  /// In vi, this message translates to:
  /// **'Tiến Hành Thanh Toán'**
  String get proceedToCheckout;

  /// No description provided for @nItems.
  ///
  /// In vi, this message translates to:
  /// **'{count} sản phẩm'**
  String nItems(int count);

  /// No description provided for @voucherCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã giảm giá'**
  String get voucherCode;

  /// No description provided for @voucherHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã giảm giá'**
  String get voucherHint;

  /// No description provided for @discountLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giảm giá ({code})'**
  String discountLabel(String code);

  /// No description provided for @checkoutTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thanh Toán'**
  String get checkoutTitle;

  /// No description provided for @shippingAddress.
  ///
  /// In vi, this message translates to:
  /// **'Địa Chỉ Giao Hàng'**
  String get shippingAddress;

  /// No description provided for @paymentMethod.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán'**
  String get paymentMethod;

  /// No description provided for @placeOrder.
  ///
  /// In vi, this message translates to:
  /// **'Đặt Hàng'**
  String get placeOrder;

  /// No description provided for @placingOrder.
  ///
  /// In vi, this message translates to:
  /// **'Đang đặt hàng...'**
  String get placingOrder;

  /// No description provided for @placeOrderWithTotal.
  ///
  /// In vi, this message translates to:
  /// **'Đặt Hàng — {total}'**
  String placeOrderWithTotal(String total);

  /// No description provided for @orderSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đặt hàng thành công!'**
  String get orderSuccess;

  /// No description provided for @orderSuccessDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng của bạn đã được đặt thành công.'**
  String get orderSuccessDesc;

  /// No description provided for @continueShopping.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp Tục Mua Sắm'**
  String get continueShopping;

  /// No description provided for @orderFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đặt hàng thất bại. Vui lòng thử lại.'**
  String get orderFailed;

  /// No description provided for @cod.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán khi nhận hàng'**
  String get cod;

  /// No description provided for @bankTransfer.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển khoản ngân hàng'**
  String get bankTransfer;

  /// No description provided for @voucher.
  ///
  /// In vi, this message translates to:
  /// **'Mã giảm giá'**
  String get voucher;

  /// No description provided for @applyVoucher.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng'**
  String get applyVoucher;

  /// No description provided for @change.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi'**
  String get change;

  /// No description provided for @deliveryLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giao hàng'**
  String get deliveryLabel;

  /// No description provided for @deliveryStandard.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu chuẩn (5-7 ngày)'**
  String get deliveryStandard;

  /// No description provided for @deliveryFast.
  ///
  /// In vi, this message translates to:
  /// **'Nhanh (2-3 ngày)'**
  String get deliveryFast;

  /// No description provided for @stepShipping.
  ///
  /// In vi, this message translates to:
  /// **'Giao hàng'**
  String get stepShipping;

  /// No description provided for @stepPayment.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán'**
  String get stepPayment;

  /// No description provided for @stepConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get stepConfirm;

  /// No description provided for @ordersTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đơn Hàng'**
  String get ordersTitle;

  /// No description provided for @orderTracking.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi đơn hàng'**
  String get orderTracking;

  /// No description provided for @trackOrder.
  ///
  /// In vi, this message translates to:
  /// **'Theo Dõi'**
  String get trackOrder;

  /// No description provided for @orderStatus.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái'**
  String get orderStatus;

  /// No description provided for @orderIdLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng #{id}'**
  String orderIdLabel(String id);

  /// No description provided for @pending.
  ///
  /// In vi, this message translates to:
  /// **'Chờ xác nhận'**
  String get pending;

  /// No description provided for @confirmed.
  ///
  /// In vi, this message translates to:
  /// **'Đã xác nhận'**
  String get confirmed;

  /// No description provided for @processing.
  ///
  /// In vi, this message translates to:
  /// **'Đang xử lý'**
  String get processing;

  /// No description provided for @shippingStatus.
  ///
  /// In vi, this message translates to:
  /// **'Đang giao'**
  String get shippingStatus;

  /// No description provided for @delivered.
  ///
  /// In vi, this message translates to:
  /// **'Đã giao'**
  String get delivered;

  /// No description provided for @cancelled.
  ///
  /// In vi, this message translates to:
  /// **'Đã hủy'**
  String get cancelled;

  /// No description provided for @noOrders.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đơn hàng'**
  String get noOrders;

  /// No description provided for @noOrdersDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng sẽ xuất hiện tại đây sau khi bạn đặt hàng'**
  String get noOrdersDesc;

  /// No description provided for @profileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hồ Sơ'**
  String get profileTitle;

  /// No description provided for @editProfile.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa hồ sơ'**
  String get editProfile;

  /// No description provided for @addresses.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ'**
  String get addresses;

  /// No description provided for @paymentMethods.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức thanh toán'**
  String get paymentMethods;

  /// No description provided for @notifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notifications;

  /// No description provided for @messages.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn'**
  String get messages;

  /// No description provided for @helpSupport.
  ///
  /// In vi, this message translates to:
  /// **'Trợ giúp & Hỗ trợ'**
  String get helpSupport;

  /// No description provided for @settings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ tối'**
  String get darkMode;

  /// No description provided for @logout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn đăng xuất?'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm;

  /// No description provided for @welcomeBack.
  ///
  /// In vi, this message translates to:
  /// **'Chào Mừng\nTrở Lại'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập để tiếp tục mua sắm'**
  String get loginSubtitle;

  /// No description provided for @loginFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập thất bại'**
  String get loginFailed;

  /// No description provided for @fillAllFields.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập đầy đủ thông tin'**
  String get fillAllFields;

  /// No description provided for @createAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tạo\nTài Khoản'**
  String get createAccount;

  /// No description provided for @registerSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký miễn phí và bắt đầu mua sắm'**
  String get registerSubtitle;

  /// No description provided for @registerFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký thất bại'**
  String get registerFailed;

  /// No description provided for @createAccountBtn.
  ///
  /// In vi, this message translates to:
  /// **'Tạo Tài Khoản'**
  String get createAccountBtn;

  /// No description provided for @fullName.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Nguyễn Văn A'**
  String get fullNameHint;

  /// No description provided for @passwordHint.
  ///
  /// In vi, this message translates to:
  /// **'Tối thiểu 6 ký tự'**
  String get passwordHint;

  /// No description provided for @phoneOptional.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại (tuỳ chọn)'**
  String get phoneOptional;

  /// No description provided for @fillRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập các trường bắt buộc'**
  String get fillRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu phải có ít nhất 6 ký tự'**
  String get passwordMinLength;

  /// No description provided for @login.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login;

  /// No description provided for @loginBtn.
  ///
  /// In vi, this message translates to:
  /// **'Đăng Nhập'**
  String get loginBtn;

  /// No description provided for @register.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get register;

  /// No description provided for @registerBtn.
  ///
  /// In vi, this message translates to:
  /// **'Đăng Ký'**
  String get registerBtn;

  /// No description provided for @email.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get password;

  /// No description provided for @name.
  ///
  /// In vi, this message translates to:
  /// **'Tên'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get phone;

  /// No description provided for @forgotPassword.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản?'**
  String get alreadyHaveAccount;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khôi phục mật khẩu'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email của bạn, chúng tôi sẽ gửi liên kết để đặt lại mật khẩu.'**
  String get forgotPasswordDesc;

  /// No description provided for @sendResetLink.
  ///
  /// In vi, this message translates to:
  /// **'Gửi liên kết'**
  String get sendResetLink;

  /// No description provided for @noInternetConnection.
  ///
  /// In vi, this message translates to:
  /// **'Không có kết nối mạng'**
  String get noInternetConnection;

  /// No description provided for @resetLinkSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi liên kết! Vui lòng kiểm tra email của bạn.'**
  String get resetLinkSent;

  /// No description provided for @invalidEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ'**
  String get invalidEmail;

  /// No description provided for @sellerDashboard.
  ///
  /// In vi, this message translates to:
  /// **'Shop của tôi'**
  String get sellerDashboard;

  /// No description provided for @sellerProducts.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm'**
  String get sellerProducts;

  /// No description provided for @sellerOrders.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng'**
  String get sellerOrders;

  /// No description provided for @sellerVouchers.
  ///
  /// In vi, this message translates to:
  /// **'Voucher'**
  String get sellerVouchers;

  /// No description provided for @registerSeller.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký bán hàng'**
  String get registerSeller;

  /// No description provided for @deliveryDashboard.
  ///
  /// In vi, this message translates to:
  /// **'Giao hàng'**
  String get deliveryDashboard;

  /// No description provided for @deliveryShipments.
  ///
  /// In vi, this message translates to:
  /// **'Đơn giao'**
  String get deliveryShipments;

  /// No description provided for @deliveryHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử'**
  String get deliveryHistory;

  /// No description provided for @adminPanel.
  ///
  /// In vi, this message translates to:
  /// **'Quản trị'**
  String get adminPanel;

  /// No description provided for @adminUsers.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng'**
  String get adminUsers;

  /// No description provided for @adminShops.
  ///
  /// In vi, this message translates to:
  /// **'Cửa hàng'**
  String get adminShops;

  /// No description provided for @adminDrivers.
  ///
  /// In vi, this message translates to:
  /// **'Nhân viên giao hàng'**
  String get adminDrivers;

  /// No description provided for @adminStats.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê'**
  String get adminStats;

  /// No description provided for @adminOverview.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan'**
  String get adminOverview;

  /// No description provided for @chatTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn'**
  String get chatTitle;

  /// No description provided for @chatEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tin nhắn nào'**
  String get chatEmpty;

  /// No description provided for @chatEmptyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu chat với người bán từ trang sản phẩm'**
  String get chatEmptyDesc;

  /// No description provided for @chatInputHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tin nhắn...'**
  String get chatInputHint;

  /// No description provided for @startChat.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu trò chuyện!'**
  String get startChat;

  /// No description provided for @online.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get online;

  /// No description provided for @justNow.
  ///
  /// In vi, this message translates to:
  /// **'Vừa xong'**
  String get justNow;

  /// No description provided for @notificationsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notificationsTitle;

  /// No description provided for @noNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thông báo'**
  String get noNotifications;

  /// No description provided for @noNotificationsDesc.
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ nhận thông báo khi có cập nhật đơn hàng'**
  String get noNotificationsDesc;

  /// No description provided for @readAll.
  ///
  /// In vi, this message translates to:
  /// **'Đọc tất cả'**
  String get readAll;

  /// No description provided for @minutesAgo.
  ///
  /// In vi, this message translates to:
  /// **'{count} phút trước'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In vi, this message translates to:
  /// **'{count} giờ trước'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In vi, this message translates to:
  /// **'{count} ngày trước'**
  String daysAgo(int count);

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get add;

  /// No description provided for @close.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get close;

  /// No description provided for @back.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get back;

  /// No description provided for @loading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry;

  /// No description provided for @success.
  ///
  /// In vi, this message translates to:
  /// **'Thành công'**
  String get success;

  /// No description provided for @noData.
  ///
  /// In vi, this message translates to:
  /// **'Không có dữ liệu'**
  String get noData;

  /// No description provided for @items.
  ///
  /// In vi, this message translates to:
  /// **'sản phẩm'**
  String get items;

  /// No description provided for @required.
  ///
  /// In vi, this message translates to:
  /// **'Bắt buộc'**
  String get required;

  /// No description provided for @orderNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy đơn hàng'**
  String get orderNotFound;

  /// No description provided for @products.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm'**
  String get products;

  /// No description provided for @shippingInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin giao hàng'**
  String get shippingInfo;

  /// No description provided for @driverDelivering.
  ///
  /// In vi, this message translates to:
  /// **'Tài xế đang giao'**
  String get driverDelivering;

  /// No description provided for @statusLabel.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái: {status}'**
  String statusLabel(String status);

  /// No description provided for @summary.
  ///
  /// In vi, this message translates to:
  /// **'Tóm tắt'**
  String get summary;

  /// No description provided for @orderCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã đơn'**
  String get orderCode;

  /// No description provided for @itemCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'{count} sản phẩm'**
  String itemCountLabel(int count);

  /// No description provided for @paymentMethodLabel.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức'**
  String get paymentMethodLabel;

  /// No description provided for @orderStatusTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái đơn hàng'**
  String get orderStatusTitle;

  /// No description provided for @orderCancelled.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng đã bị huỷ'**
  String get orderCancelled;

  /// No description provided for @stepPlaced.
  ///
  /// In vi, this message translates to:
  /// **'Đặt hàng'**
  String get stepPlaced;

  /// No description provided for @stepPlacedDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng đã được tạo'**
  String get stepPlacedDesc;

  /// No description provided for @stepConfirmed.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get stepConfirmed;

  /// No description provided for @stepConfirmedDesc.
  ///
  /// In vi, this message translates to:
  /// **'Người bán đã xác nhận'**
  String get stepConfirmedDesc;

  /// No description provided for @stepShippingDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đang trên đường giao'**
  String get stepShippingDesc;

  /// No description provided for @stepComplete.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất'**
  String get stepComplete;

  /// No description provided for @stepCompleteDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đã giao thành công'**
  String get stepCompleteDesc;

  /// No description provided for @statusDelivered.
  ///
  /// In vi, this message translates to:
  /// **'Đã giao thành công'**
  String get statusDelivered;

  /// No description provided for @statusShipping.
  ///
  /// In vi, this message translates to:
  /// **'Đang giao hàng'**
  String get statusShipping;

  /// No description provided for @statusConfirmed.
  ///
  /// In vi, this message translates to:
  /// **'Đã xác nhận'**
  String get statusConfirmed;

  /// No description provided for @statusProcessing.
  ///
  /// In vi, this message translates to:
  /// **'Đang xử lý'**
  String get statusProcessing;

  /// No description provided for @statusCancelled.
  ///
  /// In vi, this message translates to:
  /// **'Đã huỷ'**
  String get statusCancelled;

  /// No description provided for @statusPending.
  ///
  /// In vi, this message translates to:
  /// **'Chờ xác nhận'**
  String get statusPending;

  /// No description provided for @subtitleDelivered.
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn đã mua hàng!'**
  String get subtitleDelivered;

  /// No description provided for @subtitleShipping.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng đang trên đường đến bạn'**
  String get subtitleShipping;

  /// No description provided for @subtitleConfirmed.
  ///
  /// In vi, this message translates to:
  /// **'Người bán đang chuẩn bị hàng'**
  String get subtitleConfirmed;

  /// No description provided for @subtitleCancelled.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng đã bị huỷ bỏ'**
  String get subtitleCancelled;

  /// No description provided for @subtitlePending.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ người bán xác nhận'**
  String get subtitlePending;

  /// No description provided for @shipAssigned.
  ///
  /// In vi, this message translates to:
  /// **'Đã giao cho tài xế'**
  String get shipAssigned;

  /// No description provided for @shipPickingUp.
  ///
  /// In vi, this message translates to:
  /// **'Đang lấy hàng'**
  String get shipPickingUp;

  /// No description provided for @shipPickedUp.
  ///
  /// In vi, this message translates to:
  /// **'Đã lấy hàng'**
  String get shipPickedUp;

  /// No description provided for @shipInTransit.
  ///
  /// In vi, this message translates to:
  /// **'Đang vận chuyển'**
  String get shipInTransit;

  /// No description provided for @shipDelivered.
  ///
  /// In vi, this message translates to:
  /// **'Đã giao'**
  String get shipDelivered;

  /// No description provided for @shipFailed.
  ///
  /// In vi, this message translates to:
  /// **'Giao thất bại'**
  String get shipFailed;

  /// No description provided for @shipUnknown.
  ///
  /// In vi, this message translates to:
  /// **'Chưa rõ'**
  String get shipUnknown;

  /// No description provided for @product.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm'**
  String get product;

  /// No description provided for @searchProducts.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm sản phẩm...'**
  String get searchProducts;

  /// No description provided for @suggestedForYou.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý cho bạn'**
  String get suggestedForYou;

  /// No description provided for @recentSearches.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm gần đây'**
  String get recentSearches;

  /// No description provided for @clearAll.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tất cả'**
  String get clearAll;

  /// No description provided for @nResults.
  ///
  /// In vi, this message translates to:
  /// **'{count} kết quả'**
  String nResults(int count);

  /// No description provided for @noProductsFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy sản phẩm'**
  String get noProductsFound;

  /// No description provided for @tryDifferentKeyword.
  ///
  /// In vi, this message translates to:
  /// **'Thử từ khóa khác hoặc bỏ bộ lọc'**
  String get tryDifferentKeyword;

  /// No description provided for @loadMore.
  ///
  /// In vi, this message translates to:
  /// **'Xem Thêm'**
  String get loadMore;

  /// No description provided for @sortBy.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp: '**
  String get sortBy;

  /// No description provided for @sortNewest.
  ///
  /// In vi, this message translates to:
  /// **'Mới nhất'**
  String get sortNewest;

  /// No description provided for @sortPriceAsc.
  ///
  /// In vi, this message translates to:
  /// **'Giá tăng dần'**
  String get sortPriceAsc;

  /// No description provided for @sortPriceDesc.
  ///
  /// In vi, this message translates to:
  /// **'Giá giảm dần'**
  String get sortPriceDesc;

  /// No description provided for @sortBestRated.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá cao'**
  String get sortBestRated;

  /// No description provided for @editProfileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa hồ sơ'**
  String get editProfileTitle;

  /// No description provided for @myOrders.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng của tôi'**
  String get myOrders;

  /// No description provided for @shippingAddresses.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ giao hàng'**
  String get shippingAddresses;

  /// No description provided for @paymentMethods2.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức thanh toán'**
  String get paymentMethods2;

  /// No description provided for @messagesMenu.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn'**
  String get messagesMenu;

  /// No description provided for @helpAndSupport.
  ///
  /// In vi, this message translates to:
  /// **'Trợ giúp & Hỗ trợ'**
  String get helpAndSupport;

  /// No description provided for @languageMenu.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ / Language'**
  String get languageMenu;

  /// No description provided for @chooseLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ / Choose Language'**
  String get chooseLanguage;

  /// No description provided for @services.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ'**
  String get services;

  /// No description provided for @sellerChannel.
  ///
  /// In vi, this message translates to:
  /// **'Kênh Người Bán'**
  String get sellerChannel;

  /// No description provided for @sellerChannelDesc.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý cửa hàng & đơn hàng'**
  String get sellerChannelDesc;

  /// No description provided for @deliveryChannel.
  ///
  /// In vi, this message translates to:
  /// **'Kênh Giao Hàng'**
  String get deliveryChannel;

  /// No description provided for @deliveryChannelDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhận đơn giao & kiếm thu nhập'**
  String get deliveryChannelDesc;

  /// No description provided for @adminPanelDesc.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý hệ thống & duyệt đơn'**
  String get adminPanelDesc;

  /// No description provided for @preferences.
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chỉnh'**
  String get preferences;

  /// No description provided for @darkModeToggle.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ tối'**
  String get darkModeToggle;

  /// No description provided for @pushNotifToggle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo đẩy'**
  String get pushNotifToggle;

  /// No description provided for @emailUpdatesToggle.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật qua email'**
  String get emailUpdatesToggle;

  /// No description provided for @signOut.
  ///
  /// In vi, this message translates to:
  /// **'Đăng Xuất'**
  String get signOut;

  /// No description provided for @ordersCount.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng'**
  String get ordersCount;

  /// No description provided for @addressesCount.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ'**
  String get addressesCount;

  /// No description provided for @sessionExpired.
  ///
  /// In vi, this message translates to:
  /// **'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.'**
  String get sessionExpired;

  /// No description provided for @connectionError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi kết nối: {error}'**
  String connectionError(String error);

  /// No description provided for @startSelling.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu bán hàng'**
  String get startSelling;

  /// No description provided for @openShopFree.
  ///
  /// In vi, this message translates to:
  /// **'Mở cửa hàng miễn phí, bắt đầu kinh doanh ngay!'**
  String get openShopFree;

  /// No description provided for @shopNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên cửa hàng *'**
  String get shopNameLabel;

  /// No description provided for @shopNameHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Fashion Store ABC'**
  String get shopNameHint;

  /// No description provided for @descriptionOptional.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả (tuỳ chọn)'**
  String get descriptionOptional;

  /// No description provided for @shopDescHint.
  ///
  /// In vi, this message translates to:
  /// **'Chuyên thời trang cao cấp...'**
  String get shopDescHint;

  /// No description provided for @openShop.
  ///
  /// In vi, this message translates to:
  /// **'Mở cửa hàng'**
  String get openShop;

  /// No description provided for @shopNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên cửa hàng'**
  String get shopNameRequired;

  /// No description provided for @shopCreatedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'🎉 Mở cửa hàng thành công!'**
  String get shopCreatedSuccess;

  /// No description provided for @registerDelivery.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký giao hàng'**
  String get registerDelivery;

  /// No description provided for @deliveryRegistrationDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhận đơn giao hàng, kiếm thu nhập thêm!'**
  String get deliveryRegistrationDesc;

  /// No description provided for @vehicleTypeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Loại xe *'**
  String get vehicleTypeLabel;

  /// No description provided for @vehicleTypeHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Xe máy, Ô tô'**
  String get vehicleTypeHint;

  /// No description provided for @licensePlateOptional.
  ///
  /// In vi, this message translates to:
  /// **'Biển số xe (tuỳ chọn)'**
  String get licensePlateOptional;

  /// No description provided for @licensePlateHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: 59A1-12345'**
  String get licensePlateHint;

  /// No description provided for @startDelivery.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu giao hàng'**
  String get startDelivery;

  /// No description provided for @vehicleRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập loại xe'**
  String get vehicleRequired;

  /// No description provided for @deliveryRegisteredSuccess.
  ///
  /// In vi, this message translates to:
  /// **'🚀 Đăng ký giao hàng thành công!'**
  String get deliveryRegisteredSuccess;

  /// No description provided for @paymentMethodsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức thanh toán'**
  String get paymentMethodsTitle;

  /// No description provided for @codLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán khi nhận hàng (COD)'**
  String get codLabel;

  /// No description provided for @ewalletLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ví điện tử'**
  String get ewalletLabel;

  /// No description provided for @creditCardLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thẻ tín dụng / ghi nợ'**
  String get creditCardLabel;

  /// No description provided for @bankTransferLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển khoản ngân hàng'**
  String get bankTransferLabel;

  /// No description provided for @notifMenuTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notifMenuTitle;

  /// No description provided for @helpChatSupport.
  ///
  /// In vi, this message translates to:
  /// **'Chat với hỗ trợ'**
  String get helpChatSupport;

  /// No description provided for @helpEmail.
  ///
  /// In vi, this message translates to:
  /// **'Gửi email: support@lucent.vn'**
  String get helpEmail;

  /// No description provided for @helpHotline.
  ///
  /// In vi, this message translates to:
  /// **'Hotline: 1900 1234'**
  String get helpHotline;

  /// No description provided for @helpFaq.
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi thường gặp'**
  String get helpFaq;

  /// No description provided for @helpPrivacy.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách bảo mật'**
  String get helpPrivacy;

  /// No description provided for @helpTerms.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản sử dụng'**
  String get helpTerms;

  /// No description provided for @addressTitle.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ giao hàng'**
  String get addressTitle;

  /// No description provided for @addNewAddress.
  ///
  /// In vi, this message translates to:
  /// **'Thêm địa chỉ mới'**
  String get addNewAddress;

  /// No description provided for @fullNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Họ tên'**
  String get fullNameLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get phoneLabel;

  /// No description provided for @streetLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đường/số nhà'**
  String get streetLabel;

  /// No description provided for @wardLabel.
  ///
  /// In vi, this message translates to:
  /// **'Phường/xã'**
  String get wardLabel;

  /// No description provided for @districtLabel.
  ///
  /// In vi, this message translates to:
  /// **'Quận/huyện'**
  String get districtLabel;

  /// No description provided for @cityLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tỉnh/thành phố'**
  String get cityLabel;

  /// No description provided for @saveAddress.
  ///
  /// In vi, this message translates to:
  /// **'Lưu địa chỉ'**
  String get saveAddress;

  /// No description provided for @fillAllInfo.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập đầy đủ thông tin'**
  String get fillAllInfo;

  /// No description provided for @addressAdded.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm địa chỉ'**
  String get addressAdded;

  /// No description provided for @addressDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa địa chỉ'**
  String get addressDeleted;

  /// No description provided for @noAddresses.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có địa chỉ nào'**
  String get noAddresses;

  /// No description provided for @addAddress.
  ///
  /// In vi, this message translates to:
  /// **'+ Thêm địa chỉ'**
  String get addAddress;

  /// No description provided for @defaultLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mặc định'**
  String get defaultLabel;

  /// No description provided for @editProfileFullName.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get editProfileFullName;

  /// No description provided for @nameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Tên không được để trống'**
  String get nameRequired;

  /// No description provided for @updateSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật thành công!'**
  String get updateSuccess;

  /// No description provided for @saveChanges.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get saveChanges;

  /// No description provided for @sellerOverview.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan'**
  String get sellerOverview;

  /// No description provided for @sellerProductsNav.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm'**
  String get sellerProductsNav;

  /// No description provided for @sellerOrdersNav.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng'**
  String get sellerOrdersNav;

  /// No description provided for @shopLabel.
  ///
  /// In vi, this message translates to:
  /// **'Cửa hàng'**
  String get shopLabel;

  /// No description provided for @shopActive.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get shopActive;

  /// No description provided for @shopPending.
  ///
  /// In vi, this message translates to:
  /// **'Chờ duyệt'**
  String get shopPending;

  /// No description provided for @backToShopping.
  ///
  /// In vi, this message translates to:
  /// **'Quay về mua sắm'**
  String get backToShopping;

  /// No description provided for @totalRevenue.
  ///
  /// In vi, this message translates to:
  /// **'Tổng doanh thu'**
  String get totalRevenue;

  /// No description provided for @productsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm'**
  String get productsLabel;

  /// No description provided for @ordersLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng'**
  String get ordersLabel;

  /// No description provided for @pendingLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chờ xử lý'**
  String get pendingLabel;

  /// No description provided for @managementSection.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý'**
  String get managementSection;

  /// No description provided for @addNewProduct.
  ///
  /// In vi, this message translates to:
  /// **'Thêm sản phẩm mới'**
  String get addNewProduct;

  /// No description provided for @addNewProductDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đăng bán sản phẩm lên cửa hàng'**
  String get addNewProductDesc;

  /// No description provided for @noProducts.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có sản phẩm nào'**
  String get noProducts;

  /// No description provided for @addFirstProduct.
  ///
  /// In vi, this message translates to:
  /// **'Thêm sản phẩm đầu tiên của bạn'**
  String get addFirstProduct;

  /// No description provided for @nProductsShort.
  ///
  /// In vi, this message translates to:
  /// **'{count} sp'**
  String nProductsShort(int count);

  /// No description provided for @stock2.
  ///
  /// In vi, this message translates to:
  /// **'Kho: {count}'**
  String stock2(int count);

  /// No description provided for @deleteProduct.
  ///
  /// In vi, this message translates to:
  /// **'Xóa sản phẩm?'**
  String get deleteProduct;

  /// No description provided for @deleteProductConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm sẽ bị xóa vĩnh viễn.'**
  String get deleteProductConfirm;

  /// No description provided for @deleteAction.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get deleteAction;

  /// No description provided for @noSellerOrders.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đơn hàng'**
  String get noSellerOrders;

  /// No description provided for @customerLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khách'**
  String get customerLabel;

  /// No description provided for @nProductsDot.
  ///
  /// In vi, this message translates to:
  /// **'{count} sản phẩm'**
  String nProductsDot(int count);

  /// No description provided for @rejectAction.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get rejectAction;

  /// No description provided for @confirmAction.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirmAction;

  /// No description provided for @shipAction.
  ///
  /// In vi, this message translates to:
  /// **'Giao hàng'**
  String get shipAction;

  /// No description provided for @addProductTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm sản phẩm'**
  String get addProductTitle;

  /// No description provided for @productImages.
  ///
  /// In vi, this message translates to:
  /// **'Hình ảnh sản phẩm'**
  String get productImages;

  /// No description provided for @uploading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải...'**
  String get uploading;

  /// No description provided for @addPhoto.
  ///
  /// In vi, this message translates to:
  /// **'Thêm ảnh'**
  String get addPhoto;

  /// No description provided for @nPhotosHint.
  ///
  /// In vi, this message translates to:
  /// **'{count} ảnh · chạm để thêm'**
  String nPhotosHint(int count);

  /// No description provided for @basicInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cơ bản'**
  String get basicInfo;

  /// No description provided for @productNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên sản phẩm *'**
  String get productNameLabel;

  /// No description provided for @productNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Áo thun nam cao cấp'**
  String get productNameHint;

  /// No description provided for @productDescLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả sản phẩm *'**
  String get productDescLabel;

  /// No description provided for @productDescHint.
  ///
  /// In vi, this message translates to:
  /// **'Chất liệu cotton 100%...'**
  String get productDescHint;

  /// No description provided for @categoryLabel.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục *'**
  String get categoryLabel;

  /// No description provided for @selectCategory.
  ///
  /// In vi, this message translates to:
  /// **'Chọn danh mục'**
  String get selectCategory;

  /// No description provided for @priceAndStock.
  ///
  /// In vi, this message translates to:
  /// **'Giá & Kho'**
  String get priceAndStock;

  /// No description provided for @originalPrice.
  ///
  /// In vi, this message translates to:
  /// **'Giá gốc (₫) *'**
  String get originalPrice;

  /// No description provided for @salePrice.
  ///
  /// In vi, this message translates to:
  /// **'Giá sale (₫)'**
  String get salePrice;

  /// No description provided for @stockQuantity.
  ///
  /// In vi, this message translates to:
  /// **'Số lượng kho *'**
  String get stockQuantity;

  /// No description provided for @invalidNumber.
  ///
  /// In vi, this message translates to:
  /// **'Số không hợp lệ'**
  String get invalidNumber;

  /// No description provided for @publishProduct.
  ///
  /// In vi, this message translates to:
  /// **'Đăng sản phẩm'**
  String get publishProduct;

  /// No description provided for @productPublished.
  ///
  /// In vi, this message translates to:
  /// **'🎉 Đăng sản phẩm thành công!'**
  String get productPublished;

  /// No description provided for @waitForUpload.
  ///
  /// In vi, this message translates to:
  /// **'Đang upload ảnh, vui lòng chờ...'**
  String get waitForUpload;

  /// No description provided for @selectProductImage.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh sản phẩm'**
  String get selectProductImage;

  /// No description provided for @photoLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Thư viện ảnh'**
  String get photoLibrary;

  /// No description provided for @chooseFromCollection.
  ///
  /// In vi, this message translates to:
  /// **'Chọn từ bộ sưu tập'**
  String get chooseFromCollection;

  /// No description provided for @takePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh'**
  String get takePhoto;

  /// No description provided for @useCamera.
  ///
  /// In vi, this message translates to:
  /// **'Dùng camera để chụp'**
  String get useCamera;

  /// No description provided for @enterUrl.
  ///
  /// In vi, this message translates to:
  /// **'Nhập URL'**
  String get enterUrl;

  /// No description provided for @pasteImageUrl.
  ///
  /// In vi, this message translates to:
  /// **'Dán đường dẫn ảnh online'**
  String get pasteImageUrl;

  /// No description provided for @addImageFromUrl.
  ///
  /// In vi, this message translates to:
  /// **'Thêm ảnh từ URL'**
  String get addImageFromUrl;

  /// No description provided for @addAction.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get addAction;

  /// No description provided for @imagePickError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi chọn ảnh: {error}'**
  String imagePickError(String error);

  /// No description provided for @uploadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Upload thất bại: {error}'**
  String uploadFailed(String error);

  /// No description provided for @driverTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tài xế'**
  String get driverTitle;

  /// No description provided for @deliveryOverview.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan'**
  String get deliveryOverview;

  /// No description provided for @deliveryShipmentsNav.
  ///
  /// In vi, this message translates to:
  /// **'Đơn giao'**
  String get deliveryShipmentsNav;

  /// No description provided for @deliveryHistoryNav.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử'**
  String get deliveryHistoryNav;

  /// No description provided for @acceptingOrders.
  ///
  /// In vi, this message translates to:
  /// **'Đang nhận đơn'**
  String get acceptingOrders;

  /// No description provided for @notAcceptingOrders.
  ///
  /// In vi, this message translates to:
  /// **'Đã tắt nhận đơn'**
  String get notAcceptingOrders;

  /// No description provided for @acceptingOrdersDesc.
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ nhận được đơn giao mới'**
  String get acceptingOrdersDesc;

  /// No description provided for @enableAcceptingDesc.
  ///
  /// In vi, this message translates to:
  /// **'Bật lại để nhận đơn giao'**
  String get enableAcceptingDesc;

  /// No description provided for @totalShipments.
  ///
  /// In vi, this message translates to:
  /// **'Tổng đơn'**
  String get totalShipments;

  /// No description provided for @activeShipments.
  ///
  /// In vi, this message translates to:
  /// **'Đang giao'**
  String get activeShipments;

  /// No description provided for @completedShipments.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get completedShipments;

  /// No description provided for @currentShipments.
  ///
  /// In vi, this message translates to:
  /// **'Đơn đang giao'**
  String get currentShipments;

  /// No description provided for @noShipments.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đơn giao nào'**
  String get noShipments;

  /// No description provided for @deliveryHistoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử giao hàng'**
  String get deliveryHistoryTitle;

  /// No description provided for @noHistory.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lịch sử'**
  String get noHistory;

  /// No description provided for @shipAssignedShort.
  ///
  /// In vi, this message translates to:
  /// **'Được giao'**
  String get shipAssignedShort;

  /// No description provided for @pickUpAction.
  ///
  /// In vi, this message translates to:
  /// **'Lấy hàng'**
  String get pickUpAction;

  /// No description provided for @pickedUpAction.
  ///
  /// In vi, this message translates to:
  /// **'Đã lấy'**
  String get pickedUpAction;

  /// No description provided for @deliveringAction.
  ///
  /// In vi, this message translates to:
  /// **'Đang giao'**
  String get deliveringAction;

  /// No description provided for @deliveredAction.
  ///
  /// In vi, this message translates to:
  /// **'Đã giao'**
  String get deliveredAction;

  /// No description provided for @failedAction.
  ///
  /// In vi, this message translates to:
  /// **'Thất bại'**
  String get failedAction;

  /// No description provided for @shipmentId.
  ///
  /// In vi, this message translates to:
  /// **'Đơn #{id}'**
  String shipmentId(String id);

  /// No description provided for @nShipments.
  ///
  /// In vi, this message translates to:
  /// **'{count} đơn'**
  String nShipments(int count);

  /// No description provided for @exitAdmin.
  ///
  /// In vi, this message translates to:
  /// **'Thoát Admin'**
  String get exitAdmin;

  /// No description provided for @adminTotalRevenue.
  ///
  /// In vi, this message translates to:
  /// **'Tổng doanh thu'**
  String get adminTotalRevenue;

  /// No description provided for @adminUsersLabel.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng'**
  String get adminUsersLabel;

  /// No description provided for @adminOrdersLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng'**
  String get adminOrdersLabel;

  /// No description provided for @adminProductsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm'**
  String get adminProductsLabel;

  /// No description provided for @adminShopsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Cửa hàng'**
  String get adminShopsLabel;

  /// No description provided for @adminDriversLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tài xế'**
  String get adminDriversLabel;

  /// No description provided for @adminPendingLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chờ duyệt'**
  String get adminPendingLabel;

  /// No description provided for @adminOrderStatus.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái đơn hàng'**
  String get adminOrderStatus;

  /// No description provided for @manageUsers.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý người dùng ({count})'**
  String manageUsers(int count);

  /// No description provided for @manageShops.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý cửa hàng ({count})'**
  String manageShops(int count);

  /// No description provided for @manageDrivers.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý tài xế ({count})'**
  String manageDrivers(int count);

  /// No description provided for @approveAction.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt'**
  String get approveAction;

  /// No description provided for @rejectShopAction.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get rejectShopAction;

  /// No description provided for @shopApproved.
  ///
  /// In vi, this message translates to:
  /// **'Đã duyệt cửa hàng!'**
  String get shopApproved;

  /// No description provided for @shopRejected.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối cửa hàng!'**
  String get shopRejected;

  /// No description provided for @errorLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi: {error}'**
  String errorLabel(String error);

  /// No description provided for @onboardingTitle1.
  ///
  /// In vi, this message translates to:
  /// **'Khám Phá Sản Phẩm Cao Cấp'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt hàng nghìn sản phẩm chất lượng từ những người bán uy tín, được tuyển chọn riêng cho bạn.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In vi, this message translates to:
  /// **'Giao Hàng Siêu Tốc'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi đơn hàng theo thời gian thực. Từ cửa hàng đến tay bạn, mọi thứ đều trong tầm kiểm soát.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In vi, this message translates to:
  /// **'An Toàn & Tin Cậy'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán bảo mật, người bán xác minh, đổi trả dễ dàng. Mua sắm an tâm.'**
  String get onboardingSubtitle3;

  /// No description provided for @skip.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp theo'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In vi, this message translates to:
  /// **'Bắt Đầu Ngay'**
  String get getStarted;

  /// No description provided for @rememberMe.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhớ tài khoản'**
  String get rememberMe;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
