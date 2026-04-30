# Changelog

บันทึกการเปลี่ยนแปลงทั้งหมดของโปรเจค `alcohol_detector` จะถูกรวบรวมไว้ในไฟล์นี้

รูปแบบของไฟล์อ้างอิงตาม [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
และโปรเจคนี้ใช้ระบบเวอร์ชันแบบ [Semantic Versioning](https://semver.org/spec/v2.0.0.html)

## [Unreleased]

### Planned
- Phase UI-6B: Common widgets ตาม design ใหม่ (chevron buttons, SuccessHeader, UserCard, ConnectedDeviceCard)
- Phase UI-6C: Apply to screens (Home + screens อื่น ๆ ตาม design)
- Phase UI-7: Accessibility & QA (a11y, contrast, font scaling, dark mode review)
- Phase 6: เปลี่ยน Mock services เป็น implementation จริง
  (Bluetooth/USB, Camera+ML Kit, API)
- Lottie animations (confetti for pass result, success checkmark)

## [1.11.0] - 2026-04-30 (Phase UI-6A: Palette Swap จาก Design Update)

### Changed
- **`AppColors` swap palette ตาม design ใหม่**:
  - **Primary** (เดิม = เขียว `#22C55E`) → **น้ำเงิน `#2563EB`**
    family ใหม่: primary50/100/200/500/600/700/800/900
  - **Success** (ใหม่ — แยก namespace) → **เขียว** (ค่าเดิมของ primary)
    family: success50/100/200/500/600/700/900
  - Aliases: `primary` = primary500 (น้ำเงิน), `success` = success500 (เขียว),
    `resultPass` = success500, `headerBar` = primary700
  - `info` family ยังอยู่ (ใช้ shade เดียวกับ primary, backward-compat)
- **Components ที่ใช้ "success" semantically — สลับมาใช้ success namespace**:
  - `StatusBadge.success` variant (badge "เชื่อมต่อแล้ว", "ยืนยันแล้ว")
  - `PasswordStrengthMeter` strong / veryStrong — เขียวบอกความแข็งแรง
  - `TestResultScreen`:
    - Pass result badge gradient (เขียว)
    - Measurement card non-exceed text color
    - Save status banner (เขียว "บันทึกผลทดสอบเรียบร้อย")
  - `DriverConfirmationScreen` "อ่านบัตรสำเร็จ" pill badge
  - `ResetPasswordScreen` check icon เมื่อรหัสผ่านตรงกัน
  - `FaceFramePreview` border สีเขียวเมื่อใบหน้าอยู่ในกรอบ

### Visual Impact
- ปุ่มทุกหน้าจะเปลี่ยนเป็นน้ำเงินทันที (Login/Connect/Confirm/Start Test/Finish)
- Logo gradient + Header gradient เปลี่ยนเป็นน้ำเงิน
- Hero icons (TestReady, ForgotPassword, ResetPassword) เปลี่ยนเป็นน้ำเงิน
- Step indicator + Auth background tint เปลี่ยนเป็นโทนน้ำเงิน
- Badge / "ผ่าน" result / face frame / save status ยังเขียวตามเดิม
- บัมป์ pubspec version → `1.11.0+1` + อัปเดต `_versionUpdatedAt`

## [1.10.0] - 2026-04-30 (Phase UI-5: Micro-interactions)

### Added
- เพิ่ม dependencies: `flutter_animate ^4.5.2`, `shimmer ^3.0.0`
- `Haptics` helper รวม patterns: `light`, `medium`, `heavy`, `selection`,
  `success` (medium → light), `failure` (heavy × 2)
- Custom page transitions ใน `go_router`:
  - `_slidePage` — slide จากขวา + fade (สำหรับ next/forward navigation)
  - `_fadeScalePage` — fade + scale 0.97→1.0 (สำหรับ login/home/test screens)
- `ShimmerBox` widget — skeleton loading กรอบ shimmer

### Changed
- **DeviceController** เพิ่ม haptic feedback:
  - Connect สำเร็จ → medium / Connect ล้มเหลว → heavy
  - Disconnect → light
  - Read card สำเร็จ → medium / ล้มเหลว → heavy
  - Confirm driver → success pattern / Reject → light
- **TestController** เพิ่ม haptic:
  - เริ่มเป่า → light
  - Pass → success pattern / Fail → failure pattern
- **LoginScreen**:
  - กด login → light haptic + success haptic เมื่อสำเร็จ
  - Logo + headings มี entrance animation (fade + scale + slide)
- **HomeScreen**:
  - Device cards staggered entrance animation (fade + slideY, delay 80ms ต่อกัน)
  - Device card ใช้ `ShimmerBox` แทน text ตอน `state.isConnecting`
- บัมป์ pubspec version → `1.10.0+1` + อัปเดต `_versionUpdatedAt`

## [1.9.0] - 2026-04-30 (Phase UI-4: Test Flow Polish)

### Changed
- **FaceFramePreview** ขยับตัวแบบ animated:
  - Breathing pulse (scale 1.0 → 1.04) เมื่อใบหน้าอยู่ในกรอบ
  - Shake animation + กรอบแดง + glow แดงเมื่อใบหน้าออกจากกรอบ
  - Background radial gradient + ใบหน้า silhouette ใหญ่ขึ้น
  - กรอบ rounded ขนาดใหญ่ + glow ตามสีกรอบ
  - Warning badge มี shadow และไอคอน warning
- **TestReadyScreen** ออกแบบใหม่:
  - Hero icon breathing animation (radial gradient + pulsing glow)
  - Checklist 4 ข้อ (เป่ายาว 5s, อยู่ในกรอบ, ห้ามถอด, หายใจลึก) ใน AppCard
  - ปุ่มเริ่ม gradient + arrow icon
- **TestInProgressScreen**:
  - **Countdown overlay 3-2-1** ก่อนเริ่มจริง (gradient circle + scale animation)
  - **_BreathingProgress**: ring กลางใหญ่ + 3 wave rings ขยายออก animated
    + center label box พร้อม shadow + percent ใหญ่
  - **_StatusText**: animated transition (fade + slide) + icon ตามเฟส
  - ลบ AppRadius import ที่ไม่ได้ใช้
- **TestResultScreen**:
  - **_ResultBadge** animated reveal (scale 0.6 → 1.0 + easeOutBack)
    + gradient background + glow
    + caption ใต้ผลลัพธ์ ("พร้อมขับขี่ได้" / "กรุณาพักรถ")
  - **_MeasurementCard** ใหม่: icon + value ใหญ่ + mini bar chart
    พร้อม threshold marker (เส้นเหลือง 0.5 position)
  - **_FaceMismatchNote** เป็นการ์ดมีไอคอน + คำอธิบาย
  - **_ThresholdNote** สีเหลืองอ่อนพร้อมไอคอน
  - **_SaveStatusBanner** animated switch ระหว่าง loading/done
  - **_FinishButton** gradient + home icon
- บัมป์ pubspec version → `1.9.0+1` + อัปเดต `_versionUpdatedAt`

## [1.8.0] - 2026-04-29 (Phase UI-3: Home & Driver Dashboard Cards)

### Added
- Common Widgets ใหม่:
  - `AppCard` — wrapper การ์ดมาตรฐาน (radius lg + border + optional shadow + onTap)
  - `StatusBadge` — pill-shaped badge 5 variants (success/warning/danger/info/neutral)
    + dot indicator + optional icon

### Changed
- **HomeScreen** ยกเครื่องเป็น dashboard cards ทั้งหมด:
  - Card "เครื่องเป่าแอลกอฮอล์": icon ใหญ่ + status badge + ปุ่ม connect/disconnect
  - Card "เครื่องอ่านใบขับขี่": เช่นเดียวกัน
  - Card "ข้อมูลผู้ขับขี่":
    - State 1: ถ้ายังไม่ยืนยัน — ไอคอน person + ปุ่มรูดบัตร (disabled ถ้าไม่เชื่อมเครื่อง)
    - State 2: ถ้ายืนยันแล้ว — avatar (initials) + ชื่อ + ใบขับขี่ + badge "ยืนยันแล้ว"
      + ปุ่มเปลี่ยนผู้ขับ
  - ปุ่ม "เริ่มการทดสอบ" ใหญ่กว่าเดิม (64px) gradient + ไอคอน air + soft shadow
    (gray ตอน disabled, gradient ตอน enabled)
  - ลิงก์ "ออกจากระบบ" ลงเล็กไว้ล่างสุด พร้อมไอคอน
- **DriverConfirmationScreen** ออกแบบใหม่:
  - Badge "อ่านบัตรสำเร็จ" สีเขียวด้านบน
  - **ป้ายทะเบียนแบบไทย** — กรอบขาว ขอบดำหนา 3px ตัวอักษรใหญ่ + ชื่อจังหวัดด้านล่าง
  - การ์ดข้อมูลผู้ขับขี่: avatar (initials gradient) + ชื่อ + เลขใบขับขี่ พร้อมไอคอน
  - ปุ่ม "ยืนยันข้อมูล" gradient เขียวเด่น + ปุ่ม "ข้อมูลไม่ถูกต้อง" outlined
- บัมป์ pubspec version → `1.8.0+1` + อัปเดต `_versionUpdatedAt`

## [1.7.0] - 2026-04-29 (Phase UI-2: Auth Screens Polish)

### Added
- Common Widgets ใหม่:
  - `AuthBackground` — gradient อ่อน ๆ (primary50 → background) ใช้ร่วม 4 หน้า auth
  - `AuthStepIndicator` — แสดง "ขั้นตอนที่ X จาก Y" + แถบสีบ่งชี้
  - `CountdownRing` — circular progress + เวลาตรงกลาง
    เปลี่ยนสี (เขียว → เหลือง < 30s → แดงตอนหมดอายุ)
  - `PasswordStrengthMeter` — 4 segments + label ความแข็งแรง
    (เปล่า/อ่อน/พอใช้/แข็งแรง/แข็งแรงมาก) อิงจาก length, uppercase, digit, special

### Changed
- **Login Screen**:
  - เพิ่ม gradient background
  - ใช้ floating label แทน hint
  - prefix icon ในช่อง username/password
  - ปุ่ม "เข้าสู่ระบบ" เป็น gradient + arrow icon + soft shadow
  - "ลืมรหัสผ่าน?" ขีดเส้นใต้ + สีแบรนด์
- **ForgotPassword Screen**:
  - Step 1/3 + label "ระบุช่องทาง"
  - Hero icon (lock_reset) + พื้นหลัง gradient
  - คำอธิบายชัดเจนขึ้น
  - TextField floating label + prefix icon
- **OTP Screen**:
  - Step 2/3 + label "ยืนยัน OTP"
  - `CountdownRing` ใหญ่ขึ้นด้านบน
  - Destination card รวบรวมข้อมูลปลายทาง + รหัสอ้างอิงเป็น chip
  - หมายเหตุอีเมลขยะอยู่ในการ์ดเดียวกัน
- **ResetPassword Screen**:
  - Step 3/3 + label "ตั้งรหัสใหม่"
  - Hero icon (shield) + คำแนะนำ
  - Floating label + prefix icon ทั้งสองช่อง
  - `PasswordStrengthMeter` ใต้ช่องรหัสใหม่
  - ไอคอน check / cancel ในช่อง re-password เมื่อพิมพ์ตรง/ไม่ตรง
- **OtpInputField**:
  - กล่องใหญ่ขึ้น (52×60) + รัศมีมุมโค้ง 12px
  - Active: primary border 2px + soft shadow
  - Filled: primary50 background + primary200 border
  - ตัวเลขใหญ่และเข้ม (primary700)
- บัมป์ pubspec version → `1.7.0+1` + อัปเดต `_versionUpdatedAt`

## [1.6.0] - 2026-04-29 (Phase UI-1: Foundation)

### Added
- เพิ่ม dependency `google_fonts ^6.2.1` — โหลดฟอนต์ Sarabun จริง
- `AppSpacing` tokens (`xs/sm/md/lg/xl/xxl/xxxl` = 4/8/12/16/24/32/48)
- `AppRadius` tokens (`sm/md/lg/xl/pill` = 8/12/16/24/999)
- `AppColors` ขยายเป็น tint/shade scale: `primary`, `danger`, `info`, `warning`, `neutral`
  (เช่น `primary50`, `primary500`, `primary700` ฯลฯ)
- เพิ่ม dark mode tokens (`darkBackground`, `darkSurface`, ฯลฯ)
- `AppTheme.dark` — โครงสร้างพร้อมใช้ (เปิดใช้งานจริงใน UI ระยะหลัง)

### Changed
- `AppTextStyles` ใช้ `GoogleFonts.sarabun()` แทน fontFamily อ้างอิงเฉย ๆ
  + ขยาย type scale: display L/M, heading L/M/S, body L/M/S, label, caption
- `AppTheme` แยกเป็น `_build()` ใช้ร่วมกัน light/dark
- `MaterialApp` รองรับ `darkTheme` + `themeMode: light` (ตั้งคงที่ไว้ก่อน
  รอ migrate screens ใช้ ColorScheme เต็มตัวใน UI ระยะหลัง)
- **`AppLogo`** ปรับเป็น gradient + icon แทนกล่อง "Logo" เดิม
  พร้อม shadow soft brand color
- **`AppHeader`** ยกเครื่องใหม่:
  - แถบบนใช้ gradient น้ำเงินเข้ม (info700 → info900)
  - แถบล่างมี avatar (initials) + greeting + chips สำหรับใบขับขี่/Device
  - ขอบบนของส่วนล่างโค้งมน 24px ดู modern
- บัมป์ pubspec version → `1.6.0+1` พร้อมอัปเดต `_versionUpdatedAt`

## [1.5.1] - 2026-04-29

### Added
- เพิ่ม dependency `package_info_plus ^8.1.2`
- เพิ่ม `AppInfo` service โหลด `version` + `buildNumber` จาก `pubspec.yaml`
  ผ่าน `PackageInfo.fromPlatform()` และ inject ผ่าน `Provider`
- เพิ่ม `versionUpdatedAt` (DateTime) ใน `AppInfo` — เก็บเป็น constant
  ใน `app_info.dart` ที่ต้องอัปเดตด้วยมือทุกครั้งที่บัมป์เวอร์ชัน
- `AppFooter` แสดงบรรทัด "อัปเดตเมื่อ ..." ใต้ Version (ฟอร์แมตไทย พ.ศ.)

### Changed
- `AppFooter` อ่านเวอร์ชัน + วันที่อัปเดตจาก `AppInfo` ใน Provider แทน hardcode
  (รองรับ `versionOverride` + `updatedAtOverride` สำหรับใช้ในเทส)
- `main()` เปลี่ยนเป็น `async` เพื่อโหลด `AppInfo` ก่อน `runApp()`
- ลบ `AppConstants.appVersion` (hardcode) ออก
- อัปเดต widget test ให้ส่ง `AppInfo` ตอนสร้างแอป + verify ทั้ง Version
  และข้อความ "อัปเดตเมื่อ ..."

## [1.5.0] - 2026-04-29 (Phase 5: Test Flow + Result)

### Added
- Models: `TestPhase`, `TestOutcome`, `TestMeasurement`, `TestResult`, `TestSession`, `MockTestScenario`
- `TestRepository` (abstract) + `InMemoryTestRepository` (mock เก็บใน memory)
- `TestController` (ChangeNotifier) ควบคุม flow การทดสอบ:
  - เฟส 1: วัดอากาศ baseline (~1.2s)
  - เฟส 2: เป่าจริง — progress 0% → 100% ภายใน ~5 วินาที
  - หยุดนับเวลาเมื่อใบหน้าออกจากกรอบ (resume เมื่อกลับเข้ามา)
  - บันทึก session อัตโนมัติเมื่อเสร็จ
  - มี `nextScenario` สำหรับสลับผลลัพธ์ (pass / failAlcohol / failFaceMismatch)
- Common Widget: `FaceFramePreview` — mock camera พร้อมกรอบใบหน้า
  (เปลี่ยนสีกรอบเขียว/แดงตามสถานะ + แสดงป้าย "ขยับใบหน้าให้อยู่ในกรอบ")
- หน้า `TestReadyScreen` — หน้าก่อนเริ่ม กดเริ่ม/ยกเลิก
- หน้า `TestInProgressScreen` — Face frame + Status + Circular Progress (%)
  + ปุ่มจำลองสลับสถานะใบหน้าในกรอบ (ใช้ทดสอบโดยไม่มีกล้อง)
- หน้า `TestResultScreen` — Badge ผ่าน/ไม่ผ่าน + การ์ดวัดอากาศ/ผู้เป่า
  + threshold + สถานะการบันทึกผล + ปุ่ม "จบการทดสอบ"
- เพิ่ม Routes: `/test/ready`, `/test/in-progress`, `/test/complete`

### Changed
- เพิ่ม `TestController` ใน `MultiProvider` ของ `main.dart`

### Notes
- กล้องจริงและ face detection ยังเป็น mock — implementation จริง
  (`camera` + `google_mlkit_face_detection`) จะมาทดแทนตอนทดสอบบนอุปกรณ์จริง
- `InMemoryTestRepository` ยังไม่ persist ข้อมูลระหว่าง session ของแอป
  (Phase 6+ จะเปลี่ยนเป็น API/SQLite)

## [1.4.0] - 2026-04-29 (Phase 4: Driver Verification)

### Added
- เพิ่ม `MockCardReadScenario` enum (success / notFound / invalidNumber / mismatch) สลับ scenario ทดสอบ flow ต่าง ๆ ได้
- เพิ่ม `CardReadErrorType` enum + `CardReadException` มี `type` และ `detail` ประกอบ
- เพิ่ม `DriverInfo.maskedLicenseNumber` getter (เช่น "591100" → "59xxx00")
- หน้า `DriverConfirmationScreen`: แสดง license plate + ชื่อผู้ขับขี่ + เลขใบขับขี่ พร้อมปุ่ม "ยืนยันข้อมูล" / "ข้อมูลไม่ถูกต้อง"
- Route `/driver-confirm` รับ `DriverInfo` ผ่าน `extra`
- ใน `DeviceController`:
  - `confirmedDriver`, `cardReadError`, `isReadingCard` getters
  - `readDriverCard()` คืน `DriverInfo?` (null เมื่อ error, error เก็บใน `cardReadError`)
  - `confirmDriver()` / `rejectDriver()` / `clearCardReadError()`
  - `isReadyForTest` ตอนนี้ต้อง alcohol device + confirmed driver ทั้งคู่

### Changed
- `HomeScreen` แสดงปุ่ม "รูดใบขับขี่" หลังเชื่อมต่อเครื่องอ่าน, แสดง:
  - Banner เขียวเมื่อยืนยันใบขับขี่แล้ว (พร้อมปุ่มรูดบัตรใหม่)
  - Banner แดงเมื่อ card read ผิดพลาด พร้อมปุ่ม "ลองอีกครั้ง"
- ตัด `readDriverCard()` แบบ pass-through เก่าใน controller — แทนด้วย flow จัดการ state เต็มรูปแบบ

## [1.3.0] - 2026-04-29 (Phase 3: Device Integration)

### Added
- เพิ่ม dependency `provider ^6.1.2` สำหรับ state management
- Models: `DeviceConnectionState`, `DeviceKind`, `DeviceInfo`, `DeviceState` (immutable พร้อม `copyWith`)
- Services (abstract + mock implementations):
  - `AlcoholDeviceService` — scan / connect / disconnect / readMeasurements
  - `CardReaderService` — scan / connect / disconnect / readCard (พร้อม `DriverInfo`, `CardReadException`)
- `DeviceController` (ChangeNotifier) — รวมการจัดการสถานะของอุปกรณ์ทั้งสองตัว, มี `isReadyForTest` flag
- ปรับ `main.dart` ใช้ `MultiProvider` ห่อแอปเพื่อ inject `DeviceController` ลงทั้ง widget tree

### Changed
- `HomeScreen` ฟังสถานะจาก `DeviceController`:
  - ปุ่มเครื่องเป่า: เปลี่ยนสีจากเทา → แดงเมื่อเชื่อมต่อ + แสดง loading ระหว่างเชื่อมต่อ
  - ปุ่มเครื่องอ่านใบขับขี่: เช่นเดียวกัน
  - ปุ่ม "เริ่มการทดสอบ" ปลดล็อกเฉพาะเมื่อเครื่องเป่าเชื่อมต่อแล้ว (`isReadyForTest`)
  - แสดง `Device ID` ใน header เมื่อเชื่อมต่อสำเร็จ
  - มี Error banner เมื่อเชื่อมต่อไม่สำเร็จ

### Notes
- Implementation ยังเป็น Mock (ใช้ `Future.delayed`) — Bluetooth/USB Serial จริงจะมาทดแทนตอนทดสอบกับฮาร์ดแวร์ โดย interface พร้อมรองรับแล้ว

## [1.2.0] - 2026-04-29 (Phase 2: Authentication Flow)

### Added
- Models: `ContactType` enum + `OtpRequest` + `ContactValidator` (ตรวจสอบและ mask เบอร์/อีเมล)
- Custom widget `OtpInputField` — กล่อง OTP 6 หลัก รองรับ auto-focus, backspace, paste
- หน้า `OtpVerificationScreen`:
  - แสดงปลายทางที่ส่ง OTP (mask) + รหัสอ้างอิง 5 ตัวอักษร
  - ตัวจับเวลานับถอยหลัง 5 นาที
  - ปุ่ม "ขอรหัสใหม่อีกครั้ง" (reset countdown)
  - หมายเหตุพิเศษสำหรับ email ("หากไม่ได้รับ ให้ดูในอีเมล์ขยะ")
  - รองรับทั้ง phone และ email ในไฟล์เดียว
- หน้า `ResetPasswordScreen`:
  - ฟิลด์ New Password + Re Password พร้อม show/hide
  - Validator ตรวจความยาว ≥ 8 และยืนยันรหัสตรงกัน
- Routing เพิ่ม: `/otp/phone`, `/otp/email`, `/reset-password` (รับ `OtpRequest` ผ่าน `extra`)

### Changed
- `ForgotPasswordScreen`: เพิ่ม validation ตรวจรูปแบบเบอร์/อีเมล อัตโนมัติ และ navigate ไปหน้า OTP ที่เหมาะสม พร้อม `OtpRequest`
- `LoginScreen`: เพิ่ม Form validation, loading state, และ disable ปุ่มขณะส่ง

## [1.1.0] - 2026-04-28 (Phase 1: Foundation)

### Added
- เพิ่ม dependencies: `go_router` (routing), `intl` (จัด format วันที่ พ.ศ.)
- ตั้งโครงสร้างโฟลเดอร์: `lib/core` (theme, constants, utils), `lib/widgets/common`, `lib/screens`, `lib/routes`, `lib/models`, `lib/services`
- ระบบ Theme & Color Palette (`AppColors`, `AppTextStyles`, `AppTheme`) ตาม Mockup
- ค่าคงที่กลาง `AppConstants` (ชื่อแอป, เวอร์ชัน, threshold 3 mg%, OTP expiry 5 นาที)
- `DateFormatter` สำหรับ format วันที่/เวลาเป็น พ.ศ. และตัวจับเวลา OTP
- Common Widgets:
  - `AppLogo` — โลโก้ + ชื่อระบบ
  - `AppButton` (primary / danger / secondary / outline) พร้อม loading state และ icon
  - `AppHeader` — แถบทักทายผู้ใช้พร้อมวันที่/เวลา + เลขใบขับขี่ + Device ID
  - `AppFooter` — แสดง Version
  - `AppScaffold` — Scaffold มาตรฐานพร้อม Header/Footer
- ระบบ Routing ด้วย `go_router` (`AppRoutes`, `AppRouter`)
- หน้า Placeholder: `LoginScreen`, `ForgotPasswordScreen`, `HomeScreen`
- ปรับ `main.dart` ให้ใช้ Theme + Router ใหม่
- อัปเดต widget test ให้ตรงกับโครงสร้างแอปใหม่

### Changed
- เปลี่ยนชื่อ root widget จาก `MyApp` เป็น `AlcoholDetectorApp`

## [1.0.0] - 2026-04-28

## [1.0.0] - 2026-04-28

### Added
- สร้างโปรเจค Flutter เริ่มต้น (`flutter create`)
- รองรับแพลตฟอร์ม Android, iOS, Windows, macOS, Linux และ Web
- ตั้งค่า `pubspec.yaml` พร้อม dependencies พื้นฐาน (`cupertino_icons`, `flutter_lints`)
- เพิ่ม `.claude/` ใน `.gitignore`
- เพิ่มไฟล์ `CHANGELOG.md`
- เพิ่มไฟล์ `implement-plan-feature.md` สรุปแผนพัฒนาฟีเจอร์จาก Mockup และ User Flow Diagram
