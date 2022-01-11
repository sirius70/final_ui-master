class FeedModel {
  String feed;
  String stationId;
  String uid;
  String userName;

  FeedModel({this.feed, this.stationId, this.uid, this.userName});
  factory FeedModel.fromMap(map){
    return FeedModel(
        uid: map['uid'],
        feed: map['feed'],
        stationId: map['stationId'],
        userName: map['userName'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'uid': uid,
      'feed': feed,
      'stationId': stationId,
      'userName': userName,
    };
  }

}

