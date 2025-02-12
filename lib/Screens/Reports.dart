import 'package:flutter/material.dart';
class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            ListTile(
              title: Text("Lost and Found Report"),
              leading: Icon(Icons.search),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Create Report"),
                    content: Text("Create a lost and found report."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text("OK"),
                      )
                    ],
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Shoplifting Report"),
              leading: Icon(Icons.report),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Create Report"),
                    content: Text("Create a shoplifting report."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text("OK"),
                      )
                    ],
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Children Missing Report"),
              leading: Icon(Icons.child_care),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Create Report"),
                    content: Text("Create a children missing report."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text("OK"),
                      )
                    ],
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Customer Bill Verification Report"),
              leading: Icon(Icons.receipt_long),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Create Report"),
                    content: Text("Create a customer bill verification report."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text("OK"),
                      )
                    ],
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Goods Out Report"),
              leading: Icon(Icons.local_shipping),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Create Report"),
                    content: Text("Create a goods out report."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text("OK"),
                      )
                    ],
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Worker Items Report"),
              leading: Icon(Icons.inventory),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Create Report"),
                    content: Text("Create a worker items report."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text("OK"),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
