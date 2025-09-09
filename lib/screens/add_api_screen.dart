// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';

// class PositionScreen extends StatefulWidget {
//   const PositionScreen({super.key});

//   @override
//   State<PositionScreen> createState() => _PositionScreenState();
// }

// class _PositionScreenState extends State<PositionScreen>
//     with TickerProviderStateMixin {
//   bool _isSidebarOpen = true;
//   double? _lastScreenWidth;
//   List<dynamic> _positions = [];
//   List<dynamic> _filteredPositions = [];
//   int _currentPage = 1;
//   final int _rowsPerPage = 10;

//   @override
//   void initState() {
//     super.initState();
//     //_fetchData();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final width = MediaQuery.of(context).size.width;
//     final isUltraSmallScreen = width <= 400;
//     if (_lastScreenWidth == null ||
//         (_lastScreenWidth! > 400 && isUltraSmallScreen)) {
//       if (isUltraSmallScreen && _isSidebarOpen) {
//         setState(() {
//           _isSidebarOpen = false;
//         });
//       }
//     }
//     _lastScreenWidth = width;
//   }

//   // Future<void> _fetchData() async {
//   //   final response =
//   //       await APIServiceConfig(subAPI: '${APIConfig.positions}/getAllPositions')
//   //           .fetch();

//   //   setState(() {
//   //     _positions = response;
//   //     _filteredPositions = List.from(_positions);
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isSmallScreen = size.width <= 768;
//     final isVerySmallScreen = size.width <= 500;
//     final isUltraSmallScreen = size.width <= 400;
//     final startIndex = (_currentPage - 1) * _rowsPerPage;
//     final endIndex = (startIndex + _rowsPerPage).clamp(
//       0,
//       _filteredPositions.length,
//     );
//     final totalPages = (_filteredPositions.length / _rowsPerPage).ceil();
//     final mainPadding =
//         isUltraSmallScreen ? 12.0 : (isVerySmallScreen ? 16.0 : 24.0);
//     final currentPagePositions = _filteredPositions.sublist(
//       startIndex,
//       endIndex,
//     );

//     return Scaffold(
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         padding: EdgeInsets.all(mainPadding),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(
//                   12,
//                 ),
//               ),
//               color: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     LayoutBuilder(
//                       builder: (
//                         context,
//                         constraints,
//                       ) =>
//                           SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         physics: const BouncingScrollPhysics(),
//                         child: ConstrainedBox(
//                           constraints: BoxConstraints(
//                             minWidth: constraints.maxWidth > 0
//                                 ? constraints.maxWidth - 32
//                                 : 300,
//                           ),
//                           child: AnimationLimiter(
//                             child: DataTable(
//                               columnSpacing: isSmallScreen ? 8 : 16,
//                               horizontalMargin: 16,
//                               headingRowHeight: 48,
//                               dataRowMaxHeight: 56,
//                               headingRowColor: WidgetStateColor.resolveWith(
//                                 (
//                                   states,
//                                 ) =>
//                                     const Color(
//                                   0xFF2E7D32,
//                                 ).withAlpha(
//                                   1,
//                                 ),
//                               ),
//                               dataRowColor: WidgetStateColor.resolveWith(
//                                 (states) => states.contains(
//                                   WidgetState.hovered,
//                                 )
//                                     ? Colors.grey.shade100
//                                     : Colors.white,
//                               ),
//                               columns: [
//                                 DataColumn(
//                                   label: Expanded(
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         // setState(() {
//                                         //   _sortColumn = 'title';
//                                         //   _sortAscending =
//                                         //       _sortColumn == 'title'
//                                         //           ? !_sortAscending
//                                         //           : true;
//                                         //   _sortPositions();
//                                         // });
//                                       },
//                                       child: Text(
//                                         'Position Name',
//                                         style: GoogleFonts.poppins(
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.grey.shade800,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 DataColumn(
//                                   label: Expanded(
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         // setState(() {
//                                         //   _sortColumn = 'position_desc';
//                                         //   _sortAscending =
//                                         //       _sortColumn == 'position_desc'
//                                         //           ? !_sortAscending
//                                         //           : true;
//                                         //   _sortPositions();
//                                         // });
//                                       },
//                                       child: Text(
//                                         'Description',
//                                         style: GoogleFonts.poppins(
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.grey.shade800,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 DataColumn(
//                                   label: Expanded(
//                                     child: Text(
//                                       'Active',
//                                       style: GoogleFonts.poppins(
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.grey.shade800,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                               rows: currentPagePositions.asMap().entries.map((
//                                 entry,
//                               ) {
//                                 final position = entry.value;

//                                 return DataRow(
//                                   cells: [
//                                     DataCell(
//                                       Text(
//                                         position['position_title'] ?? 'N/A',
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 14,
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                     DataCell(
//                                       Text(
//                                         position['position_desc'] ?? 'N/A',
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ),
//                                     DataCell(
//                                       Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           DropdownButton<String>(
//                                             value: position['is_active'] ?? 'N',
//                                             items: const [
//                                               DropdownMenuItem(
//                                                 value: 'Y',
//                                                 child: Text(
//                                                   'Yes',
//                                                 ),
//                                               ),
//                                               DropdownMenuItem(
//                                                 value: 'N',
//                                                 child: Text(
//                                                   'No',
//                                                 ),
//                                               ),
//                                             ],
//                                             onChanged: (
//                                               newStatus,
//                                             ) async {
//                                               // if (newStatus != null &&
//                                               //     newStatus !=
//                                               //         position['is_active']) {
//                                               //   dynamic parameters =
//                                               //       Map.of(position);

//                                               //   parameters["is_active"] =
//                                               //       newStatus;

//                                               //   APIServiceConfig(
//                                               //           subAPI:
//                                               //               '${APIConfig.positions}/updatePosition',
//                                               //           callBack: _fetchData,
//                                               //           parameters: parameters)
//                                               //       .update();
//                                               // }
//                                             },
//                                             style: GoogleFonts.poppins(
//                                               fontSize: 12,
//                                             ),
//                                             iconSize: 16,
//                                             underline: Container(),
//                                           ),
//                                           const SizedBox(
//                                             width: 8,
//                                           ),
//                                           IconButton(
//                                             icon: const Icon(
//                                               FontAwesomeIcons.penToSquare,
//                                               size: 16,
//                                               color: Color(
//                                                 0xFF2E7D32,
//                                               ),
//                                             ),
//                                             onPressed: () => add(context,
//                                                 position: position),
//                                             tooltip: 'Edit',
//                                           ),
//                                           IconButton(
//                                             icon: const Icon(
//                                               FontAwesomeIcons.trash,
//                                               size: 16,
//                                               color: Colors.red,
//                                             ),
//                                             onPressed: () {},
//                                             // onPressed: () => APIServiceConfig(
//                                             //     subAPI:
//                                             //         '${APIConfig.positions}/deletePosition',
//                                             //     callBack: _fetchData,
//                                             //     parameters: {
//                                             //       "position_id":
//                                             //           position["position_id"]
//                                             //     }).delete(),
//                                             tooltip: 'Delete',
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Page $_currentPage of $totalPages',
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             MouseRegion(
//                               cursor: _currentPage > 1
//                                   ? SystemMouseCursors.click
//                                   : SystemMouseCursors.basic,
//                               child: GestureDetector(
//                                 onTap: _currentPage > 1
//                                     ? () => setState(
//                                           () => _currentPage--,
//                                         )
//                                     : null,
//                                 child: AnimatedContainer(
//                                   duration: const Duration(
//                                     milliseconds: 200,
//                                   ),
//                                   padding: const EdgeInsets.all(
//                                     8,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: _currentPage > 1
//                                         ? Colors.white
//                                         : Colors.grey.shade200,
//                                     borderRadius: BorderRadius.circular(
//                                       8,
//                                     ),
//                                     border: Border.all(
//                                       color: _currentPage > 1
//                                           ? const Color(
//                                               0xFF2E7D32,
//                                             )
//                                           : Colors.grey.shade400,
//                                       width: 1,
//                                     ),
//                                     boxShadow: _currentPage > 1
//                                         ? [
//                                             BoxShadow(
//                                               color: Colors.grey.withOpacity(
//                                                 0.1,
//                                               ),
//                                               blurRadius: 4,
//                                               offset: const Offset(
//                                                 0,
//                                                 2,
//                                               ),
//                                             ),
//                                           ]
//                                         : null,
//                                   ),
//                                   child: Icon(
//                                     FontAwesomeIcons.chevronLeft,
//                                     size: 16,
//                                     color: _currentPage > 1
//                                         ? const Color(
//                                             0xFF2E7D32,
//                                           )
//                                         : Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             MouseRegion(
//                               cursor: _currentPage < totalPages
//                                   ? SystemMouseCursors.click
//                                   : SystemMouseCursors.basic,
//                               child: GestureDetector(
//                                 onTap: _currentPage < totalPages
//                                     ? () => setState(
//                                           () => _currentPage++,
//                                         )
//                                     : null,
//                                 child: AnimatedContainer(
//                                   duration: const Duration(
//                                     milliseconds: 200,
//                                   ),
//                                   padding: const EdgeInsets.all(
//                                     8,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: _currentPage < totalPages
//                                         ? Colors.white
//                                         : Colors.grey.shade200,
//                                     borderRadius: BorderRadius.circular(
//                                       8,
//                                     ),
//                                     border: Border.all(
//                                       color: _currentPage < totalPages
//                                           ? const Color(
//                                               0xFF2E7D32,
//                                             )
//                                           : Colors.grey.shade400,
//                                       width: 1,
//                                     ),
//                                     boxShadow: _currentPage < totalPages
//                                         ? [
//                                             BoxShadow(
//                                               color: Colors.grey.withOpacity(
//                                                 0.1,
//                                               ),
//                                               blurRadius: 4,
//                                               offset: const Offset(
//                                                 0,
//                                                 2,
//                                               ),
//                                             ),
//                                           ]
//                                         : null,
//                                   ),
//                                   child: Icon(
//                                     FontAwesomeIcons.chevronRight,
//                                     size: 16,
//                                     color: _currentPage < totalPages
//                                         ? const Color(
//                                             0xFF2E7D32,
//                                           )
//                                         : Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: FloatingActionButton(
//           onPressed: () async {
//             add(context);
//           },
//           child: const Icon(
//             Icons.add,
//             color: Colors.green,
//           ),
//         ),
//       ),
//     );
//   }

//   void add(BuildContext context, {dynamic position}) {
//     TextEditingController positionTitle = TextEditingController();
//     TextEditingController positionDesc = TextEditingController();

//     positionTitle.text = (position ?? {})["position_title"] ?? '';
//     positionDesc.text = (position ?? {})["position_desc"] ?? '';

//     bool _validateForm() {
//       // Title validation
//       if (positionTitle.text.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please enter a position title')),
//         );
//         return false;
//       }
//       if (positionTitle.text.length < 3) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('Title must be at least 3 characters long')),
//         );
//         return false;
//       }
//       if (positionTitle.text.length > 100) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Title must not exceed 100 characters')),
//         );
//         return false;
//       }

//       // Description validation
//       if (positionDesc.text.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please enter a description')),
//         );
//         return false;
//       }
//       if (positionDesc.text.length < 10) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('Description must be at least 10 characters long')),
//         );
//         return false;
//       }
//       if (positionDesc.text.length > 500) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('Description must not exceed 500 characters')),
//         );
//         return false;
//       }

//       return true;
//     }

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setDialogState) => Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 500),
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: AnimationConfiguration.toStaggeredList(
//                   duration: const Duration(milliseconds: 500),
//                   childAnimationBuilder: (widget) => SlideAnimation(
//                     verticalOffset: 50.0,
//                     child: FadeInAnimation(child: widget),
//                   ),
//                   children: [
//                     Text(
//                       '${position == null ? 'Add' : 'Edit'} Position',
//                       style: GoogleFonts.poppins(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     CustomLabel(
//                       label: 'Title',
//                       isRequired: true,
//                     ),
//                     const SizedBox(height: 8),
//                     CustomTextFormField(
//                       controller: positionTitle,
//                       hintText: 'e.g., President',
//                     ),
//                     const SizedBox(height: 15),
//                     CustomLabel(
//                       label: 'Description',
//                       isRequired: true,
//                     ),
//                     const SizedBox(height: 8),
//                     CustomTextFormField(
//                       controller: positionDesc,
//                       hintText: 'e.g., Highest Leader',
//                       maxLines: 3,
//                       maxLength: 500,
//                     ),
//                     const SizedBox(height: 24),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: Text(
//                             'Cancel',
//                             style: GoogleFonts.poppins(
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             // if (_validateForm()) {
//                             //   if (position == null) {
//                             //     APIServiceConfig(
//                             //         subAPI:
//                             //             '${APIConfig.positions}/insertPosition',
//                             //         callBack: _fetchData,
//                             //         parameters: {
//                             //           "position_title": positionTitle.text,
//                             //           "position_desc": positionDesc.text,
//                             //         }).add();
//                             //   } else {
//                             //     APIServiceConfig(
//                             //         subAPI:
//                             //             '${APIConfig.positions}/updatePosition',
//                             //         callBack: _fetchData,
//                             //         parameters: {
//                             //           "position_id": position["position_id"],
//                             //           "position_title": positionTitle.text,
//                             //           "position_desc": positionDesc.text,
//                             //           "is_active": position["is_active"],
//                             //         }).update();
//                             //   }
//                             //   Navigator.pop(context);
//                             // }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF2E7D32),
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: Text(
//                             'Save',
//                             style: GoogleFonts.poppins(),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
