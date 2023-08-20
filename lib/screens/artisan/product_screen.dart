import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  final String? productId;
  final String? action;
  const ProductScreen({Key? key, this.productId, this.action = ""})
      : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey();
  TextEditingController _costController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (widget.action != "") {
        fetchProduct();
      }
    });
  }

  void fetchProduct() async {
    Map<String,dynamic> response=await Provider.of<ProfileProvider>(context, listen: false)
        .fetch_one_product(widget.productId);
        if (response["status"]) {
          _nameController.text=response["product"].name;
          _costController.text=response["product"].cost.toString();
          _descriptionController.text=response["product"].description;
        }
  }

  void ShowSnackBar(String title, bool status) {
    final snackbar = SnackBar(
      content: Text(title),
      backgroundColor: status ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

Map<String, dynamic> data;
if (widget.action=="") {
   data = await context
        .read<ProfileProvider>()
        .createProduct(_nameController.text, int.parse(_costController.text),
            _descriptionController.text);
} else {
    data = await context
        .read<ProfileProvider>()
        .updateProduct(_nameController.text, int.parse(_costController.text),
            _descriptionController.text,widget.productId!);
}

    if (data["status"]) {
      print("success");
      if (widget.action=="") {
      _nameController.text = "";
      _costController.text = "";
      _descriptionController.text = "";
      }
      ShowSnackBar(data["message"], true);
      //  Navigator.of(context).pop(

      //                 );
    } else {
      // ignore: deprecated_member_use
      ShowSnackBar(data["message"], false);
    }
    print("login file");
    print(data);
  }

  Widget _buildSubmitButton() {
    return context.watch<ProfileProvider>().getSubmitting
        ? CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))
        : Container(
            height: 50.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _handleSubmit();
              },
              child: Text("Submit"),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.action != "" ? "Update Product" : "Add Product"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage("assets/images/background-front.jpg"),
                  fit: BoxFit.cover)

              //image: DecorationImage(image: AssetImage("assets/images/backgound.jpg"),fit: BoxFit.cover)
              ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: context.watch<ProfileProvider>().loading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Add Product you want people to see and buy",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          //initialValue: context.watch<ProfileProvider>().profile.name,
                          controller: _nameController,
                          validator: (value) {
                            if (value == "") {
                              return "Please Enter Product Name";
                            }
                          },
                          decoration: InputDecoration(
                              labelText: "Product Name*",
                              // filled: true,
                              labelStyle: TextStyle(color: Color(0xff52575C)),
                              prefixIcon: Icon(
                                Icons.pattern_rounded,
                                color: Color(0xff52575C),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff52575C)))),
                          // onSaved: (value) => _email = value!
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          // initialValue: context.watch<ProfileProvider>().profile.phone,
                          controller: _costController,

                          validator: (value) {
                            if (value == "") {
                              return "Please Enter Product Cost";
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Product Cost(N)*",
                              // filled: true,
                              labelStyle: TextStyle(color: Color(0xff52575C)),
                              prefixIcon: Icon(
                                Icons.money,
                                color: Color(0xff52575C),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff52575C)))),
                          // onSaved: (value) => _email = value!
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          // initialValue: context.watch<ProfileProvider>().profile.address,
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                              labelText: "Description(Optional)",
                              // filled: true,
                              labelStyle: TextStyle(color: Color(0xff52575C)),
                              prefixIcon: Icon(
                                Icons.more,
                                color: Color(0xff52575C),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff52575C)))),
                          // onSaved: (value) => _email = value!
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        _buildSubmitButton(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
