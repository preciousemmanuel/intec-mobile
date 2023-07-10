// import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../main.dart';


// class NotificationRouterService {
//   static router(NotificationItem data, BuildContext context) async {
//     print("sllsccc: " + data.type.toString());
//     print("ssss: " + data.action.toString());

//     // if (goToCommentScreen.indexOf(data.type!) > -1) {
//     //   // Navigator.push(
//     //   //     context,
//     //   //     CustomPageRoute(CommentScreen(
//     //   //       postId: data.action!,
//     //   //     )));
//     //   navigatorKey.currentState?.push(CustomPageRoute(CommentScreen(
//     //     postId: data.action!,
//     //   )));
//     //   return;
//     // }
//     // if (goToTransactionHistoryScreen.indexOf(data.type!) > -1) {
//     //   if (data.action != null && data.action == "0") {
//     //     navigatorKey.currentState?.push(CustomPageRoute(
//     //         TransactionHistoryDetails(transactionRef: data.action!)));
//     //     return;
//     //   }
//     //   navigatorKey.currentState
//     //       ?.push(CustomPageRoute(WalletTransactionHistory()));
//     //   return;
//     // }
//     // if (goToCauseScreen.indexOf(data.type!) > -1) {
//     //   navigatorKey.currentState?.push(CustomPageRoute(CauseDetails(
//     //     causeId: data.action!,
//     //     buttonText: "Join",
//     //   )));
//     //   return;
//     // }
//     // if (goToMoneyAskersScreen.indexOf(data.type!) > -1) {
//     //   navigatorKey.currentState?.push(CustomPageRoute(YourBeggars()));
//     //   return;
//     // }
//     // if (goToGroupScreen.indexOf(data.type!) > -1) {
//     //   navigatorKey.currentState?.push(CustomPageRoute(ViewGroupDetailScreen(
//     //     groupId: data.action,
//     //   )));
//     //   return;
//     // }

//     // if (goToCommunityScreen.indexOf(data.type!) > -1) {
//     //   navigatorKey.currentState?.push(CustomPageRoute(FriendGlobalScreen()));
//     //   return;
//     // }

//     // if (goToVybeRequestScreen.indexOf(data.type!) > -1) {
//     //   navigatorKey.currentState?.push(CustomPageRoute(FriendGlobalScreen(
//     //     initialIndex: 1,
//     //   )));
//     //   return;
//     // }

//     // if (goToMessageScreen.indexOf(data.type!) > -1) {
//     //   navigatorKey.currentState?.push(CustomPageRoute(MessageScreen()));
//     //   return;
//     // }
//     // if (goToTargetSavingsScreen.indexOf(data.type!) > -1) {
//     //   navigatorKey.currentState
//     //       ?.push(CustomPageRoute(SingleTargetSavingsDetails(
//     //     savingsId: int.tryParse(data.action!) ?? 0,
//     //   )));
//     //   return;
//     // }

//     // if (goToFixedSavingsScreen.indexOf(data.type!) > -1) {
//     //   navigatorKey.currentState
//     //       ?.push(CustomPageRoute(SingleFixedDepositSavingsDetails(
//     //     savingsId: int.tryParse(data.action!) ?? 0,
//     //   )));
//     //   return;
//     // }

//     // // if (goToTicketScreen.indexOf(data.type!) > -1) {
//     // //   navigatorKey.currentState
//     // //       ?.push(CustomPageRoute(ViewTicket(eventId: data.action ?? "")));
//     // //   return;
//     // // }

//     // if (goToTicketScreen.indexOf(data.type!) > -1) {
//     //   navigatorKey.currentState
//     //       ?.push(CustomPageRoute(ViewEventDetails(eventId: data.action ?? "")));
//     //   return;
//     // }

//     // if (goToEventScreen.indexOf(data.type!) > -1) {
//     //   navigatorKey.currentState
//     //       ?.push(CustomPageRoute(ViewEventDetails(eventId: data.action ?? "")));
//     //   return;
//     // }

//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('userId');

//     print(data.sender!.userId.toString());
//     print(userId.toString());
//     print("====");

//     // if (data.sender!.userId == userId) {
//     //   Navigator.push(
//     //       context, CupertinoPageRoute(builder: (context) => MyProfile()));
//     //   return;
//     // }

//     // navigatorKey.currentState?.push(CustomPageRoute(UsersProfile(
//     //     firstName: data.sender!.firstName,
//     //     lastName: data.sender!.lastName,
//     //     id: data.sender!.userId,
//     //     profileImage: data.sender!.profileImage)));
//   }
// }
