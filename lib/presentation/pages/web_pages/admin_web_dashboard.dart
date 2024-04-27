import 'package:flutter/material.dart';
import 'package:greenway/presentation/pages/web_pages/tab_views/tab_one.dart';

class WebDashboard extends StatefulWidget {
  const WebDashboard({super.key});

  @override
  State<WebDashboard> createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            groupAlignment: groupAlignment,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: labelType,
            leading: showLeading
                ? FloatingActionButton(
                    elevation: 0,
                    onPressed: () {
                      // Add your onPressed code here!
                    },
                    child: const Icon(Icons.add),
                  )
                : const SizedBox(),
            trailing: showTrailing
                ? IconButton(
                    onPressed: () {
                      // Add your onPressed code here!
                    },
                    icon: const Icon(Icons.more_horiz_rounded),
                  )
                : const SizedBox(),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.local_shipping),
                selectedIcon: Icon(Icons.local_shipping_outlined),
                label: Text('Consegne'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.map),
                selectedIcon: Icon(Icons.map_outlined),
                label: Text('Mappa e dati'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.schema),
                selectedIcon: Icon(Icons.schema_outlined),
                label: Text('Riepilogo'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(child: _renderChild(_selectedIndex)),
        ],
      ),
    );
  }

  Widget _renderChild(index) {
    switch (index) {
      case 0:
        return const TabOne();
        break;
      case 1:
        return const TabTwo();
        break;
      case 2:
        return const TabTree();
        break;
      default:
        return Container(
          child: const Text("Something feels fishy! :P"),
        );
    }
  }
}
