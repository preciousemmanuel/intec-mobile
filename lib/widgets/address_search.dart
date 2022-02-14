import 'package:flutter/material.dart';
import 'package:intechpro/controllers/place_api_controller.dart';

import 'package:intechpro/model/address_suggestion.dart';

class AddressSearch extends SearchDelegate<AddressSuggestion> {
    final sessionToken;
    
  AddressSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }


  PlaceApiProvider? apiClient;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.clear,color: Theme.of(context).primaryColor),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

 String? get searchFieldLabel => "Search Location...";
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      backgroundColor: Colors.white,
      textTheme: TextTheme(
    headline6: TextStyle(
      color: Colors.black,
      fontSize: 15.0,
    ),
  ),
      appBarTheme: AppBarTheme(backgroundColor: Colors.white,),
      hintColor: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back,color: Theme.of(context).primaryColor,),
      onPressed: () {
        close(context, AddressSuggestion());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print(query);
    return FutureBuilder(
      // We will put the api call here
      future: query == ""
          ? null
          : apiClient?.fetchSuggestions(
              query, Localizations.localeOf(context).languageCode),

      builder: (context, AsyncSnapshot<List<AddressSuggestion>> snapshot) => query == ''
          ? Container(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 70, color: Theme.of(context).primaryColor),
                    // Text(
                    //   "Enter Address",
                    //   style: TextStyle(color: Theme.of(context).accentColor),
                    // )
                  ],
                ),
              ),
            )
          : snapshot.hasData
              ? ListView.separated(
                 separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            
                            height: 10,
                          );
                        },
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    print("delegate###");
                    print(snapshot.data);
                    var list = snapshot.data! as List;
                    return ListTile(
                      leading: Icon(Icons.place,color: Colors.black38,),
                      // we will display the data returned from our future here
                      title:
                          Text((list[index] as AddressSuggestion).description,style:TextStyle(color: Colors.black)),
                      onTap: () {
                        close(context, list[index] as AddressSuggestion);
                      },
                    );
                  },
                )
              : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Loading...',style: TextStyle(color: Colors.black),),
              ),
    );
  }
}
