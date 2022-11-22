import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:micro_pharma/adminScreens/GoogleMapPage.dart';
import 'package:micro_pharma/adminScreens/admin_page.dart';
import 'package:micro_pharma/adminScreens/location_screen.dart';
import 'package:micro_pharma/userScreens/call_planner.dart';
import 'package:micro_pharma/userScreens/daily_call_report.dart';
import 'package:micro_pharma/userScreens/user_dashboard.dart';
import 'package:micro_pharma/userScreens/day_plan.dart';
import 'package:micro_pharma/userScreens/master_screen.dart';
import 'package:micro_pharma/userScreens/product_order.dart';
import 'package:micro_pharma/userScreens/userSettings.dart';
import 'userScreens/login_page.dart';
import 'userScreens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:micro_pharma/adminScreens/adminSettings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MicroPharma());
}

class MicroPharma extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  late var myDocument = FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      documentSnapshot.get('role');
    }
  });

  MicroPharma({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'login': (context) => LoginPage(),
        'home': (context) => HomePage(),
        'user_dashboard': (context) => Dashboard(),
        'admin': (context) => AdminPage(),
        'dayplan': (context) => DayPlan(),
        'productorder': (context) => ProductOrder(),
        'callplanner': (context) => CallPlanner(),
        'master': (context) => Master(),
        'dailycallreport': (context) => DailyCallReport(),
        'usersettings': (context) => UserSettings(),
        'adminsettings': (context) => AdminSettings(),
        'map_page': (context) => GoogleMapPage(),
        'location_screen': (context) => LocationScreen(),
      },
      home: LoginPage(),
    );
  }
}



//       StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Container(
//               alignment: Alignment.center,
//               child: const CircularProgressIndicator(
//                   backgroundColor: Colors.white, color: Colors.blue),
//             );
//           } else if (snapshot.hasError) {
//             return Text('Something went wrong');
//           } else if (snapshot.hasData && snapshot.data != null) {
//             return StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection("users")
//                   .doc(user!.uid)
//                   .snapshots(),
//               builder: ((BuildContext context,
//                   AsyncSnapshot<DocumentSnapshot> snapshot) {
//                 if (snapshot.hasData && snapshot.data != null) {
//                   if (myDocument == 'admin') {
//                     return AdminPage();
//                   } else if (myDocument == 'user') {
//                     return HomePage();
//                   }
//                 }
//                 return Material(
//                   child: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 );
//               }),
//             );
//           } else {
//             return LoginPage();
//           }
//         },
//       ),
//     );
//   }
// }
