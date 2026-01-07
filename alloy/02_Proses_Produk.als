/*
 * FILE: 02_Proses_Produk.als
 * DESKRIPSI: Proses manajemen produk (CRUD)
 * KELOMPOK: Web_PPN
 */

-- ENTITAS DASAR
sig Waktu {}
sig Nominal {}

abstract sig KategoriProduk {}
one sig PupukCair, PupukPadat, ObatTanaman, KategoriLain extends KategoriProduk {}

abstract sig AtributProduk {}
one sig Baru, Laris, Promo, Bonus, Habis extends AtributProduk {}

abstract sig StatusProduk {}
one sig Dipajang, ProdukAktif, ProdukNonAktif extends StatusProduk {}

sig Produk {
    kategori: one KategoriProduk,
    harga: one Nominal,
    atribut: set AtributProduk,
    statusProduk: one StatusProduk,
    tanggalDibuat: one Waktu
}

sig SistemProduk {
    daftarProduk: set Produk
}

-- ===================
-- PROSES: TAMBAH PRODUK
-- ===================
pred tambahProduk[s: SistemProduk, s2: SistemProduk, p: Produk] {
    -- Precondition: produk belum ada
    p not in s.daftarProduk
    -- Postcondition: produk ditambahkan
    s2.daftarProduk = s.daftarProduk + p
}

-- ===================
-- PROSES: HAPUS PRODUK
-- ===================
pred hapusProduk[s: SistemProduk, s2: SistemProduk, p: Produk] {
    -- Precondition: produk ada di sistem
    p in s.daftarProduk
    -- Postcondition: produk dihapus
    s2.daftarProduk = s.daftarProduk - p
}

-- ===================
-- PROSES: UBAH STATUS PRODUK
-- ===================
pred ubahStatusProduk[p: Produk, p2: Produk, statusBaru: StatusProduk] {
    -- Precondition: status berbeda
    p.statusProduk != statusBaru
    -- Postcondition: status berubah
    p2.statusProduk = statusBaru
    p2.kategori = p.kategori
    p2.harga = p.harga
    p2.atribut = p.atribut
    p2.tanggalDibuat = p.tanggalDibuat
}

-- ASSERTION
assert TambahProdukBerhasil {
    all s: SistemProduk, s2: SistemProduk, p: Produk |
        tambahProduk[s, s2, p] implies p in s2.daftarProduk
}

assert HapusProdukBerhasil {
    all s: SistemProduk, s2: SistemProduk, p: Produk |
        hapusProduk[s, s2, p] implies p not in s2.daftarProduk
}

-- RUN COMMANDS
run TampilkanProduk {
    some p: Produk | p.kategori = PupukCair
    some p: Produk | p.kategori = PupukPadat
} for 5

run ProsesTambahProduk {
    some s: SistemProduk, s2: SistemProduk, p: Produk |
        tambahProduk[s, s2, p]
} for 4

run ProsesHapusProduk {
    some s: SistemProduk, s2: SistemProduk, p: Produk |
        hapusProduk[s, s2, p]
} for 4

run ProsesUbahStatus {
    some p: Produk, p2: Produk |
        ubahStatusProduk[p, p2, ProdukNonAktif]
} for 3

-- CHECK
check TambahProdukBerhasil for 5
check HapusProdukBerhasil for 5
