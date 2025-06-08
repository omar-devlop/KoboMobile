
![Logo](https://www.kobotoolbox.org/assets/images/common/kobotoolbox_logo_default_for-light-bg.svg)

&nbsp;
# 📱 KoboMobile


**KoboMobile** is an unofficial Flutter-based Android application designed for [KoboToolbox](https://www.kobotoolbox.org/) data managers. It enables seamless access to form submissions, including browsing, viewing attachments, and exporting responses, all from your Android device.
&nbsp;
## ✨ Features

- 🔐 Secure login to your KoboToolbox account  
- 👥 Log in with and switch between multiple accounts  
- 📄 Browse and filter forms and submissions  
- 🗂️ View submission metadata, attachments, and values
- 📎 Easily access and open attached files (images, audio, documents, etc.) 
- ✅ Validate and review submissions content
- 📊 Generate custom charts on the report page for visual insights
- 🖨️ Export submissions as PDF  
- 📋 Switch between table and list views  
- 🌐 Works with both official and custom KoboToolbox servers
- 🎨 Clean and modern user interface
- 📚 Multi-language support
- 🔎 **Deep Search** across all forms by `meta/instanceName` for fast submission lookup  
- 🚧 A lot more coming soon... stay tuned! 🚀







&nbsp;
## 📦 Download

The latest stable APK releases are available on the [GitHub Releases](https://github.com/omar-devlop/KoboMobile/releases) page.

#### Installation Instructions:
- Download the desired APK file to your Android device.  
- If prompted, enable installation from unknown sources in your device settings.  
- Open the downloaded APK file and follow the on-screen instructions to complete the installation.

> ⚠️ For security and the best experience, always use the latest official release.
&nbsp;
## 👨‍💻 For Developers & Contributors
### Prerequisites

- Flutter SDK (≥ 3.7.0)  
- Android Studio or VS Code with Flutter plugin  
- KoboToolbox account (optional for testing)

## Installation


```bash
git clone https://github.com/omar-devlop/KoboMobile.git
cd KoboMobile
flutter pub get
flutter run
```
    

#### 🔑 API Keys Setup

**Before running the app, you need to create a file to store your Cloudflare API credentials.**  
This is required for accessing AI features powered by [Cloudflare Workers AI](https://developers.cloudflare.com/workers-ai/).

Create this file:  
```plaintext
lib/core/api/api_keys.dart
```

and add the following variables with your own values:

```dart
final cloudflareApiToken = 'YOUR_CLOUDFLARE_API_TOKEN_HERE';
final cloudflareAccountId = 'YOUR_CLOUDFLARE_ACCOUNT_ID_HERE';
```
&nbsp;
## 🐞 Issues & Support

If you encounter any bugs or have feature requests, please open an issue on the GitHub repository.
&nbsp;
## 📫 Contact

For questions or suggestions, feel free to contact me at [omar.alafa.work@gmail.com] or open a discussion on the GitHub repo.
&nbsp;
## 🙋‍♂️ About Me

I'm a self-taught Flutter developer who loves learning by doing! 🎯  
Always open to tips, tricks, or friendly advice from senior devs. 🙌  
If you have some, don’t be shy — I’m all ears and ready to level up! 🚀🔥
