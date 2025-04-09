import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/**
 * CoupleService는 커플 관련 Firestore 접근을 담당하는 서비스
 * - 커플 시작 날짜 저장
 * - 커플 문서 ID 조회
 * - 파트너 UID를 통해 문서 연결
 */

class CoupleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 커플 ID 생성 (정렬된 UID 2개를 조합)
  String getCoupleId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return sorted.join("_");
  }

  /// 생성된 커플 아이디 가져오기
  Future<String?> getCurrentCoupleId() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    final uid = currentUser.uid;

    final userDoc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    final partnerUid = userDoc.data()?["partnerUid"];
    if (partnerUid == null) return null;

    return getCoupleId(uid, partnerUid);
  }

  Future<void> setAnniversaryDate(DateTime date) async {
    final coupleId = await getCurrentCoupleId();
    if (coupleId == null) return;

    await FirebaseFirestore.instance
        .collection("couples")
        .doc(coupleId)
        .update({
      "anniversaryDate": date.toIso8601String(),
    });
  }

  Future<DateTime?> getAnniversaryDate() async {
    final coupleId = await getCurrentCoupleId();
    if (coupleId == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection("couples")
        .doc(coupleId)
        .get();

    final isoString = doc.data()?["anniversaryDate"];
    if (isoString == null) return null;

    return DateTime.tryParse(isoString);
  }

  /// 유저의 초대코드를 통해 UID 조회
  Future<String?> getPartnerUidByInviteCode(String inviteCode) async {
    final snapshot = await _firestore
        .collection("users")
        .where("inviteCode", isEqualTo: inviteCode)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return null;
  }

  /// 사용자들 연결 처리 및 초대 코드 제거
  Future<void> connectUsers(String currentUid, String partnerUid) async {
    await _firestore.collection("users").doc(partnerUid).update({
      "isConnected": true,
      "partnerUid": currentUid,
      "inviteCode": FieldValue.delete(),
    });

    await _firestore.collection("users").doc(currentUid).update({
      "isConnected": true,
      "partnerUid": partnerUid,
      "inviteCode": FieldValue.delete(),
    });
  }

  /// 커플 문서 생성 (기본 데이터 포함)
  Future<void> createCoupleDocument(String coupleId) async {
    await _firestore.collection("couples").doc(coupleId).set({
      "calendar": [],
    });
  }
}
