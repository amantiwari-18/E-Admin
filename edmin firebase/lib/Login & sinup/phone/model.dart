class UserModel {
  String? uid;
  String? name;
  String? email;
  String? profilepic;
  String? password;
  String? phone;
  String? designation;
  String? division;
  String? extention;
  String? telephone;
  String? profilePic;


  UserModel({this.uid, this.name, this.email, this.profilePic,this.password, this.phone,
  this.designation,this.division,this.extention,this.telephone  
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    name = map["name"];
    email = map["email"];
    profilepic = map["profilepic"];
    password= map["password"];
    designation= map["designation"];
    phone= map["phone"];
    division= map["division"];
    extention= map["extention"];
    telephone= map["telephone"];
    profilePic=map["profilePic"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "profilepic": profilepic,
       "password":password,
    "designation":designation,
    "phone":phone,
    "division":division,
    "extention":extention,
    "telephone":telephone,
    "profilePic":profilePic
    };
  }
}