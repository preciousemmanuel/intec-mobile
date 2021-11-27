import 'package:flutter/material.dart';
import 'package:intechpro/model/service.dart';
import 'package:intechpro/providers/service_provider.dart';
import 'package:intechpro/screens/sub_service_screen.dart';
import 'package:intechpro/widgets/service_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<ServiceProvider>(context, listen: false).fetch_services();
    });
  }

  void onhandleTap(Service service) {
    print("sher@##");
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SubServiceScreen(service: service)));
    print(service.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF0F0F0),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        backgroundColor: Colors.white,
        title: Text(
          "IntecPRO",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage("assets/images/background-img.jpg"),
                  fit: BoxFit.cover)

              //image: DecorationImage(image: AssetImage("assets/images/backgound.jpg"),fit: BoxFit.cover)
              ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 22.0,
                ),
                Row(
                  children: [
                    Text(
                      "Welcome",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 25.0,
                          color: Theme.of(context).accentColor),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      "Johnson!",
                      style:
                          TextStyle(color: Color(0xff4E4D4D), fontSize: 25.0),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "What do you want to do:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                context.watch<ServiceProvider>().getLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)),
                      )
                    : SizedBox(
                        height: 400.0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 30,
                                    childAspectRatio: 8.0 / 9.0),
                            itemCount: context
                                .watch<ServiceProvider>()
                                .getServices
                                .length,
                            itemBuilder: (BuildContext context, int index) {
                              Service service = context
                                  .watch<ServiceProvider>()
                                  .getServices[index];
                              return ServiceCard(
                                  onTap: () => onhandleTap(service),
                                  service: service);
                            },
                            // crossAxisCount: 3,
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
