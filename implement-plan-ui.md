# Implement Plan: ปรับ UI ให้สวยและใช้งานง่ายขึ้น

เอกสารนี้สรุปแผนการปรับปรุงหน้าตา (UI/UX) ของแอป `alcohol_detector` จากดีไซน์ Mockup เดิมที่เน้นการใช้งาน — ให้ดูทันสมัย น่าใช้ และคงเอกลักษณ์ของแอปบันทึกการวัดระดับแอลกอฮอล์

---

## 1. เป้าหมาย (Goals)

| เป้าหมาย | ตัวชี้วัด |
|---------|----------|
| สร้างเอกลักษณ์ของแบรนด์ | มีโลโก้จริง + ฟอนต์ + สีหลักที่จดจำได้ |
| ลดภาระสายตา | spacing สม่ำเสมอ + visual hierarchy ชัดเจน |
| สื่อสารสถานะแบบ real-time | สีและไอคอนแสดงสถานะการเชื่อมต่อ/ทดสอบเข้าใจง่าย |
| สร้างความเชื่อมั่น | UI ดูเป็นมืออาชีพ น่าใช้สำหรับการตรวจวัดราชการ |
| รองรับการใช้งานทุกแสงภาพ | Dark mode + High contrast |

---

## 2. หลักการดีไซน์ (Design Principles)

### 2.1 Visual Tone
- **Modern Material 3 expressive** — โทนเรียบสะอาดแบบ Material You แต่มี personality
- **เน้นความปลอดภัย** — โทนเขียวสื่อ "ผ่าน/ปลอดภัย", แดงสื่อ "เกิน/อันตราย", น้ำเงินสื่อ "ระบบราชการ"
- **Photographic confidence** — ใช้ภาพจริง / ไอคอน outline แทน emoji

### 2.2 Spacing Scale
ใช้ระบบ token: `xs=4, sm=8, md=12, lg=16, xl=24, xxl=32, xxxl=48` แทนการกำหนดตัวเลขแบบกระจัดกระจาย

### 2.3 Elevation & Surfaces
- 3 ระดับ: `surface` (พื้นปกติ), `surfaceContainer` (การ์ด), `surfaceContainerHighest` (modal)
- ใช้ shadow เบา ๆ + border radius 12-16px ให้ดู soft-modern

### 2.4 Motion
- Transition 200-300ms ease-out
- `flutter_animate` สำหรับ entrance/exit
- Hero animation ตอนเปลี่ยนหน้า (Login → Home)

---

## 3. งาน Foundation (ทำก่อน)

### 3.1 Brand Assets
- [ ] สร้าง/หาโลโก้จริง (SVG + PNG @1x/2x/3x) แทนกล่อง "Logo"
- [ ] สร้าง app icon ใหม่ (Android/iOS/Web/Windows)
- [ ] เลือก hero illustration / background สำหรับหน้า Login (ถ้ามี)
- [ ] วาง assets ใน `assets/images/`, `assets/icons/`

### 3.2 Typography
- [ ] โหลด **Sarabun** เป็น Flutter asset จริง (ปัจจุบันอ้างอิงเฉย ๆ ไม่ได้โหลด)
  - น้ำหนัก: Regular 400, Medium 500, SemiBold 600, Bold 700
  - source: Google Fonts หรือ self-host
- [ ] ปรับ `AppTextStyles` ให้ใช้ font family `Sarabun` จริง
- [ ] กำหนด type scale: `displayL/M/S, headlineL/M/S, titleL/M/S, bodyL/M/S, labelL/M/S`

### 3.3 Color System (ขยาย)
ปัจจุบันมี primary/danger/secondary แค่ 1 ระดับต่อสี — ขยายเป็นระดับ tint/shade

```dart
class AppColors {
  // Primary (green)
  static const primary50 = Color(0xFFEFFDF4);
  static const primary100 = Color(0xFFD1FADF);
  static const primary500 = Color(0xFF22C55E);  // brand
  static const primary700 = Color(0xFF15803D);
  static const primary900 = Color(0xFF14532D);
  // ... เช่นเดียวกันสำหรับ danger, info, neutral
}
```

### 3.4 Spacing & Radius Tokens
```dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 48.0;
}
class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const pill = 999.0;
}
```

### 3.5 Dark Mode
- [ ] ทำ `AppTheme.dark` คู่ขนานกับ `light`
- [ ] รองรับ `themeMode: system` ใน `MaterialApp`
- [ ] ทดสอบทุก screen ใน dark mode

---

## 4. แผนการปรับ UI ทีละหน้า

### 4.1 Login Screen
**ตอนนี้**: form กลางจอ, logo placeholder, ไม่มีพื้นหลัง

**เป้าหมาย**:
- เพิ่ม **gradient background** แนวตั้ง (primary50 → white) หรือ subtle pattern
- โลโก้จริง + ชื่อระบบ + คำอธิบายสั้น ๆ
- TextField เป็น **filled พร้อม floating label** (Material 3 style)
- ปุ่ม "เข้าสู่ระบบ" มี icon ไอคอน arrow หรือ fingerprint
- ลิงก์ "ลืมรหัสผ่าน" ให้เด่นขึ้น (underline + brand color)
- เพิ่ม version + อัปเดตที่ส่วนล่างให้ subtle

### 4.2 Forgot Password / OTP / Reset Password
- หัวข้อแสดง progress (`1/3 → 2/3 → 3/3`) ให้ผู้ใช้รู้ว่าอยู่ขั้นไหน
- OTP boxes:
  - ขยายขนาด, ตัวเลขเด่น
  - Active box มี ring สีแบรนด์
  - completed box มี check icon
- Countdown timer:
  - แสดงเป็น **circular progress** + เวลานับถอยหลังตรงกลาง
  - เปลี่ยนเป็นแดงเมื่อใกล้หมดเวลา (< 30 วินาที)
- Reset password: เพิ่ม **password strength meter** (เขียว/เหลือง/แดง)

### 4.3 Home Screen
**ตอนนี้**: ปุ่มเรียงกัน + banner

**เป้าหมาย**: ปรับเป็น **dashboard cards**
- การ์ด "อุปกรณ์เป่าแอลกอฮอล์":
  - Icon ใหญ่ + ชื่ออุปกรณ์ + Device ID
  - Status badge (เขียว "เชื่อมต่อแล้ว" / เทา "ยังไม่เชื่อมต่อ" / แดง "ขัดข้อง")
  - Pulse animation บน icon ตอน connecting
- การ์ด "ข้อมูลผู้ขับขี่":
  - Avatar / initials
  - ชื่อ + เลขใบขับขี่
  - ปุ่ม "รูดบัตรใหม่" inline
- ปุ่ม "เริ่มการทดสอบ" ใหญ่ มี icon นิ้วเป่า + gradient fill ตอน enable
- Header: gradient bar น้ำเงิน → น้ำเงินเข้ม + greeting มีชื่อ + วันที่

### 4.4 Driver Confirmation
- License plate box ใหญ่ ดูเป็นป้ายทะเบียนจริง (กรอบเหลี่ยมขาว ตัวอักษรใหญ่)
- ข้อมูลผู้ขับขี่: card layout พร้อม avatar
- ปุ่ม "ยืนยัน" สีเขียว expressive + ปุ่ม "ไม่ถูกต้อง" outlined
- Animation slide-up จาก home

### 4.5 Test Ready Screen
- Hero illustration / animation: ไอคอนเป่า + breathing animation
- คำแนะนำเป็น checklist (เป่ายาว 5 วินาที, อยู่ในกรอบ, ฯลฯ)
- ปุ่ม "เริ่มการทดสอบ" สีเขียวเด่น + countdown 3-2-1 ก่อนเริ่ม

### 4.6 Test In Progress Screen ⭐ (สำคัญที่สุด)
**ตอนนี้**: mock camera + circular progress

**เป้าหมาย**:
- **Camera preview จริง** + face detection overlay
- กรอบใบหน้า:
  - เปลี่ยนสีสมูธ (เขียว ↔ แดง ↔ เหลือง)
  - มี breathing pulse ตอน face in frame
  - มี shake animation ตอน face out of frame
- Progress:
  - **radial progress** เต็มหน้า + เปอร์เซ็นต์ตรงกลาง animated
  - **wave/breathing animation** รอบ ๆ ขณะเป่า
  - แสดง mg% real-time (เคลื่อนไหวขึ้นลง)
- Status text: large + animated transition ระหว่างเฟส
- Background: dim เพื่อ focus ที่ camera

### 4.7 Test Result Screen ⭐
- Result badge:
  - **Animated reveal** (scale + fade)
  - Pass: ไอคอน check ใหญ่ + confetti animation (lottie)
  - Fail: ไอคอน warning ใหญ่
- Measurement cards:
  - Icon (อากาศ = ลม, ผู้เป่า = หน้า)
  - Value ใหญ่ + unit
  - มินิ chart bar เทียบกับ threshold
- "ระดับการแจ้งเตือน 3 mg%" แสดงเป็น **threshold line marker**
- Save status: success animation (checkmark draw)

---

## 5. Common Widgets ที่ต้องเพิ่ม / ปรับ

| Widget | Status | Notes |
|---|---|---|
| `AppLogo` | ปรับ | ใช้ asset จริง |
| `AppButton` | ปรับ | เพิ่ม variant: `tonal`, `pill`; เพิ่ม loading shimmer |
| `AppHeader` | ปรับ | gradient + avatar + greeting |
| `AppCard` | ใหม่ | wrapper สำหรับ dashboard cards |
| `StatusBadge` | ใหม่ | เขียว/เหลือง/แดง พร้อม dot indicator |
| `OtpInputField` | ปรับ | ขยายขนาด + active ring |
| `ProgressRing` | ใหม่ | circular progress พร้อมเลขกลาง |
| `AppEmptyState` | ใหม่ | สำหรับหน้าว่าง / error |
| `ShimmerBox` | ใหม่ | loading skeleton |
| `AppSnackBar` | ใหม่ | toast/snackbar สวย ๆ |

---

## 6. Micro-interactions & Animations

| Where | Effect | Library |
|---|---|---|
| Page transitions | slide + fade | go_router custom |
| Button press | scale 0.96 + haptic | flutter (built-in) |
| Card appearance | fade + slide-up 200ms | `flutter_animate` |
| OTP correct | green pulse | `flutter_animate` |
| Connecting status | pulse animation บน icon | `flutter_animate` |
| Test progress wave | breathing scale | `flutter_animate` |
| Pass result | confetti | `lottie` หรือ `confetti` |
| Save success | checkmark draw | `lottie` |
| Loading | shimmer | `shimmer` |

---

## 7. Dependencies ที่ต้องเพิ่ม

| Package | ใช้สำหรับ |
|---|---|
| `flutter_animate` ^4.5 | Micro-animations |
| `lottie` ^3.1 | Lottie animations (confetti, success) |
| `shimmer` ^3.0 | Loading skeleton |
| `google_fonts` ^6.2 | (ทางเลือก) โหลด Sarabun ออนไลน์ ถ้าไม่ self-host |

---

## 8. แผนงานเป็น Phase

### Phase UI-1: Foundation (แตก branch `30-04-69-phase-ui-1-foundation`)
- ติดตั้ง Sarabun font asset
- ขยาย AppColors เป็น tint/shade scale
- เพิ่ม `AppSpacing`, `AppRadius` tokens
- ทำ Dark Theme
- เพิ่มโลโก้จริง + app icon
- ปรับ `MaterialApp` รองรับ `themeMode: system`

### Phase UI-2: Auth Polish
- ปรับ Login (gradient, hero, floating labels)
- ปรับ OTP (boxes, countdown ring)
- ปรับ Reset Password (strength meter)
- ปรับ ForgotPassword (progress indicator)

### Phase UI-3: Home & Driver
- เปลี่ยนปุ่ม Home เป็น dashboard cards
- เพิ่ม `StatusBadge` + `AppCard`
- ปรับ Header gradient + avatar
- ปรับ Driver Confirmation card layout

### Phase UI-4: Test Flow Polish
- ปรับ TestReady (illustration + checklist + countdown)
- ปรับ TestInProgress (radial progress, wave animation, face frame transitions)
- ปรับ TestResult (animated reveal, confetti, measurement cards)

### Phase UI-5: Micro-interactions
- เพิ่ม flutter_animate ทั่วแอป
- Page transitions
- Haptic feedback ในจุดสำคัญ
- Shimmer loading states

### Phase UI-6: Accessibility & QA
- Semantic labels
- ตรวจ contrast ratio (WCAG AA)
- รองรับ font scaling
- ทดสอบทุก screen ใน dark mode
- ทดสอบบนอุปกรณ์จริง (อย่างน้อย Android + iOS)

---

## 9. ไฟล์ที่ต้องแตะ (สรุปคร่าว ๆ)

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart          ← ขยาย scale
│   │   ├── app_text_styles.dart     ← ใช้ Sarabun จริง + type scale
│   │   ├── app_theme.dart           ← เพิ่ม dark
│   │   ├── app_spacing.dart         ← ใหม่
│   │   └── app_radius.dart          ← ใหม่
│   └── ...
├── widgets/
│   └── common/
│       ├── app_logo.dart            ← ใช้ asset
│       ├── app_buttons.dart         ← เพิ่ม variants
│       ├── app_header.dart          ← gradient + avatar
│       ├── app_card.dart            ← ใหม่
│       ├── status_badge.dart        ← ใหม่
│       ├── progress_ring.dart       ← ใหม่
│       ├── shimmer_box.dart         ← ใหม่
│       └── ...
├── screens/                         ← ปรับ UI ทุกหน้าตาม Phase 4
└── ...

assets/
├── fonts/Sarabun-*.ttf
├── images/logo.png, hero.png
├── icons/app_icon.png
└── lottie/confetti.json, success.json
```

---

## 10. Open Questions

1. **Brand identity**: มี logo / brand guideline จากลูกค้าหรือไม่? ถ้ายังต้องสร้างเอง
2. **Color tone**: คงเขียวสื่อ "ผ่าน" หรืออาจจะใช้สีน้ำเงินตามหน่วยงานราชการ?
3. **Font licensing**: Sarabun เป็น OFL — ใช้ได้ฟรีในเชิงพาณิชย์ ✅
4. **Lottie animations**: มีงบสำหรับซื้อ animation หรือใช้จาก lottiefiles.com (ฟรี)?
5. **Dark mode priority**: จำเป็นในระยะแรกไหม หรือเลื่อน Phase หลัง?
6. **Camera asset**: ใช้ illustration / icon mock หรือรอเชื่อมกล้องจริงค่อยทำ UI สวย?
7. **Language**: คงไทยอย่างเดียว หรือต้องรองรับอังกฤษด้วย?

---

## 11. Estimated Effort (คร่าว ๆ)

| Phase | งาน | เวลา (วัน) |
|---|---|---|
| UI-1 | Foundation | 2 |
| UI-2 | Auth polish | 2 |
| UI-3 | Home & Driver | 2 |
| UI-4 | Test flow polish | 3 |
| UI-5 | Micro-interactions | 2 |
| UI-6 | Accessibility & QA | 2 |
| **รวม** | | **~13 วัน** |

> หมายเหตุ: ประเมินสำหรับนักพัฒนา 1 คนทำเต็มเวลา; งานออกแบบ asset (logo, illustrations) แยกต่างหาก
