# Easy Cooking — คำสั่งที่ใช้บ่อย

รันทุกคำสั่งที่โฟลเดอร์โปรเจกต์ (`cooking-recipe-flutter/`)

---

## 1. เปิดแอปดูหน้าจอ (Run)

| คำสั่ง | ใช้ทำอะไร |
|---|---|
| `flutter run -d chrome` | เปิดใน Chrome ✅ **ใช้ได้เลยบนเครื่องนี้ (แนะนำ)** |
| `flutter run -d windows` | เปิดเป็นโปรแกรมบน Windows (ต้องติดตั้ง Visual Studio C++ ก่อน ดูหัวข้อ 2) |
| `flutter run -d edge` | เปิดใน Microsoft Edge |
| `flutter run` | ถ้ามีหลายอุปกรณ์ จะให้เลือกว่าจะเปิดบนอุปกรณ์ไหน |
| `flutter run -d <device-id>` | เปิดบนอุปกรณ์ที่ระบุ (ดู id ได้จาก `flutter devices`) |
| `flutter run --release` | เปิดแบบ release (ลื่นกว่า แต่ใช้ hot reload ไม่ได้) |

### 📱 เปิดบน iPhone / มือถือ ด้วยการสแกน QR (คล้าย Expo)

```
.\phone
```
- สคริปต์จะแสดง **QR code** ใน terminal แล้วเปิด server ที่ `http://<IP เครื่อง>:8080`
- มือถือต้องต่อ **Wi-Fi เดียวกับคอม** → เปิดกล้อง iPhone สแกน QR → เปิดใน Safari
- รอให้ terminal ขึ้น `is being served at` ก่อนค่อยสแกน (ครั้งแรกใช้เวลาราว 1 นาที)
- แก้โค้ดแล้วกด `R` ใน terminal จากนั้นดึงหน้าจอลงเพื่อรีเฟรชใน Safari
- อยากให้ดูเหมือนแอปจริง (เต็มจอ ไม่มีแถบ Safari): ใน Safari กด Share → **Add to Home Screen**
- ใช้พอร์ตอื่น: `.\phone 9000`

**ถ้าสแกนแล้วเปิดไม่ขึ้น:** มักเป็นเพราะ Windows Firewall บล็อก
- ครั้งแรกที่รัน ถ้ามีหน้าต่าง Firewall ถามเรื่อง `dart.exe` → กด **Allow**
- Wi-Fi ของคอมตั้งเป็น **Public** อยู่ ซึ่งบล็อกการเชื่อมต่อจากเครื่องอื่น → เปลี่ยนเป็น **Private**:
  Settings → Network & internet → Wi-Fi → (ชื่อ Wi-Fi) → Network profile type → **Private network**
- ใช้ไม่ได้กับ Wi-Fi สาธารณะ/ร้านกาแฟ ที่ห้ามเครื่องคุยกันเอง (ลองใช้ hotspot จากมือถือแทน)

> หมายเหตุ: วิธีนี้คือการเปิดแอปเป็น**เว็บ**ใน Safari หน้าตาและการทำงานเหมือนกันเกือบทั้งหมด
> ถ้าจะลงเป็นแอป iOS จริง Flutter ต้องใช้เครื่อง **Mac + Xcode** (ยังไม่มีแบบ Expo Go)

**จำลองขนาดจอมือถือใน Chrome:** รัน `flutter run -d chrome` → กด `F12` → กด `Ctrl+Shift+M` → เลือกรุ่นมือถือ เช่น iPhone 14 / Pixel 7

### ปุ่มลัดระหว่างที่แอปรันอยู่ (พิมพ์ใน terminal)

| ปุ่ม | ใช้ทำอะไร |
|---|---|
| `r` | Hot reload — แก้โค้ดแล้วอัปเดตหน้าจอทันที |
| `R` | Hot restart — เริ่มแอปใหม่ (state หาย) |
| `o` | สลับระบบจำลองระหว่าง Android / iOS (เห็น transition ที่ต่างกัน) |
| `b` | สลับความสว่างของระบบ (ทดสอบธีม "ตามระบบ") |
| `p` | เปิด/ปิดเส้นแสดงขอบ widget (debug layout) |
| `P` | แสดงกราฟประสิทธิภาพ (FPS) |
| `s` | เซฟ screenshot ลงไฟล์ |
| `v` | เปิด DevTools ในเบราว์เซอร์ |
| `c` | ล้างหน้าจอ terminal |
| `q` | ปิดแอป |
| `h` | ดูปุ่มลัดทั้งหมด |

---

## 2. อุปกรณ์ / Emulator

| คำสั่ง | ใช้ทำอะไร |
|---|---|
| `flutter devices` | ดูอุปกรณ์ที่ต่ออยู่ตอนนี้ |
| `flutter emulators` | ดูรายการ emulator ที่มี |
| `flutter emulators --launch <emulator-id>` | เปิด emulator |
| `flutter emulators --create --name pixel` | สร้าง Android emulator ใหม่ (ต้องมี Android SDK image ก่อน) |
| `flutter doctor` | เช็กว่าเครื่องพร้อมรันแต่ละแพลตฟอร์มหรือยัง |

### สถานะเครื่องนี้ (จาก `flutter doctor`)

| แพลตฟอร์ม | สถานะ | ต้องทำอะไร |
|---|---|---|
| Chrome / Edge | ✅ พร้อม | — |
| Windows | ❌ ยังไม่พร้อม | เปิด **Visual Studio Installer** → Modify บน VS Community 2022 → ติ๊ก workload **"Desktop development with C++"** (ให้มี MSVC build tools, C++ CMake tools, Windows 10/11 SDK) → Install แล้วรัน `flutter doctor` อีกครั้ง |
| Android | ❌ ยังไม่พร้อม | ติดตั้ง **Android Studio** → เปิดครั้งแรกให้ลง Android SDK → รัน `flutter doctor --android-licenses` → สร้าง emulator ที่ Device Manager หรือเสียบมือถือที่เปิด USB debugging |

> ถ้าเจอ `Unable to find suitable Visual Studio toolchain` แปลว่ายังไม่ได้ลง C++ workload ตามตารางข้างบน ระหว่างนี้ใช้ `flutter run -d chrome` แทนได้

---

## 3. ติดตั้ง / ล้างโปรเจกต์

| คำสั่ง | ใช้ทำอะไร |
|---|---|
| `flutter pub get` | ติดตั้ง package ตาม `pubspec.yaml` |
| `flutter pub outdated` | ดู package ที่มีเวอร์ชันใหม่ |
| `flutter pub upgrade` | อัปเดต package |
| `flutter clean` | ล้างไฟล์ build (ใช้ตอนเจอ error แปลกๆ) แล้วตามด้วย `flutter pub get` |

---

## 4. ตรวจโค้ด / ทดสอบ

| คำสั่ง | ใช้ทำอะไร |
|---|---|
| `flutter analyze` | ตรวจหา error / warning ในโค้ด |
| `dart format lib test` | จัดรูปแบบโค้ดให้เรียบร้อย |
| `flutter test` | รัน test ทั้งหมดในโฟลเดอร์ `test/` |
| `flutter test test/widget_test.dart` | รัน test เฉพาะไฟล์ |

---

## 5. Build ไฟล์ติดตั้ง

| คำสั่ง | ผลลัพธ์อยู่ที่ |
|---|---|
| `flutter build apk --release` | `build/app/outputs/flutter-apk/app-release.apk` (ติดตั้งบน Android ได้เลย) |
| `flutter build apk --split-per-abi` | APK แยกตามสถาปัตยกรรม (ไฟล์เล็กลง) |
| `flutter build appbundle` | `.aab` สำหรับอัปโหลด Google Play |
| `flutter build web` | `build/web/` (เอาไปโฮสต์เป็นเว็บได้) |
| `flutter build windows` | `build/windows/x64/runner/Release/` |
| `flutter build ipa` | สำหรับ iOS (ต้องใช้เครื่อง Mac) |

**ลองเปิดเว็บที่ build แล้ว:**
```
cd build/web
python -m http.server 8080
```
แล้วเปิด http://localhost:8080 (ต้องมี Python ติดตั้งไว้ ถ้าไม่มีใช้ `npx serve build/web` แทนได้)

---

## 6. สิ่งที่ลองได้ในแอป

- **หน้าหลัก:** ค้นหาเมนู (ไทย/อังกฤษ), กดหมวดหมู่, ปัดสไลด์เมนูแนะนำ
- **หน้าสูตร:** ดึงรูปลงเพื่อซูม, สลับแท็บวัตถุดิบ/วิธีทำ, ติ๊กวัตถุดิบ
- **Start cooking:** โหมดทำอาหารทีละขั้น
- **หัวใจ ♥:** บันทึกเมนู → ดูที่แท็บ "บันทึกไว้"
- **ตั้งค่า:** สลับธีม สว่าง/มืด/ตามระบบ และภาษา ไทย/English (ปิดแอปแล้วค่ายังอยู่)
