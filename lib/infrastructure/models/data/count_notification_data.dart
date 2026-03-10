
class CountNotificationModel {
    String? notification;
    String? transaction;

    CountNotificationModel({
        this.notification,
        this.transaction,
    });

    CountNotificationModel copyWith({
        String? notification,
        String? transaction,
    }) => 
        CountNotificationModel(
            notification: notification ?? this.notification,
            transaction: transaction ?? this.transaction,
        );

    factory CountNotificationModel.fromJson(Map<String, dynamic> json) => CountNotificationModel(
        notification: json["notification"]?.toString(),
        transaction: json["transaction"]?.toString(),
    );

    Map<String, dynamic> toJson() => {
        "notification": notification,
        "transaction": transaction,
    };
}
