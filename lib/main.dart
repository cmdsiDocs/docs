// main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/about_screen.dart';
import 'screens/api_screen.dart'; // New
import 'screens/contact_screen.dart';
import 'screens/documentation_screen.dart'; // New
// main.dart (imports section)
import 'screens/home_screen.dart';
import 'screens/luvpark_screen.dart';
import 'screens/luvpark_spms_screen.dart';

void main() {
  runApp(const CleverMindsApp());
}

class CleverMindsApp extends StatelessWidget {
  const CleverMindsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clever Minds Digital Solutions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue[800],
          elevation: 1,
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const AboutScreen(),
    const ApiScreen(),
    const DocumentationScreen(),
    const ContactScreen(),
  ];

  final List<String> _tabTitles = [
    'Home',
    'About Us',
    'API',
    'Documentation',
    'Contact Us'
  ];
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownHovered = false;
  bool _isButtonHovered = false;
  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  bool get _shouldShowDropdown => _isButtonHovered || _isDropdownHovered;
  void _updateOverlay() {
    if (_shouldShowDropdown && _overlayEntry == null) {
      _showDocsOverlay();
    } else if (!_shouldShowDropdown && _overlayEntry != null) {
      _removeOverlay();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isDropdownHovered = false;
  }

  void _showDocsOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => MouseRegion(
        onEnter: (_) {
          setState(() {
            _isDropdownHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isDropdownHovered = false;
            _updateOverlay();
          });
        },
        child: Positioned(
          width: 200,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 40),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildDocsMenuItem(
                      'LuvPark',
                      Icons.local_parking,
                      () {
                        _removeOverlay();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LuvParkScreen()),
                        );
                      },
                    ),
                    _buildDocsMenuItem(
                      'LuvPark SPMS',
                      Icons.security,
                      () {
                        _removeOverlay();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LuvParkSpmsScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      appBar: isWideScreen ? _buildDesktopAppBar() : null,
      body: _screens[_currentIndex],
      bottomNavigationBar: isWideScreen ? null : _buildMobileNavigation(),
      drawer: !isWideScreen ? _buildMobileDrawer() : null,
    );
  }

  AppBar _buildDesktopAppBar() {
    return AppBar(
      title: Row(
        children: [
          InkWell(
            onTap: () => setState(() => _currentIndex = 0),
            child: Row(
              children: [
                Center(
                  child: Image.asset('assets/images/logo.png',
                      width: 24, height: 24),
                ),
                const SizedBox(width: 10),
                Text(
                  'Clever Minds',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: List.generate(_tabTitles.length, (index) {
              if (index == 3) {
                // Documentation tab with hover menu
                return MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isButtonHovered = true;
                      _updateOverlay();
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isButtonHovered = false;
                      _updateOverlay();
                    });
                  },
                  child: CompositedTransformTarget(
                    link: _layerLink,
                    child: TextButton(
                      onPressed: () => setState(() => _currentIndex = index),
                      style: TextButton.styleFrom(
                        foregroundColor: _currentIndex == index
                            ? Colors.blue[800]
                            : Colors.grey[600],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        _tabTitles[index],
                        style: GoogleFonts.poppins(
                          fontWeight: _currentIndex == index
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton(
                    onPressed: () => setState(() => _currentIndex = index),
                    style: TextButton.styleFrom(
                      foregroundColor: _currentIndex == index
                          ? Colors.blue[800]
                          : Colors.grey[600],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    child: Text(
                      _tabTitles[index],
                      style: GoogleFonts.poppins(
                        fontWeight: _currentIndex == index
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }
            }),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Get Started'),
          ),
        ),
      ],
    );
  }

  Widget _buildDocsMenuItem(String title, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue[800]),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileNavigation() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue[800],
      unselectedItemColor: Colors.grey[600],
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'About',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.api),
          label: 'API',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description),
          label: 'Docs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.contact_mail),
          label: 'Contact',
        ),
      ],
    );
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[800],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'CM',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Clever Minds',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Digital Solutions',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Main navigation items
          ...List.generate(_tabTitles.length, (index) {
            if (index == 3) {
              // Documentation with sub-items
              return ExpansionTile(
                leading: Icon(
                  _getIconForIndex(index),
                  color: _currentIndex == index
                      ? Colors.blue[800]
                      : Colors.grey[600],
                ),
                title: Text(
                  _tabTitles[index],
                  style: GoogleFonts.poppins(
                    color: _currentIndex == index
                        ? Colors.blue[800]
                        : Colors.grey[600],
                    fontWeight: _currentIndex == index
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                children: [
                  _buildMobileDocsItem('LuvPark', Icons.local_parking, () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LuvParkScreen()),
                    );
                  }),
                  _buildMobileDocsItem('LuvPark SPMS', Icons.security, () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LuvParkSpmsScreen()),
                    );
                  }),
                ],
              );
            } else {
              return ListTile(
                leading: Icon(
                  _getIconForIndex(index),
                  color: _currentIndex == index
                      ? Colors.blue[800]
                      : Colors.grey[600],
                ),
                title: Text(
                  _tabTitles[index],
                  style: GoogleFonts.poppins(
                    color: _currentIndex == index
                        ? Colors.blue[800]
                        : Colors.grey[600],
                    fontWeight: _currentIndex == index
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                onTap: () {
                  setState(() => _currentIndex = index);
                  Navigator.pop(context);
                },
              );
            }
          }),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.login),
            title: Text(
              'Get Started',
              style: GoogleFonts.poppins(
                color: Colors.blue[800],
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDocsItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Colors.blue[700]),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[700],
        ),
      ),
      onTap: onTap,
    );
  }
}

IconData _getIconForIndex(int index) {
  switch (index) {
    case 0:
      return Icons.home;
    case 1:
      return Icons.info;
    case 2:
      return Icons.api;
    case 3:
      return Icons.description;
    case 4:
      return Icons.contact_mail;
    default:
      return Icons.home;
  }
}
// main.dart

// ignore_for_file: prefer_const_constructors

// import 'package:cmdsidocs/models/model.dart';
// import 'package:collection/collection.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// // ======================= MODELS =======================

// @HiveType(typeId: 1)
// class Account extends HiveObject {
//   @HiveField(0)
//   String username;
//   @HiveField(1)
//   String password;
//   @HiveField(2)
//   String role; // admin/user
//   @HiveField(3)
//   bool undeletable;

//   Account({
//     required this.username,
//     required this.password,
//     required this.role,
//     this.undeletable = false,
//   });
// }

// @HiveType(typeId: 2)
// class FileItem extends HiveObject {
//   @HiveField(0)
//   String name;
//   @HiveField(1)
//   String path;
//   @HiveField(2)
//   String title;
//   @HiveField(3)
//   String description;

//   FileItem({
//     required this.name,
//     required this.path,
//     this.title = "",
//     this.description = "",
//   });
// }

// @HiveType(typeId: 3)
// class Folder extends HiveObject {
//   @HiveField(0)
//   String name;
//   @HiveField(1)
//   List<FileItem> files;
//   @HiveField(2)
//   List<Folder> subfolders;

//   Folder({
//     required this.name,
//     List<FileItem>? files,
//     List<Folder>? subfolders,
//   })  : files = files ?? [],
//         subfolders = subfolders ?? [];
// }

// // ======================= GLOBALS =======================

// late Box<Account> accountBox;
// late Box<Folder> folderBox;
// Account? loggedInUser;

// Folder get rootFolder => folderBox.getAt(0)!;

// // ======================= MAIN =======================

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();
//   Hive.registerAdapter(AccountAdapter());
//   Hive.registerAdapter(FileItemAdapter());
//   Hive.registerAdapter(FolderAdapter());

//   accountBox = await Hive.openBox<Account>('accounts');
//   folderBox = await Hive.openBox<Folder>('folders');

//   if (accountBox.isEmpty) {
//     final admin = Account(
//         username: "admin",
//         password: "admin123",
//         role: "admin",
//         undeletable: true);
//     final user = Account(username: "user", password: "user123", role: "user");

//     await accountBox.add(admin);
//     await accountBox.add(user);
//   }

//   // Root folder
//   if (folderBox.isEmpty) folderBox.add(Folder(name: "Root"));

//   runApp(FileManagerApp());
// }

// // ======================= APP =======================

// class FileManagerApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "File Manager",
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: LoginScreen(),
//     );
//   }
// }

// // ======================= LOGIN SCREEN =======================

// class LoginScreen extends StatefulWidget {
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   String? error;

//   void _login() {
//     String u = _usernameController.text.trim();
//     String p = _passwordController.text.trim();
//     Account? acc = accountBox.values
//         .firstWhereOrNull((a) => a.username == u && a.password == p);

//     if (acc != null) {
//       loggedInUser = acc;
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => HomeScreen()));
//     } else {
//       setState(() => error = "Invalid username or password");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Login")),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//                 controller: _usernameController,
//                 decoration: InputDecoration(labelText: "Username")),
//             TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(labelText: "Password")),
//             SizedBox(height: 12),
//             ElevatedButton(onPressed: _login, child: Text("Login")),
//             if (error != null)
//               Text(error!, style: TextStyle(color: Colors.red)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ======================= HOME SCREEN =======================

// class HomeScreen extends StatelessWidget {
//   void _logout(BuildContext context) {
//     loggedInUser = null;
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (_) => LoginScreen()));
//   }

//   void _manageAccounts(BuildContext context) {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (_) => AccountManagementScreen()));
//   }

//   void _openFiles(BuildContext context) {
//     Navigator.push(context,
//         MaterialPageRoute(builder: (_) => FilesScreen(folder: rootFolder)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home - ${loggedInUser?.username}"),
//         actions: [
//           if (loggedInUser?.role == "admin")
//             IconButton(
//                 icon: Icon(Icons.manage_accounts),
//                 onPressed: () => _manageAccounts(context)),
//           IconButton(
//               icon: Icon(Icons.logout), onPressed: () => _logout(context)),
//         ],
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => _openFiles(context),
//           child: Text("Open File Manager"),
//         ),
//       ),
//     );
//   }
// }

// // ======================= ACCOUNT MANAGEMENT =======================

// class AccountManagementScreen extends StatefulWidget {
//   @override
//   State<AccountManagementScreen> createState() =>
//       _AccountManagementScreenState();
// }

// class _AccountManagementScreenState extends State<AccountManagementScreen> {
//   void _addAccount() {
//     final uController = TextEditingController();
//     final pController = TextEditingController();
//     String role = "user";

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text("Add Account"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//                 controller: uController,
//                 decoration: InputDecoration(labelText: "Username")),
//             TextField(
//                 controller: pController,
//                 decoration: InputDecoration(labelText: "Password")),
//             DropdownButton<String>(
//               value: role,
//               items: ["admin", "user"]
//                   .map((r) => DropdownMenuItem(value: r, child: Text(r)))
//                   .toList(),
//               onChanged: (val) => setState(() => role = val ?? "user"),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context), child: Text("Cancel")),
//           ElevatedButton(
//             onPressed: () {
//               accountBox.add(Account(
//                   username: uController.text,
//                   password: pController.text,
//                   role: role));
//               setState(() {});
//               Navigator.pop(context);
//             },
//             child: Text("Save"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _deleteAccount(Account acc) {
//     if (acc.undeletable) return;
//     acc.delete();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Account Management")),
//       body: ListView(
//         children: accountBox.values
//             .map((a) => ListTile(
//                   title: Text("${a.username} (${a.role})"),
//                   trailing: a.undeletable
//                       ? Text("Default", style: TextStyle(color: Colors.grey))
//                       : IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () => _deleteAccount(a)),
//                 ))
//             .toList(),
//       ),
//       floatingActionButton:
//           FloatingActionButton(onPressed: _addAccount, child: Icon(Icons.add)),
//     );
//   }
// }

// // ======================= FILES SCREEN =======================

// class FilesScreen extends StatefulWidget {
//   final Folder folder;
//   FilesScreen({required this.folder});

//   @override
//   State<FilesScreen> createState() => _FilesScreenState();
// }

// class _FilesScreenState extends State<FilesScreen> {
//   late Folder _currentFolder;
//   bool _sortAsc = true;

//   @override
//   void initState() {
//     super.initState();
//     _currentFolder = widget.folder;
//   }

//   void _addFolder() {
//     final controller = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text("New Folder"),
//         content: TextField(
//             controller: controller,
//             decoration: InputDecoration(labelText: "Folder name")),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context), child: Text("Cancel")),
//           ElevatedButton(
//             onPressed: () {
//               final newFolder = Folder(name: controller.text);
//               _currentFolder.subfolders.add(newFolder);
//               _currentFolder.save();
//               setState(() {});
//               Navigator.pop(context);
//             },
//             child: Text("Create"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _uploadFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       final f = result.files.single;
//       final titleController = TextEditingController();
//       final descController = TextEditingController();

//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: Text("File Metadata"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                   controller: titleController,
//                   decoration: InputDecoration(labelText: "Title")),
//               TextField(
//                   controller: descController,
//                   decoration: InputDecoration(labelText: "Description")),
//             ],
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () => Navigator.pop(context), child: Text("Cancel")),
//             ElevatedButton(
//               onPressed: () {
//                 _currentFolder.files.add(FileItem(
//                   name: f.name,
//                   path: f.path ?? "",
//                   title: titleController.text,
//                   description: descController.text,
//                 ));
//                 _currentFolder.save();
//                 setState(() {});
//                 Navigator.pop(context);
//               },
//               child: Text("Save"),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   void _deleteFolder(Folder folder) {
//     _currentFolder.subfolders.remove(folder);
//     _currentFolder.save();
//     setState(() {});
//   }

//   void _deleteFile(FileItem file) {
//     _currentFolder.files.remove(file);
//     _currentFolder.save();
//     setState(() {});
//   }

//   void _renameFolder(Folder folder) {
//     final controller = TextEditingController(text: folder.name);
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text("Rename Folder"),
//         content: TextField(
//             controller: controller,
//             decoration: InputDecoration(labelText: "Folder name")),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context), child: Text("Cancel")),
//           ElevatedButton(
//             onPressed: () {
//               folder.name = controller.text;
//               _currentFolder.save();
//               setState(() {});
//               Navigator.pop(context);
//             },
//             child: Text("Save"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _renameFile(FileItem file) {
//     final titleController = TextEditingController(text: file.title);
//     final descController = TextEditingController(text: file.description);
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text("Edit File Info"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//                 controller: titleController,
//                 decoration: InputDecoration(labelText: "Title")),
//             TextField(
//                 controller: descController,
//                 decoration: InputDecoration(labelText: "Description")),
//           ],
//         ),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context), child: Text("Cancel")),
//           ElevatedButton(
//             onPressed: () {
//               file.title = titleController.text;
//               file.description = descController.text;
//               _currentFolder.save();
//               setState(() {});
//               Navigator.pop(context);
//             },
//             child: Text("Save"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sortedFolders = List.from(_currentFolder.subfolders)
//       ..sort((a, b) =>
//           _sortAsc ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
//     final sortedFiles = List.from(_currentFolder.files)
//       ..sort((a, b) =>
//           _sortAsc ? a.title.compareTo(b.title) : b.title.compareTo(a.title));

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Files - ${_currentFolder.name}"),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (val) => setState(() => _sortAsc = val == "asc"),
//             itemBuilder: (_) => [
//               PopupMenuItem(value: "asc", child: Text("Sort A → Z")),
//               PopupMenuItem(value: "desc", child: Text("Sort Z → A")),
//             ],
//           ),
//         ],
//       ),
//       body: ListView(
//         children: [
//           ...sortedFolders.map((f) => ListTile(
//                 leading: Icon(Icons.folder),
//                 title: Text(f.name),
//                 onTap: () => setState(() => _currentFolder = f),
//                 trailing: loggedInUser?.role == "admin"
//                     ? PopupMenuButton<String>(
//                         onSelected: (val) {
//                           if (val == "rename") _renameFolder(f);
//                           if (val == "delete") _deleteFolder(f);
//                         },
//                         itemBuilder: (_) => [
//                           PopupMenuItem(value: "rename", child: Text("Rename")),
//                           PopupMenuItem(value: "delete", child: Text("Delete")),
//                         ],
//                       )
//                     : null,
//               )),
//           ...sortedFiles.map((file) => ListTile(
//                 leading: Icon(Icons.insert_drive_file),
//                 title: Text(file.title.isNotEmpty ? file.title : file.name),
//                 subtitle: Text(file.description),
//                 trailing: loggedInUser?.role == "admin"
//                     ? PopupMenuButton<String>(
//                         onSelected: (val) {
//                           if (val == "rename") _renameFile(file);
//                           if (val == "delete") _deleteFile(file);
//                         },
//                         itemBuilder: (_) => [
//                           PopupMenuItem(value: "rename", child: Text("Edit")),
//                           PopupMenuItem(value: "delete", child: Text("Delete")),
//                         ],
//                       )
//                     : null,
//               )),
//         ],
//       ),
//       floatingActionButton: loggedInUser?.role == "admin"
//           ? Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 FloatingActionButton(
//                     onPressed: _addFolder,
//                     child: Icon(Icons.create_new_folder)),
//                 SizedBox(height: 10),
//                 FloatingActionButton(
//                     onPressed: _uploadFile, child: Icon(Icons.upload_file)),
//               ],
//             )
//           : null,
//     );
//   }
// }
