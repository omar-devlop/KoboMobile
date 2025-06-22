
![KoboMobile Banner](https://github.com/user-attachments/assets/c9ba77dc-4e30-4dbe-878c-ac72ee9cd7a5)

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
## 🎬 Quick Tour

[![Watch the video](https://img.youtube.com/vi/U4rekRtW8Hc/maxresdefault.jpg)](https://youtu.be/U4rekRtW8Hc)


&nbsp;
## 📱 Screenshots

<div align="center">
  <div>
    <img src="https://github.com/user-attachments/assets/bee56fc6-261d-4aa8-831c-ddfaa9d9e8a3" width="30%" />
    <img src="https://github.com/user-attachments/assets/9b4f9642-6fde-48a3-a2a8-f353194e81e9" width="30%" />
    <img src="https://github.com/user-attachments/assets/96e9eb5e-5ae5-4357-bb40-866af338fa8b" width="30%" />
    <img src="https://github.com/user-attachments/assets/249abe9b-ffef-421d-8c0e-a82311be7225" width="30%" />
    <img src="https://github.com/user-attachments/assets/67fae540-2ec9-413b-ad84-785920922a37" width="30%" />
    <img src="https://github.com/user-attachments/assets/16564538-2e7d-4a9b-a17e-4096e1aaaa1f" width="30%" />
    <img src="https://github.com/user-attachments/assets/4687489f-13a6-4e66-ac37-2eebc010f6cd" width="30%" />
    <img src="https://github.com/user-attachments/assets/9c4c96e0-a0ef-4118-9588-48b0c19a429b" width="30%" />
    <img src="https://github.com/user-attachments/assets/38d36da5-1379-46ca-83f9-11f4b71a85e4" width="30%" />
    <img src="https://github.com/user-attachments/assets/358c3c50-98c1-4399-b1fb-171346b1632a" width="30%" />
    <img src="https://github.com/user-attachments/assets/92868413-209b-4982-b84a-93fb6df8100d" width="30%" />
    <img src="https://github.com/user-attachments/assets/f51f517f-1f7b-49d8-b9d4-780e1009fccf" width="30%" />
    <img src="https://github.com/user-attachments/assets/7456177c-e4d5-4c14-ab33-9a21c8e8186d" width="30%" />
    <img src="https://github.com/user-attachments/assets/907edf6d-83b8-473a-9228-c3286e162833" width="30%" />
    <img src="https://github.com/user-attachments/assets/08ab36f0-71d7-4a09-8b3b-824feca43c92" width="30%" />
    <img src="https://github.com/user-attachments/assets/f7027ae3-d441-48e5-8071-771641fa2c39" width="30%" />
    <img src="https://github.com/user-attachments/assets/aa77c851-e587-4b98-be62-380fa22b7328" width="30%" />
    <img src="https://github.com/user-attachments/assets/5ca020c8-5c86-47af-b551-5392e12ed4a4" width="30%" />
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
const cloudflareApiToken = 'YOUR_CLOUDFLARE_API_TOKEN_HERE';
const cloudflareAccountId = 'YOUR_CLOUDFLARE_ACCOUNT_ID_HERE';
```

&nbsp;
## 🐞 Issues & Support

If you encounter any bugs or have feature requests, please open an issue on the GitHub repository.

&nbsp;
## 📫 Contact

For questions or suggestions, feel free to contact me at omar.alafa.work@gmail.com or open a discussion on the GitHub repo.

&nbsp;
## 🙋‍♂️ About Me

I'm a self-taught Flutter developer who loves learning by doing! 🎯  
Always open to tips, tricks, or friendly advice from senior devs. 🙌  
If you have some, don’t be shy — I’m all ears and ready to level up! 🚀🔥
