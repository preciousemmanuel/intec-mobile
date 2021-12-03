import 'package:flutter/material.dart';
import 'package:intechpro/controllers/place_api_controller.dart';

import 'package:intechpro/model/address_suggestion.dart';

class AddressSearch extends SearchDelegate<AddressSuggestion> {
  AddressSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }
  final sessionToken;
  PlaceApiProvider? apiClient;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back),
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

      builder: (context, snapshot) => query == ''
          ? Container(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 40, color: Theme.of(context).primaryColor),
                    Text(
                      "Enter Address",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    )
                  ],
                ),
              ),
            )
          : snapshot.hasData
              ? ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    var list = snapshot.data! as List;
                    return ListTile(
                      // we will display the data returned from our future here
                      title:
                          Text((list[index] as AddressSuggestion).description),
                      onTap: () {
                        close(context, list[index] as AddressSuggestion);
                      },
                    );
                  },
                )
              : Container(child: Text('Loading...')),
    );
  }
}
