# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GasmanProvider is an iOS app (UIKit, Swift) for a gas delivery service provider. It supports Arabic and English with full RTL layout support.

## Build & Run

This is an Xcode project — open `GasmanProvider.xcodeproj` in Xcode to build and run. There is no Podfile; dependencies are managed via Swift Package Manager (SPM) within Xcode.

Key dependencies used (visible from imports):
- **Alamofire** — networking
- **Lottie** — animations
- **Kingfisher** (likely) — remote image loading via `UIImageView` extensions

## Architecture

The app follows **MVVM** with UIKit + **Combine** for data binding.

### Screen Pattern
Every screen consists of:
- `SomeVC.swift` + `SomeVC.xib` — the view controller (XIB-based UI, no Storyboard)
- `SomeVM.swift` — the view model, subclasses `BaseViewModel`

`BaseViewController` (`Shared/View/BaseViewController/BaseViewController.swift`) is the base class for all VCs. It:
- Binds `isLoading` publisher to a global `AppIndicator`
- Binds `error` publisher to toast/alert display
- Handles unauthenticated/blocked states by redirecting to `LoginVC`
- Provides `push()`, `pop()`, `popToRoot()` navigation helpers
- Applies `NavigationStyle` (`.white` or `.gray`) to navigation bar

`BaseViewModel` (`Shared/View/BaseViewController/BaseViewModel.swift`) is the base for all VMs. It:
- Exposes `@Published var isLoading`, `@Published var error`, and several `PassthroughSubject` publishers
- Provides `request(_:)` and `getAllRequest(_:)` — async/throws wrappers around `ResponseHandler` that handle server response keys
- On `.unauthenticated` or `.blocked` responses, calls `blockUser()` which clears session and redirects to `LoginVC`

### Networking Layer (`Networking/`)
- `Endpoint<T>` — typed struct describing a request (path, method, headers, body, uploads)
- `Requestable` — protocol implemented by `Endpoint`
- `NetworkExecuter` / `DefaultNetworkExecuter` — executes requests via Alamofire
- `ResponseHandler` / `DefaultResponseHandler` — decodes `Data` into `T` using `ResponseDecoder`
- `BaseResponse<T>` — standard server envelope: `{ key, msg, data }`
- `ServerResponseKey` — enum of server status keys: `.success`, `.fail`, `.exception`, `.unauthenticated`, `.blocked`, `.needActive`, `.needApproval`
- `RequestHeaderType` — `.authorized(token:)`, `.unauthorized`, `.ifAuthorized(token:?)` — injects `Authorization: Bearer` and `lang` headers
- Endpoints are grouped by feature in `Networking/Endpoints/`: `AuthEndpoints`, `HomeEndPoints`, `CartEndPoints`, `OrdersEndPoints`, `OrderDetailsEndPoints`, `MoreEndPoints`, `NotificationsEndPoints`
- Base API URL: `https://gasman.sa/api/`

### App Flow
1. `SplashVC` → checks `UserDefaults.isLogin`
2. If logged in → `AppTabBarController` (4 tabs: Home, Cart, Orders, More)
3. If not → `LoginVC` inside `BaseNav`

Guest mode is supported (`UserDefaults.guest`). Cart and Orders tabs show `GuestLoginPopup` for guest users.

### Session & Storage (`Shared/Helper/Session.swift`)
`Session` is a static facade over `UserDefaults` for:
- `token` / `accessToken`
- `isLogin`, `isGuest`
- `user` (a `User` Codable model)

### Localization (`Localization/`)
- Supports `ar` and `en` via `Localizable.strings`
- `Language` struct manages current language, RTL detection, and API language header
- `Language.setAppLanguage(lang:)` updates `AppleLanguages` in `UserDefaults` and applies RTL/LTR appearance globally
- Localization in XIBs is done via `xibLocKey` / `xibPlaceholderLocKey` `@IBInspectable` properties (defined in `Language.swift`)
- `.localized` string extension resolves keys from `Localizable.strings`

### Shared UI Components (`Shared/View/`)
- `GeneralButton`, `IconTextGeneralButton` — styled primary buttons
- `TextFieldView`, `GeneralTextField`, `PasswordTextField`, `PhoneTextField`, `OTPTextField` — custom input fields
- `DropDownTextView`, `PickerFieldView` — picker/dropdown inputs
- `ToastShower` protocol + `ToastManager` — toast notifications (adopted by `BaseViewController`)
- `LoaderManager` / `AppIndicator` — global loading indicator
- `AlertManager` — top-alert banners
- `ProfileImageView`, `ImagePickerView` — image selection UI
- `LottieView`, `LottiePopup` — Lottie animation wrappers
- `StaticPagesView` — reusable web-content viewer (used for Terms, Privacy, About Us)
- `GuestLoginPopup` — shown when guest attempts authenticated action

### Resources (`Resources/`)
- `Assets.xcassets` — organized by feature folder: `Auth/`, `Home/`, `Cart/`, `Orders/`, `More/`, `TabBar/`, `Colors/`
- `Fonts/Fonts.swift` — font registration
- Color assets are referenced via `.main`, `.textFieldBorder`, etc. (named colors in Assets)

### Feature Modules (`App/`)
Each feature follows `FeatureName/{Model,View,ViewModel}` structure:
- `Auth/` — Login, Signup, Verification, ForgetPassword, PasswordVerification, ResetPassword
- `Home/` — Home screen with banners/categories, ProductDetails
- `Cart/` — CartScreen, CartInquiry (order summary/coupon), SelectAddress, SelectLocation
- `Order/Orders/` — Orders list with state filter
- `OrderDetails/` — Order detail, cancel reason popup, rate order popup, driver info
- `More/` — Profile, Settings (ChangePassword, ChangePhone, UpdateProfile), SavedAddresses, Wallet, Notifications, AboutUs, ContactUs, FAQ, Complaints, Terms, PrivacyPolicy, MyRatings
- `Notification/` — Notification list, `NotificationCountManager`
- `FCM/` — Firebase push notification setup
- `LocationManager/AppLocationManager.swift` — CoreLocation wrapper
