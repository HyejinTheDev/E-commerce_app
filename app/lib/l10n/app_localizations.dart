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
  /// **'Sản phẩm nổi bật'**
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
  /// **'Phí vận chuyển'**
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

  /// No description provided for @checkoutTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thanh Toán'**
  String get checkoutTitle;

  /// No description provided for @shippingAddress.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ giao hàng'**
  String get shippingAddress;

  /// No description provided for @paymentMethod.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức thanh toán'**
  String get paymentMethod;

  /// No description provided for @placeOrder.
  ///
  /// In vi, this message translates to:
  /// **'Đặt Hàng'**
  String get placeOrder;

  /// No description provided for @orderSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đặt hàng thành công!'**
  String get orderSuccess;

  /// No description provided for @orderSuccessDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng của bạn đã được tạo.'**
  String get orderSuccessDesc;

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

  /// No description provided for @login.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login;

  /// No description provided for @register.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get register;

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
