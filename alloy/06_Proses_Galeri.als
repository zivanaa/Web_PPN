/*
 * FILE: 06_Proses_Galeri.als
 * DESKRIPSI: Proses manajemen galeri foto
 * KELOMPOK: Web_PPN
 */

-- ENTITAS DASAR
sig Waktu {}

abstract sig StatusAktif {}
one sig UserAktif, UserNonAktif extends StatusAktif {}

abstract sig StatusTampil {}
one sig Ditampilkan, Disembunyikan extends StatusTampil {}

-- PENGGUNA
abstract sig Pengguna {
    status: one StatusAktif
}
sig Admin extends Pengguna {}

-- GALERI
sig Galeri {
    tanggalUpload: one Waktu,
    statusGaleri: one StatusTampil,
    diuploadOleh: one Admin
}

sig SistemGaleri {
    daftarGaleri: set Galeri,
    daftarAdmin: set Admin
}

-- ===================
-- PROSES: UPLOAD GALERI
-- ===================
pred uploadGaleri[s: SistemGaleri, s2: SistemGaleri, g: Galeri, admin: Admin] {
    -- Precondition
    admin in s.daftarAdmin
    g not in s.daftarGaleri
    g.diuploadOleh = admin
    -- Postcondition
    s2.daftarGaleri = s.daftarGaleri + g
    s2.daftarAdmin = s.daftarAdmin
}

-- ===================
-- PROSES: TAMPILKAN GALERI
-- ===================
pred tampilkanGaleri[g: Galeri, g2: Galeri] {
    g.statusGaleri = Disembunyikan
    g2.statusGaleri = Ditampilkan
    g2.tanggalUpload = g.tanggalUpload
    g2.diuploadOleh = g.diuploadOleh
}

-- ===================
-- PROSES: SEMBUNYIKAN GALERI
-- ===================
pred sembunyikanGaleri[g: Galeri, g2: Galeri] {
    g.statusGaleri = Ditampilkan
    g2.statusGaleri = Disembunyikan
    g2.tanggalUpload = g.tanggalUpload
    g2.diuploadOleh = g.diuploadOleh
}

-- ===================
-- PROSES: HAPUS GALERI
-- ===================
pred hapusGaleri[s: SistemGaleri, s2: SistemGaleri, g: Galeri] {
    -- Precondition
    g in s.daftarGaleri
    -- Postcondition
    s2.daftarGaleri = s.daftarGaleri - g
    s2.daftarAdmin = s.daftarAdmin
}

-- ASSERTION
assert UploadGaleriBerhasil {
    all s: SistemGaleri, s2: SistemGaleri, g: Galeri, a: Admin |
        uploadGaleri[s, s2, g, a] implies g in s2.daftarGaleri
}

assert HapusGaleriBerhasil {
    all s: SistemGaleri, s2: SistemGaleri, g: Galeri |
        hapusGaleri[s, s2, g] implies g not in s2.daftarGaleri
}

-- RUN COMMANDS
run TampilkanGaleri {
    some g: Galeri | g.statusGaleri = Ditampilkan
    some g: Galeri | g.statusGaleri = Disembunyikan
} for 5

run ProsesUploadGaleri {
    some s: SistemGaleri, s2: SistemGaleri, g: Galeri, a: Admin |
        uploadGaleri[s, s2, g, a]
} for 4

run ProsesHapusGaleri {
    some s: SistemGaleri, s2: SistemGaleri, g: Galeri |
        hapusGaleri[s, s2, g]
} for 4

-- CHECK
check UploadGaleriBerhasil for 5
check HapusGaleriBerhasil for 5
