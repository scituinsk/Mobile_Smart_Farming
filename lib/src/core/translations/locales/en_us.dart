const Map<String, String> enUS = {
  // Splash & Loading Screen
  'loading_devices': 'Loading devices...',
  'splash_initializing': 'Initializing...',
  'splash_checking_connection': 'Checking connection...',
  'splash_no_internet': 'No internet connection!',
  'splash_starting_app': 'Starting app...',
  'splash_getting_auth': 'Getting auth service...',
  'splash_checking_auth': 'Checking authentication...',
  'splash_welcome_back': 'Welcome back!',
  'splash_please_login': 'Please login...',
  'splash_error_dialog_title': 'Connection Issue',
  'splash_error_dialog_message':
      'Unable to connect to server. Please ensure you have a stable internet connection.',
  'splash_error_dialog_retry': 'Retry',
  'error': 'Error',

  // Auth - Login & Register
  'login_success': 'Login successful',
  'register_success': 'Registration successful! Please login',
  'auth_first_name': 'First Name',
  'auth_first_name_hint': 'Enter your first name...',
  'auth_last_name': 'Last Name (optional)',
  'auth_last_name_hint': 'Enter your last name...',
  'auth_username': 'Username',
  'auth_username_hint': 'Enter your username...',
  'auth_email': 'Email Address',
  'auth_email_hint': 'Enter your email address...',
  'auth_password': 'Password',
  'auth_password_hint': 'Enter your password...',
  'auth_confirm_password': 'Confirm Password',
  'auth_confirm_password_hint': 'Confirm your password...',
  'auth_i_agree': 'I agree with ',
  'auth_terms_conditions': 'terms and conditions',
  'auth_already_have_account': 'Already have an account?',
  'auth_login_here': ' Login here',
  'auth_registering_btn': 'Registering...',
  'auth_register_btn': 'Register',
  'auth_register_title': 'Register Account',
  'auth_register_subtitle': 'Complete your data to create an account.',
  'auth_username_email': 'Username or Email',
  'auth_username_email_hint': 'Enter your username or email...',
  'auth_dont_have_account': 'Don\'t have an account? ',
  'auth_register_link': 'Register account',
  'auth_login_btn': 'Login',
  'auth_login_title': 'Login Account',
  'auth_login_subtitle': 'Enter your email and password.',
  'auth_terms_title': 'Terms & Conditions',
  'auth_terms_content': '''
By accessing and using the "Smart Irrigation" Feature in this application, You ("User") are considered to have read, understood, and agreed to all the contents of the terms and conditions below.

## 1. Service Description

The "Smart Irrigation" feature is a digital support system designed to make it easier for Users to:

* Monitor land condition data in real-time, including temperature and humidity data, received from User-owned sensor devices.
* Control and adjust watering schedules, including duration and frequency, remotely through the application.

The purpose of this Feature is as a support tool in efforts toward more efficient modern agriculture.

## 2. Dependence on Hardware and Data

* **Data Accuracy:** The real-time monitoring function ("Monitor temperature, humidity, and water") depends entirely on the accuracy, calibration, and operational condition of the sensor devices installed on the land by the User. We are not responsible for data inaccuracies caused by malfunction, wrong placement, or sensor damage.
* **Command Execution:** The Feature's ability to run irrigation control ("Irrigation control becomes very simple") depends on stable internet connectivity and the normal function of actuator devices (e.g., solenoid valves or water pumps) on the User's land.

## 3. User Responsibility

The User is fully responsible for:

* Installation, maintenance, and functionality of all hardware connected to the system.
* Initial setup and adjustment of irrigation schedules ("Set duration and frequency").
* The User understands that the system only executes commands according to the configuration entered by the User.
''',

  // Validation - Email/Username
  'validation_email_username_required': 'Email or username is required',
  'validation_email_invalid': 'Invalid email format',
  'validation_email_required': 'Email is required',
  'validation_email_format': 'Invalid email format',
  'validation_username_required': 'Username is required',
  'validation_username_min_3_chars': 'Username must be at least 3 characters',
  'validation_username_chars':
      'Username can only contain letters, numbers, and underscores',
  'validation_username_min_length': 'Username must be at least 3 characters',
  'validation_username_invalid_chars':
      'Username can only contain letters, numbers, and underscores',

  // Validation - Password
  'validation_password_required': 'Password is required',
  'validation_password_min_length': 'Password must be at least 6 characters',
  'validation_password_min_8': 'Password must be at least 8 characters',
  'validation_password_uppercase':
      'Password must contain at least 1 uppercase letter',
  'validation_password_lowercase':
      'Password must contain at least 1 lowercase letter',
  'validation_password_number': 'Password must contain at least 1 number',
  'validation_confirm_password_required': 'Password confirmation is required',
  'validation_password_mismatch': 'Passwords do not match',

  // Validation - Name
  'validation_first_name_required': 'First name is required',
  'validation_first_name_min_length':
      'First name must be at least 2 characters',
  'validation_name_max_length': 'Name must not exceed 255 characters',
  'validation_last_name_max_length': 'Last name cannot exceed 255 characters',

  // Validation - Date
  'validation_start_date_before_end':
      'Start date must be less than or equal to end date',
  'validation_end_date_after_start':
      'End date must be greater than or equal to start date',

  // History - Screen
  'history_log_title': 'History Log',
  'history_log_subtitle': 'System activity records',
  'history_list_title': 'History List',
  'search_history_title': 'Search History',

  // History - States
  'history_loading': 'Loading history...',
  'history_empty': 'No history found',
  'history_refresh': 'Refresh',
  'history_default_name': 'default',
  'history_error_schedule': 'IoT failed to execute schedule',
  'history_error_task': 'IoT failed to execute task',
  'history_group_detail': 'Group Details',
  'history_finished': 'Finished',

  // Filter - General
  'filter_title': 'Filter By',
  'filter_select_date': 'Select date',
  'filter_select_all': 'Select All',
  'filter_time_range': 'Time Range',
  'filter_clear': 'Clear',
  'filter_until': 'to',
  'filter_reset': 'Reset',
  'filter_apply': 'Apply',

  // Filter - History Types
  'filter_device_history': 'Device History',
  'filter_schedule_history': 'Schedule Group History',
  'filter_select_device': 'Select Device',
  'filter_select_schedule_group': 'Select Schedule Group',
  'filter_select_device_warning': 'Select a device to choose schedule groups!',

  // Sorting
  'sorting_title': 'Sort By',
  'sorting_oldest': 'Oldest/Ascending',
  'sorting_newest': 'Newest/Descending',

  // Modul - Add Device
  'add_device_title': 'Add Device',
  'add_device_subtitle': 'Add device to this account',
  'device_code_label': 'Device Code',
  'device_code_hint': 'Ex: 018bd6f8-7d8b-7132-842b-3247e',
  'device_password_label': 'Device Password',
  'device_password_hint': 'Ex: paktani1',
  'button_cancel': 'Cancel',
  'button_add_device': 'Add Device',

  // Modul - Validation
  'validation_code_required': 'Module code is required',
  'validation_code_min_length': 'Module code must be at least 6 characters',
  'validation_device_password_required': 'Password is required',
  'validation_device_password_min_length':
      'Password must be at least 4 characters',
  'validation_modul_name_required': 'Name is required',
  'validation_modul_name_min_length':
      'Module name must be at least 3 characters',
  'validation_modul_name_max_length':
      'Module name must not exceed 20 characters',
  'validation_modul_description_max_length':
      'Module description must not exceed 1000 characters',
  'validation_new_password_required': 'New password is required',
  'validation_password_confirm_mismatch':
      'Password and confirmation do not match',

  // Modul - Success/Error
  'form_invalid_title': 'Invalid Form',
  'form_invalid_message': 'Please check module code and password',
  'add_device_success': 'Device added successfully',
  'delete_device_success': 'Device deleted successfully',
  'delete_device_from_user_success':
      'Successfully removed device from this user',
  'edit_device_success': 'Device updated successfully',
  'edit_password_success': 'Device password updated successfully',

  // QR Code
  'qr_code_title': 'QR Code',
  'qr_scan_instruction': 'Please scan the QR Code below:',
  'qr_access_message':
      'Anyone who scans this code with the app will immediately gain access to view data from the module',
  'qr_not_found_title': 'Not Found',
  'qr_no_barcode_message': 'No QR/Barcode detected',
  'qr_no_value_message': 'Code has no text value',

  // App Name
  'app_name': 'PakTani',

  // Device Menu
  'device_history_menu': 'Device History',
  'edit_device_menu': 'Edit Device',
  'delete_device_menu': 'Delete Device',
  'edit_password_menu': 'Edit password',

  // Edit Device Dialog
  'edit_device_dialog_title': 'Edit Device',
  'device_name_label': 'Device Name',
  'device_name_hint': 'Ex: Greenhouse A',
  'device_description_label': 'Device Description',
  'device_description_hint': 'Ex: East greenhouse',
  'device_image_label': 'Device Image',
  'button_save': 'Save',

  // Delete Device Dialog
  'delete_device_dialog_title': 'Delete device from account?',
  'delete_device_dialog_message':
      'This device will be removed from the device list in this account.',
  'button_delete': 'Delete',

  // Edit Password Dialog
  'edit_password_dialog_title': 'Edit password',
  'new_password_label': 'New password',
  'new_password_hint': 'Ex: PakTani1',
  'confirm_password_label': 'Confirm password',
  'confirm_password_hint': 'Ex: PakTani1',

  // Relay Settings
  'relay_settings_title': 'Relay Settings',
  'relay_settings_subtitle': 'Set up relay groups for scheduling',
  'relay_group_subtitle': 'Relay group',

  // Weekdays Short
  'weekday_mon_short': 'Mon',
  'weekday_tue_short': 'Tue',
  'weekday_wed_short': 'Wed',
  'weekday_thu_short': 'Thu',
  'weekday_fri_short': 'Fri',
  'weekday_sat_short': 'Sat',
  'weekday_sun_short': 'Sun',

  // Weekdays Long
  'weekday_mon_long': 'Monday',
  'weekday_tue_long': 'Tuesday',
  'weekday_wed_long': 'Wednesday',
  'weekday_thu_long': 'Thursday',
  'weekday_fri_long': 'Friday',
  'weekday_sat_long': 'Saturday',
  'weekday_sun_long': 'Sunday',

  // Schedule Status
  'schedule_no_repeat': 'No repeat',
  'schedule_every_day': 'Every day',

  // Device List
  'device_list_title': 'Device List',
  'device_list_loading': 'Loading devices...',
  'device_list_empty': 'No devices found',
  'device_list_refresh': 'Refresh',

  // Device Locked
  'device_locked_title': 'Device locked',
  'device_locked_message':
      'Re-enter the new device password to access the device!',

  // Locked Dialog
  'locked_dialog_warning_title': 'Warning!',
  'locked_dialog_password_changed': 'Password has been changed!',
  'locked_dialog_message':
      'Please change the password first to access the module or remove the module from this account.',
  'locked_dialog_delete_button': 'Delete Module',
  'locked_dialog_readd_button': 'Add Again',

  // Notification
  'notification_title': 'Notifications',
  'notification_filter_all': 'All',
  'notification_filter_unread': 'Unread',
  'notification_mark_all_read': 'Mark all as read',
  'notification_list_title': 'All Notifications',
  'notification_loading': 'Loading notification history...',
  'notification_empty_unread': 'No unread notifications',
  'notification_empty_all': 'No notifications',
  'notification_refresh': 'Refresh',

  // Onboarding
  'onboard_1_title': 'Smart Irrigation in Your Hands',
  'onboard_1_subtitle':
      'Watering control made super easy. Start a new journey to modern farming from your fingertips.',
  'onboard_2_title': 'Watering Schedule Made Simple',
  'onboard_2_subtitle':
      'Set duration and frequency as needed. Plants stay fresh, you stay relaxed.',
  'onboard_3_title': 'Real-Time\nField Data!',
  'onboard_3_subtitle':
      'Monitor temperature, humidity, and water directly from your phone. Keep your field ready for the best harvest.',
  'onboard_3_button': 'Start App',

  // Profile - Controller
  'logout_success': 'Logout successful',
  'edit_profile_success': 'Profile updated successfully!',
  'edit_photo_success': 'Profile photo updated successfully',

  // Profile - Screen
  'profile_title': 'Profile',
  'change_language': 'Change Language',
  'profile_tab_personal': 'Personal Information',
  'profile_tab_contact': 'Contact Us',

  // Profile - Widgets
  'contact_organization_name': 'SCIT UIN Sunan Kalijaga',
  'profile_first_name_label': 'First name',
  'profile_first_name_hint': 'Enter first name',
  'profile_last_name_label': 'Last name',
  'profile_last_name_hint': 'Enter last name',
  'profile_save_button': 'Save Changes',

  // Profile - Logout Dialog
  'logout_dialog_title': 'Logout from this account?',
  'logout_dialog_message':
      'You will be logged out and need to login again to access the app.\nAre you sure?',
  'logout_dialog_confirm': 'Logout',

  // Relay - Controller Errors
  'relay_error_no_device': 'No device selected',
  'relay_error_device_not_found': 'Device not found',
  'relay_form_invalid_message': 'Please check the RelayGroup name',
  'relay_form_invalid_check': 'Please check the form',

  // Relay - Controller Success
  'relay_add_group_success': 'RelayGroup added successfully',
  'relay_edit_group_success': 'Relay group name updated successfully',
  'relay_edit_success': 'Relay updated successfully',
  'relay_delete_group_success': 'Relay group deleted successfully',
  'relay_move_failed': 'Failed to move relay',

  // Relay - Controller Validation
  'validation_relay_group_name_required': 'Group name is required',
  'validation_relay_group_name_min': 'Group name must be at least 2 characters',
  'validation_relay_group_name_max': 'Group name cannot exceed 20 characters',
  'validation_relay_name_required': 'Relay name is required',
  'validation_relay_name_min': 'Relay name must be at least 2 characters',
  'validation_relay_name_max': 'Relay name cannot exceed 20 characters',

  // Relay - Screen
  'relay_title': 'Relay Groups',
  'relay_subtitle': 'Manage irrigation device switch groups',

  // Relay - Group List
  'relay_ungrouped_title': 'Ungrouped Relays',
  'relay_group_empty': 'No relays in this group',
  'relay_group_label': 'Group',
  'relay_list_empty': 'No relays',
  'relay_must_be_in_group': 'Relay must be placed in a group!',

  // Relay - Modals
  'relay_add_group_title': 'Add New Group',
  'relay_edit_group_title': 'Edit Group Name',
  'relay_edit_relay_title': 'Edit Relay',
  'relay_group_name_label': 'Group Name',
  'relay_group_name_hint': 'Ex: GreenH 1',
  'relay_name_label': 'Relay Name',
  'relay_name_hint': 'Ex: Solenoid 1',
  'relay_description_label': 'Relay Description',
  'relay_description_hint': 'Enter Description',
  'relay_delete_group_title': 'Delete this Group?',
  'relay_delete_group_message':
      'This group will be removed from the relay list.',

  // Relay - Menu Sheet
  'relay_menu_title': 'Select Edit Menu',
  'relay_menu_edit_group': 'Edit Group',
  'relay_menu_edit_relay': 'Edit Relay',

  // Schedule - Controller
  'error_group_not_found': 'Selected group not found!',
  'error_device_not_found': 'Selected device not found!',
  'error_form_invalid': 'Form invalid. Please check your input.',
  'success_set_normal_mode': 'Successfully set to normal mode',
  'success_set_sequential_mode': 'Successfully set sequential mode @val',
  'error_time_not_selected': 'Time not selected',
  'error_day_not_selected': 'Select at least 1 day',
  'success_schedule_added': 'Schedule added',
  'success_schedule_updated': 'Schedule updated',
  'success_schedule_deleted': 'Successfully deleted schedule',
  'ws_error_connection': 'Websocket connection unavailable.',
  'ws_error_send': 'Failed to send to websocket: @error',
  'error_no_relay_in_group': 'No relays in this group.',
  'success_turn_on_all': 'Successfully turned on all relays in group',
  'success_turn_off_all': 'Successfully turned off all relays in group',

  // Schedule - Validation
  'val_seq_empty': 'Sequential count cannot be empty',
  'val_seq_min': 'Sequential count minimum 1',
  'val_seq_max': 'Must be less than total solenoids',
  'val_dur_empty': 'Irrigation duration cannot be empty',
  'val_dur_invalid': 'Please enter a valid number.',
  'val_dur_min': 'Duration cannot be less than 1.',
  'val_dur_max': 'Duration cannot be more than 720.',

  // Schedule - Screen
  'schedule_subtitle': 'Manage group scheduling',

  // Schedule - Schedule Information Widget
  'schedule_mode_sequential': 'Sequential Mode',
  'schedule_mode_normal': 'Normal Mode',
  'schedule_mode_status_description': 'System scheduling mode status',
  'schedule_set_mode_button': 'Set Mode',
  'schedule_relay_count_title': 'Relay Count',
  'schedule_relay_count_description': 'Number of relays in group',

  // Schedule - Add/Edit Schedule Sheet
  'schedule_add_title': 'Add Schedule',
  'schedule_edit_title': 'Edit Schedule',
  'schedule_time_label': 'Schedule Time',
  'schedule_pick_time_button': 'Pick Time',
  'schedule_duration_label': 'Irrigation duration',
  'schedule_duration_hint': 'Enter duration (minutes)',
  'schedule_repeat_label': 'Repeat irrigation',
  'schedule_all_button': 'All',
  'schedule_reset_button': 'Reset',

  // Schedule - Delete Dialog
  'schedule_delete_title': 'Delete this Schedule?',
  'schedule_delete_message': 'This schedule will be deleted.',

  // Schedule - Schedule Item
  'schedule_duration_prefix': 'Duration',
  'schedule_duration_suffix': 'minutes',

  // Schedule - Schedule List
  'schedule_list_title': 'Schedule List',
  'schedule_list_empty': 'Press + to add new irrigation schedule',

  // Schedule - Solenoid Emergency Dialog
  'solenoid_emergency_title': 'Warning!',
  'solenoid_emergency_subtitle':
      'This feature is for emergency or testing purposes!',
  'solenoid_emergency_message':
      'Choose to activate or deactivate all solenoids in this group.',
  'solenoid_emergency_deactivate': 'Deactivate',
  'solenoid_emergency_activate': 'Activate',

  // Schedule - Solenoid List
  'solenoid_list_title': 'Relay Status',
  'solenoid_list_empty': 'No relays in this group',

  // Schedule - Solenoid Setting Sheet
  'solenoid_setting_title': 'Total Solenoid',
  'solenoid_setting_choose_label': 'Choose Scheduling',
  'solenoid_setting_sequential': 'Sequential',
  'solenoid_setting_simultaneous': 'Simultaneous',
  'solenoid_setting_count_label': 'Set Solenoid Count',
  'solenoid_setting_count_hint': 'Enter duration',

  // Schedule - Solenoid Status Chip
  'solenoid_status_active': 'Active',
  'solenoid_status_inactive': 'Inactive',
};
