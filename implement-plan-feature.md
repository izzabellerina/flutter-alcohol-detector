# Implement Plan: Feature สำหรับ Application เป่าแอลกอฮอล์

เอกสารนี้สรุปฟีเจอร์ทั้งหมดจาก Mockup และ User Flow Diagram (Version 260403.01) เพื่อใช้เป็นแผนในการพัฒนา Flutter Application สำหรับระบบบันทึกการวัดระดับแอลกอฮอล์

---

## 1. ภาพรวมระบบ (Overview)

แอปพลิเคชันสำหรับบันทึกการวัดระดับแอลกอฮอล์ของผู้ขับขี่ก่อนปฏิบัติงาน โดยมีองค์ประกอบหลัก:

- ระบบยืนยันตัวตนผู้ขับขี่ผ่านการรูดใบขับขี่
- ระบบเชื่อมต่ออุปกรณ์ภายนอก (เครื่องเป่าแอลกอฮอล์ + เครื่องอ่านใบขับขี่)
- ระบบตรวจจับใบหน้าระหว่างการทดสอบ
- ระบบบันทึกและแสดงผลการทดสอบ

### User Flow หลัก
```
เริ่มกระบวนการ → เปิด Application → เข้าสู่ระบบ
        → รูดใบขับขี่ → เป่าแอลกอฮอล์ → ผลการทดสอบ
        → พักรถ/เลิกขับรถ → สิ้นสุดกระบวนการ
```

---

## 2. รายการฟีเจอร์หลัก (Feature List)

### 2.1 Authentication (ยืนยันตัวตน)
- [ ] หน้า Login (Username + Password)
- [ ] ฟังก์ชัน "ลืมรหัสผ่าน"
- [ ] รับ OTP ผ่านหมายเลขโทรศัพท์ (SMS)
- [ ] รับ OTP ผ่านอีเมล
- [ ] หน้ายืนยัน OTP (มีตัวจับเวลา 5 นาที + รหัสอ้างอิง)
- [ ] หน้าตั้งรหัสผ่านใหม่ (New Password + Re Password)

### 2.2 Device Connection (เชื่อมต่ออุปกรณ์)
- [ ] เชื่อมต่อเครื่องเป่าแอลกอฮอล์ (แสดง Device ID เช่น `S2SF5KSJ`)
- [ ] เชื่อมต่อเครื่องอ่านใบขับขี่
- [ ] ปุ่ม "เลิกเชื่อมต่ออุปกรณ์"
- [ ] แสดงสถานะอุปกรณ์ที่เชื่อมต่อแบบ real-time

### 2.3 Driver Verification (ยืนยันผู้ขับขี่)
- [ ] รูดใบขับขี่ผ่านเครื่องอ่านบัตร
- [ ] ดึงและแสดงข้อมูลผู้ขับขี่ (เลขใบขับขี่, ชื่อ-นามสกุล, ทะเบียนรถ ฯลฯ)
- [ ] หน้ายืนยันข้อมูล (ปุ่ม "ยืนยันข้อมูล" / "ข้อมูลไม่ถูกต้อง")
- [ ] จัดการ Error Cases:
  - กรณีข้อมูลใบขับขี่ไม่ถูกต้อง
  - กรณีอ่านบัตรไม่ได้ (ไม่พบใบขับขี่)
  - กรณีข้อมูลใบขับขี่ไม่ตรงกับระบบ

### 2.4 Alcohol Test (การทดสอบเป่าแอลกอฮอล์)
- [ ] หน้า "พร้อมเริ่มการทดสอบ" (ปุ่ม "เริ่มการทดสอบ")
- [ ] หน้าทดสอบแบบ real-time พร้อม Progress (0% → 100%)
- [ ] ตรวจจับใบหน้าในกรอบตลอดการทดสอบ (Face Detection)
- [ ] แจ้งเตือน "ขยับใบหน้าอยู่ในกรอบ" เมื่อใบหน้าหลุดกรอบ
- [ ] แสดงสถานะ "เริ่มการเป่า..." / "กำลังเป่า..."
- [ ] หน้า "การทดสอบเสร็จสมบูรณ์"

### 2.5 Test Results (ผลการทดสอบ)
- [ ] แสดงผล "ผ่าน" / "ไม่ผ่าน"
- [ ] แสดงค่าวัดอากาศ (Baseline) — `mg%` พร้อม timestamp
- [ ] แสดงค่าวัดผู้เป่า — `mg%` พร้อม timestamp
- [ ] ระดับการแจ้งเตือน (Threshold): **3 mg%**
- [ ] บันทึกผลทดสอบลงระบบอัตโนมัติ
- [ ] จัดการ Result Cases:
  - กรณีผ่าน (ค่าต่ำกว่า threshold)
  - กรณีไม่ผ่าน — ตรวจพบแอลกอฮอล์
  - กรณีไม่ผ่าน — ใบหน้าไม่ตรงกับฐานข้อมูล
- [ ] ปุ่ม "จบการทดสอบ"

### 2.6 Common UI Elements
- [ ] Header แสดงวันที่/เวลา + ทักทาย (เช่น "01 มกราคม 2569 เวลา 17.00 น. สวัสดี DEMO")
- [ ] Footer แสดงเวอร์ชันแอป (เช่น `Version 260403.01`)
- [ ] Logo และชื่อระบบ "ระบบบันทึกการวัดระดับแอลกอฮอล์"

---

## 3. รายการหน้าจอ (Screen List)

| # | ชื่อหน้า | คำอธิบาย |
|---|---------|----------|
| 1 | Login | หน้าเข้าสู่ระบบ Username/Password |
| 2 | Forgot Password | กรอกหมายเลขโทรศัพท์/อีเมลเพื่อรับ OTP |
| 3 | OTP Verification (Phone) | กรอก OTP ที่ได้จาก SMS |
| 4 | OTP Verification (Email) | กรอก OTP ที่ได้จากอีเมล |
| 5 | Reset Password | ตั้งรหัสผ่านใหม่ |
| 6 | Home (Not Connected) | หน้าหลักก่อนเชื่อมต่ออุปกรณ์ |
| 7 | Home (Device Connected) | หลังเชื่อมต่อเครื่องเป่าแอลกอฮอล์ |
| 8 | Home (Card Reader Connected) | หลังเชื่อมต่อเครื่องอ่านใบขับขี่ |
| 9 | Driver Info Confirmation | ยืนยันข้อมูลผู้ขับขี่จากใบขับขี่ |
| 10 | Driver Info Mismatch | ข้อมูลใบขับขี่ไม่ตรงกับระบบ |
| 11 | Card Read Failed | กรณีอ่านบัตรไม่ได้ |
| 12 | Ready to Test | พร้อมเริ่มการทดสอบ |
| 13 | Testing in Progress | หน้าทดสอบ + Face Detection |
| 14 | Face Out of Frame Warning | แจ้งเตือนใบหน้าหลุดกรอบ |
| 15 | Test Complete | การทดสอบเสร็จสมบูรณ์ |
| 16 | Result: Pass | ผลการทดสอบผ่าน |
| 17 | Result: Fail (Alcohol) | ตรวจพบแอลกอฮอล์ |
| 18 | Result: Fail (Face Mismatch) | ใบหน้าไม่ตรงกับฐานข้อมูล |

---

## 4. แผนการพัฒนา (Development Roadmap)

### Phase 1 — โครงสร้างพื้นฐาน
- ตั้งโครงสร้างโปรเจค (folders: `lib/screens`, `lib/widgets`, `lib/models`, `lib/services`)
- ตั้ง Theme และ Color Palette ให้สอดคล้องกับ Mockup
- ตั้งระบบ Routing/Navigation
- สร้าง Common Widgets (Header, Footer, Buttons)

### Phase 2 — Authentication Flow
- หน้า Login + State Management
- Forgot Password + OTP Flow (SMS / Email)
- Reset Password
- เชื่อมต่อ API Authentication

### Phase 3 — Device Integration
- เชื่อมต่อเครื่องเป่าแอลกอฮอล์ (Bluetooth / USB / Serial)
- เชื่อมต่อเครื่องอ่านใบขับขี่
- จัดการ Connection State

### Phase 4 — Driver Verification
- อ่านข้อมูลใบขับขี่
- หน้ายืนยันข้อมูลผู้ขับขี่
- จัดการ Error Cases (อ่านไม่ได้, ข้อมูลไม่ตรง)

### Phase 5 — Test Flow
- หน้าทดสอบ + Camera/Face Detection
- รับค่าจากเครื่องเป่าแบบ real-time
- คำนวณและแสดงผล (Pass / Fail)
- บันทึกผลลงระบบ

### Phase 6 — Polish & QA
- ทดสอบทุก Flow และ Error Cases
- ปรับ UI/UX ตาม Mockup
- ทดสอบบนอุปกรณ์จริง

---

## 5. Dependencies ที่คาดว่าจะใช้

| Package | ใช้สำหรับ |
|---------|-----------|
| `flutter_bloc` หรือ `provider` / `riverpod` | State Management |
| `go_router` | Routing |
| `dio` หรือ `http` | API Communication |
| `flutter_secure_storage` | เก็บ Token / Credentials |
| `flutter_blue_plus` | เชื่อมต่อ Bluetooth กับอุปกรณ์ |
| `usb_serial` | เชื่อมต่ออุปกรณ์ผ่าน USB Serial |
| `camera` | กล้องสำหรับ Face Detection |
| `google_mlkit_face_detection` | ตรวจจับใบหน้า |
| `intl` | Format วันที่/เวลา (รองรับ พ.ศ.) |
| `pin_code_fields` | UI กรอก OTP |

---

## 6. Business Rules ที่ต้องระวัง

- **ระดับ Threshold**: ค่าแจ้งเตือนอยู่ที่ **3 mg%** — ค่าเกินจะถือว่า "ไม่ผ่าน"
- **OTP**: มีอายุ 5 นาที + ต้องมีรหัสอ้างอิง (เช่น `ED1AR`) เพื่อยืนยัน
- **Face Detection**: ต้องตรวจจับใบหน้าผู้เป่าตลอดเวลาทดสอบ — ถ้าหลุดกรอบต้องแจ้งเตือนและหยุดการเป่า
- **Test Sequence**: ต้องวัด **อากาศ** (baseline) ก่อน แล้วจึงวัด **ผู้เป่า**
- **Date Format**: ใช้ปี พ.ศ. (เช่น 2569) ในการแสดงผล
- **Version Display**: แสดง Version แบบ `YYMMDD.NN` (เช่น `260403.01`)

---

## 7. Open Questions (ประเด็นที่ต้องสอบถามเพิ่ม)

- API Endpoints และ Authentication Method ที่ใช้
- โปรโตคอลในการเชื่อมต่อกับเครื่องเป่าแอลกอฮอล์ (Bluetooth/USB/Serial?)
- รุ่นและ SDK ของเครื่องอ่านใบขับขี่ที่รองรับ
- ฐานข้อมูลใบหน้า — ใช้ใน Local หรือ Cloud Service?
- ข้อกำหนดด้าน Offline Mode (กรณีไม่มีอินเทอร์เน็ต)
- Logging / Audit Trail ที่ต้องเก็บ
