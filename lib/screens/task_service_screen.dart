// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:intechpro/model/currency.dart';
import 'package:intechpro/model/service.dart';
import 'package:intechpro/model/sub_service.dart';
import 'package:intechpro/model/task.dart';
import 'package:intechpro/providers/service_provider.dart';
import 'package:intechpro/screens/request_service_screen.dart';
import 'package:intechpro/screens/supplier_products.dart';
import 'package:intechpro/widgets/service_card.dart';
import 'package:intechpro/widgets/service_other_card.dart';
import 'package:intechpro/widgets/service_other_card_home.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskServiceScreen extends StatefulWidget {
  SubService service;
  Service? parentService;
  TaskServiceScreen({required this.service, this.parentService});
  @override
  State<StatefulWidget> createState() {
    return _TaskServiceScreen();
  }
}

class _TaskServiceScreen extends State<TaskServiceScreen> {
  initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (widget.parentService!.userType == 4) {
        Provider.of<ServiceProvider>(context, listen: false)
            .fetch_suppliers_by_serviceId(
                widget.service.serviceId, widget.service.uid);
      } else {
        Provider.of<ServiceProvider>(context, listen: false)
            .fetch_tasks(widget.service.serviceId, widget.service.uid);
      }
    });
  }

  void onhandleTap(Task task, index) {
    print("sher@##");
    if (widget.parentService!.userType == 4) {
      //supplier just take them to call supplier
      // launch("tel://${task.phone}");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => SupplierProductScreen(service: task)));
    } else {
      print(task.uid);
      if (task.cost == 0) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Could not find task?"),
                content: Text(
                    "Request Assessment with Repairs and pay an all-inclusive cost of " +
                        currency.symbol +
                        widget.service.cost.toString() +
                        " comprising 75% of ${widget.service.cost.toString()} as artisan's daily work rate and 25% of ${widget.service.cost.toString()} as  non-refundable fee for job assessment done or exigencies for cancelled/rebooked appointments."),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Close',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => RequestServiceScreen(
                              parentService: widget.parentService,
                              subService: widget.service,
                              task: task)));
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              );
            });
      } else {
        context.read<ServiceProvider>().selectedTask(index);
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (_) => RequestServiceScreen(
        //           subService: widget.service,
        //           task: task,
        //           parentService: widget.parentService,
        //         )));
      }
    }
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
          widget.service.name +
              "(${context.watch<ServiceProvider>().getSelectedTasks.length})",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          context.watch<ServiceProvider>().getSelectedTasks.length > 0
              ? TextButton(
                  onPressed: () {
                    String taskname = "";
                    int cost = 0;
                    for (var i = 0;
                        i <
                            Provider.of<ServiceProvider>(context, listen: false)
                                .getSelectedTasks
                                .length;
                        i++) {
                      Task e =
                          Provider.of<ServiceProvider>(context, listen: false)
                              .getSelectedTasks[i];
                      print("hko##");
                      print(e.cost);
                      print(e.name);
                      taskname +=
                          e.name + " x " + e.numberSelected.toString() + "; ";
                      cost += e.cost * e.numberSelected!.toInt();
                    }

                    Task task = new Task(
                        name: taskname,
                        cost: cost,
                        uid: "",
                        visible: true,
                        subServiceId: widget.service.uid,
                        serviceId: widget.parentService!.uid);

                    print("doiet#");
                    print(taskname);
                    print(cost);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => RequestServiceScreen(
                              subService: widget.service,
                              task: task,
                              parentService: widget.parentService,
                            )));
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ))
              : Container(),
          widget.parentService!.userType == 4
              ? IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                              child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    "Here is a Price guide for ${widget.service.name}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Divider(),
                                Expanded(
                                    child: Text(widget.service.price_guide ??
                                        "No Price Guide Yet!"))
                              ],
                            ),
                          ));
                        });
                  },
                  icon: Icon(
                    Icons.info_rounded,
                    color: Theme.of(context).primaryColor,
                  ))
              : Container()
        ],
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
                  widget.parentService!.userType == 4
                      ? "Please choose the supplier you want to contact;"
                      : "Please choose type with labour charge of task (s) to do. Client to provide work materials ",
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
                                    Theme.of(context).primaryColor)),
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
                            // gridDelegate:
                            //     SliverGridDelegateWithFixedCrossAxisCount(
                            //         crossAxisCount: 3,
                            //         crossAxisSpacing: 10,
                            //         mainAxisSpacing: 10,
                            //         childAspectRatio: 8.0 / 9.0),
                            itemCount: context
                                .watch<ServiceProvider>()
                                .getTasks
                                .length,
                            itemBuilder: (BuildContext context, int index) {
                              Task task = context
                                  .watch<ServiceProvider>()
                                  .getTasks[index];
                              return widget.parentService!.userType == 4
                                  ? ServiceOtherCard(
                                      isSelected: context
                                          .watch<ServiceProvider>()
                                          .getTasks[index]
                                          .isSelected,
                                      type: "subservice",
                                      // onLongPress:()=> onhandleLongTap(index),
                                      onTap: () => onhandleTap(task, index),
                                      service: task)
                                  : ServiceOtherCardHome(
                                      indexCount: index,
                                      numberTask: context
                                              .watch<ServiceProvider>()
                                              .getTasks[index]
                                              .numberSelected ??
                                          1,
                                      isSelected: context
                                          .watch<ServiceProvider>()
                                          .getTasks[index]
                                          .isSelected,
                                      type: "subservice",
                                      // onLongPress:()=> onhandleLongTap(index),
                                      onTap: () => onhandleTap(task, index),
                                      service: task);
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
