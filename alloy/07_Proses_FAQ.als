/*
 * FILE: 07_Proses_FAQ.als
 * DESKRIPSI: Proses manajemen FAQ
 * KELOMPOK: Web_PPN
 */

-- ENTITAS DASAR
abstract sig StatusAktif {}
one sig UserAktif, UserNonAktif extends StatusAktif {}

abstract sig StatusTampil {}
one sig Ditampilkan, Disembunyikan extends StatusTampil {}

-- PENGGUNA
abstract sig Pengguna {
    status: one StatusAktif
}
sig Admin extends Pengguna {}

-- FAQ
sig FAQ {
    statusFAQ: one StatusTampil,
    dibuatOleh: one Admin
}

sig SistemFAQ {
    daftarFAQ: set FAQ,
    daftarAdmin: set Admin
}

-- ===================
-- PROSES: TAMBAH FAQ
-- ===================
pred tambahFAQ[s: SistemFAQ, s2: SistemFAQ, f: FAQ, admin: Admin] {
    -- Precondition
    admin in s.daftarAdmin
    f not in s.daftarFAQ
    f.dibuatOleh = admin
    -- Postcondition
    s2.daftarFAQ = s.daftarFAQ + f
    s2.daftarAdmin = s.daftarAdmin
}

-- ===================
-- PROSES: TAMPILKAN FAQ
-- ===================
pred tampilkanFAQ[f: FAQ, f2: FAQ] {
    f.statusFAQ = Disembunyikan
    f2.statusFAQ = Ditampilkan
    f2.dibuatOleh = f.dibuatOleh
}

-- ===================
-- PROSES: SEMBUNYIKAN FAQ
-- ===================
pred sembunyikanFAQ[f: FAQ, f2: FAQ] {
    f.statusFAQ = Ditampilkan
    f2.statusFAQ = Disembunyikan
    f2.dibuatOleh = f.dibuatOleh
}

-- ===================
-- PROSES: HAPUS FAQ
-- ===================
pred hapusFAQ[s: SistemFAQ, s2: SistemFAQ, f: FAQ] {
    -- Precondition
    f in s.daftarFAQ
    -- Postcondition
    s2.daftarFAQ = s.daftarFAQ - f
    s2.daftarAdmin = s.daftarAdmin
}

-- ASSERTION
assert TambahFAQBerhasil {
    all s: SistemFAQ, s2: SistemFAQ, f: FAQ, a: Admin |
        tambahFAQ[s, s2, f, a] implies f in s2.daftarFAQ
}

assert HapusFAQBerhasil {
    all s: SistemFAQ, s2: SistemFAQ, f: FAQ |
        hapusFAQ[s, s2, f] implies f not in s2.daftarFAQ
}

-- RUN COMMANDS
run TampilkanFAQ {
    some f: FAQ | f.statusFAQ = Ditampilkan
    some f: FAQ | f.statusFAQ = Disembunyikan
} for 5

run ProsesTambahFAQ {
    some s: SistemFAQ, s2: SistemFAQ, f: FAQ, a: Admin |
        tambahFAQ[s, s2, f, a]
} for 4

run ProsesHapusFAQ {
    some s: SistemFAQ, s2: SistemFAQ, f: FAQ |
        hapusFAQ[s, s2, f]
} for 4

-- CHECK
check TambahFAQBerhasil for 5
check HapusFAQBerhasil for 5
