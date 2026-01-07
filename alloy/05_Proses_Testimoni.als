/*
 * FILE: 05_Proses_Testimoni.als
 * DESKRIPSI: Proses manajemen testimoni pelanggan
 * KELOMPOK: Web_PPN
 */

-- ENTITAS DASAR
sig Waktu {}
sig Nominal {}

abstract sig StatusAktif {}
one sig UserAktif, UserNonAktif extends StatusAktif {}

abstract sig StatusTampil {}
one sig Ditampilkan, Disembunyikan extends StatusTampil {}

-- PENGGUNA
abstract sig Pengguna {
    status: one StatusAktif
}
sig Admin extends Pengguna {}
sig Pelanggan extends Pengguna {}

-- PRODUK
sig Produk {
    harga: one Nominal
}

-- TESTIMONI
sig Testimoni {
    pelanggan: one Pelanggan,
    produkDireview: one Produk,
    tanggalUlasan: one Waktu,
    statusTampil: one StatusTampil,
    dikelolahOleh: one Admin
}

sig SistemTestimoni {
    daftarProduk: set Produk,
    daftarTestimoni: set Testimoni,
    daftarAdmin: set Admin,
    daftarPelanggan: set Pelanggan
}

-- ===================
-- PROSES: TAMBAH TESTIMONI
-- ===================
pred tambahTestimoni[s: SistemTestimoni, s2: SistemTestimoni, te: Testimoni, admin: Admin] {
    -- Precondition
    admin in s.daftarAdmin
    te.pelanggan in s.daftarPelanggan
    te.produkDireview in s.daftarProduk
    te not in s.daftarTestimoni
    te.dikelolahOleh = admin
    -- Postcondition
    s2.daftarTestimoni = s.daftarTestimoni + te
    s2.daftarProduk = s.daftarProduk
    s2.daftarAdmin = s.daftarAdmin
    s2.daftarPelanggan = s.daftarPelanggan
}

-- ===================
-- PROSES: UBAH STATUS TAMPIL
-- ===================
pred ubahStatusTampil[te: Testimoni, te2: Testimoni, statusBaru: StatusTampil] {
    -- Precondition: status berbeda
    te.statusTampil != statusBaru
    -- Postcondition
    te2.statusTampil = statusBaru
    te2.pelanggan = te.pelanggan
    te2.produkDireview = te.produkDireview
    te2.tanggalUlasan = te.tanggalUlasan
    te2.dikelolahOleh = te.dikelolahOleh
}

-- ===================
-- PROSES: TAMPILKAN TESTIMONI
-- ===================
pred tampilkanTestimoni[te: Testimoni, te2: Testimoni] {
    te.statusTampil = Disembunyikan
    te2.statusTampil = Ditampilkan
    te2.pelanggan = te.pelanggan
    te2.produkDireview = te.produkDireview
    te2.tanggalUlasan = te.tanggalUlasan
    te2.dikelolahOleh = te.dikelolahOleh
}

-- ===================
-- PROSES: SEMBUNYIKAN TESTIMONI
-- ===================
pred sembunyikanTestimoni[te: Testimoni, te2: Testimoni] {
    te.statusTampil = Ditampilkan
    te2.statusTampil = Disembunyikan
    te2.pelanggan = te.pelanggan
    te2.produkDireview = te.produkDireview
    te2.tanggalUlasan = te.tanggalUlasan
    te2.dikelolahOleh = te.dikelolahOleh
}

-- ===================
-- PROSES: HAPUS TESTIMONI
-- ===================
pred hapusTestimoni[s: SistemTestimoni, s2: SistemTestimoni, te: Testimoni] {
    -- Precondition
    te in s.daftarTestimoni
    -- Postcondition
    s2.daftarTestimoni = s.daftarTestimoni - te
    s2.daftarProduk = s.daftarProduk
    s2.daftarAdmin = s.daftarAdmin
    s2.daftarPelanggan = s.daftarPelanggan
}

-- ASSERTION
assert TestimoniPunyaPelanggan {
    all te: Testimoni | some te.pelanggan
}

assert TambahTestimoniBerhasil {
    all s: SistemTestimoni, s2: SistemTestimoni, te: Testimoni, a: Admin |
        tambahTestimoni[s, s2, te, a] implies te in s2.daftarTestimoni
}

-- RUN COMMANDS
run TampilkanTestimoni {
    some te: Testimoni | te.statusTampil = Ditampilkan
    some te: Testimoni | te.statusTampil = Disembunyikan
} for 5

run ProsesTambahTestimoni {
    some s: SistemTestimoni, s2: SistemTestimoni, te: Testimoni, a: Admin |
        tambahTestimoni[s, s2, te, a]
} for 5

run ProsesTampilkan {
    some te: Testimoni, te2: Testimoni | tampilkanTestimoni[te, te2]
} for 3

run ProsesSembunyikan {
    some te: Testimoni, te2: Testimoni | sembunyikanTestimoni[te, te2]
} for 3

-- CHECK
check TestimoniPunyaPelanggan for 5
check TambahTestimoniBerhasil for 5
