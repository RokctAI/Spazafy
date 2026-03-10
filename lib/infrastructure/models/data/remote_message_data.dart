

class RemoteMessageData{
  final String? id;
  final String? status;
  RemoteMessageData({this.id, this.status});

  factory RemoteMessageData.fromJson( Map data){
    return RemoteMessageData(
      id: data["id"]?.toString(),
      status: data["status"]
    );
  }

}
