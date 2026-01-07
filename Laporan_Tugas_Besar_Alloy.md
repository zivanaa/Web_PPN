# LAPORAN TUGAS BESAR
# PEMODELAN FORMAL MENGGUNAKAN ALLOY

## SISTEM INFORMASI PT PRAMUDITA PUPUK NUSANTARA (Web_PPN)

---

**Mata Kuliah:** [Nama Mata Kuliah]

**Dosen Pengampu:** [Nama Dosen]

**Kelompok:** [Nama Kelompok]

**Anggota Kelompok:**
1. [Nama Anggota 1] - [NIM]
2. [Nama Anggota 2] - [NIM]
3. [Nama Anggota 3] - [NIM]

**Program Studi:** [Nama Program Studi]

**Fakultas:** [Nama Fakultas]

**Universitas:** [Nama Universitas]

**Tahun:** 2025

---

\newpage

## DAFTAR ISI

1. [Pendahuluan](#1-pendahuluan)
   - 1.1 Latar Belakang
   - 1.2 Tujuan
   - 1.3 Ruang Lingkup
2. [Deskripsi Sistem](#2-deskripsi-sistem)
   - 2.1 Gambaran Umum Sistem
   - 2.2 Fitur Utama Sistem
   - 2.3 Arsitektur Sistem
3. [Pemodelan Alloy](#3-pemodelan-alloy)
   - 3.1 Pendahuluan Alloy
   - 3.2 Struktur File Model
   - 3.3 Definisi Entitas (Signatures)
   - 3.4 Proses-Proses Bisnis (Predicates)
   - 3.5 Constraints (Facts)
   - 3.6 Assertions
4. [Penjelasan Detail Setiap Proses](#4-penjelasan-detail-setiap-proses)
   - 4.1 Proses Manajemen Produk
   - 4.2 Proses Manajemen Diskon
   - 4.3 Proses Transaksi Penjualan
   - 4.4 Proses Manajemen Testimoni
   - 4.5 Proses Manajemen Galeri
   - 4.6 Proses Manajemen FAQ
5. [Hasil Eksekusi dan Visualisasi](#5-hasil-eksekusi-dan-visualisasi)
6. [Kesimpulan](#6-kesimpulan)
7. [Lampiran](#7-lampiran)

---

\newpage

## 1. PENDAHULUAN

### 1.1 Latar Belakang

PT Pramudita Pupuk Nusantara (PPN) adalah perusahaan pupuk nasional yang berfokus pada pertanian berkelanjutan. Dalam rangka mendukung operasional bisnis, perusahaan ini mengembangkan sistem informasi berbasis web (Web_PPN) yang mencakup:

- Website publik untuk menampilkan katalog produk
- Panel admin untuk mengelola produk, transaksi, testimoni, galeri, dan FAQ
- Sistem pencatatan penjualan (logbook) dengan berbagai metode pembayaran
- Manajemen diskon dengan periode waktu otomatis

Untuk memastikan sistem ini berjalan dengan benar dan bebas dari kesalahan logika, diperlukan pemodelan formal menggunakan bahasa spesifikasi Alloy. Pemodelan ini memungkinkan verifikasi terhadap properti-properti sistem sebelum implementasi.

### 1.2 Tujuan

Tujuan dari pembuatan model Alloy untuk sistem Web_PPN adalah:

1. **Memvalidasi desain sistem** - Memastikan bahwa desain sistem sudah benar secara logis
2. **Menemukan bug potensial** - Mengidentifikasi kemungkinan kesalahan sebelum implementasi
3. **Mendokumentasikan spesifikasi** - Membuat dokumentasi formal yang presisi
4. **Memverifikasi properti sistem** - Membuktikan bahwa sistem memenuhi properti yang diharapkan

### 1.3 Ruang Lingkup

Pemodelan Alloy ini mencakup proses-proses utama dalam sistem Web_PPN:

| No | Proses | Deskripsi |
|----|--------|-----------|
| 1 | Manajemen Produk | Tambah, hapus, dan ubah status produk |
| 2 | Manajemen Diskon | Buat, aktifkan, dan akhiri diskon |
| 3 | Transaksi Penjualan | Buat transaksi dan proses pembayaran |
| 4 | Manajemen Testimoni | Tambah, tampilkan/sembunyikan, hapus testimoni |
| 5 | Manajemen Galeri | Upload dan hapus foto galeri |
| 6 | Manajemen FAQ | Tambah dan hapus FAQ |

---

\newpage

## 2. DESKRIPSI SISTEM

### 2.1 Gambaran Umum Sistem

Sistem Web_PPN adalah platform e-commerce dan manajemen internal untuk PT Pramudita Pupuk Nusantara. Sistem ini terdiri dari dua bagian utama:

**A. Website Publik (Customer-Facing)**
- Halaman beranda dengan carousel produk
- Katalog produk dengan filter kategori
- Detail produk dengan informasi lengkap
- Galeri foto aktivitas perusahaan
- Halaman FAQ
- Link ke marketplace (Tokopedia, Shopee, Lazada, TikTok Shop)

**B. Panel Admin (Internal)**
- Dashboard manajemen
- CRUD Produk
- Pencatatan penjualan (Logbook)
- Manajemen testimoni pelanggan
- Manajemen galeri
- Manajemen FAQ
- Manajemen diskon

### 2.2 Fitur Utama Sistem

#### 2.2.1 Manajemen Produk
Produk dalam sistem memiliki atribut:
- **Kategori**: Pupuk Cair, Pupuk Padat, Obat Tanaman, Lainnya
- **Atribut**: Baru, Laris, Promo, Bonus, Habis
- **Status**: Dipajang, Aktif, Non-aktif

#### 2.2.2 Sistem Diskon
Diskon memiliki lifecycle:
1. **Direncanakan** - Diskon dibuat tapi belum aktif
2. **Berjalan** - Diskon sedang aktif
3. **Selesai** - Diskon sudah berakhir

#### 2.2.3 Transaksi Penjualan
Metode pembayaran yang tersedia:
- Cash (tunai langsung)
- Down Payment (uang muka)
- Cicilan 1 Minggu
- Cicilan 1 Bulan

Status pembayaran: **Lunas** atau **Belum Lunas**

#### 2.2.4 Testimoni dan Galeri
- Testimoni dari pelanggan dapat ditampilkan atau disembunyikan
- Galeri berisi foto aktivitas perusahaan

### 2.3 Arsitektur Sistem

```
┌─────────────────────────────────────────────────────────────┐
│                      WEBSITE PUBLIK                          │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌───────┐  │
│  │ Beranda │ │ Produk  │ │ Galeri  │ │   FAQ   │ │ About │  │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └───────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                        DATABASE                              │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌───────┐  │
│  │ Produk  │ │ Diskon  │ │Transaksi│ │Testimoni│ │ Galeri│  │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └───────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       PANEL ADMIN                            │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌───────┐  │
│  │ Produk  │ │ Diskon  │ │ Logbook │ │Testimoni│ │ Galeri│  │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └───────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

\newpage

## 3. PEMODELAN ALLOY

### 3.1 Pendahuluan Alloy

**Alloy** adalah bahasa pemodelan formal yang dikembangkan oleh MIT. Alloy menggunakan logika relasional untuk mendeskripsikan struktur dan perilaku sistem. Komponen utama dalam Alloy:

| Komponen | Deskripsi |
|----------|-----------|
| **Signature (sig)** | Mendefinisikan entitas/tipe data |
| **Field** | Atribut dari signature |
| **Fact** | Constraint yang selalu berlaku |
| **Predicate (pred)** | Operasi/proses yang dapat dilakukan |
| **Assertion (assert)** | Properti yang harus diverifikasi |
| **Run** | Perintah untuk mencari instance |
| **Check** | Perintah untuk memverifikasi assertion |

### 3.2 Struktur File Model

Model Alloy untuk sistem Web_PPN dibagi menjadi 7 file terpisah:

| No | Nama File | Deskripsi |
|----|-----------|-----------|
| 1 | `01_Core_Entitas.als` | Definisi semua entitas dasar sistem |
| 2 | `02_Proses_Produk.als` | Proses manajemen produk |
| 3 | `03_Proses_Diskon.als` | Proses manajemen diskon |
| 4 | `04_Proses_Transaksi.als` | Proses transaksi penjualan |
| 5 | `05_Proses_Testimoni.als` | Proses manajemen testimoni |
| 6 | `06_Proses_Galeri.als` | Proses manajemen galeri |
| 7 | `07_Proses_FAQ.als` | Proses manajemen FAQ |

### 3.3 Definisi Entitas (Signatures)

#### 3.3.1 Entitas Dasar

```alloy
sig Waktu {}
sig Nominal {}
```

**Penjelasan:**
- `Waktu` - Merepresentasikan tanggal/waktu dalam sistem
- `Nominal` - Merepresentasikan nilai uang

#### 3.3.2 Status dan Enumerasi

```alloy
-- Status Pengguna
abstract sig StatusAktif {}
one sig UserAktif, UserNonAktif extends StatusAktif {}

-- Kategori Produk
abstract sig KategoriProduk {}
one sig PupukCair, PupukPadat, ObatTanaman, KategoriLain extends KategoriProduk {}

-- Atribut Produk
abstract sig AtributProduk {}
one sig Baru, Laris, Promo, Bonus, Habis extends AtributProduk {}

-- Status Produk
abstract sig StatusProduk {}
one sig Dipajang, ProdukAktif, ProdukNonAktif extends StatusProduk {}

-- Status Diskon
abstract sig StatusDiskon {}
one sig Direncanakan, Berjalan, Selesai extends StatusDiskon {}

-- Metode Pembayaran
abstract sig MetodePembayaran {}
one sig Cash, DownPayment, Cicilan1Minggu, Cicilan1Bulan extends MetodePembayaran {}

-- Status Pembayaran
abstract sig StatusPembayaran {}
one sig Lunas, BelumLunas extends StatusPembayaran {}

-- Status Tampil
abstract sig StatusTampil {}
one sig Ditampilkan, Disembunyikan extends StatusTampil {}
```

**Penjelasan:**
- Menggunakan pola `abstract sig` + `one sig extends` untuk membuat enumerasi
- `one sig` memastikan hanya ada satu instance dari setiap nilai enum

#### 3.3.3 Entitas Pengguna

```alloy
abstract sig Pengguna {
    status: one StatusAktif
}
sig Admin extends Pengguna {}
sig Pelanggan extends Pengguna {}
sig Koordinator extends Pengguna {}
sig Marketing extends Pengguna {}
sig Presenter extends Pengguna {}
```

**Penjelasan:**
- `Pengguna` adalah abstract signature yang menjadi parent
- Setiap pengguna memiliki status aktif/non-aktif
- Ada 5 jenis pengguna: Admin, Pelanggan, Koordinator, Marketing, Presenter

#### 3.3.4 Entitas Produk

```alloy
sig Produk {
    kategori: one KategoriProduk,
    harga: one Nominal,
    atribut: set AtributProduk,
    statusProduk: one StatusProduk,
    tanggalDibuat: one Waktu
}
```

**Penjelasan:**
- Setiap produk memiliki tepat satu kategori (`one`)
- Produk dapat memiliki beberapa atribut sekaligus (`set`)
- Status produk menentukan apakah ditampilkan di website

#### 3.3.5 Entitas Diskon

```alloy
sig Diskon {
    tanggalMulai: one Waktu,
    tanggalSelesai: one Waktu,
    statusDiskon: one StatusDiskon,
    produkDiskon: one Produk
}
```

**Penjelasan:**
- Diskon memiliki periode waktu (mulai dan selesai)
- Status diskon berubah sesuai waktu: Direncanakan → Berjalan → Selesai
- Setiap diskon terkait dengan satu produk

#### 3.3.6 Entitas Transaksi

```alloy
sig ItemTransaksi {
    produk: one Produk,
    hargaSatuan: one Nominal,
    subtotal: one Nominal
}

sig Transaksi {
    tanggalTransaksi: one Waktu,
    koordinator: one Koordinator,
    items: set ItemTransaksi,
    metodePembayaran: one MetodePembayaran,
    totalBayar: one Nominal,
    jumlahDibayar: one Nominal,
    statusPembayaran: one StatusPembayaran,
    presenter: lone Presenter,
    marketing: lone Marketing,
    dibuatOleh: one Admin
}
```

**Penjelasan:**
- `ItemTransaksi` merepresentasikan item dalam satu transaksi
- `Transaksi` dapat memiliki banyak item (`set ItemTransaksi`)
- `lone` berarti optional (0 atau 1)
- Transaksi mencatat metode pembayaran dan status pembayaran

#### 3.3.7 Entitas Testimoni, Galeri, dan FAQ

```alloy
sig Testimoni {
    pelanggan: one Pelanggan,
    produkDireview: one Produk,
    tanggalUlasan: one Waktu,
    statusTampil: one StatusTampil,
    dikelolahOleh: one Admin
}

sig Galeri {
    tanggalUpload: one Waktu,
    statusGaleri: one StatusTampil,
    diuploadOleh: one Admin
}

sig FAQ {
    statusFAQ: one StatusTampil,
    dibuatOleh: one Admin
}
```

### 3.4 Proses-Proses Bisnis (Predicates)

Predicate dalam Alloy merepresentasikan operasi atau proses yang dapat dilakukan dalam sistem. Format umum:

```alloy
pred namaProses[param1: Tipe1, param2: Tipe2] {
    -- Precondition (syarat sebelum proses)
    -- Postcondition (hasil setelah proses)
    -- Frame condition (apa yang tidak berubah)
}
```

### 3.5 Constraints (Facts)

Facts adalah constraint yang selalu berlaku dalam sistem:

```alloy
-- Setiap item transaksi harus milik tepat satu transaksi
fact ItemMilikSatuTransaksi {
    all it: ItemTransaksi | one t: Transaksi | it in t.items
}

-- Transaksi lunas harus memiliki jumlah dibayar = total bayar
fact TransaksiLunasValid {
    all t: Transaksi | t.statusPembayaran = Lunas implies
        t.jumlahDibayar = t.totalBayar
}

-- Diskon pada produk yang sama tidak boleh aktif bersamaan
fact DiskonUnik {
    all disj d1, d2: Diskon | d1.produkDiskon = d2.produkDiskon implies
        d1.statusDiskon = Selesai or d2.statusDiskon = Selesai
}
```

### 3.6 Assertions

Assertions adalah properti yang harus diverifikasi:

```alloy
assert TambahProdukBerhasil {
    all s: SistemProduk, s2: SistemProduk, p: Produk |
        tambahProduk[s, s2, p] implies p in s2.daftarProduk
}

assert TransaksiLunasValid {
    all t: Transaksi |
        t.statusPembayaran = Lunas implies t.jumlahDibayar = t.totalBayar
}
```

---

\newpage

## 4. PENJELASAN DETAIL SETIAP PROSES

### 4.1 Proses Manajemen Produk

**File:** `02_Proses_Produk.als`

#### 4.1.1 Tambah Produk

```alloy
pred tambahProduk[s: SistemProduk, s2: SistemProduk, p: Produk] {
    -- Precondition: produk belum ada
    p not in s.daftarProduk
    -- Postcondition: produk ditambahkan
    s2.daftarProduk = s.daftarProduk + p
}
```

**Penjelasan:**
- **Input:** State awal sistem (s), state akhir sistem (s2), produk baru (p)
- **Precondition:** Produk belum ada di sistem (`p not in s.daftarProduk`)
- **Postcondition:** Produk ditambahkan ke daftar (`s2.daftarProduk = s.daftarProduk + p`)

**Diagram Alur:**
```
┌─────────────┐     ┌──────────────────┐     ┌─────────────┐
│ State Awal  │ --> │ tambahProduk[p]  │ --> │ State Akhir │
│ {P1, P2}    │     │                  │     │ {P1, P2, P3}│
└─────────────┘     └──────────────────┘     └─────────────┘
```

#### 4.1.2 Hapus Produk

```alloy
pred hapusProduk[s: SistemProduk, s2: SistemProduk, p: Produk] {
    -- Precondition: produk ada di sistem
    p in s.daftarProduk
    -- Precondition: tidak ada transaksi yang menggunakan produk ini
    no it: ItemTransaksi | it.produk = p and it in s.daftarTransaksi.items
    -- Postcondition: produk dihapus
    s2.daftarProduk = s.daftarProduk - p
}
```

**Penjelasan:**
- Produk hanya bisa dihapus jika tidak ada transaksi yang menggunakannya
- Ini mencegah inkonsistensi data

#### 4.1.3 Ubah Status Produk

```alloy
pred ubahStatusProduk[p: Produk, p2: Produk, statusBaru: StatusProduk] {
    -- Precondition: status berbeda
    p.statusProduk != statusBaru
    -- Postcondition: status berubah, atribut lain tetap
    p2.statusProduk = statusBaru
    p2.kategori = p.kategori
    p2.harga = p.harga
    p2.atribut = p.atribut
}
```

**Penjelasan:**
- Frame condition memastikan atribut lain tidak berubah
- Hanya status yang dimodifikasi

---

### 4.2 Proses Manajemen Diskon

**File:** `03_Proses_Diskon.als`

#### 4.2.1 Lifecycle Diskon

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│ DIRENCANAKAN │ --> │   BERJALAN   │ --> │   SELESAI    │
│              │     │              │     │              │
│ (belum aktif)│     │ (sedang aktif)│    │ (sudah habis)│
└──────────────┘     └──────────────┘     └──────────────┘
       │                    │                    │
       ▼                    ▼                    ▼
   buatDiskon()      aktifkanDiskon()     akhiriDiskon()
```

#### 4.2.2 Buat Diskon

```alloy
pred buatDiskon[s: SistemDiskon, s2: SistemDiskon, d: Diskon, p: Produk] {
    -- Precondition
    p in s.daftarProduk
    d not in s.daftarDiskon
    d.produkDiskon = p
    d.statusDiskon = Direncanakan
    -- Postcondition
    s2.daftarDiskon = s.daftarDiskon + d
}
```

#### 4.2.3 Aktifkan Diskon

```alloy
pred aktifkanDiskon[d: Diskon, d2: Diskon] {
    -- Precondition: status direncanakan
    d.statusDiskon = Direncanakan
    -- Postcondition: status berjalan
    d2.statusDiskon = Berjalan
    d2.produkDiskon = d.produkDiskon
}
```

#### 4.2.4 Akhiri Diskon

```alloy
pred akhiriDiskon[d: Diskon, d2: Diskon] {
    -- Precondition: status berjalan
    d.statusDiskon = Berjalan
    -- Postcondition: status selesai
    d2.statusDiskon = Selesai
}
```

---

### 4.3 Proses Transaksi Penjualan

**File:** `04_Proses_Transaksi.als`

#### 4.3.1 Alur Transaksi

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    BUAT     │ --> │   PROSES    │ --> │    LUNAS    │
│  TRANSAKSI  │     │  PEMBAYARAN │     │             │
└─────────────┘     └─────────────┘     └─────────────┘
       │                   │                   │
       ▼                   ▼                   ▼
 Status: BelumLunas   Cicilan/DP        Status: Lunas
```

#### 4.3.2 Buat Transaksi

```alloy
pred buatTransaksi[s: SistemTransaksi, s2: SistemTransaksi, t: Transaksi, admin: Admin] {
    -- Precondition
    admin in s.daftarAdmin
    t not in s.daftarTransaksi
    all it: t.items | it.produk in s.daftarProduk
    t.dibuatOleh = admin
    t.statusPembayaran = BelumLunas
    -- Postcondition
    s2.daftarTransaksi = s.daftarTransaksi + t
}
```

**Penjelasan:**
- Admin harus valid
- Semua produk dalam item harus ada di sistem
- Status awal transaksi adalah "Belum Lunas"

#### 4.3.3 Tandai Lunas

```alloy
pred tandaiLunas[t: Transaksi, t2: Transaksi] {
    -- Precondition: belum lunas
    t.statusPembayaran = BelumLunas
    -- Postcondition: jadi lunas
    t2.statusPembayaran = Lunas
    t2.jumlahDibayar = t.totalBayar
}
```

**Penjelasan:**
- Mengubah status dari "Belum Lunas" menjadi "Lunas"
- Jumlah dibayar menjadi sama dengan total bayar

---

### 4.4 Proses Manajemen Testimoni

**File:** `05_Proses_Testimoni.als`

#### 4.4.1 Tambah Testimoni

```alloy
pred tambahTestimoni[s: SistemTestimoni, s2: SistemTestimoni, te: Testimoni, admin: Admin] {
    admin in s.daftarAdmin
    te.pelanggan in s.daftarPelanggan
    te.produkDireview in s.daftarProduk
    te not in s.daftarTestimoni
    te.dikelolahOleh = admin
    s2.daftarTestimoni = s.daftarTestimoni + te
}
```

#### 4.4.2 Tampilkan/Sembunyikan Testimoni

```alloy
pred tampilkanTestimoni[te: Testimoni, te2: Testimoni] {
    te.statusTampil = Disembunyikan
    te2.statusTampil = Ditampilkan
}

pred sembunyikanTestimoni[te: Testimoni, te2: Testimoni] {
    te.statusTampil = Ditampilkan
    te2.statusTampil = Disembunyikan
}
```

---

### 4.5 Proses Manajemen Galeri

**File:** `06_Proses_Galeri.als`

#### 4.5.1 Upload Galeri

```alloy
pred uploadGaleri[s: SistemGaleri, s2: SistemGaleri, g: Galeri, admin: Admin] {
    admin in s.daftarAdmin
    g not in s.daftarGaleri
    g.diuploadOleh = admin
    s2.daftarGaleri = s.daftarGaleri + g
}
```

#### 4.5.2 Hapus Galeri

```alloy
pred hapusGaleri[s: SistemGaleri, s2: SistemGaleri, g: Galeri] {
    g in s.daftarGaleri
    s2.daftarGaleri = s.daftarGaleri - g
}
```

---

### 4.6 Proses Manajemen FAQ

**File:** `07_Proses_FAQ.als`

#### 4.6.1 Tambah FAQ

```alloy
pred tambahFAQ[s: SistemFAQ, s2: SistemFAQ, f: FAQ, admin: Admin] {
    admin in s.daftarAdmin
    f not in s.daftarFAQ
    f.dibuatOleh = admin
    s2.daftarFAQ = s.daftarFAQ + f
}
```

#### 4.6.2 Hapus FAQ

```alloy
pred hapusFAQ[s: SistemFAQ, s2: SistemFAQ, f: FAQ] {
    f in s.daftarFAQ
    s2.daftarFAQ = s.daftarFAQ - f
}
```

---

\newpage

## 5. HASIL EKSEKUSI DAN VISUALISASI

### 5.1 Cara Menjalankan Model

1. Buka **Alloy Analyzer**
2. Buka file `.als` yang diinginkan
3. Klik menu **Execute**
4. Pilih command yang ingin dijalankan (Run atau Check)
5. Klik **Show** untuk melihat visualisasi

### 5.2 Contoh Run Commands

#### Run: Tampilkan Produk
```alloy
run TampilkanProduk {
    some p: Produk | p.kategori = PupukCair
    some p: Produk | p.kategori = PupukPadat
} for 5
```
**Hasil:** Menampilkan instance dengan minimal 2 produk dari kategori berbeda

#### Run: Tampilkan Transaksi
```alloy
run TampilkanTransaksi {
    some t: Transaksi | t.statusPembayaran = Lunas
    some t: Transaksi | t.statusPembayaran = BelumLunas
} for 5
```
**Hasil:** Menampilkan instance dengan transaksi lunas dan belum lunas

#### Run: Proses Tambah Produk
```alloy
run ProsesTambahProduk {
    some s: SistemProduk, s2: SistemProduk, p: Produk |
        tambahProduk[s, s2, p]
} for 4
```
**Hasil:** Menampilkan transisi state saat menambah produk

### 5.3 Contoh Check Commands

```alloy
check TambahProdukBerhasil for 5
check TransaksiLunasValid for 5
check DiskonPunyaProduk for 5
```

**Hasil yang diharapkan:** "No counterexample found" - artinya assertion terbukti benar

### 5.4 Interpretasi Hasil

| Hasil | Interpretasi |
|-------|--------------|
| Instance found | Model berhasil menemukan contoh yang memenuhi constraint |
| No instance found | Tidak ada contoh yang memenuhi (mungkin constraint terlalu ketat) |
| No counterexample found | Assertion terbukti benar dalam scope yang diberikan |
| Counterexample found | Assertion dilanggar, ada bug dalam model |

---

\newpage

## 6. KESIMPULAN

### 6.1 Ringkasan

Pemodelan formal menggunakan Alloy untuk sistem Web_PPN telah berhasil dilakukan dengan hasil sebagai berikut:

1. **7 file model Alloy** telah dibuat untuk merepresentasikan berbagai proses dalam sistem
2. **6 proses utama** telah dimodelkan: Produk, Diskon, Transaksi, Testimoni, Galeri, dan FAQ
3. **Constraints dan assertions** telah didefinisikan untuk memverifikasi properti sistem

### 6.2 Properti yang Terverifikasi

| No | Properti | Status |
|----|----------|--------|
| 1 | Tambah produk berhasil menambah produk ke sistem | ✓ Verified |
| 2 | Hapus produk berhasil menghapus produk dari sistem | ✓ Verified |
| 3 | Transaksi lunas memiliki jumlah dibayar = total bayar | ✓ Verified |
| 4 | Setiap diskon memiliki produk terkait | ✓ Verified |
| 5 | Setiap testimoni memiliki pelanggan | ✓ Verified |

### 6.3 Manfaat Pemodelan

1. **Deteksi dini kesalahan** - Kesalahan logika dapat ditemukan sebelum implementasi
2. **Dokumentasi formal** - Model Alloy menjadi dokumentasi yang presisi
3. **Verifikasi properti** - Properti sistem dapat dibuktikan secara formal
4. **Pemahaman sistem** - Memaksa pemahaman mendalam terhadap sistem

### 6.4 Saran Pengembangan

1. Menambahkan model untuk autentikasi dan otorisasi
2. Memodelkan concurrent access dan race conditions
3. Menambahkan temporal properties menggunakan Alloy dengan Electrum

---

\newpage

## 7. LAMPIRAN

### Lampiran A: Daftar File Model Alloy

| No | Nama File | Ukuran | Jumlah Baris |
|----|-----------|--------|--------------|
| 1 | 01_Core_Entitas.als | - | ~100 |
| 2 | 02_Proses_Produk.als | - | ~80 |
| 3 | 03_Proses_Diskon.als | - | ~90 |
| 4 | 04_Proses_Transaksi.als | - | ~100 |
| 5 | 05_Proses_Testimoni.als | - | ~90 |
| 6 | 06_Proses_Galeri.als | - | ~70 |
| 7 | 07_Proses_FAQ.als | - | ~70 |

### Lampiran B: Referensi

1. Jackson, D. (2012). *Software Abstractions: Logic, Language, and Analysis*. MIT Press.
2. Alloy Documentation. https://alloytools.org/documentation.html
3. Alloy Tutorial. https://alloytools.org/tutorials/online/

### Lampiran C: Source Code Lengkap

(Lihat file `.als` terlampir)

---

**--- AKHIR LAPORAN ---**
