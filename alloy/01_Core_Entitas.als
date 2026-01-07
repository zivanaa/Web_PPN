/*
 * FILE: 01_Core_Entitas.als
 * DESKRIPSI: Definisi entitas dasar sistem Web_PPN
 * KELOMPOK: Web_PPN
 */

-- ENTITAS DASAR
sig Waktu {}
sig Nominal {}

-- STATUS PENGGUNA
abstract sig StatusAktif {}
one sig UserAktif, UserNonAktif extends StatusAktif {}

-- KATEGORI PRODUK
abstract sig KategoriProduk {}
one sig PupukCair, PupukPadat, ObatTanaman, KategoriLain extends KategoriProduk {}

-- ATRIBUT PRODUK
abstract sig AtributProduk {}
one sig Baru, Laris, Promo, Bonus, Habis extends AtributProduk {}

-- STATUS PRODUK
abstract sig StatusProduk {}
one sig Dipajang, ProdukAktif, ProdukNonAktif extends StatusProduk {}

-- STATUS DISKON
abstract sig StatusDiskon {}
one sig Direncanakan, Berjalan, Selesai extends StatusDiskon {}

-- METODE PEMBAYARAN
abstract sig MetodePembayaran {}
one sig Cash, DownPayment, Cicilan1Minggu, Cicilan1Bulan extends MetodePembayaran {}

-- STATUS PEMBAYARAN
abstract sig StatusPembayaran {}
one sig Lunas, BelumLunas extends StatusPembayaran {}

-- STATUS TAMPIL
abstract sig StatusTampil {}
one sig Ditampilkan, Disembunyikan extends StatusTampil {}

-- PENGGUNA
abstract sig Pengguna {
    status: one StatusAktif
}
sig Admin extends Pengguna {}
sig Pelanggan extends Pengguna {}
sig Koordinator extends Pengguna {}
sig Marketing extends Pengguna {}
sig Presenter extends Pengguna {}

-- PRODUK
sig Produk {
    kategori: one KategoriProduk,
    harga: one Nominal,
    atribut: set AtributProduk,
    statusProduk: one StatusProduk,
    tanggalDibuat: one Waktu
}

-- DISKON
sig Diskon {
    tanggalMulai: one Waktu,
    tanggalSelesai: one Waktu,
    statusDiskon: one StatusDiskon,
    produkDiskon: one Produk
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

-- TESTIMONI
sig Testimoni {
    pelanggan: one Pelanggan,
    produkDireview: one Produk,
    tanggalUlasan: one Waktu,
    statusTampil: one StatusTampil,
    dikelolahOleh: one Admin
}

-- GALERI
sig Galeri {
    tanggalUpload: one Waktu,
    statusGaleri: one StatusTampil,
    diuploadOleh: one Admin
}

-- FAQ
sig FAQ {
    statusFAQ: one StatusTampil,
    dibuatOleh: one Admin
}

-- STATE SISTEM
sig SistemPPN {
    daftarProduk: set Produk,
    daftarTransaksi: set Transaksi,
    daftarDiskon: set Diskon,
    daftarTestimoni: set Testimoni,
    daftarGaleri: set Galeri,
    daftarFAQ: set FAQ,
    daftarAdmin: set Admin,
    daftarPelanggan: set Pelanggan
}

-- CONSTRAINT DASAR
fact ItemMilikSatuTransaksi {
    all it: ItemTransaksi | one t: Transaksi | it in t.items
}

-- RUN: Tampilkan entitas dasar
run TampilkanEntitas {
    some Produk
    some Admin
    some Pelanggan
} for 4
