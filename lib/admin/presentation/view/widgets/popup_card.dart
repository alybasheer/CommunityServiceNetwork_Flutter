import 'package:flutter/material.dart';
import 'package:fyp_source_code/admin/presentation/controller/admin_panel_controller.dart';
import 'package:get/get.dart';

final AdminPanelController ctrl = Get.find<AdminPanelController>();
void popupCard(BuildContext context, String userId, int index) {
  final data = ctrl.res[index];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Volunteer Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),

            _infoRow("Name", data['name']),
            _infoRow("City", data['city']),
            _infoRow("Location", data['location']),
            _infoRow("Expertise", data['expertise']),
            _infoRow("Reason", data['reason']),
            _infoRow("CNIC", data['cnic']),

            const SizedBox(height: 8),

            // Status badge
            Row(
              children: [
                Text("Status:", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(data['status']).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    data['status'].toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(data['status']),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ctrl.approveVolunteer(userId);
                  },
                  child: Text("Approve"),
                ),
                ElevatedButton(
                  onPressed: () {
                    ctrl.rejectVolunteer(userId);
                  },
                  child: Text("Reject"),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget _infoRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            "$title:",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: title == "Location" ? 2 : null,
            overflow:
                title == "Location"
                    ? TextOverflow.ellipsis
                    : TextOverflow.visible,
            style: TextStyle(color: Colors.grey[800], fontSize: 14),
          ),
        ),
      ],
    ),
  );
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'approved':
      return Colors.green;
    case 'pending':
      return Colors.orange;
    case 'rejected':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
