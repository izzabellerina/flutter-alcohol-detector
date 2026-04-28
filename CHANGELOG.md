# Changelog

บันทึกการเปลี่ยนแปลงทั้งหมดของโปรเจค `alcohol_detector` จะถูกรวบรวมไว้ในไฟล์นี้

รูปแบบของไฟล์อ้างอิงตาม [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
และโปรเจคนี้ใช้ระบบเวอร์ชันแบบ [Semantic Versioning](https://semver.org/spec/v2.0.0.html)

## [Unreleased]

### Planned
- Phase 2: Authentication Flow (OTP via SMS/Email, Reset Password)
- Phase 3: เชื่อมต่ออุปกรณ์ (เครื่องเป่าแอลกอฮอล์ + เครื่องอ่านใบขับขี่)
- Phase 4: ยืนยันข้อมูลผู้ขับขี่
- Phase 5: หน้าทดสอบ + Face Detection + บันทึกผล

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
