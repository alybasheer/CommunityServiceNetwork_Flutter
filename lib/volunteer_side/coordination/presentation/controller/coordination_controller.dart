import 'package:get/get.dart';

class VolunteerRequest {
  final String id;
  final String name;
  final String location;
  final String timeAgo;
  final String avatarUrl;
  final bool accepted;

  VolunteerRequest({
    required this.id,
    required this.name,
    required this.location,
    required this.timeAgo,
    this.avatarUrl = '',
    this.accepted = false,
  });
}

class CoordinationController extends GetxController {
  // false = All, true = Accepted
  final RxBool showAccepted = false.obs;

  // sample data
  final RxList<VolunteerRequest> requests =
      <VolunteerRequest>[
        VolunteerRequest(
          id: '1',
          name: 'Ahmed Khan',
          location: 'North Nazimabad',
          timeAgo: '2 min ago',
          avatarUrl: '',
          accepted: true,
        ),
        VolunteerRequest(
          id: '2',
          name: 'Sara Ahmed',
          location: 'Clifton',
          timeAgo: '5 min ago',
          avatarUrl: '',
          accepted: false,
        ),
        VolunteerRequest(
          id: '3',
          name: 'Bilal Shah',
          location: 'Gulshan',
          timeAgo: '10 min ago',
          avatarUrl: '',
          accepted: true,
        ),
      ].obs;

  List<VolunteerRequest> get filteredRequests {
    if (showAccepted.value) {
      return requests.where((r) => r.accepted).toList();
    }
    return requests.toList();
  }

  void setShowAccepted(bool v) => showAccepted.value = v;
}
