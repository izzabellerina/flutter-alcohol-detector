# Changelog

บันทึกการเปลี่ยนแปลงทั้งหมดของโปรเจค `alcohol_detector` จะถูกรวบรวมไว้ในไฟล์นี้

รูปแบบของไฟล์อ้างอิงตาม [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
และโปรเจคนี้ใช้ระบบเวอร์ชันแบบ [Semantic Versioning](https://semver.org/spec/v2.0.0.html)

## [Unreleased]

### Planned
- Phase 6: Polish & QA (ทดสอบ flow ทุกกรณี + ปรับ UI/UX + ทดสอบบนอุปกรณ์จริง)
- เปลี่ยน Mock services เป็น implementation จริง:
  - Bluetooth/USB Serial สำหรับเครื่องเป่าและเครื่องอ่านบัตร
  - Camera + google_mlkit_face_detection สำหรับตรวจจับใบหน้า
  - API จริงสำหรับ Auth flow + บันทึกผลทดสอบ

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
