
## 🧳 Travely – Your Simple Travel Mate


### 👨‍💻 Developed By

| Name                | Roll No | Department           |
| ------------------- | ------- | -------------------- |
| **Arbab Hussain Qureshi** | 22SW028 | Software Engineering |
| **Farooque Sajjad**   | 22SW048 | Software Engineering |

**Section:** 01  
**Course:** Mobile Application Development (MAD)  
**Institute:** *Mehran University of Engineering & Technology, Jamshoro – Pakistan*  
**Instructor:** *Ma’am Maryam*

---

### 🌍 **About the Project**

Travelers often struggle to find accurate and centralized information about city attractions—especially in developing regions with unreliable internet or scattered online sources. **Travely** solves this by offering a **simple, clean, and responsive mobile app** that allows users to:

✔️ Search any city globally
✔️ Discover verified attractions
✔️ View image-rich summaries
✔️ Save favorite places to cloud storage

---

### 🚀 **Key Features**

| Feature                       | Description                                        |
| ----------------------------- | -------------------------------------------------- |
| 🌆 **Global City Search**     | Fetches notable attractions using Wikipedia API    |
| 🖼 **High-quality Images**    | Fetches attraction photos using Unsplash API       |
| ⭐ **Favorites System**        | Save & sync favorite places via Firebase Firestore |
| 🎨 **Dynamic, Responsive UI** | Built with Flutter Material 3 for modern UX        |
| 🔒 **User Authentication**    | Firebase email/password login                      |
| 📶 **Offline Resilience**     | Local persistence after first data fetch           |

---

### 🏗️ **System Architecture**

| Layer                 | Technology                                        |
| --------------------- | ------------------------------------------------- |
| **Frontend**          | Flutter (Material 3), Provider (State Management) |
| **Backend**           | Firebase Authentication + Firestore               |
| **APIs**              | Wikipedia REST API, Unsplash API                  |
| **Version Control**   | GitHub                                            |
| **Hosting / Storage** | Firebase Firestore                                |

---

### 🔧 **Dependencies**

| Package                | Purpose                            |
| ---------------------- | ---------------------------------- |
| `http`                 | REST API communication             |
| `provider`             | State management                   |
| `firebase_auth`        | User authentication                |
| `cloud_firestore`      | Cloud database storage             |
| `cached_network_image` | Smooth and cached image loading    |
| `flutter_dotenv`       | Securing API keys                  |
| `url_launcher`         | Opening Wikipedia pages in browser |

---

### 🗄️ **Data Storage Justification**

Travely uses **Firebase Firestore** because it provides:
✅ Real-time sync across devices
✅ Scalable cloud storage
✅ Secure access with Firebase Auth
✅ No server maintenance required

---

### 🐞 **Common Issues & Fixes During Development**

| Issue                       | Cause                   | Fix                           |
| --------------------------- | ----------------------- | ----------------------------- |
| Geocode 403 Error           | Missing API headers     | Added `User-Agent` header     |
| Firestore Permission Denied | Unpublished rules       | Updated and deployed rules    |
| Favorites not refreshing    | No real-time listener   | Used Firestore stream updates |
| Missing image thumbnails    | Wikipedia lacked photos | Fallback to Unsplash          |
| Navigation from Splash      | Wrong route             | Redirected to `HomeShell()`   |

---

### 🧹 **Maintainability**

✔ Clean Architecture (UI, Logic, Data separated)
✔ Modular & well-commented code
✔ Provider for clean state management
✔ Version controlled on GitHub

---

### 📌 **How to Run**

```bash
git clone https://github.com/arbabhussainq/Travely.git
cd Travely
flutter pub get
flutter run
```

> 📌 Don’t forget to add your own **Unsplash API key**, **Firebase config**, and `.env` file.

---

### 📜 **License**

This project is for **educational purposes** under MUET Jamshoro.
Free to use and modify with proper credit to the authors.

---







