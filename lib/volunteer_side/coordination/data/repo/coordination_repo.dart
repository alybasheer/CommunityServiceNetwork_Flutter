import 'package:fyp_source_code/network/api_service.dart';
import 'package:fyp_source_code/services/api_names.dart';
import 'package:fyp_source_code/volunteer_side/coordination/data/model/coordination_contact.dart';

class CoordinationRepo {
  final DioHelper _dioHelper = DioHelper();

  Future<CoordinationContactsResult> getContacts() async {
    final response = await _dioHelper.get(
      url: ApiNames.coordinationContacts,
      isauthorize: true,
    );

    final requestees = <CoordinationContact>[];
    final volunteers = <CoordinationContact>[];

    if (response is List) {
      _addContacts(response, requestees, volunteers);
    } else if (response is Map) {
      final map = Map<String, dynamic>.from(response);
      final data = map['data'];
      if (data is Map) {
        final dataMap = Map<String, dynamic>.from(data);
        _addContacts(dataMap['requestees'], requestees, volunteers);
        _addContacts(dataMap['volunteers'], requestees, volunteers);
        _addContacts(dataMap['contacts'], requestees, volunteers);
      } else if (data is List) {
        _addContacts(data, requestees, volunteers);
      }
      _addContacts(map['requestees'], requestees, volunteers);
      _addContacts(map['volunteers'], requestees, volunteers);
      _addContacts(map['contacts'], requestees, volunteers);
    }

    return CoordinationContactsResult(
      requestees: requestees,
      volunteers: volunteers,
    );
  }

  void _addContacts(
    dynamic value,
    List<CoordinationContact> requestees,
    List<CoordinationContact> volunteers,
  ) {
    if (value is! List) {
      return;
    }

    for (final item in value) {
      if (item is! Map) {
        continue;
      }
      final contact = CoordinationContact.fromJson(
        Map<String, dynamic>.from(item),
      );
      if (contact.id.isEmpty) {
        continue;
      }
      if (contact.isVolunteer) {
        if (!volunteers.any((e) => e.id == contact.id)) {
          volunteers.add(contact);
        }
      } else if (!requestees.any((e) => e.id == contact.id)) {
        requestees.add(contact);
      }
    }
  }
}

class CoordinationContactsResult {
  final List<CoordinationContact> requestees;
  final List<CoordinationContact> volunteers;

  CoordinationContactsResult({
    required this.requestees,
    required this.volunteers,
  });
}
