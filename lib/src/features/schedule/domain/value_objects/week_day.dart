enum WeekDay { mon, tue, wed, thu, fri, sat, sun }

extension WeekDayLabel on WeekDay {
  String get short {
    switch (this) {
      case WeekDay.mon:
        return "Sen";
      case WeekDay.tue:
        return 'Sel';
      case WeekDay.wed:
        return 'Rab';
      case WeekDay.thu:
        return 'Kam';
      case WeekDay.fri:
        return 'Jum';
      case WeekDay.sat:
        return 'Sab';
      case WeekDay.sun:
        return 'Min';
    }
  }

  String get long {
    switch (this) {
      case WeekDay.mon:
        return 'Senin';
      case WeekDay.tue:
        return 'Selasa';
      case WeekDay.wed:
        return 'Rabu';
      case WeekDay.thu:
        return 'Kamis';
      case WeekDay.fri:
        return 'Jumat';
      case WeekDay.sat:
        return 'Sabtu';
      case WeekDay.sun:
        return 'Minggu';
    }
  }

  // Helper for mapping code to enum
  static WeekDay fromCode(String code) {
    switch (code) {
      case 'mon':
        return WeekDay.mon;
      case 'tue':
        return WeekDay.tue;
      case 'wed':
        return WeekDay.wed;
      case 'thu':
        return WeekDay.thu;
      case 'fri':
        return WeekDay.fri;
      case 'sat':
        return WeekDay.sat;
      case 'sun':
        return WeekDay.sun;
      default:
        throw ArgumentError('Invalid day code: $code');
    }
  }
}
