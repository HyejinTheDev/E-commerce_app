// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Lucent';

  @override
  String get home => 'Trang chủ';

  @override
  String get explore => 'Khám phá';

  @override
  String get cart => 'Giỏ hàng';

  @override
  String get orders => 'Đơn hàng';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get searchHint => 'Tìm sản phẩm, thương hiệu...';

  @override
  String get categories => 'Danh mục';

  @override
  String get allCategories => 'Tất cả';

  @override
  String get featuredProducts => 'Nổi Bật';

  @override
  String get newArrivals => 'Hàng mới về';

  @override
  String get seeAll => 'Xem tất cả';

  @override
  String get springCollection => 'Bộ Sưu Tập\nXuân';

  @override
  String get shopNow => 'Mua Ngay';

  @override
  String get browseAndAdd => 'Duyệt sản phẩm và thêm vào giỏ';

  @override
  String get shopNowBtn => 'Mua Sắm Ngay';

  @override
  String get productDetail => 'Chi Tiết Sản Phẩm';

  @override
  String get selectSize => 'Chọn size';

  @override
  String get selectColor => 'Chọn màu';

  @override
  String get description => 'Mô tả';

  @override
  String get reviews => 'Đánh giá';

  @override
  String get writeReview => 'Viết đánh giá';

  @override
  String get submitReview => 'Gửi Đánh Giá';

  @override
  String get reviewHint => 'Hãy chia sẻ nhận xét của bạn về sản phẩm...';

  @override
  String get total => 'Tổng';

  @override
  String get addToCart => 'Giỏ';

  @override
  String get buyNow => 'Mua Ngay';

  @override
  String get addedToCart => 'đã được thêm vào giỏ hàng';

  @override
  String get stock => 'Kho';

  @override
  String get inStock => 'Còn hàng';

  @override
  String get outOfStock => 'Hết hàng';

  @override
  String get chatWithSeller => 'Chat với người bán';

  @override
  String get reviewSuccess => 'Đánh giá thành công!';

  @override
  String get reviewFailed => 'Gửi đánh giá thất bại';

  @override
  String get cartTitle => 'Giỏ Hàng';

  @override
  String get cartEmpty => 'Giỏ hàng trống';

  @override
  String get cartEmptyDesc => 'Thêm sản phẩm để bắt đầu mua sắm';

  @override
  String get checkout => 'Thanh Toán';

  @override
  String get subtotal => 'Tạm tính';

  @override
  String get shipping => 'Vận chuyển';

  @override
  String get freeShipping => 'Miễn phí';

  @override
  String get orderTotal => 'Tổng cộng';

  @override
  String get removeItem => 'Xóa';

  @override
  String get tax => 'Thuế';

  @override
  String get proceedToCheckout => 'Tiến Hành Thanh Toán';

  @override
  String nItems(int count) {
    return '$count sản phẩm';
  }

  @override
  String get voucherCode => 'Mã giảm giá';

  @override
  String get voucherHint => 'Nhập mã giảm giá';

  @override
  String discountLabel(String code) {
    return 'Giảm giá ($code)';
  }

  @override
  String get checkoutTitle => 'Thanh Toán';

  @override
  String get shippingAddress => 'Địa Chỉ Giao Hàng';

  @override
  String get paymentMethod => 'Thanh toán';

  @override
  String get placeOrder => 'Đặt Hàng';

  @override
  String get placingOrder => 'Đang đặt hàng...';

  @override
  String placeOrderWithTotal(String total) {
    return 'Đặt Hàng — $total';
  }

  @override
  String get orderSuccess => 'Đặt hàng thành công!';

  @override
  String get orderSuccessDesc => 'Đơn hàng của bạn đã được đặt thành công.';

  @override
  String get continueShopping => 'Tiếp Tục Mua Sắm';

  @override
  String get orderFailed => 'Đặt hàng thất bại. Vui lòng thử lại.';

  @override
  String get cod => 'Thanh toán khi nhận hàng';

  @override
  String get bankTransfer => 'Chuyển khoản ngân hàng';

  @override
  String get voucher => 'Mã giảm giá';

  @override
  String get applyVoucher => 'Áp dụng';

  @override
  String get change => 'Thay đổi';

  @override
  String get deliveryLabel => 'Giao hàng';

  @override
  String get deliveryStandard => 'Tiêu chuẩn (5-7 ngày)';

  @override
  String get deliveryFast => 'Nhanh (2-3 ngày)';

  @override
  String get stepShipping => 'Giao hàng';

  @override
  String get stepPayment => 'Thanh toán';

  @override
  String get stepConfirm => 'Xác nhận';

  @override
  String get ordersTitle => 'Đơn Hàng';

  @override
  String get orderTracking => 'Theo dõi đơn hàng';

  @override
  String get trackOrder => 'Theo Dõi';

  @override
  String get orderStatus => 'Trạng thái';

  @override
  String orderIdLabel(String id) {
    return 'Đơn hàng #$id';
  }

  @override
  String get pending => 'Chờ xác nhận';

  @override
  String get confirmed => 'Đã xác nhận';

  @override
  String get processing => 'Đang xử lý';

  @override
  String get shippingStatus => 'Đang giao';

  @override
  String get delivered => 'Đã giao';

  @override
  String get cancelled => 'Đã hủy';

  @override
  String get noOrders => 'Chưa có đơn hàng';

  @override
  String get noOrdersDesc =>
      'Đơn hàng sẽ xuất hiện tại đây sau khi bạn đặt hàng';

  @override
  String get profileTitle => 'Hồ Sơ';

  @override
  String get editProfile => 'Chỉnh sửa hồ sơ';

  @override
  String get addresses => 'Địa chỉ';

  @override
  String get paymentMethods => 'Phương thức thanh toán';

  @override
  String get notifications => 'Thông báo';

  @override
  String get messages => 'Tin nhắn';

  @override
  String get helpSupport => 'Trợ giúp & Hỗ trợ';

  @override
  String get settings => 'Cài đặt';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get darkMode => 'Chế độ tối';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get logoutConfirm => 'Bạn có chắc muốn đăng xuất?';

  @override
  String get cancel => 'Hủy';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get welcomeBack => 'Chào Mừng\nTrở Lại';

  @override
  String get loginSubtitle => 'Đăng nhập để tiếp tục mua sắm';

  @override
  String get loginFailed => 'Đăng nhập thất bại';

  @override
  String get fillAllFields => 'Vui lòng nhập đầy đủ thông tin';

  @override
  String get createAccount => 'Tạo\nTài Khoản';

  @override
  String get registerSubtitle => 'Đăng ký miễn phí và bắt đầu mua sắm';

  @override
  String get registerFailed => 'Đăng ký thất bại';

  @override
  String get createAccountBtn => 'Tạo Tài Khoản';

  @override
  String get fullName => 'Họ và tên';

  @override
  String get fullNameHint => 'Nguyễn Văn A';

  @override
  String get passwordHint => 'Tối thiểu 6 ký tự';

  @override
  String get phoneOptional => 'Số điện thoại (tuỳ chọn)';

  @override
  String get fillRequired => 'Vui lòng nhập các trường bắt buộc';

  @override
  String get passwordMinLength => 'Mật khẩu phải có ít nhất 6 ký tự';

  @override
  String get login => 'Đăng nhập';

  @override
  String get loginBtn => 'Đăng Nhập';

  @override
  String get register => 'Đăng ký';

  @override
  String get registerBtn => 'Đăng Ký';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get name => 'Tên';

  @override
  String get phone => 'Số điện thoại';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get dontHaveAccount => 'Chưa có tài khoản?';

  @override
  String get alreadyHaveAccount => 'Đã có tài khoản?';

  @override
  String get forgotPasswordTitle => 'Khôi phục mật khẩu';

  @override
  String get forgotPasswordDesc =>
      'Nhập email của bạn, chúng tôi sẽ gửi liên kết để đặt lại mật khẩu.';

  @override
  String get sendResetLink => 'Gửi liên kết';

  @override
  String get noInternetConnection => 'Không có kết nối mạng';

  @override
  String get resetLinkSent =>
      'Đã gửi liên kết! Vui lòng kiểm tra email của bạn.';

  @override
  String get invalidEmail => 'Email không hợp lệ';

  @override
  String get sellerDashboard => 'Shop của tôi';

  @override
  String get sellerProducts => 'Sản phẩm';

  @override
  String get sellerOrders => 'Đơn hàng';

  @override
  String get sellerVouchers => 'Voucher';

  @override
  String get registerSeller => 'Đăng ký bán hàng';

  @override
  String get deliveryDashboard => 'Giao hàng';

  @override
  String get deliveryShipments => 'Đơn giao';

  @override
  String get deliveryHistory => 'Lịch sử';

  @override
  String get adminPanel => 'Quản trị';

  @override
  String get adminUsers => 'Người dùng';

  @override
  String get adminShops => 'Cửa hàng';

  @override
  String get adminDrivers => 'Nhân viên giao hàng';

  @override
  String get adminStats => 'Thống kê';

  @override
  String get adminOverview => 'Tổng quan';

  @override
  String get chatTitle => 'Tin nhắn';

  @override
  String get chatEmpty => 'Chưa có tin nhắn nào';

  @override
  String get chatEmptyDesc => 'Bắt đầu chat với người bán từ trang sản phẩm';

  @override
  String get chatInputHint => 'Nhập tin nhắn...';

  @override
  String get startChat => 'Bắt đầu trò chuyện!';

  @override
  String get online => 'Đang hoạt động';

  @override
  String get justNow => 'Vừa xong';

  @override
  String get notificationsTitle => 'Thông báo';

  @override
  String get noNotifications => 'Chưa có thông báo';

  @override
  String get noNotificationsDesc =>
      'Bạn sẽ nhận thông báo khi có cập nhật đơn hàng';

  @override
  String get readAll => 'Đọc tất cả';

  @override
  String minutesAgo(int count) {
    return '$count phút trước';
  }

  @override
  String hoursAgo(int count) {
    return '$count giờ trước';
  }

  @override
  String daysAgo(int count) {
    return '$count ngày trước';
  }

  @override
  String get save => 'Lưu';

  @override
  String get delete => 'Xóa';

  @override
  String get edit => 'Sửa';

  @override
  String get add => 'Thêm';

  @override
  String get close => 'Đóng';

  @override
  String get back => 'Quay lại';

  @override
  String get loading => 'Đang tải...';

  @override
  String get error => 'Lỗi';

  @override
  String get retry => 'Thử lại';

  @override
  String get success => 'Thành công';

  @override
  String get noData => 'Không có dữ liệu';

  @override
  String get items => 'sản phẩm';

  @override
  String get required => 'Bắt buộc';

  @override
  String get orderNotFound => 'Không tìm thấy đơn hàng';

  @override
  String get products => 'Sản phẩm';

  @override
  String get shippingInfo => 'Thông tin giao hàng';

  @override
  String get driverDelivering => 'Tài xế đang giao';

  @override
  String statusLabel(String status) {
    return 'Trạng thái: $status';
  }

  @override
  String get summary => 'Tóm tắt';

  @override
  String get orderCode => 'Mã đơn';

  @override
  String itemCountLabel(int count) {
    return '$count sản phẩm';
  }

  @override
  String get paymentMethodLabel => 'Phương thức';

  @override
  String get orderStatusTitle => 'Trạng thái đơn hàng';

  @override
  String get orderCancelled => 'Đơn hàng đã bị huỷ';

  @override
  String get stepPlaced => 'Đặt hàng';

  @override
  String get stepPlacedDesc => 'Đơn hàng đã được tạo';

  @override
  String get stepConfirmed => 'Xác nhận';

  @override
  String get stepConfirmedDesc => 'Người bán đã xác nhận';

  @override
  String get stepShippingDesc => 'Đang trên đường giao';

  @override
  String get stepComplete => 'Hoàn tất';

  @override
  String get stepCompleteDesc => 'Đã giao thành công';

  @override
  String get statusDelivered => 'Đã giao thành công';

  @override
  String get statusShipping => 'Đang giao hàng';

  @override
  String get statusConfirmed => 'Đã xác nhận';

  @override
  String get statusProcessing => 'Đang xử lý';

  @override
  String get statusCancelled => 'Đã huỷ';

  @override
  String get statusPending => 'Chờ xác nhận';

  @override
  String get subtitleDelivered => 'Cảm ơn bạn đã mua hàng!';

  @override
  String get subtitleShipping => 'Đơn hàng đang trên đường đến bạn';

  @override
  String get subtitleConfirmed => 'Người bán đang chuẩn bị hàng';

  @override
  String get subtitleCancelled => 'Đơn hàng đã bị huỷ bỏ';

  @override
  String get subtitlePending => 'Đang chờ người bán xác nhận';

  @override
  String get shipAssigned => 'Đã giao cho tài xế';

  @override
  String get shipPickingUp => 'Đang lấy hàng';

  @override
  String get shipPickedUp => 'Đã lấy hàng';

  @override
  String get shipInTransit => 'Đang vận chuyển';

  @override
  String get shipDelivered => 'Đã giao';

  @override
  String get shipFailed => 'Giao thất bại';

  @override
  String get shipUnknown => 'Chưa rõ';

  @override
  String get product => 'Sản phẩm';

  @override
  String get searchProducts => 'Tìm kiếm sản phẩm...';

  @override
  String get suggestedForYou => 'Gợi ý cho bạn';

  @override
  String get recentSearches => 'Tìm kiếm gần đây';

  @override
  String get clearAll => 'Xóa tất cả';

  @override
  String nResults(int count) {
    return '$count kết quả';
  }

  @override
  String get noProductsFound => 'Không tìm thấy sản phẩm';

  @override
  String get tryDifferentKeyword => 'Thử từ khóa khác hoặc bỏ bộ lọc';

  @override
  String get loadMore => 'Xem Thêm';

  @override
  String get sortBy => 'Sắp xếp: ';

  @override
  String get sortNewest => 'Mới nhất';

  @override
  String get sortPriceAsc => 'Giá tăng dần';

  @override
  String get sortPriceDesc => 'Giá giảm dần';

  @override
  String get sortBestRated => 'Đánh giá cao';

  @override
  String get editProfileTitle => 'Sửa hồ sơ';

  @override
  String get myOrders => 'Đơn hàng của tôi';

  @override
  String get shippingAddresses => 'Địa chỉ giao hàng';

  @override
  String get paymentMethods2 => 'Phương thức thanh toán';

  @override
  String get messagesMenu => 'Tin nhắn';

  @override
  String get helpAndSupport => 'Trợ giúp & Hỗ trợ';

  @override
  String get languageMenu => 'Ngôn ngữ / Language';

  @override
  String get chooseLanguage => 'Chọn ngôn ngữ / Choose Language';

  @override
  String get services => 'Dịch vụ';

  @override
  String get sellerChannel => 'Kênh Người Bán';

  @override
  String get sellerChannelDesc => 'Quản lý cửa hàng & đơn hàng';

  @override
  String get deliveryChannel => 'Kênh Giao Hàng';

  @override
  String get deliveryChannelDesc => 'Nhận đơn giao & kiếm thu nhập';

  @override
  String get adminPanelDesc => 'Quản lý hệ thống & duyệt đơn';

  @override
  String get preferences => 'Tuỳ chỉnh';

  @override
  String get darkModeToggle => 'Chế độ tối';

  @override
  String get pushNotifToggle => 'Thông báo đẩy';

  @override
  String get emailUpdatesToggle => 'Cập nhật qua email';

  @override
  String get signOut => 'Đăng Xuất';

  @override
  String get ordersCount => 'Đơn hàng';

  @override
  String get addressesCount => 'Địa chỉ';

  @override
  String get sessionExpired =>
      'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.';

  @override
  String connectionError(String error) {
    return 'Lỗi kết nối: $error';
  }

  @override
  String get startSelling => 'Bắt đầu bán hàng';

  @override
  String get openShopFree => 'Mở cửa hàng miễn phí, bắt đầu kinh doanh ngay!';

  @override
  String get shopNameLabel => 'Tên cửa hàng *';

  @override
  String get shopNameHint => 'VD: Fashion Store ABC';

  @override
  String get descriptionOptional => 'Mô tả (tuỳ chọn)';

  @override
  String get shopDescHint => 'Chuyên thời trang cao cấp...';

  @override
  String get openShop => 'Mở cửa hàng';

  @override
  String get shopNameRequired => 'Vui lòng nhập tên cửa hàng';

  @override
  String get shopCreatedSuccess => '🎉 Mở cửa hàng thành công!';

  @override
  String get registerDelivery => 'Đăng ký giao hàng';

  @override
  String get deliveryRegistrationDesc =>
      'Nhận đơn giao hàng, kiếm thu nhập thêm!';

  @override
  String get vehicleTypeLabel => 'Loại xe *';

  @override
  String get vehicleTypeHint => 'VD: Xe máy, Ô tô';

  @override
  String get licensePlateOptional => 'Biển số xe (tuỳ chọn)';

  @override
  String get licensePlateHint => 'VD: 59A1-12345';

  @override
  String get startDelivery => 'Bắt đầu giao hàng';

  @override
  String get vehicleRequired => 'Vui lòng nhập loại xe';

  @override
  String get deliveryRegisteredSuccess => '🚀 Đăng ký giao hàng thành công!';

  @override
  String get paymentMethodsTitle => 'Phương thức thanh toán';

  @override
  String get codLabel => 'Thanh toán khi nhận hàng (COD)';

  @override
  String get ewalletLabel => 'Ví điện tử';

  @override
  String get creditCardLabel => 'Thẻ tín dụng / ghi nợ';

  @override
  String get bankTransferLabel => 'Chuyển khoản ngân hàng';

  @override
  String get notifMenuTitle => 'Thông báo';

  @override
  String get helpChatSupport => 'Chat với hỗ trợ';

  @override
  String get helpEmail => 'Gửi email: support@lucent.vn';

  @override
  String get helpHotline => 'Hotline: 1900 1234';

  @override
  String get helpFaq => 'Câu hỏi thường gặp';

  @override
  String get helpPrivacy => 'Chính sách bảo mật';

  @override
  String get helpTerms => 'Điều khoản sử dụng';

  @override
  String get addressTitle => 'Địa chỉ giao hàng';

  @override
  String get addNewAddress => 'Thêm địa chỉ mới';

  @override
  String get fullNameLabel => 'Họ tên';

  @override
  String get phoneLabel => 'Số điện thoại';

  @override
  String get streetLabel => 'Đường/số nhà';

  @override
  String get wardLabel => 'Phường/xã';

  @override
  String get districtLabel => 'Quận/huyện';

  @override
  String get cityLabel => 'Tỉnh/thành phố';

  @override
  String get saveAddress => 'Lưu địa chỉ';

  @override
  String get fillAllInfo => 'Vui lòng nhập đầy đủ thông tin';

  @override
  String get addressAdded => 'Đã thêm địa chỉ';

  @override
  String get addressDeleted => 'Đã xóa địa chỉ';

  @override
  String get noAddresses => 'Chưa có địa chỉ nào';

  @override
  String get addAddress => '+ Thêm địa chỉ';

  @override
  String get defaultLabel => 'Mặc định';

  @override
  String get editProfileFullName => 'Họ và tên';

  @override
  String get nameRequired => 'Tên không được để trống';

  @override
  String get updateSuccess => 'Cập nhật thành công!';

  @override
  String get saveChanges => 'Lưu thay đổi';

  @override
  String get sellerOverview => 'Tổng quan';

  @override
  String get sellerProductsNav => 'Sản phẩm';

  @override
  String get sellerOrdersNav => 'Đơn hàng';

  @override
  String get shopLabel => 'Cửa hàng';

  @override
  String get shopActive => 'Đang hoạt động';

  @override
  String get shopPending => 'Chờ duyệt';

  @override
  String get backToShopping => 'Quay về mua sắm';

  @override
  String get totalRevenue => 'Tổng doanh thu';

  @override
  String get productsLabel => 'Sản phẩm';

  @override
  String get ordersLabel => 'Đơn hàng';

  @override
  String get pendingLabel => 'Chờ xử lý';

  @override
  String get managementSection => 'Quản lý';

  @override
  String get addNewProduct => 'Thêm sản phẩm mới';

  @override
  String get addNewProductDesc => 'Đăng bán sản phẩm lên cửa hàng';

  @override
  String get noProducts => 'Chưa có sản phẩm nào';

  @override
  String get addFirstProduct => 'Thêm sản phẩm đầu tiên của bạn';

  @override
  String nProductsShort(int count) {
    return '$count sp';
  }

  @override
  String stock2(int count) {
    return 'Kho: $count';
  }

  @override
  String get deleteProduct => 'Xóa sản phẩm?';

  @override
  String get deleteProductConfirm => 'Sản phẩm sẽ bị xóa vĩnh viễn.';

  @override
  String get deleteAction => 'Xóa';

  @override
  String get noSellerOrders => 'Chưa có đơn hàng';

  @override
  String get customerLabel => 'Khách';

  @override
  String nProductsDot(int count) {
    return '$count sản phẩm';
  }

  @override
  String get rejectAction => 'Từ chối';

  @override
  String get confirmAction => 'Xác nhận';

  @override
  String get shipAction => 'Giao hàng';

  @override
  String get addProductTitle => 'Thêm sản phẩm';

  @override
  String get productImages => 'Hình ảnh sản phẩm';

  @override
  String get uploading => 'Đang tải...';

  @override
  String get addPhoto => 'Thêm ảnh';

  @override
  String nPhotosHint(int count) {
    return '$count ảnh · chạm để thêm';
  }

  @override
  String get basicInfo => 'Thông tin cơ bản';

  @override
  String get productNameLabel => 'Tên sản phẩm *';

  @override
  String get productNameHint => 'Áo thun nam cao cấp';

  @override
  String get productDescLabel => 'Mô tả sản phẩm *';

  @override
  String get productDescHint => 'Chất liệu cotton 100%...';

  @override
  String get categoryLabel => 'Danh mục *';

  @override
  String get selectCategory => 'Chọn danh mục';

  @override
  String get priceAndStock => 'Giá & Kho';

  @override
  String get originalPrice => 'Giá gốc (₫) *';

  @override
  String get salePrice => 'Giá sale (₫)';

  @override
  String get stockQuantity => 'Số lượng kho *';

  @override
  String get invalidNumber => 'Số không hợp lệ';

  @override
  String get publishProduct => 'Đăng sản phẩm';

  @override
  String get productPublished => '🎉 Đăng sản phẩm thành công!';

  @override
  String get waitForUpload => 'Đang upload ảnh, vui lòng chờ...';

  @override
  String get selectProductImage => 'Chọn ảnh sản phẩm';

  @override
  String get photoLibrary => 'Thư viện ảnh';

  @override
  String get chooseFromCollection => 'Chọn từ bộ sưu tập';

  @override
  String get takePhoto => 'Chụp ảnh';

  @override
  String get useCamera => 'Dùng camera để chụp';

  @override
  String get enterUrl => 'Nhập URL';

  @override
  String get pasteImageUrl => 'Dán đường dẫn ảnh online';

  @override
  String get addImageFromUrl => 'Thêm ảnh từ URL';

  @override
  String get addAction => 'Thêm';

  @override
  String imagePickError(String error) {
    return 'Lỗi chọn ảnh: $error';
  }

  @override
  String uploadFailed(String error) {
    return 'Upload thất bại: $error';
  }

  @override
  String get driverTitle => 'Tài xế';

  @override
  String get deliveryOverview => 'Tổng quan';

  @override
  String get deliveryShipmentsNav => 'Đơn giao';

  @override
  String get deliveryHistoryNav => 'Lịch sử';

  @override
  String get acceptingOrders => 'Đang nhận đơn';

  @override
  String get notAcceptingOrders => 'Đã tắt nhận đơn';

  @override
  String get acceptingOrdersDesc => 'Bạn sẽ nhận được đơn giao mới';

  @override
  String get enableAcceptingDesc => 'Bật lại để nhận đơn giao';

  @override
  String get totalShipments => 'Tổng đơn';

  @override
  String get activeShipments => 'Đang giao';

  @override
  String get completedShipments => 'Hoàn thành';

  @override
  String get currentShipments => 'Đơn đang giao';

  @override
  String get noShipments => 'Chưa có đơn giao nào';

  @override
  String get deliveryHistoryTitle => 'Lịch sử giao hàng';

  @override
  String get noHistory => 'Chưa có lịch sử';

  @override
  String get shipAssignedShort => 'Được giao';

  @override
  String get pickUpAction => 'Lấy hàng';

  @override
  String get pickedUpAction => 'Đã lấy';

  @override
  String get deliveringAction => 'Đang giao';

  @override
  String get deliveredAction => 'Đã giao';

  @override
  String get failedAction => 'Thất bại';

  @override
  String shipmentId(String id) {
    return 'Đơn #$id';
  }

  @override
  String nShipments(int count) {
    return '$count đơn';
  }

  @override
  String get exitAdmin => 'Thoát Admin';

  @override
  String get adminTotalRevenue => 'Tổng doanh thu';

  @override
  String get adminUsersLabel => 'Người dùng';

  @override
  String get adminOrdersLabel => 'Đơn hàng';

  @override
  String get adminProductsLabel => 'Sản phẩm';

  @override
  String get adminShopsLabel => 'Cửa hàng';

  @override
  String get adminDriversLabel => 'Tài xế';

  @override
  String get adminPendingLabel => 'Chờ duyệt';

  @override
  String get adminOrderStatus => 'Trạng thái đơn hàng';

  @override
  String manageUsers(int count) {
    return 'Quản lý người dùng ($count)';
  }

  @override
  String manageShops(int count) {
    return 'Quản lý cửa hàng ($count)';
  }

  @override
  String manageDrivers(int count) {
    return 'Quản lý tài xế ($count)';
  }

  @override
  String get approveAction => 'Duyệt';

  @override
  String get rejectShopAction => 'Từ chối';

  @override
  String get shopApproved => 'Đã duyệt cửa hàng!';

  @override
  String get shopRejected => 'Đã từ chối cửa hàng!';

  @override
  String errorLabel(String error) {
    return 'Lỗi: $error';
  }

  @override
  String get onboardingTitle1 => 'Khám Phá Sản Phẩm Cao Cấp';

  @override
  String get onboardingSubtitle1 =>
      'Duyệt hàng nghìn sản phẩm chất lượng từ những người bán uy tín, được tuyển chọn riêng cho bạn.';

  @override
  String get onboardingTitle2 => 'Giao Hàng Siêu Tốc';

  @override
  String get onboardingSubtitle2 =>
      'Theo dõi đơn hàng theo thời gian thực. Từ cửa hàng đến tay bạn, mọi thứ đều trong tầm kiểm soát.';

  @override
  String get onboardingTitle3 => 'An Toàn & Tin Cậy';

  @override
  String get onboardingSubtitle3 =>
      'Thanh toán bảo mật, người bán xác minh, đổi trả dễ dàng. Mua sắm an tâm.';

  @override
  String get skip => 'Bỏ qua';

  @override
  String get next => 'Tiếp theo';

  @override
  String get getStarted => 'Bắt Đầu Ngay';

  @override
  String get rememberMe => 'Ghi nhớ tài khoản';
}
