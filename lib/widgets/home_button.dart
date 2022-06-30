
// class HomeButton extends StatelessWidget {
//   String? title;
//   VoidCallback? onTap;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 50,
//         width: 200,
//         decoration: BoxDecoration(
//           color: themeColor,
//           borderRadius: BorderRadius.circular(22),
//         ),
//         child: Center(
//           child: Text(
//             title ?? '',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w500,
//               fontSize: 20,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }