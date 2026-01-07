/*
 * FILE: 03_Proses_Diskon.als
 * DESKRIPSI: Proses manajemen diskon
 * KELOMPOK: Web_PPN
 */

-- ENTITAS DASAR
sig Waktu {}
sig Nominal {}

abstract sig KategoriProduk {}
one sig PupukCair, PupukPadat, ObatTanaman extends KategoriProduk {}

abstract sig StatusProduk {}
one sig Dipajang, ProdukAktif, ProdukNonAktif extends StatusProduk {}

abstract sig StatusDiskon {}
one sig Direncanakan, Berjalan, Selesai extends StatusDiskon {}

sig Produk {
    kategori: one KategoriProduk,
    harga: one Nominal,
    statusProduk: one StatusProduk
}

sig Diskon {
    tanggalMulai: one Waktu,
    tanggalSelesai: one Waktu,
    statusDiskon: one StatusDiskon,
    produkDiskon: one Produk
}

sig SistemDiskon {
    daftarProduk: set Produk,
    daftarDiskon: set Diskon
}

-- CONSTRAINT
fact DiskonUnik {
    all disj d1, d2: Diskon | d1.produkDiskon = d2.produkDiskon implies
        d1.statusDiskon = Selesai or d2.statusDiskon = Selesai
}

-- ===================
-- PROSES: BUAT DISKON BARU
-- ===================
pred buatDiskon[s: SistemDiskon, s2: SistemDiskon, d: Diskon, p: Produk] {
    -- Precondition: produk ada, diskon belum ada
    p in s.daftarProduk
    d not in s.daftarDiskon
    d.produkDiskon = p
    d.statusDiskon = Direncanakan
    -- Postcondition: diskon ditambahkan
    s2.daftarDiskon = s.daftarDiskon + d
    s2.daftarProduk = s.daftarProduk
}

-- ===================
-- PROSES: AKTIFKAN DISKON
-- ===================
pred aktifkanDiskon[d: Diskon, d2: Diskon] {
    -- Precondition: status direncanakan
    d.statusDiskon = Direncanakan
    -- Postcondition: status berjalan
    d2.statusDiskon = Berjalan
    d2.produkDiskon = d.produkDiskon
    d2.tanggalMulai = d.tanggalMulai
    d2.tanggalSelesai = d.tanggalSelesai
}

-- ===================
-- PROSES: AKHIRI DISKON
-- ===================
pred akhiriDiskon[d: Diskon, d2: Diskon] {
    -- Precondition: status berjalan
    d.statusDiskon = Berjalan
    -- Postcondition: status selesai
    d2.statusDiskon = Selesai
    d2.produkDiskon = d.produkDiskon
    d2.tanggalMulai = d.tanggalMulai
    d2.tanggalSelesai = d.tanggalSelesai
}

-- ===================
-- PROSES: HAPUS DISKON
-- ===================
pred hapusDiskon[s: SistemDiskon, s2: SistemDiskon, d: Diskon] {
    -- Precondition: diskon ada dan sudah selesai
    d in s.daftarDiskon
    d.statusDiskon = Selesai
    -- Postcondition: diskon dihapus
    s2.daftarDiskon = s.daftarDiskon - d
    s2.daftarProduk = s.daftarProduk
}

-- ASSERTION
assert DiskonPunyaProduk {
    all d: Diskon | some d.produkDiskon
}

assert AktifkanDiskonBerhasil {
    all d: Diskon, d2: Diskon |
        aktifkanDiskon[d, d2] implies d2.statusDiskon = Berjalan
}

-- RUN COMMANDS
run TampilkanDiskon {
    some d: Diskon | d.statusDiskon = Berjalan
    some d: Diskon | d.statusDiskon = Direncanakan
} for 5

run ProsesBuatDiskon {
    some s: SistemDiskon, s2: SistemDiskon, d: Diskon, p: Produk |
        buatDiskon[s, s2, d, p]
} for 4

run ProsesAktifkanDiskon {
    some d: Diskon, d2: Diskon | aktifkanDiskon[d, d2]
} for 3

run ProsesSiklusDiskon {
    some d1: Diskon | d1.statusDiskon = Direncanakan
    some d2: Diskon | d2.statusDiskon = Berjalan
    some d3: Diskon | d3.statusDiskon = Selesai
} for 5

-- CHECK
check DiskonPunyaProduk for 5
check AktifkanDiskonBerhasil for 5
