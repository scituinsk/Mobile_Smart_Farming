const Map<String, String> idID = {
  // Splash & Loading Screen
  'splash_initializing': 'Memulai...',
  'splash_checking_connection': 'Memeriksa koneksi...',
  'splash_no_internet': 'Tidak ada koneksi internet!',
  'splash_starting_app': 'Memulai aplikasi...',
  'splash_getting_auth': 'Mendapatkan layanan autentikasi...',
  'splash_checking_auth': 'Memeriksa status login...',
  'splash_welcome_back': 'Selamat datang kembali!',
  'splash_please_login': 'Silahkan login...',
  'splash_error_dialog_title': 'Koneksi Bermasalah',
  'splash_error_dialog_message':
      'Tidak dapat terhubung ke server. Pastikan Anda memiliki koneksi internet yang stabil.',
  'splash_error_dialog_retry': 'Coba Lagi',
  'error': 'Galat',
  'loading_devices': 'Memuat perangkat...',

  // Auth - Login & Register
  'login_success': 'Login berhasil',
  'register_success': 'Register berhasil! silahkan login',
  'auth_first_name': 'Nama Depan',
  'auth_first_name_hint': 'Masukkan nama depan anda...',
  'auth_last_name': 'Nama Belakang (opsional)',
  'auth_last_name_hint': 'Masukkan nama belakang anda...',
  'auth_username': 'Username',
  'auth_username_hint': 'Masukkan username anda...',
  'auth_email': 'Alamat Email',
  'auth_email_hint': 'Masukkan alamat email anda...',
  'auth_password': 'Password',
  'auth_password_hint': 'Masukkan password anda...',
  'auth_confirm_password': 'Konfirmasi Password',
  'auth_confirm_password_hint': 'Konfirmasi password anda...',
  'auth_i_agree': 'Saya setuju dengan ',
  'auth_terms_conditions': 'syarat dan ketentuan',
  'auth_already_have_account': 'Sudah punya akun?',
  'auth_login_here': ' Login di sini',
  'auth_registering_btn': 'Mendaftar...',
  'auth_register_btn': 'Daftar',
  'auth_register_title': 'Daftar Akun',
  'auth_register_subtitle': 'Lengkapi data anda untuk membuat akun.',
  'auth_username_email': 'Username atau Email',
  'auth_username_email_hint': 'Masukkan username atau email anda...',
  'auth_dont_have_account': 'Belum punya akun? ',
  'auth_register_link': 'Daftar akun',
  'auth_login_btn': 'Masuk',
  'auth_login_title': 'Masuk Akun',
  'auth_login_subtitle': 'Masukkan email dan password anda.',
  'auth_terms_title': 'Syarat & ketentuan',
  'auth_terms_content': '''
Dengan mengakses dan menggunakan fitur "Irigasi Cerdas" Fitur dalam aplikasi ini, Anda ("Pengguna") dianggap telah membaca, memahami, dan menyetujui seluruh isi dari syarat dan ketentuan di bawah ini.

## 1. Deskripsi Layanan

Fitur "Irigasi Cerdas" adalah sebuah sistem bantu digital yang dirancang untuk memudahkan Pengguna dalam:

* Memantau data kondisi lahan secara real-time, termasuk data suhu dan kelembapan, yang diterima dari perangkat sensor milik Pengguna.
* Mengontrol dan mengatur jadwal penyiraman, termasuk durasi dan frekuensi, dari jarak jauh melalui aplikasi.

Tujuan Fitur ini adalah sebagai alat pendukung dalam upaya menuju pertanian modern yang lebih efisien.

## 2. Ketergantungan pada Perangkat Keras dan Data

* **Akurasi Data:** Fungsi pemantauan real-time ("Pantau suhu, kelembapan, dan air") sepenuhnya bergantung pada akurasi, kalibrasi, dan kondisi operasional perangkat sensor yang dipasang di lahan oleh Pengguna. Kami tidak bertanggung jawab atas ketidakakuratan data yang disebabkan oleh malfungsi, penempatan yang salah, atau kerusakan sensor.
* **Eksekusi Perintah:** Kemampuan Fitur untuk menjalankan kontrol penyiraman ("Kontrol penyiraman jadi simpel banget") bergantung pada konektivitas internet yang stabil dan fungsi normal dari perangkat aktuator (misalnya, katup solenoid atau pompa air) di lahan Pengguna.

## 3. Tanggung Jawab Pengguna

Pengguna bertanggung jawab penuh atas:

* Pemasangan, perawatan, dan fungsionalitas semua perangkat keras yang terhubung ke sistem.
* Pengaturan awal dan penyesuaian jadwal penyiraman ("Atur durasi dan frekuensi").
* Pengguna memahami bahwa sistem hanya menjalankan perintah sesuai dengan konfigurasi yang dimasukkan oleh Pengguna.
''',

  // Validation - Email/Username
  'validation_email_username_required':
      'Email atau username tidak boleh kosong',
  'validation_email_invalid': 'Format email tidak valid',
  'validation_email_required': 'Email tidak boleh kosong',
  'validation_email_format': 'Format email tidak valid',
  'validation_username_required': 'Username tidak boleh kosong',
  'validation_username_min_3_chars': 'Username minimal 3 karakter',
  'validation_username_chars':
      'Username hanya boleh berisi huruf, angka, dan underscore',
  'validation_username_min_length': 'Username minimal 3 karakter',
  'validation_username_invalid_chars':
      'Username hanya boleh berisi huruf, angka, dan underscore',

  // Validation - Password
  'validation_password_required': 'Password tidak boleh kosong',
  'validation_password_min_length': 'Password minimal 6 karakter',
  'validation_password_min_8': 'Password minimal 8 karakter',
  'validation_password_uppercase':
      'Password harus mengandung minimal 1 huruf besar',
  'validation_password_lowercase':
      'Password harus mengandung minimal 1 huruf kecil',
  'validation_password_number': 'Password harus mengandung minimal 1 angka',
  'validation_confirm_password_required':
      'Konfirmasi password tidak boleh kosong',
  'validation_password_mismatch': 'Password tidak cocok',

  // Validation - Name
  'validation_first_name_required': 'Nama tidak boleh kosong',
  'validation_first_name_min_length': 'Nama minimal 2 karakter',
  'validation_name_max_length': 'Nama maksimal 255 karakter',
  'validation_last_name_max_length': 'Nama belakang maksimal 255 karakter',

  // Validation - Date
  'validation_start_date_before_end':
      'Start date harus lebih kecil atau sama dengan end date',
  'validation_end_date_after_start':
      'End date harus lebih besar atau sama dengan start date',

  // History - Screen
  'history_log_title': 'Log Riwayat',
  'history_log_subtitle': 'Catatan aktivitas sistem',
  'history_list_title': 'Daftar Riwayat',
  'search_history_title': 'Cari Riwayat',

  // History - States
  'history_loading': 'Memuat riwayat...',
  'history_empty': 'Riwayat tidak ditemukan atau belum ada',
  'history_refresh': 'Refresh',
  'history_default_name': 'default',
  'history_error_schedule': 'IoT gagal menjalankan penjadwalan',
  'history_error_task': 'IoT gagal menjalankan tugas',
  'history_group_detail': 'Detail Grup',
  'history_finished': 'Selesai',

  // Filter - General
  'filter_title': 'Filter Berdasarkan',
  'filter_select_date': 'Pilih tanggal',
  'filter_select_all': 'Pilih Semua',
  'filter_time_range': 'Rentang Waktu',
  'filter_clear': 'Clear',
  'filter_until': 'sampai',
  'filter_reset': 'Reset',
  'filter_apply': 'Apply',

  // Filter - History Types
  'filter_device_history': 'History Perangkat',
  'filter_schedule_history': 'History Penjadwalan Grup',
  'filter_select_device': 'Pilih Perangkat',
  'filter_select_schedule_group': 'Pilih Grup Penjadwalan',
  'filter_select_device_warning':
      'Pilih Perangkat untuk memilih group penjadwalan!',

  // Sorting
  'sorting_title': 'Urutkan Berdasarkan',
  'sorting_oldest': 'Terlama/Ascending',
  'sorting_newest': 'Terbaru/Descending',

  // Modul - Add Device
  'add_device_title': 'Tambah Perangkat',
  'add_device_subtitle': 'Tambahkan perangkat ke akun ini',
  'device_code_label': 'Kode Perangkat',
  'device_code_hint': 'Ex: 018bd6f8-7d8b-7132-842b-3247e',
  'device_password_label': 'Password Perangkat',
  'device_password_hint': 'Ex: paktani1',
  'button_cancel': 'Batal',
  'button_add_device': 'Tambahkan Perangkat',

  // Modul - Validation
  'validation_code_required': 'Kode modul tidak boleh kosong',
  'validation_code_min_length': 'Kode modul minimal 6 karakter',
  'validation_device_password_required': 'Password tidak boleh kosong',
  'validation_device_password_min_length': 'Password minimal 4 karakter',
  'validation_modul_name_required': 'Nama tidak boleh kosong',
  'validation_modul_name_min_length': 'Nama modul minimal 3 karakter',
  'validation_modul_name_max_length': 'Nama modul maksimal 20 karakter',
  'validation_modul_description_max_length':
      'Nama modul maksimal 1000 karakter',
  'validation_new_password_required': 'Password baru tidak boleh kosong',
  'validation_password_confirm_mismatch': 'Password dan konfirmasi tidak sama',

  // Modul - Success/Error
  'form_invalid_title': 'Form tidak valid',
  'form_invalid_message': 'Periksa kembali kode modul dan password',
  'add_device_success': 'Berhasil menambahkan modul',
  'delete_device_success': 'Berhasil menghapus modul',
  'delete_device_from_user_success': 'berhasil menghapus modul dari user ini',
  'edit_device_success': 'Berhasil mengubah modul',
  'edit_password_success': 'Berhasil mengubah password modul',

  // QR Code
  'qr_code_title': 'QR Code',
  'qr_scan_instruction': 'Silahkan Scan QR Code dibawah ini:',
  'qr_access_message':
      'Orang yang memindai kode ini dengan aplikasi akan langsung mendapatkan akses untuk melihat data dari modul',
  'qr_not_found_title': 'Tidak ditemukan',
  'qr_no_barcode_message': 'Tidak ada QR/Barcode terdeteksi',
  'qr_no_value_message': 'Kode tidak memiliki nilai teks',

  // App Name
  'app_name': 'PakTani',

  // Device Menu
  'device_history_menu': 'Riwayat Perangkat',
  'edit_device_menu': 'Edit Perangkat',
  'delete_device_menu': 'Hapus Perangkat',
  'edit_password_menu': 'Edit password',

  // Edit Device Dialog
  'edit_device_dialog_title': 'Edit Perangkat',
  'device_name_label': 'Nama Perangkat',
  'device_name_hint': 'Ex: Greenhouse A',
  'device_description_label': 'Deskripsi Perangkat',
  'device_description_hint': 'Ex: Greenhouse timur',
  'device_image_label': 'Gambar Perangkat',
  'button_save': 'Simpan',

  // Delete Device Dialog
  'delete_device_dialog_title': 'Hapus Perangkat dari akun?',
  'delete_device_dialog_message':
      'Perangkat ini akan dihapus dari daftar Perangkat di akun ini.',
  'button_delete': 'Hapus',

  // Edit Password Dialog
  'edit_password_dialog_title': 'Edit password',
  'new_password_label': 'Password baru',
  'new_password_hint': 'Ex: PakTani1',
  'confirm_password_label': 'Konfirmasi password',
  'confirm_password_hint': 'Ex: PakTani1',

  // Relay Settings
  'relay_settings_title': 'Pengaturan Relay',
  'relay_settings_subtitle': 'Atur group relay untuk mengatur penjadwalan',
  'relay_group_subtitle': 'Group relay',

  // Weekdays Short
  'weekday_mon_short': 'Sen',
  'weekday_tue_short': 'Sel',
  'weekday_wed_short': 'Rab',
  'weekday_thu_short': 'Kam',
  'weekday_fri_short': 'Jum',
  'weekday_sat_short': 'Sab',
  'weekday_sun_short': 'Min',

  // Weekdays Long
  'weekday_mon_long': 'Senin',
  'weekday_tue_long': 'Selasa',
  'weekday_wed_long': 'Rabu',
  'weekday_thu_long': 'Kamis',
  'weekday_fri_long': 'Jumat',
  'weekday_sat_long': 'Sabtu',
  'weekday_sun_long': 'Minggu',

  // Schedule Status
  'schedule_no_repeat': 'Tidak ada pengulangan',
  'schedule_every_day': 'Setiap hari',

  // Device List
  'device_list_title': 'Daftar Perangkat',
  'device_list_loading': 'Memuat Perangkat...',
  'device_list_empty': 'Tidak ada perangkat yang ditemukan',
  'device_list_refresh': 'Refresh',

  // Device Locked
  'device_locked_title': 'Perangkat terkunci',
  'device_locked_message':
      'Masukkan ulang password Perangkat yang baru untuk mengakses Perangkat!',

  // Locked Dialog
  'locked_dialog_warning_title': 'Peringatan!',
  'locked_dialog_password_changed': 'Password telah diubah!',
  'locked_dialog_message':
      'Silahkan ubah password terlebih dahulu untuk dapat mengakses modul atau hapus modul dari akun ini.',
  'locked_dialog_delete_button': 'Hapus Modul',
  'locked_dialog_readd_button': 'Tambahkan Ulang',

  // Notification
  'notification_title': 'Notifikasi',
  'notification_filter_all': 'Semua',
  'notification_filter_unread': 'Belum Dibaca',
  'notification_mark_all_read': 'Tandai semua dibaca',
  'notification_list_title': 'Semua Notifikasi',
  'notification_loading': 'Memuat riwayat notifikasi...',
  'notification_empty_unread': 'Tidak ada notifikasi yang belum dibaca',
  'notification_empty_all': 'Tidak ada notifikasi',
  'notification_refresh': 'Refresh',

  // Onboarding
  'onboard_1_title': 'Irigasi Cerdas di Tangan Kamu',
  'onboard_1_subtitle':
      'Kontrol penyiraman jadi simpel banget. Mulai langkah baru menuju pertanian modern dari genggamanmu.',
  'onboard_2_title': 'Jadwal Penyiraman Tanpa Ribet',
  'onboard_2_subtitle':
      'Atur durasi dan frekuensi sesuai kebutuhan. Tanaman selalu segar, kamu jadi lebih tenang.',
  'onboard_3_title': 'Data Lahan,\nReal Time!',
  'onboard_3_subtitle':
      'Pantau suhu, kelembapan, dan air langsung dari HP. Biar lahanmu selalu siap hasilin panen terbaik.',
  'onboard_3_button': 'Mulai Aplikasi',

  // Profile - Controller
  'logout_success': 'Logout berhasil',
  'edit_profile_success': 'Berhasil mengubah profile!',
  'edit_photo_success': 'Berhasil mengubah photo profile',

  // Profile - Screen
  'profile_title': 'Profile',
  'change_language': 'Ganti Bahasa',
  'profile_tab_personal': 'Informasi Pribadi',
  'profile_tab_contact': 'Hubungi Kami',

  // Profile -Widgets
  'contact_organization_name': 'SCIT UIN Sunan Kalijaga',
  'profile_first_name_label': 'Nama depan',
  'profile_first_name_hint': 'Masukkan nama depan',
  'profile_last_name_label': 'Nama belakang',
  'profile_last_name_hint': 'Masukkan nama belakang',
  'profile_save_button': 'Simpan Perubahan',

  // Profile -Logout Dialog
  'logout_dialog_title': 'Keluar dari akun ini?',
  'logout_dialog_message':
      'Kamu akan keluar dari akun ini dan harus login ulang untuk mengakses aplikasi lagi.\nYakin keluar akun?',
  'logout_dialog_confirm': 'Keluar',

  // Relay - Controller Errors
  'relay_error_no_device': 'Tidak ada Perangkat yang dipilih',
  'relay_error_device_not_found': 'Perangkat tidak ditemukan',
  'relay_form_invalid_message': 'Periksa kembali nama RelayGroup',
  'relay_form_invalid_check': 'Periksa kembali form',

  // Relay - Controller Success
  'relay_add_group_success': 'Berhasil menambahkan RelayGroup',
  'relay_edit_group_success': 'Berhasil mengubah nama grub relay',
  'relay_edit_success': 'Berhasil mengubah relay',
  'relay_delete_group_success': 'Berhasil menghapus grub relay',
  'relay_move_failed': 'Gagal memindahkan relay',

  // Relay - Controller Validation
  'validation_relay_group_name_required': 'Nama Group tidak boleh kosong',
  'validation_relay_group_name_min': 'Nama Group minimal 2 karakter',
  'validation_relay_group_name_max': 'Nama Group maksimal 20 karakter',
  'validation_relay_name_required': 'Nama Relay tidak boleh kosong',
  'validation_relay_name_min': 'Nama Relay minimal 2 karakter',
  'validation_relay_name_max': 'Nama Relay maksimal 20 karakter',

  // Relay - Screen
  'relay_title': 'Grub Relay',
  'relay_subtitle': 'Atur group saklar perangkat irigasi',

  // Relay - Group List
  'relay_ungrouped_title': 'Relay Belum Dikelompokkan',
  'relay_group_empty': 'Tidak ada relay di group ini',
  'relay_group_label': 'Group',
  'relay_list_empty': 'Tidak ada relay',
  'relay_must_be_in_group': 'Relay harus diletakkan di group!',

  // Relay - Modals
  'relay_add_group_title': 'Tambah Grub Baru',
  'relay_edit_group_title': 'Ubah Nama Grub',
  'relay_edit_relay_title': 'Ubah Relay',
  'relay_group_name_label': 'Nama Grub',
  'relay_group_name_hint': 'Ex: GreenH 1',
  'relay_name_label': 'Nama Relay',
  'relay_name_hint': 'Ex: Solenoid 1',
  'relay_description_label': 'Deskripsi Relay',
  'relay_description_hint': 'Masukkan Deskripsi',
  'relay_delete_group_title': 'Hapus Grub ini?',
  'relay_delete_group_message': 'Grub ini akan dihapus dari daftar relay.',

  // Relay - Menu Sheet
  'relay_menu_title': 'Pilih Menu Edit',
  'relay_menu_edit_group': 'Edit Group',
  'relay_menu_edit_relay': 'Edit Relay',

  // Schedule - Controller
  'error_group_not_found': 'Group yang dipilih tidak ada!',
  'error_device_not_found': 'Perangkat yang dipilih tidak ada!',
  'error_form_invalid': 'Form tidak valid. Periksa kembali input Anda.',
  'success_set_normal_mode': 'Berhasil set mode normal',
  'success_set_sequential_mode': 'Berhasil set mode sequential @val',
  'error_time_not_selected': 'Waktu belum dipilih',
  'error_day_not_selected': 'Pilih minimal 1 hari',
  'success_schedule_added': 'Jadwal ditambahkan',
  'success_schedule_updated': 'Jadwal diperbarui',
  'success_schedule_deleted': 'Berhasil menghapus schedule',
  'ws_error_connection': 'Koneksi websocket tidak tersedia.',
  'ws_error_send': 'Gagal mengirim ke websocket: @error',
  'error_no_relay_in_group': 'Tidak ada relay dalam group ini.',
  'success_turn_on_all': 'Berhasil menyalakan semua relay dalam group',
  'success_turn_off_all': 'Berhasil mematikan semua relay dalam group',

  // Schedule - Validation
  'val_seq_empty': 'Jumlah Sequential tidak boleh kosong',
  'val_seq_min': 'Jumlah Sequential minimal 1',
  'val_seq_max': 'Harus kurang dari jumlah total solenoid',
  'val_dur_empty': 'Durasi penyiraman tidak boleh kosong',
  'val_dur_invalid': 'Harap masukkan angka yang valid.',
  'val_dur_min': 'Durasi tidak boleh kurang dari 1.',
  'val_dur_max': 'Durasi tidak boleh lebih dari 720.',

  // Schedule - Screen
  'schedule_subtitle': 'Atur penjadwalan grup',

  // Schedule - Schedule Information Widget
  'schedule_mode_sequential': 'Mode Sequential',
  'schedule_mode_normal': 'Mode Normal',
  'schedule_mode_status_description': 'Status mode penjadwalan sistem',
  'schedule_set_mode_button': 'Atur Mode',
  'schedule_relay_count_title': 'Jumlah Relay',
  'schedule_relay_count_description': 'Jumlah relay pada grup',

  // Schedule - Add/Edit Schedule Sheet
  'schedule_add_title': 'Tambah Penjadwalan',
  'schedule_edit_title': 'Ubah Penjadwalan',
  'schedule_time_label': 'Waktu Penjadwalan',
  'schedule_pick_time_button': 'Pilih Waktu',
  'schedule_duration_label': 'Durasi penyiraman',
  'schedule_duration_hint': 'Masukkan durasi (menit)',
  'schedule_repeat_label': 'Ulangi penyiraman',
  'schedule_all_button': 'Semua',
  'schedule_reset_button': 'Reset',

  // Schedule - Delete Dialog
  'schedule_delete_title': 'Hapus Schedule ini?',
  'schedule_delete_message': 'Schedule ini akan dihapus.',

  // Schedule - Schedule Item
  'schedule_duration_prefix': 'Durasi',
  'schedule_duration_suffix': 'menit',

  // Schedule - Schedule List
  'schedule_list_title': 'Daftar Penjadwalan',
  'schedule_list_empty': 'Tekan + untuk menambahkan jadwal irigasi baru',

  // Schedule - Solenoid Emergency Dialog
  'solenoid_emergency_title': 'Peringatan!',
  'solenoid_emergency_subtitle':
      'Fitur ini digunakan untuk keadaan darurat atau untuk percobaan/testing!',
  'solenoid_emergency_message':
      'Pilih aktifkan atau non-aktifkan semua solenoid dalam group ini.',
  'solenoid_emergency_deactivate': 'Non-aktif',
  'solenoid_emergency_activate': 'Aktif',

  // Schedule - Solenoid List
  'solenoid_list_title': 'Status Relay',
  'solenoid_list_empty': 'Tidak ada relay di group ini',

  // Schedule - Solenoid Setting Sheet
  'solenoid_setting_title': 'Total Solenoid',
  'solenoid_setting_choose_label': 'Pilih Penjadwalan',
  'solenoid_setting_sequential': 'Bergantian',
  'solenoid_setting_simultaneous': 'Bersamaan',
  'solenoid_setting_count_label': 'Atur Jumlah Solenoid',
  'solenoid_setting_count_hint': 'Masukkan durasi',

  // Schedule - Solenoid Status Chip
  'solenoid_status_active': 'Aktif',
  'solenoid_status_inactive': 'Tidak Aktif',
};
