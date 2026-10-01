# Easy Cooking — วิธี Deploy

รันทุกคำสั่งที่โฟลเดอร์โปรเจกต์ (`cooking-recipe-flutter/`)
ไม่จำเป็นต้องใช้ Android Studio (ใช้แค่ติดตั้ง Android SDK / เปิด Emulator)

---

## สรุปเร็ว

| อยากได้ | ทำแบบไหน | ค่าใช้จ่าย |
|---|---|---|
| ส่งแอปให้เพื่อนที่ใช้ **Android** ลอง | Build APK (หัวข้อ 1) | ฟรี |
| ให้คนใช้ **iPhone** ลองได้ | Flutter Web + Add to Home Screen (หัวข้อ 2) | ฟรี |
| ลิงก์เปิดได้ทุกเครื่อง | Flutter Web (หัวข้อ 2) | ฟรี |
| ขึ้น **Play Store** จริง | หัวข้อ 3 | $25 (ครั้งเดียว) |
| ขึ้น **App Store / TestFlight** | หัวข้อ 4 | $99/ปี + ต้องมี Mac |

---

## 1. Android — Build APK แล้วติดตั้งลงมือถือ

```
flutter build apk --release
```
- ไฟล์อยู่ที่ `build/app/outputs/flutter-apk/app-release.apk`
- ส่งไฟล์เข้ามือถือ (LINE / Google Drive / สาย USB) แล้วกดติดตั้ง
  - ต้องอนุญาต "ติดตั้งแอปจากแหล่งที่ไม่รู้จัก" ก่อน
- เสียบสาย USB + เปิด USB debugging แล้ว → `flutter install` ติดตั้งให้เลย
- ไฟล์เล็กลง: `flutter build apk --split-per-abi` (มือถือส่วนใหญ่ใช้ไฟล์ `arm64-v8a`)

> ⚠️ APK ใช้ได้กับ **Android เท่านั้น** iPhone ใช้ไม่ได้

---

## 2. Web — ได้ลิงก์เปิดได้ทุกเครื่อง (รวม iPhone)

```
flutter build web
```
แล้วเอาโฟลเดอร์ `build/web` ไปขึ้นเว็บ เลือกที่ไหนก็ได้ (ฟรีทั้งหมด):

| บริการ | วิธี | เหมาะกับ |
|---|---|---|
| **Netlify Drop** | เปิด https://app.netlify.com/drop แล้วลากโฟลเดอร์ `build/web` ไปวาง | ลองครั้งแรก ง่ายสุด |
| **Firebase Hosting** | `npm i -g firebase-tools` → `firebase login` → `firebase init hosting` (public dir = `build/web`) → `firebase deploy` | จะใช้ Firebase ต่อ (login, database) |
| **GitHub Pages** | `flutter build web --base-href /<ชื่อ-repo>/` แล้ว push `build/web` ขึ้น branch `gh-pages` | โค้ดอยู่บน GitHub อยู่แล้ว |
| **Vercel / Cloudflare Pages** | เชื่อม GitHub repo | อยากให้ deploy อัตโนมัติทุกครั้งที่ push |

**ให้ iPhone ใช้เหมือนแอป:** เปิดลิงก์ใน Safari → กด Share → **Add to Home Screen**

---

## 3. Google Play Store

1. สมัคร **Google Play Console** — $25 จ่ายครั้งเดียว
2. แก้ `applicationId` ใน `android/app/build.gradle.kts` ให้ไม่ซ้ำใคร
   (ตอนนี้เป็น `com.easycooking.easy_cooking` — ตั้งครั้งเดียว เปลี่ยนทีหลังไม่ได้)
3. ตั้งชื่อแอป (`android:label` ใน `android/app/src/main/AndroidManifest.xml`) และไอคอน (ใช้ package `flutter_launcher_icons`)
4. สร้าง keystore สำหรับ sign แอป:
   ```
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
5. สร้าง `android/key.properties`:
   ```
   storePassword=<รหัส>
   keyPassword=<รหัส>
   keyAlias=upload
   storeFile=<path ไปที่ upload-keystore.jks>
   ```
6. ตั้งค่า `signingConfigs` ใน `android/app/build.gradle.kts` ให้ release ใช้ key นี้
   (ตอนนี้ release ยังใช้ debug key อยู่) — ดู https://docs.flutter.dev/deployment/android
7. Build เป็น **AAB** (Play Store รับแค่แบบนี้):
   ```
   flutter build appbundle
   ```
   ไฟล์อยู่ที่ `build/app/outputs/bundle/release/app-release.aab`
8. อัปโหลดใน Play Console → เริ่มจาก **Internal testing** ก่อน
   - บัญชีส่วนตัวที่สมัครใหม่: ต้องมีผู้ทดสอบ **12 คน นาน 14 วัน** ก่อนปล่อย Production ได้
9. อัปเดตครั้งต่อไป: เพิ่มเลขใน `pubspec.yaml` เช่น `version: 1.0.1+2` (เลขหลัง `+` ต้องเพิ่มทุกครั้ง)

> ⚠️ **เก็บ keystore + รหัสผ่านให้ดี** ถ้าหายจะอัปเดตแอปเดิมไม่ได้
> ⚠️ **ห้าม commit** `key.properties` และ `*.jks` ขึ้น Git (เพิ่มลง `.gitignore`)

---

## 4. iPhone — App Store / TestFlight (ถ้าอยากทำจริงจัง)

- iPhone ใช้ไฟล์ **IPA** ไม่ใช่ APK
- **ต้อง build บน Mac + Xcode** (`flutter build ipa`) — บน Windows ทำไม่ได้
  - ไม่มี Mac: ใช้ cloud build เช่น **Codemagic** (มีโควตาฟรี)
- ส่ง IPA ให้คนอื่นติดตั้งเองเหมือน APK **ไม่ได้**
- ทางเลือก:
  - **TestFlight / App Store:** Apple Developer Program $99/ปี — แชร์ลิงก์ทดสอบได้ถึง 10,000 คน
  - **Sideload ลงเครื่องตัวเอง (ฟรี):** Codemagic build IPA → ใช้ Sideloadly บน Windows sign ด้วย Apple ID ฟรี → **ใช้ได้แค่ 7 วัน** ต้องลงใหม่ทุกสัปดาห์

> 💡 ถ้าแค่อยากให้คนใช้ iPhone ลอง → ใช้หัวข้อ 2 (Web) ง่ายและฟรีที่สุด
