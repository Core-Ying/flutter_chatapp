
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await Firestore.instance.collection("users")
        .where("name", isEqualTo: username)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }
  getUserByUserEmail(String email) async {
    return await Firestore.instance.collection("users")
        .where("email", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  uploadUserInfo(userMap){
    Firestore.instance.collection("users")
        .add(userMap).catchError((e){
      print(e.toString());
    });
  }

  createChatRoom(String charRoomId,chatRoomMap) {
    Firestore.instance.collection("ChatRoom")
        .document(charRoomId).setData(chatRoomMap).catchError((e) {
      print(e.toString());
    });
  }
  // changePassword (String password)async {
  //   Firestore.instance.collection("users");
  //
  //
  // }
  Future<void> addMessage(String chatRoomId, messageMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e){
      print(e.toString());
    });
  }
  getChats(String chatRoomId) async{
    return Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }
  getUserEmail(String itIsMyemail) async {
    return  Firestore.instance
        .collection("users")
        .where('email', arrayContains: itIsMyemail)
        .snapshots();
  }
  getUserChats(String itIsMyName) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }
  //getChatRooms=getUserChats
  getChatRooms(String userName)async {
    return await Firestore.instance.collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}