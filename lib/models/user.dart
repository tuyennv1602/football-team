class User {
   int id;
  String userName;
  Null avatar;
  String email;
  Null phoneNUmber;
  int createDate;
  // List<Null> roleList;
  // List<Null> groupList;

  User(
      {this.id,
      this.userName,
      this.avatar,
      this.email,
      this.phoneNUmber,
      this.createDate,
      // this.roleList,
      // this.groupList
      });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    avatar = json['avatar'];
    email = json['email'];
    phoneNUmber = json['phoneNUmber'];
    createDate = json['createDate'];
    // if (json['roleList'] != null) {
    //   roleList = new List<Null>();
    //   json['roleList'].forEach((v) {
    //     roleList.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['groupList'] != null) {
    //   groupList = new List<Null>();
    //   json['groupList'].forEach((v) {
    //     groupList.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    data['phoneNUmber'] = this.phoneNUmber;
    data['createDate'] = this.createDate;
    // if (this.roleList != null) {
    //   data['roleList'] = this.roleList.map((v) => v.toJson()).toList();
    // }
    // if (this.groupList != null) {
    //   data['groupList'] = this.groupList.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}