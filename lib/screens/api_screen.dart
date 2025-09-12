// screens/api_screen.dart
// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:cmdsidocs/api_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import '../custom_dialogs.dart';
import '../http_request.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key, this.menuId});

  final int? menuId;

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  List<dynamic> menus = [];
  List<dynamic> apiDocs = [];
  bool isLoading = true;
  int menuId = 0;

  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {};

  @override
  void initState() {
    super.initState();
    menuId = widget.menuId ?? 0;
    _loadMenus();
  }

  Future<void> _loadMenus() async {
    final response =
        await HTTPRequest(subApi: '${APIConfig.apiMenus}/page/0').get();

    setState(() {
      if (response['success'] == 'Y') {
        menus = response['items'];
      }

      isLoading = false;
    });
  }

  Future<void> _loadApiDocumentation() async {
    final response =
        await HTTPRequest(subApi: '${APIConfig.apiMenus}/$menuId/content')
            .get();

    setState(() {
      if (response['success'] == 'Y') {
        apiDocs = response["items"]["content"];
      }

      isLoading = false;
    });
  }

  // void _scrollToSection(String title) {
  //   final key = _sectionKeys[title];
  //   if (key != null && key.currentContext != null) {
  //     Scrollable.ensureVisible(
  //       key.currentContext!,
  //       duration: const Duration(milliseconds: 400),
  //       curve: Curves.easeInOut,
  //     );
  //   }
  // }

  // Restore Add dialog + insertion logic
  void _addNewApiDocumentation() {
    showDialog(
      context: context,
      builder: (context) => AddApiDocumentationDialog(
        onSave: (newDoc) async {
          const CustomDialog(onWillPop: false).loadingDialog();
          List alisto = List.of(apiDocs);
          alisto.add(newDoc);

          final response = await HTTPRequest(
              subApi: '${APIConfig.apiMenus}/$menuId/content',
              parameters: {"content": jsonEncode(alisto)}).post();

          Get.back();

          if (response["success"] == 'Y') {
            setState(() => apiDocs.add(newDoc));
            Get.back();
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text('Added: ${newDoc["title"]}')),
            );
          } else {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text('Failed to add: ${newDoc["title"]}')),
            );
          }
        },
      ),
    );
  }

  void _addNewMenu() {
    showDialog(
      context: context,
      builder: (context) => AddApiMenuDialog(
        menus: menus,
        onSave: (menu) async {
          const CustomDialog(onWillPop: false).loadingDialog();

          final response =
              await HTTPRequest(subApi: APIConfig.apiMenus, parameters: menu)
                  .post();

          Get.back();

          if (response["success"] == 'Y') {
            if (menu["is_main_page"] == 'Y') {
              setState(() => menus.add(menu));
            } else {
              setState(() => menus = menus.map((item) {
                    if (item["menu_id"] == menu["parent_menu_id"]) {
                      item["children"].add(menu);
                    }
                    return item;
                  }).toList());
            }
            Get.back();
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text('Added: ${menu["title"]}')),
            );
          } else {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text('Failed to add: ${menu["title"]}')),
            );
          }
        },
      ),
    );
  }

  Widget _buildSidebar(bool isMobile) {
    return Container(
      width: isMobile ? null : 240,
      color: Colors.grey[100],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'API Reference',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.blue),
                tooltip: "Add Menu",
                onPressed: _addNewMenu,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...menus.map((entry) {
            return ExpansionTile(
              title: Text(
                entry["title"],
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: (entry["children"] as List).map<Widget>((doc) {
                if (doc["children"] != null &&
                    (doc["children"] as List).isNotEmpty) {
                  // 🔁 Submenu (recursively ExpansionTile)
                  return ExpansionTile(
                    title: Text(
                      doc["title"],
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    children: (doc["children"] as List).map<Widget>((subDoc) {
                      return ListTile(
                        title: Text(
                          subDoc["title"],
                          style: GoogleFonts.poppins(fontSize: 13),
                        ),
                        onTap: () {
                          if (isMobile) Navigator.pop(context);
                          setState(() => menuId = subDoc["id"]);
                          _loadApiDocumentation();
                        },
                      );
                    }).toList(),
                  );
                } else {
                  // ✅ Regular page (no children)
                  return ListTile(
                    title: Text(
                      doc["title"],
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    onTap: () {
                      if (isMobile) Navigator.pop(context);
                      setState(() => menuId = doc["menu_id"]);
                      _loadApiDocumentation();
                    },
                  );
                }
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: const Text("API Reference"),
              backgroundColor: Colors.white,
            )
          : null,
      drawer: isMobile
          ? Drawer(
              child: _buildSidebar(true),
            )
          : null,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                if (!isMobile) _buildSidebar(false),

                // -------- Main Content --------
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: apiDocs
                          .map(
                            (api) => Container(
                              key: _sectionKeys[api["title"]],
                              margin: const EdgeInsets.only(bottom: 40),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    api["title"],
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    api["desc"],
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildCodeBlock(api["code"], 'http'),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),

      // -------- Floating Add Button --------
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewApiDocumentation,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCodeBlock(String code, String language) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 45, 16, 16),
            child: SelectableText(
              code,
              style: GoogleFonts.firaCode(
                fontSize: 14,
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    language.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Code copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.content_copy,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Add Menu
class AddApiMenuDialog extends StatefulWidget {
  const AddApiMenuDialog(
      {super.key, required this.onSave, required this.menus});
  final Function(dynamic) onSave;
  final List<dynamic> menus;

  @override
  State<AddApiMenuDialog> createState() => _AddApiMenuDialogState();
}

class _AddApiMenuDialogState extends State<AddApiMenuDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _codeController = TextEditingController();
  String? isMainPage = 'Y';
  String? parentMenuId;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _onSave() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Title required')));
      return;
    }

    widget.onSave({
      "page_id": 0,
      "title": title,
      "desc": description,
      "is_main_page": isMainPage ?? 'Y',
      "parent_menu_id": parentMenuId,
      "children": []
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Menu',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Is main menu?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: [
                const DropdownMenuItem(
                    value: null, child: Text('Select (Y/N)')),
                ...[
                  {"text": 'Yes', "value": 'Y'},
                  {"text": 'No', "value": 'N'}
                ].map(
                  (item) => DropdownMenuItem(
                    value: item["value"],
                    child: Text(item["text"] as String),
                  ),
                ),
              ],
              value: isMainPage,
              onChanged: (value) => setState(
                () => isMainPage = value,
              ),
            ),
            if ((isMainPage ?? 'Y') == 'N') ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Parent menu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text('Select parent menu')),
                  ...widget.menus.map(
                    (item) => DropdownMenuItem(
                      value: item["menu_id"].toString(),
                      child: Text(item["title"] as String),
                    ),
                  ),
                ],
                value: parentMenuId,
                onChanged: (value) => setState(
                  () => parentMenuId = value,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel')),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: _onSave, child: const Text('Save')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Add API dialog + code editor
class AddApiDocumentationDialog extends StatefulWidget {
  const AddApiDocumentationDialog(
      {super.key, required this.onSave, this.parentMenuId});
  final Function(Map<String, dynamic>) onSave;
  final int? parentMenuId;

  @override
  State<AddApiDocumentationDialog> createState() =>
      _AddApiDocumentationDialogState();
}

class _AddApiDocumentationDialogState extends State<AddApiDocumentationDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _codeController = TextEditingController();
  String isMainPage = '0';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _onSave() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final code = _codeController.text;

    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Title required')));
      return;
    }

    widget.onSave({"title": title, "desc": description, "code": code});
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New API Documentation',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Code',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              child: CodeEditorField(controller: _codeController),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel')),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: _onSave, child: const Text('Save')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CodeEditorField extends StatefulWidget {
  final TextEditingController controller;
  const CodeEditorField({super.key, required this.controller});

  @override
  State<CodeEditorField> createState() => _CodeEditorFieldState();
}

class _CodeEditorFieldState extends State<CodeEditorField> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2D2D2D),
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(minHeight: 160),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        style: GoogleFonts.firaCode(
          fontSize: 13,
          color: Colors.white,
          height: 1.5,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isCollapsed: true,
        ),
        cursorColor: Colors.white,
      ),
    );
  }
}
