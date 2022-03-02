import 'package:flutter/material.dart';
import 'package:intechpro/model/service.dart';
import 'package:intechpro/model/sub_service.dart';
import 'package:intechpro/providers/service_provider.dart';
import 'package:intechpro/screens/request_service_screen.dart';
import 'package:intechpro/screens/task_service_screen.dart';
import 'package:intechpro/widgets/service_card.dart';
import 'package:intechpro/widgets/service_other_card.dart';
import 'package:provider/provider.dart';

class SubServiceScreen extends StatefulWidget {
  Service service;
  SubServiceScreen({required this.service});
  @override
  State<StatefulWidget> createState() {
    return _SubServiceScreen();
  }
}

class _SubServiceScreen extends State<SubServiceScreen> {
  initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<ServiceProvider>(context, listen: false)
          .fetch_subservices(widget.service.uid);
    });
  }

  void onhandleTap(SubService service) {
    print("sher@##");
    print(service.uid);
    if (service.hasTask) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => TaskServiceScreen(
              service: service, parentService: widget.service)));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => RequestServiceScreen(
                subService: service,
                parentService: widget.service,
              )));
    }
  }

  String showText() {
    if (widget.service.userType == 2) {
      return "Do you want to keep the service life of your facilities in proper condition? Our verified artisans can help.";
    } else if (widget.service.userType == 3) {
      return "Are you facing delays collecting waste, moving loads, or dispatching deliveries? Our truck call-up service is all you need.";
    }
    return "Are you loosing time finding repair materials to fix defects? Our network of suppliers can respond swiftly to your needs.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF0F0F0),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          widget.service.name,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage("assets/images/backgound.jpg"),
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
                Text(
                  showText(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                context.watch<ServiceProvider>().getLoading
                    ? Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text("Loading ${widget.service.name} services...")
                          ],
                        ),
                      )
                    : Expanded(
                        // height: 400.0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 10),

                            // gridDelegate:
                            //     SliverGridDelegateWithFixedCrossAxisCount(
                            //         crossAxisCount: 3,
                            //         crossAxisSpacing: 10,
                            //         mainAxisSpacing: 10,
                            //         childAspectRatio: 8.0 / 9.0),
                            itemCount: context
                                .watch<ServiceProvider>()
                                .getSubServices
                                .length,
                            itemBuilder: (BuildContext context, int index) {
                              SubService subservice = context
                                  .watch<ServiceProvider>()
                                  .getSubServices[index];
                              return ServiceOtherCard(
                                  type: "subservice",
                                  onTap: () => onhandleTap(subservice),
                                  service: subservice);
                            },
                            // crossAxisCount: 3,
                          ),
                        ),
                      ),
                SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
