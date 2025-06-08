
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
## 📱 Screenshots

<div align="center">
<div>
<img src="https://github.com/user-attachments/assets/4560bf67-c741-40da-8ee7-5ab580cbc30f" width="30%" />
<img src="https://github.com/user-attachments/assets/d2c35074-d9f7-4aa6-ae07-1b0cfce89ee0" width="30%" />
<img src="https://github.com/user-attachments/assets/f0f993ba-60da-4583-b91c-7e8d185bab66" width="30%" />
<img src="https://github.com/user-attachments/assets/9931c372-cc35-4ac3-8a10-01d3cc6ac73d" width="30%" />
<img src="https://github.com/user-attachments/assets/bd9bffb2-fdf4-4079-8552-cddf1520b0dc" width="30%" />
<img src="https://github.com/user-attachments/assets/6d1ec775-c720-42bd-838d-57a0e7b81e87" width="30%" />
<img src="https://github.com/user-attachments/assets/199d89ba-03d4-4a36-9a37-ed5bca306ed8" width="30%" />
<img src="https://github.com/user-attachments/assets/c4d93927-7de5-401a-bc62-3aaf8ca3b25b" width="30%" />
<img src="https://github.com/user-attachments/assets/2b2a1fff-5e8e-4cbe-9cdd-d2450f65715f" width="30%" />
<img src="https://github.com/user-attachments/assets/7c0982d4-ed66-40ac-a0e1-77bb3a9f640d" width="30%" />
<img src="https://github.com/user-attachments/assets/95ef1f6b-c9c3-4efe-a3b4-34be75eb9b80" width="30%" />
<img src="https://github.com/user-attachments/assets/dd80c84b-c0bc-44f5-b31a-d7b127650a94" width="30%" />
<img src="https://github.com/user-attachments/assets/88aaa28f-84af-41d1-bdc6-f125b68e2285" width="30%" />
<img src="https://github.com/user-attachments/assets/09b125e0-0bbe-4b51-9acc-54c3254aacd2" width="30%" />
<img src="https://github.com/user-attachments/assets/8b412371-eb76-4586-9a72-607260a268e6" width="30%" />
<img src="https://github.com/user-attachments/assets/cee2ac36-0be9-4e2b-a19d-7e4cf37d58b5" width="30%" />
<img src="https://github.com/user-attachments/assets/f4741105-b7fb-4e94-af2a-ba125274837b" width="30%" />
<img src="https://github.com/user-attachments/assets/80a283e1-4d34-4f4d-b283-2001d7b98c90" width="30%" />
</div>
</div>



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
