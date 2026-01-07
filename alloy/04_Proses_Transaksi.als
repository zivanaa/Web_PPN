/*
 * FILE: 04_Proses_Transaksi.als
 * DESKRIPSI: Proses transaksi penjualan (Logbook)
 * KELOMPOK: Web_PPN
 */

-- ENTITAS DASAR
sig Waktu {}
sig Nominal {}

abstract sig StatusAktif {}
one sig UserAktif, UserNonAktif extends StatusAktif {}

abstract sig MetodePembayaran {}
one sig Cash, DownPayment, Cicilan1Minggu, Cicilan1Bulan extends MetodePembayaran {}

abstract sig StatusPembayaran {}
one sig Lunas, BelumLunas extends StatusPembayaran {}

-- PENGGUNA
abstract sig Pengguna {
    status: one StatusAktif
}
sig Admin extends Pengguna {}
sig Koordinator extends Pengguna {}
sig Marketing extends Pengguna {}
sig Presenter extends Pengguna {}

-- PRODUK
sig Produk {
    harga: one Nominal
}

-- ITEM TRANSAKSI
sig ItemTransaksi {
    produk: one Produk,
    hargaSatuan: one Nominal,
    subtotal: one Nominal
}

-- TRANSAKSI
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

sig SistemTransaksi {
    daftarProduk: set Produk,
    daftarTransaksi: set Transaksi,
    daftarAdmin: set Admin
}

-- CONSTRAINT
fact ItemMilikSatuTransaksi {
    all it: ItemTransaksi | one t: Transaksi | it in t.items
}

fact TransaksiLunasValid {
    all t: Transaksi | t.statusPembayaran = Lunas implies t.jumlahDibayar = t.totalBayar
}

-- ===================
-- PROSES: BUAT TRANSAKSI BARU
-- ===================
pred buatTransaksi[s: SistemTransaksi, s2: SistemTransaksi, t: Transaksi, admin: Admin] {
    -- Precondition
    admin in s.daftarAdmin
    t not in s.daftarTransaksi
    all it: t.items | it.produk in s.daftarProduk
    t.dibuatOleh = admin
    t.statusPembayaran = BelumLunas
    -- Postcondition
    s2.daftarTransaksi = s.daftarTransaksi + t
    s2.daftarProduk = s.daftarProduk
    s2.daftarAdmin = s.daftarAdmin
}

-- ===================
-- PROSES: TANDAI LUNAS
-- ===================
pred tandaiLunas[t: Transaksi, t2: Transaksi] {
    -- Precondition: belum lunas
    t.statusPembayaran = BelumLunas
    -- Postcondition: jadi lunas
    t2.statusPembayaran = Lunas
    t2.jumlahDibayar = t.totalBayar
    t2.tanggalTransaksi = t.tanggalTransaksi
    t2.koordinator = t.koordinator
    t2.items = t.items
    t2.metodePembayaran = t.metodePembayaran
    t2.totalBayar = t.totalBayar
    t2.dibuatOleh = t.dibuatOleh
}

-- ===================
-- PROSES: PROSES PEMBAYARAN CICILAN
-- ===================
pred prosesPembayaran[t: Transaksi, t2: Transaksi] {
    -- Precondition: belum lunas, metode cicilan
    t.statusPembayaran = BelumLunas
    t.metodePembayaran in Cicilan1Minggu + Cicilan1Bulan
    -- Postcondition: jumlah dibayar bertambah
    t2.tanggalTransaksi = t.tanggalTransaksi
    t2.koordinator = t.koordinator
    t2.items = t.items
    t2.metodePembayaran = t.metodePembayaran
    t2.totalBayar = t.totalBayar
    t2.dibuatOleh = t.dibuatOleh
}

-- ASSERTION
assert TransaksiLunasBerhasil {
    all t: Transaksi, t2: Transaksi |
        tandaiLunas[t, t2] implies t2.statusPembayaran = Lunas
}

-- RUN COMMANDS
run TampilkanTransaksi {
    some t: Transaksi | t.statusPembayaran = Lunas
    some t: Transaksi | t.statusPembayaran = BelumLunas
} for 5

run TampilkanMetodePembayaran {
    some t: Transaksi | t.metodePembayaran = Cash
    some t: Transaksi | t.metodePembayaran = DownPayment
    some t: Transaksi | t.metodePembayaran = Cicilan1Bulan
} for 5

run ProsesBuatTransaksi {
    some s: SistemTransaksi, s2: SistemTransaksi, t: Transaksi, a: Admin |
        buatTransaksi[s, s2, t, a]
} for 5

run ProsesTandaiLunas {
    some t: Transaksi, t2: Transaksi | tandaiLunas[t, t2]
} for 4

-- CHECK
check TransaksiLunasBerhasil for 5
