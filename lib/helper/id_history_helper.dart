class IdHistory {
  final String id;
  final String createdAt;
  final String sharedHash;
  final bool isActive;
  final List<String> cardsArray;
  final List<String> hashArray;
  final String cards;
  final String timeBeforeCorrupt;
  final String firstName;
  final String middleName;
  final String lastName;
  final String nida;
  final String phone;
  final String email;
  final String profile;

  IdHistory(
      {required this.id,
      required this.createdAt,
      required this.profile,
      required this.email,
      required this.isActive,
      required this.lastName,
      required this.cards,
      required this.cardsArray,
      required this.hashArray,
      required this.firstName,
      required this.middleName,
      required this.nida,
      required this.phone,
      required this.sharedHash,
      required this.timeBeforeCorrupt});

  factory IdHistory.fromJson(Map<String, dynamic> json) {
    print("================================");
    return IdHistory(
      id: json['id'],
      isActive: json['active'],
      timeBeforeCorrupt: json['time_before_corrupt'],
      sharedHash: json['shared_hash'],
      createdAt: json['created_at'],
      cardsArray: json['cards'].toString().split("_"),
      hashArray:json['shared_hash'].toString().split("_"),
      email: json['email'],
      cards: json['cards'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      middleName: json['middle_name'],
      nida: json['nida_no'],
      phone: json['phone'],
      profile: json['profile'],
    );
  }
}

class IdHistoryList {
  final List<IdHistory> activeIdHistory;
  final List<IdHistory> inActiveIdHistory;

  IdHistoryList({
    required this.activeIdHistory,
    required this.inActiveIdHistory,
  });
}

class IdHistoryHelper {
  static IdHistoryList filterIdHistory(List<dynamic> tickets) {
    List<IdHistory> activeIdHistory = [];
    List<IdHistory> inActiveIdHistory = [];

    for (var ticket in tickets) {
      IdHistory newIdHistory = IdHistory.fromJson(ticket);
      switch (newIdHistory.isActive) {
        case true:
          activeIdHistory.add(newIdHistory);
          break;
        case false:
          inActiveIdHistory.add(newIdHistory);
          break;
        default:
          break;
      }
    }

    return IdHistoryList(
      inActiveIdHistory: inActiveIdHistory,
      activeIdHistory: activeIdHistory,
    );
  }
}
