import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 사용자 정보 저장
  Future<void> saveUserData(
      String userId, String id, String email, String birthdate) async {
    try {
      await _firestore.collection('users').doc(userId as String?).set({
        'id': id,
        'email': email,
        'birthdate': birthdate,
        'isConnected': false, // 초기 연결 상태
      });
      print("회원가입 성공");
    } catch (e) {
      print("회원가입 실패: $e");
    }
  }

  // 아이디로 이메일 찾기
  Future<String?> getEmailFromUserId(String userId) async {
    try {
      QuerySnapshot result = await _firestore
          .collection('users')
          .where('id', isEqualTo: userId)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        return result.docs.first['email']; // 이메일 반환
      } else {
        return null; // 아이디가 존재하지 않음
      }
    } catch (e) {
      print("이메일 찾기 실패: $e");
      return null;
    }
  }

  // 이메일 중복 검사
  Future<bool> isEmailDuplicate(String email) async {
    final QuerySnapshot result = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty;
  }

  // 아이디 중복 검사
  Future<bool> isIdDuplicate(String id) async {
    final QuerySnapshot result =
        await _firestore.collection('users').where('id', isEqualTo: id).get();
    return result.docs.isNotEmpty;
  }

  // 커플 연결 여부 확인
  Future<bool> checkConnection(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc['isConnected'] == true;
      }
    } catch (e) {
      print("커플 연결 상태 확인 실패: $e");
    }
    return false;
  }
}
