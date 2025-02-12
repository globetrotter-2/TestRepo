import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:signature/signature.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String name = '';
  String position = '';
  String company = '';
  String underControlCompany = '';
  String reportingManager = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController underControlCompanyController = TextEditingController();
  TextEditingController reportingManagerController = TextEditingController();

  //for Signature
  String? _selectedKeyTakeover;
  String? _selectedStaffTakeover;
  File? _uploadedIdTakeover;
  final SignatureController _takeoverSignatureController = SignatureController();

  String? _selectedKeyHandover;
  String? _selectedStaffHandover;
  File? _uploadedIdHandover;
  final SignatureController _handoverSignatureController = SignatureController();

  String? _selectedVisitor;
  String? _selectedVisitorHandover;
  File? _uploadedSignature;
  final SignatureController _uploadedSignatureController = SignatureController();
  //Dropdown choose

  final List<Map<String, String>> keys = [
    {"keyId": "1", "keyName": "Front Door"},
    {"keyId": "2", "keyName": "Back Door"},
    {"keyId": "3", "keyName": "Office Cabinet"},
  ];

  final List<String> staffNames = ["Alice", "Bob", "Charlie", "David"];

  // Function to upload ID card (gallery/camera)
  Future<void> _uploadIdCard(bool isTakeover) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: await showDialog<ImageSource>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Choose Image Source"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, ImageSource.camera),
              child: Text("Camera"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, ImageSource.gallery),
              child: Text("Gallery"),
            ),
          ],
        ),
      ) ?? ImageSource.gallery, // Provide a default value in case null is returned
    );

    if (image != null) {
      setState(() {
        if (isTakeover) {
          _uploadedIdTakeover = File(image.path);
        } else {
          _uploadedIdHandover = File(image.path);
        }
      });
    }
  }

  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  // edit the profile if we need to the change position
  void showEditProfileDialog(BuildContext context) {
    nameController.text = name;
    positionController.text = position;
    companyController.text = company;
    underControlCompanyController.text = underControlCompany;
    reportingManagerController.text = reportingManager;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField("Name", nameController),
                _buildTextField("Position", positionController),
                _buildTextField("Company", companyController),
                _buildTextField("Working Under", underControlCompanyController),
                _buildTextField("Reporting To", reportingManagerController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  position = positionController.text;
                  company = companyController.text;
                  underControlCompany = underControlCompanyController.text;
                  reportingManager = reportingManagerController.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
        title: const Text("Company Logo"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body:DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                            image: _profileImage != null
                                ? DecorationImage(image: FileImage(_profileImage!), fit: BoxFit.cover)
                                : const DecorationImage(
                              image: AssetImage('assets/'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () => _showImageSourceDialog(context),
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.camera_alt_outlined, size: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name.isEmpty ? "Name" : name, style: _textStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(position.isEmpty ? "Position" : position, style: _textStyle(fontSize: 16, color: Colors.grey)),
                            Text('Company: ${company.isEmpty ? "Company Name" : company}', style: _textStyle()),
                            Text('Working Under: ${underControlCompany.isEmpty ? "N/A" : underControlCompany}', style: _textStyle()),
                            Text('Reporting to: ${reportingManager.isEmpty ? "N/A" : reportingManager}', style: _textStyle()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                /// Edit Profile Button ///
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () => showEditProfileDialog(context),
                      child: const Text("Edit profile", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Divider(height: 1,color: Colors.red,),
                //--------------------------Above the tab bar --------------------------------------------------------
                /// TabBar ///
                TabBar(
                  physics: NeverScrollableScrollPhysics(),
                  tabs: [
                    Tab(
                      text: null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.key, color: Colors.red,size: 14,),
                          Text(
                            "Key Register",
                            style: TextStyle(color: Colors.blue,fontSize: 12), // Change text color here
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      text: null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.person_pin_outlined, color: Colors.red,size: 14,),
                          Text(
                            "Visitor Register",
                            style: TextStyle(color: Colors.blue,fontSize: 11), // Change text color here
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      text: null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.file_copy_rounded, color: Colors.red,size: 14,),
                          Text(
                            "Files Register",
                            style: TextStyle(color: Colors.blue,fontSize: 11), // Change text color here
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                Divider(height: 1,color: Colors.red,),
//--------------------------Below the tab bar --------------------------------------------------------

                /// Expanded TabBar view ///
                Expanded(
                  child: TabBarView(
                    children: [
//-------------------------- Key Register Page --------------------------------------------------------

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _keyManagementRow(
                                title: "Key Takeover",
                                selectedKey: _selectedKeyTakeover,
                                selectedStaff: _selectedStaffTakeover,
                                uploadedId: _uploadedIdTakeover,
                                signatureController: _takeoverSignatureController,
                                onSubmit: () {},
                                onMakeReport: () {},
                                onUpload: () => _uploadIdCard(true),
                                onKeyChanged: (value) {
                                  setState(() {
                                    _selectedKeyTakeover = value;
                                  });
                                },
                                onStaffChanged: (value) {
                                  setState(() {
                                    _selectedStaffTakeover = value;
                                  });
                                },
                              ),
                              _keyManagementRow(
                                title: "Key Handover",
                                selectedKey: _selectedKeyHandover,
                                selectedStaff: _selectedStaffHandover,
                                uploadedId: _uploadedIdHandover,
                                signatureController: _handoverSignatureController,
                                onSubmit: () {},
                                onMakeReport: () {},
                                onUpload: () => _uploadIdCard(false),
                                onKeyChanged: (value) {
                                  setState(() {
                                    _selectedKeyHandover = value;
                                  });
                                },
                                onStaffChanged: (value) {
                                  setState(() {
                                    _selectedStaffHandover = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
//-------------------------- Visitor Register Page --------------------------------------------------------

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Visitor Register",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: "Name",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: "Purpose of Visit",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: "Time In",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: "Time Out",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: "ID Provided",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => _uploadIdCard(true),
                                child: Text("Upload ID Card"),
                              ),
                              SizedBox(height: 8),
                              Text("Signature"),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                ),
                                height: 100,
                                child: Signature(
                                  controller: _uploadedSignatureController,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () => _uploadedSignatureController.clear(),
                                    child: Text("Clear"),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text("Save"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
//-------------------------- Files Page ----------------------------------------------------------------
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView(
                          children: [
                            ListTile(
                              title: Text("Merchandiser Document"),
                            ),
                            Divider(height: 0.5,color: Colors.black,),
                            ListTile(
                              title: Text("Workers Document"),
                            ),
                            Divider(height: 0.5,color: Colors.black,),
                            ListTile(
                              title: Text("Fire Drill Document"),
                            ),
                            Divider(height: 0.5,color: Colors.black,),
                            ListTile(
                              title: Text("Medical Emergency Document"),
                            ),
                            Divider(height: 0.5,color: Colors.black,),
                            ListTile(
                              title: Text("Contractor Document"),
                            ),
                            Divider(height: 0.5,color: Colors.black,),
                            ListTile(
                              title: Text("Sub Contractor Document"),
                            ),
                            Divider(height: 0.5,color: Colors.black,),
                            ListTile(
                              title: Text("Workers Accommodation Document"),
                            ),
                            Divider(height: 0.5,color: Colors.black,),
                            ListTile(
                              title: Text("Water Provide Document"),
                            ),
                            Divider(height: 0.5,color: Colors.black,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]
          ),
        ),
      ),
    );

  }



  // Widget to render a key management row
  Widget _keyManagementRow({
    required String title,
    required String? selectedKey,
    required String? selectedStaff,
    required File? uploadedId,
    required SignatureController signatureController,
    required VoidCallback onSubmit,
    required VoidCallback onMakeReport,
    required Function() onUpload,
    required ValueChanged<String?> onKeyChanged,
    required ValueChanged<String?> onStaffChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select Key"),
                DropdownButton<String>(
                  value: selectedKey,
                  hint: Text("Select Key"),
                  onChanged: onKeyChanged,
                  items: keys
                      .map((key) => DropdownMenuItem<String>(
                    value: key["keyId"],
                    child: Text("${key["keyName"]} (ID: ${key["keyId"]})"),
                  ))
                      .toList(),
                ),
                SizedBox(height: 8),
                Text("Select Staff"),
                DropdownButton<String>(
                  value: selectedStaff,
                  hint: Text("Select Staff"),
                  onChanged: onStaffChanged,
                  items: staffNames
                      .map((staff) => DropdownMenuItem<String>(
                    value: staff,
                    child: Text(staff),
                  ))
                      .toList(),
                ),
              ],
            ),
            // Expanded(
            //   child:
            // ),
          ],
        ),
        Column(
          children: [
            Text("Upload ID Card"),
            ElevatedButton(
              onPressed: onUpload,
              child: Text("Upload"),
            ),
            if (uploadedId != null)
              Image.file(
                uploadedId,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 8),
            Text("Signature"),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              height: 100,
              child: Signature(
                controller: signatureController,
                backgroundColor: Colors.white,
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => signatureController.clear(),
                  child: Text("Clear"),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("Save"),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: onSubmit,
              child: Text("Submit"),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: onMakeReport,
              child: Text("Make Report"),
            ),
          ],
        ),
        Divider(thickness: 2),
      ],
    );
  }
}

TextStyle _textStyle({double fontSize = 14, FontWeight fontWeight = FontWeight.normal, Color color = Colors.white}) {
  return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
}



