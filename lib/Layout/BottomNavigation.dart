import 'package:adminapp/Screens/CCTV.dart';
import 'package:adminapp/Screens/Home.dart';
import 'package:adminapp/Screens/Notification.dart';
import 'package:adminapp/Screens/Reports.dart';
import 'package:flutter/material.dart';

class ModernCurvedBottomNavApp extends StatefulWidget {
  @override
  _ModernCurvedBottomNavAppState createState() =>
      _ModernCurvedBottomNavAppState();
}

class _ModernCurvedBottomNavAppState extends State<ModernCurvedBottomNavApp> {
  int _currentIndex = 0; // Default selected index

  final List<Widget> _pages = [
    HomePage(),
    CCTVScreen(),
    NotificationScreen(),
    ReportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 80),
            painter: WavePainter(),
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: FloatingActionButton(
              backgroundColor: Colors.redAccent,
              onPressed: () => _showScanOptions(context),
              child: Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0; // Home
                    });
                  },
                  icon: Icon(Icons.home),
                  color: _currentIndex == 0 ? Colors.purple : Colors.grey,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1; // cctv screen
                    });
                  },
                  icon: Icon(Icons.tv),
                  color: _currentIndex == 1 ? Colors.purple : Colors.grey,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 2; // Notification
                    });
                  },
                  icon: Icon(Icons.notifications),
                  color: _currentIndex == 2 ? Colors.purple : Colors.grey,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 3; // Reports
                    });
                  },
                  icon: Icon(Icons.report),
                  color: _currentIndex == 3 ? Colors.purple : Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showScanOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose Scan Option",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildScanOption(context, Icons.account_box, "Passport Scan", "Passport"),
              _buildScanOption(context, Icons.card_membership, "License Scan", "License"),
              _buildScanOption(context, Icons.credit_card, "Nationality ID Scan", "Nationality ID"),
              _buildScanOption(context, Icons.work, "Company ID Scan", "Company ID"),
              _buildScanOption(context, Icons.description, "Document Scan", "Document"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScanOption(BuildContext context, IconData icon, String label, String type) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        _performOCR(context, type);
      },
    );
  }

  void _performOCR(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("OCR in Progress"),
        content: Text("Scanning and extracting $type details..."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Close"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$type details exported to PDF and Excel.")),
              );
            },
            child: Text("Export"),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.35, 0)
      ..quadraticBezierTo(size.width * 0.42, 0, size.width * 0.45, 20)
      ..arcToPoint(
        Offset(size.width * 0.55, 20),
        radius: Radius.circular(20),
        clockwise: false,
      )
      ..quadraticBezierTo(size.width * 0.58, 0, size.width * 0.65, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}



