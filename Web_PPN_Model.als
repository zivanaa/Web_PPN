/*
 * ============================================================================
 * ALLOY MODEL: SISTEM INFORMASI PT PRAMUDITA PUPUK NUSANTARA (Web_PPN)
 * ============================================================================
 *
 * Deskripsi: Model formal untuk sistem informasi perusahaan pupuk yang mencakup:
 *   - Manajemen Produk (CRUD produk pupuk)
 *   - Pencatatan Penjualan (Logbook transaksi)
 *   - Manajemen Diskon (Promo dengan periode waktu)
 *   - Sistem Pembayaran (Cash, DP, Cicilan)
 *   - Manajemen Testimoni dan Galeri
 *
 * Kelompok: Web_PPN
 * Mata Kuliah: [Nama Mata Kuliah]
 * ============================================================================
 */

-- =============================================================================
-- BAGIAN 1: DEFINISI SIGNATURE (ENTITAS DASAR)
-- =============================================================================

-- Signature untuk waktu/tanggal (abstrak)
sig Waktu {}

-- Signature untuk jumlah uang (abstrak)
sig Nominal {
    nilai: one Int
}

-- =============================================================================
-- BAGIAN 2: ENTITAS PENGGUNA
-- =============================================================================

-- Abstrak signature untuk semua pengguna sistem
abstract sig Pengguna {
    nama: one String,
    status: one StatusAktif
}

-- Admin sistem (dapat mengakses semua fitur admin panel)
sig Admin extends Pengguna {}

-- Pelanggan (dapat melihat produk dan memberikan testimoni)
sig Pelanggan extends Pengguna {
    alamat: lone String
}

-- Koordinator penjualan (terlibat dalam transaksi)
sig Koordinator extends Pengguna {}

-- Marketing (mendapatkan komisi dari penjualan)
sig Marketing extends Pengguna {
    komisi: set Transaksi
}

-- Presenter (mempresentasikan produk)
sig Presenter extends Pengguna {}

-- Status aktif pengguna
enum StatusAktif { Aktif, NonAktif }

-- =============================================================================
-- BAGIAN 3: ENTITAS PRODUK
-- =============================================================================

-- Kategori produk pupuk
enum KategoriProduk {
    PupukCair,
    PupukPadat,
    ObatTanaman,
    Lainnya
}

-- Atribut khusus produk
enum AtributProduk {
    Baru,       -- Produk baru
    Laris,      -- Produk populer
    Promo,      -- Sedang promo
    Bonus,      -- Ada bonus
    Habis       -- Stok habis
}

-- Status tampilan produk
enum StatusProduk {
    Dipajang,   -- Ditampilkan di website
    Aktif,      -- Aktif tapi tidak dipajang
    NonAktif    -- Tidak aktif
}

-- Signature utama untuk Produk
sig Produk {
    namaProduk: one String,
    kategori: one KategoriProduk,
    harga: one Nominal,
    stok: one Int,
    atribut: set AtributProduk,
    statusProduk: one StatusProduk,
    diskon: lone Diskon,
    tanggalDibuat: one Waktu
}

-- =============================================================================
-- BAGIAN 4: ENTITAS DISKON
-- =============================================================================

-- Status diskon berdasarkan waktu
enum StatusDiskon {
    Direncanakan,   -- Belum dimulai
    Berjalan,       -- Sedang aktif
    Selesai         -- Sudah berakhir
}

-- Signature untuk Diskon
sig Diskon {
    persentase: one Int,
    tanggalMulai: one Waktu,
    tanggalSelesai: one Waktu,
    statusDiskon: one StatusDiskon,
    produkDiskon: one Produk
}

-- =============================================================================
-- BAGIAN 5: ENTITAS TRANSAKSI DAN PEMBAYARAN
-- =============================================================================

-- Metode pembayaran yang tersedia
enum MetodePembayaran {
    Cash,           -- Pembayaran tunai langsung
    DownPayment,    -- Uang muka (DP)
    Cicilan1Minggu, -- Cicilan 1 minggu
    Cicilan1Bulan   -- Cicilan 1 bulan
}

-- Status pembayaran transaksi
enum StatusPembayaran {
    Lunas,
    BelumLunas
}

-- Detail item dalam transaksi
sig ItemTransaksi {
    produk: one Produk,
    jumlah: one Int,
    hargaSatuan: one Nominal,
    subtotal: one Nominal
}

-- Signature utama untuk Transaksi (Logbook)
sig Transaksi {
    tanggalTransaksi: one Waktu,
    koordinator: one Koordinator,
    alamatPengiriman: one String,
    items: set ItemTransaksi,
    metodePembayaran: one MetodePembayaran,
    totalBayar: one Nominal,
    jumlahDibayar: one Nominal,
    sisaPembayaran: one Nominal,
    statusPembayaran: one StatusPembayaran,
    presenter: lone Presenter,
    marketing: lone Marketing,
    komisiMarketing: lone Nominal,
    dibuatOleh: one Admin
}

-- =============================================================================
-- BAGIAN 6: ENTITAS TESTIMONI
-- =============================================================================

-- Status tampilan testimoni
enum StatusTampil {
    Ditampilkan,
    Disembunyikan
}

-- Signature untuk Testimoni/Ulasan
sig Testimoni {
    pelanggan: one Pelanggan,
    produkDireview: one Produk,
    isiUlasan: one String,
    tanggalUlasan: one Waktu,
    statusTampil: one StatusTampil,
    dikelolahOleh: one Admin
}

-- =============================================================================
-- BAGIAN 7: ENTITAS GALERI
-- =============================================================================

-- Signature untuk item Galeri
sig Galeri {
    deskripsi: one String,
    tanggalUpload: one Waktu,
    statusGaleri: one StatusTampil,
    diuploadOleh: one Admin
}

-- =============================================================================
-- BAGIAN 8: ENTITAS FAQ
-- =============================================================================

-- Signature untuk FAQ
sig FAQ {
    pertanyaan: one String,
    jawaban: one String,
    statusFAQ: one StatusTampil,
    dibuatOleh: one Admin
}

-- =============================================================================
-- BAGIAN 9: STATE SISTEM
-- =============================================================================

-- State keseluruhan sistem
sig SistemPPN {
    daftarProduk: set Produk,
    daftarTransaksi: set Transaksi,
    daftarDiskon: set Diskon,
    daftarTestimoni: set Testimoni,
    daftarGaleri: set Galeri,
    daftarFAQ: set FAQ,
    daftarAdmin: set Admin,
    daftarPelanggan: set Pelanggan,
    waktuSekarang: one Waktu
}

-- =============================================================================
-- BAGIAN 10: FAKTA (FACTS) - CONSTRAINT INVARIANT
-- =============================================================================

-- Fact 1: Setiap diskon harus terkait dengan tepat satu produk
fact DiskonTerkaitProduk {
    all d: Diskon | one p: Produk | d.produkDiskon = p
    all d: Diskon | d.produkDiskon.diskon = d
}

-- Fact 2: Item transaksi harus memiliki jumlah positif
fact JumlahItemPositif {
    all it: ItemTransaksi | it.jumlah > 0
}

-- Fact 3: Persentase diskon harus valid (1-100)
fact PersentaseDiskonValid {
    all d: Diskon | d.persentase > 0 and d.persentase <= 100
}

-- Fact 4: Stok produk tidak boleh negatif
fact StokTidakNegatif {
    all p: Produk | p.stok >= 0
}

-- Fact 5: Produk dengan stok 0 harus memiliki atribut Habis
fact ProdukHabisJikaStok0 {
    all p: Produk | p.stok = 0 implies Habis in p.atribut
}

-- Fact 6: Transaksi yang lunas memiliki sisa pembayaran 0
fact TransaksiLunas {
    all t: Transaksi | t.statusPembayaran = Lunas implies t.sisaPembayaran.nilai = 0
}

-- Fact 7: Setiap item transaksi harus milik tepat satu transaksi
fact ItemMilikSatuTransaksi {
    all it: ItemTransaksi | one t: Transaksi | it in t.items
}

-- Fact 8: Testimoni harus dari pelanggan yang valid
fact TestimoniDariPelanggan {
    all te: Testimoni | te.pelanggan in Pelanggan
}

-- Fact 9: Marketing yang mendapat komisi harus terdaftar di transaksi
fact KomisiMarketing {
    all m: Marketing, t: Transaksi | t in m.komisi implies t.marketing = m
}

-- Fact 10: Produk dengan atribut Promo harus memiliki diskon aktif
fact PromoHarusAdaDiskon {
    all p: Produk | Promo in p.atribut implies
        (some d: Diskon | d.produkDiskon = p and d.statusDiskon = Berjalan)
}

-- =============================================================================
-- BAGIAN 11: PREDICATES - OPERASI SISTEM
-- =============================================================================

-- -----------------------------------------------------------------------------
-- PROSES 1: MANAJEMEN PRODUK
-- -----------------------------------------------------------------------------

-- Predicate: Tambah produk baru
pred tambahProduk[s, s': SistemPPN, p: Produk] {
    -- Precondition: Produk belum ada di sistem
    p not in s.daftarProduk

    -- Postcondition: Produk ditambahkan ke sistem
    s'.daftarProduk = s.daftarProduk + p

    -- Frame condition: Entitas lain tidak berubah
    s'.daftarTransaksi = s.daftarTransaksi
    s'.daftarDiskon = s.daftarDiskon
    s'.daftarTestimoni = s.daftarTestimoni
    s'.daftarGaleri = s.daftarGaleri
    s'.daftarFAQ = s.daftarFAQ
}

-- Predicate: Hapus produk
pred hapusProduk[s, s': SistemPPN, p: Produk] {
    -- Precondition: Produk ada di sistem
    p in s.daftarProduk

    -- Precondition: Produk tidak memiliki transaksi aktif
    no it: ItemTransaksi | it.produk = p and it in s.daftarTransaksi.items

    -- Postcondition: Produk dihapus dari sistem
    s'.daftarProduk = s.daftarProduk - p

    -- Frame condition
    s'.daftarTransaksi = s.daftarTransaksi
    s'.daftarTestimoni = s.daftarTestimoni
    s'.daftarGaleri = s.daftarGaleri
    s'.daftarFAQ = s.daftarFAQ
}

-- Predicate: Update status produk
pred ubahStatusProduk[p, p': Produk, statusBaru: StatusProduk] {
    -- Precondition: Status berubah
    p.statusProduk != statusBaru

    -- Postcondition: Status diperbarui
    p'.statusProduk = statusBaru

    -- Frame: Atribut lain tetap sama
    p'.namaProduk = p.namaProduk
    p'.kategori = p.kategori
    p'.harga = p.harga
    p'.stok = p.stok
}

-- Predicate: Kurangi stok produk (saat penjualan)
pred kurangiStok[p, p': Produk, jumlah: Int] {
    -- Precondition: Stok cukup
    p.stok >= jumlah
    jumlah > 0

    -- Postcondition: Stok berkurang
    p'.stok = minus[p.stok, jumlah]

    -- Frame condition
    p'.namaProduk = p.namaProduk
    p'.kategori = p.kategori
    p'.harga = p.harga
    p'.statusProduk = p.statusProduk
}

-- -----------------------------------------------------------------------------
-- PROSES 2: MANAJEMEN DISKON
-- -----------------------------------------------------------------------------

-- Predicate: Buat diskon baru
pred buatDiskon[s, s': SistemPPN, d: Diskon, p: Produk] {
    -- Precondition: Produk ada di sistem
    p in s.daftarProduk

    -- Precondition: Produk belum punya diskon aktif
    p.diskon = none or p.diskon.statusDiskon = Selesai

    -- Precondition: Persentase valid
    d.persentase > 0 and d.persentase <= 100

    -- Postcondition: Diskon ditambahkan
    s'.daftarDiskon = s.daftarDiskon + d
    d.produkDiskon = p

    -- Frame condition
    s'.daftarProduk = s.daftarProduk
    s'.daftarTransaksi = s.daftarTransaksi
}

-- Predicate: Aktifkan diskon (status berubah dari Direncanakan ke Berjalan)
pred aktifkanDiskon[d, d': Diskon] {
    -- Precondition: Diskon dalam status direncanakan
    d.statusDiskon = Direncanakan

    -- Postcondition: Status berubah jadi berjalan
    d'.statusDiskon = Berjalan

    -- Frame condition
    d'.persentase = d.persentase
    d'.produkDiskon = d.produkDiskon
    d'.tanggalMulai = d.tanggalMulai
    d'.tanggalSelesai = d.tanggalSelesai
}

-- Predicate: Akhiri diskon
pred akhiriDiskon[d, d': Diskon] {
    -- Precondition: Diskon sedang berjalan
    d.statusDiskon = Berjalan

    -- Postcondition: Status berubah jadi selesai
    d'.statusDiskon = Selesai

    -- Frame condition
    d'.persentase = d.persentase
    d'.produkDiskon = d.produkDiskon
}

-- -----------------------------------------------------------------------------
-- PROSES 3: PENCATATAN PENJUALAN (LOGBOOK)
-- -----------------------------------------------------------------------------

-- Predicate: Buat transaksi baru
pred buatTransaksi[s, s': SistemPPN, t: Transaksi, admin: Admin] {
    -- Precondition: Admin valid
    admin in s.daftarAdmin

    -- Precondition: Transaksi belum ada
    t not in s.daftarTransaksi

    -- Precondition: Semua produk dalam item ada di sistem
    all it: t.items | it.produk in s.daftarProduk

    -- Precondition: Stok mencukupi untuk semua item
    all it: t.items | it.produk.stok >= it.jumlah

    -- Postcondition: Transaksi ditambahkan
    s'.daftarTransaksi = s.daftarTransaksi + t
    t.dibuatOleh = admin

    -- Frame condition
    s'.daftarDiskon = s.daftarDiskon
    s'.daftarTestimoni = s.daftarTestimoni
    s'.daftarGaleri = s.daftarGaleri
    s'.daftarFAQ = s.daftarFAQ
}

-- Predicate: Proses pembayaran (update status)
pred prosesPembayaran[t, t': Transaksi, jumlahBayar: Nominal] {
    -- Precondition: Transaksi belum lunas
    t.statusPembayaran = BelumLunas

    -- Precondition: Jumlah pembayaran positif
    jumlahBayar.nilai > 0

    -- Postcondition: Update jumlah yang dibayar
    t'.jumlahDibayar.nilai = plus[t.jumlahDibayar.nilai, jumlahBayar.nilai]

    -- Postcondition: Update sisa pembayaran
    t'.sisaPembayaran.nilai = minus[t.totalBayar.nilai, t'.jumlahDibayar.nilai]

    -- Postcondition: Update status jika lunas
    t'.sisaPembayaran.nilai <= 0 implies t'.statusPembayaran = Lunas
    t'.sisaPembayaran.nilai > 0 implies t'.statusPembayaran = BelumLunas

    -- Frame condition
    t'.tanggalTransaksi = t.tanggalTransaksi
    t'.koordinator = t.koordinator
    t'.items = t.items
    t'.metodePembayaran = t.metodePembayaran
}

-- Predicate: Tandai transaksi lunas
pred tandaiLunas[t, t': Transaksi] {
    -- Precondition: Transaksi belum lunas
    t.statusPembayaran = BelumLunas

    -- Postcondition: Status jadi lunas
    t'.statusPembayaran = Lunas
    t'.sisaPembayaran.nilai = 0
    t'.jumlahDibayar = t.totalBayar

    -- Frame condition
    t'.tanggalTransaksi = t.tanggalTransaksi
    t'.koordinator = t.koordinator
    t'.items = t.items
}

-- -----------------------------------------------------------------------------
-- PROSES 4: MANAJEMEN TESTIMONI
-- -----------------------------------------------------------------------------

-- Predicate: Tambah testimoni
pred tambahTestimoni[s, s': SistemPPN, te: Testimoni, admin: Admin] {
    -- Precondition: Admin valid
    admin in s.daftarAdmin

    -- Precondition: Pelanggan valid
    te.pelanggan in s.daftarPelanggan

    -- Precondition: Produk yang direview ada
    te.produkDireview in s.daftarProduk

    -- Postcondition: Testimoni ditambahkan
    s'.daftarTestimoni = s.daftarTestimoni + te
    te.dikelolahOleh = admin

    -- Frame condition
    s'.daftarProduk = s.daftarProduk
    s'.daftarTransaksi = s.daftarTransaksi
    s'.daftarDiskon = s.daftarDiskon
    s'.daftarGaleri = s.daftarGaleri
    s'.daftarFAQ = s.daftarFAQ
}

-- Predicate: Ubah status tampilan testimoni
pred ubahStatusTestimoni[te, te': Testimoni, statusBaru: StatusTampil] {
    -- Precondition: Status berubah
    te.statusTampil != statusBaru

    -- Postcondition: Status diperbarui
    te'.statusTampil = statusBaru

    -- Frame condition
    te'.pelanggan = te.pelanggan
    te'.produkDireview = te.produkDireview
    te'.isiUlasan = te.isiUlasan
}

-- Predicate: Hapus testimoni
pred hapusTestimoni[s, s': SistemPPN, te: Testimoni] {
    -- Precondition: Testimoni ada
    te in s.daftarTestimoni

    -- Postcondition: Testimoni dihapus
    s'.daftarTestimoni = s.daftarTestimoni - te

    -- Frame condition
    s'.daftarProduk = s.daftarProduk
    s'.daftarTransaksi = s.daftarTransaksi
    s'.daftarDiskon = s.daftarDiskon
    s'.daftarGaleri = s.daftarGaleri
    s'.daftarFAQ = s.daftarFAQ
}

-- -----------------------------------------------------------------------------
-- PROSES 5: MANAJEMEN GALERI
-- -----------------------------------------------------------------------------

-- Predicate: Upload foto galeri
pred uploadGaleri[s, s': SistemPPN, g: Galeri, admin: Admin] {
    -- Precondition: Admin valid
    admin in s.daftarAdmin

    -- Precondition: Foto belum ada
    g not in s.daftarGaleri

    -- Postcondition: Foto ditambahkan
    s'.daftarGaleri = s.daftarGaleri + g
    g.diuploadOleh = admin

    -- Frame condition
    s'.daftarProduk = s.daftarProduk
    s'.daftarTransaksi = s.daftarTransaksi
    s'.daftarDiskon = s.daftarDiskon
    s'.daftarTestimoni = s.daftarTestimoni
    s'.daftarFAQ = s.daftarFAQ
}

-- Predicate: Hapus foto galeri
pred hapusGaleri[s, s': SistemPPN, g: Galeri] {
    -- Precondition: Foto ada
    g in s.daftarGaleri

    -- Postcondition: Foto dihapus
    s'.daftarGaleri = s.daftarGaleri - g

    -- Frame condition
    s'.daftarProduk = s.daftarProduk
    s'.daftarTransaksi = s.daftarTransaksi
    s'.daftarDiskon = s.daftarDiskon
    s'.daftarTestimoni = s.daftarTestimoni
    s'.daftarFAQ = s.daftarFAQ
}

-- -----------------------------------------------------------------------------
-- PROSES 6: MANAJEMEN FAQ
-- -----------------------------------------------------------------------------

-- Predicate: Tambah FAQ
pred tambahFAQ[s, s': SistemPPN, f: FAQ, admin: Admin] {
    -- Precondition: Admin valid
    admin in s.daftarAdmin

    -- Postcondition: FAQ ditambahkan
    s'.daftarFAQ = s.daftarFAQ + f
    f.dibuatOleh = admin

    -- Frame condition
    s'.daftarProduk = s.daftarProduk
    s'.daftarTransaksi = s.daftarTransaksi
    s'.daftarDiskon = s.daftarDiskon
    s'.daftarTestimoni = s.daftarTestimoni
    s'.daftarGaleri = s.daftarGaleri
}

-- Predicate: Hapus FAQ
pred hapusFAQ[s, s': SistemPPN, f: FAQ] {
    -- Precondition: FAQ ada
    f in s.daftarFAQ

    -- Postcondition: FAQ dihapus
    s'.daftarFAQ = s.daftarFAQ - f

    -- Frame condition
    s'.daftarProduk = s.daftarProduk
    s'.daftarTransaksi = s.daftarTransaksi
    s'.daftarDiskon = s.daftarDiskon
    s'.daftarTestimoni = s.daftarTestimoni
    s'.daftarGaleri = s.daftarGaleri
}

-- =============================================================================
-- BAGIAN 12: ASSERTIONS - PROPERTI YANG HARUS SELALU BENAR
-- =============================================================================

-- Assertion 1: Setelah menambah produk, jumlah produk bertambah
assert TambahProdukMenambahJumlah {
    all s, s': SistemPPN, p: Produk |
        tambahProduk[s, s', p] implies #s'.daftarProduk = plus[#s.daftarProduk, 1]
}

-- Assertion 2: Setelah menghapus produk, jumlah produk berkurang
assert HapusProdukMengurangiJumlah {
    all s, s': SistemPPN, p: Produk |
        hapusProduk[s, s', p] implies #s'.daftarProduk = minus[#s.daftarProduk, 1]
}

-- Assertion 3: Transaksi lunas tidak memiliki sisa pembayaran
assert TransaksiLunasTidakAdaSisa {
    all t: Transaksi |
        t.statusPembayaran = Lunas implies t.sisaPembayaran.nilai = 0
}

-- Assertion 4: Produk dengan stok 0 tidak bisa dijual
assert TidakBisaJualStokKosong {
    all t: Transaksi, it: ItemTransaksi |
        it in t.items implies it.produk.stok >= it.jumlah
}

-- Assertion 5: Diskon yang berjalan harus memiliki produk terkait
assert DiskonBerjalanPunyaProduk {
    all d: Diskon |
        d.statusDiskon = Berjalan implies d.produkDiskon != none
}

-- Assertion 6: Setiap testimoni harus memiliki pelanggan dan produk valid
assert TestimoniValid {
    all te: Testimoni |
        te.pelanggan in Pelanggan and te.produkDireview in Produk
}

-- Assertion 7: Persentase diskon selalu dalam range valid
assert PersentaseDiskonDalamRange {
    all d: Diskon | d.persentase > 0 and d.persentase <= 100
}

-- Assertion 8: Marketing hanya dapat komisi dari transaksi yang mereka tangani
assert KomisiHanyaDariTransaksiSendiri {
    all m: Marketing, t: Transaksi |
        t in m.komisi implies t.marketing = m
}

-- =============================================================================
-- BAGIAN 13: RUN COMMANDS - UNTUK VISUALISASI DAN TESTING
-- =============================================================================

-- Run 1: Tampilkan instance sistem dengan produk dan diskon
run TampilkanSistemDasar {
    some s: SistemPPN |
        #s.daftarProduk >= 2 and
        #s.daftarDiskon >= 1 and
        some d: s.daftarDiskon | d.statusDiskon = Berjalan
} for 5

-- Run 2: Tampilkan skenario transaksi penjualan
run TampilkanTransaksi {
    some s: SistemPPN |
        #s.daftarTransaksi >= 1 and
        some t: s.daftarTransaksi |
            #t.items >= 2 and
            t.statusPembayaran = BelumLunas
} for 6

-- Run 3: Tampilkan skenario transaksi dengan berbagai metode pembayaran
run TampilkanMetodePembayaran {
    some t1, t2: Transaksi |
        t1 != t2 and
        t1.metodePembayaran = Cash and
        t2.metodePembayaran = Cicilan1Bulan
} for 5

-- Run 4: Tampilkan proses diskon lengkap (dari direncanakan sampai selesai)
run TampilkanSiklusDiskon {
    some d1, d2, d3: Diskon |
        d1 != d2 and d2 != d3 and d1 != d3 and
        d1.statusDiskon = Direncanakan and
        d2.statusDiskon = Berjalan and
        d3.statusDiskon = Selesai
} for 6

-- Run 5: Tampilkan testimoni dari pelanggan
run TampilkanTestimoni {
    some s: SistemPPN |
        #s.daftarTestimoni >= 2 and
        some te: s.daftarTestimoni | te.statusTampil = Ditampilkan
} for 5

-- Run 6: Skenario lengkap sistem
run SkenarioLengkap {
    some s: SistemPPN |
        #s.daftarProduk >= 3 and
        #s.daftarTransaksi >= 2 and
        #s.daftarDiskon >= 1 and
        #s.daftarTestimoni >= 1 and
        #s.daftarGaleri >= 1 and
        #s.daftarFAQ >= 1 and
        some t: s.daftarTransaksi | t.statusPembayaran = Lunas and
        some t: s.daftarTransaksi | t.statusPembayaran = BelumLunas
} for 8

-- =============================================================================
-- BAGIAN 14: CHECK COMMANDS - VERIFIKASI ASSERTIONS
-- =============================================================================

-- Check semua assertions
check TambahProdukMenambahJumlah for 5
check HapusProdukMengurangiJumlah for 5
check TransaksiLunasTidakAdaSisa for 5
check TidakBisaJualStokKosong for 5
check DiskonBerjalanPunyaProduk for 5
check TestimoniValid for 5
check PersentaseDiskonDalamRange for 5
check KomisiHanyaDariTransaksiSendiri for 5

-- =============================================================================
-- AKHIR MODEL
-- =============================================================================
