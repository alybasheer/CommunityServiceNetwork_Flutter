import 'package:fyp_source_code/communities/data/model/community_model.dart';
import 'package:fyp_source_code/network/api_service.dart';
import 'package:fyp_source_code/services/api_names.dart';

class CommunitiesRepo {
  final DioHelper _dioHelper = DioHelper();

  Future<List<CommunityModel>> getCommunities({
    String? category,
    String? status,
    double? latitude,
    double? longitude,
    double radiusKm = 10,
  }) async {
    final response = await _dioHelper.get(
      url: ApiNames.communities(
        category: category,
        status: status,
        lat: latitude,
        lng: longitude,
        radius: radiusKm,
      ),
      isauthorize: true,
    );

    return _extractList(response, const ['communities', 'items'])
        .map((e) => CommunityModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<CommunityModel> createCommunity(Object? reqBody) async {
    final response = await _dioHelper.post(
      url: ApiNames.communitiesBase,
      reqBody: reqBody,
      isauthorize: true,
    );
    return _parseCommunity(response);
  }

  Future<CommunityModel> joinCommunity(String id) async {
    final response = await _dioHelper.post(
      url: ApiNames.joinCommunity(id),
      isauthorize: true,
    );
    return _parseCommunity(response);
  }

  Future<CommunityModel> startCommunity(String id) async {
    final response = await _dioHelper.patch(
      url: ApiNames.startCommunity(id),
      isauthorize: true,
    );
    return _parseCommunity(response);
  }

  Future<dynamic> deleteCommunity(String id) {
    return _dioHelper.delete(
      url: ApiNames.deleteCommunity(id),
      isauthorize: true,
    );
  }

  Future<List<CommunityMessage>> getMessages(String id) async {
    final response = await _dioHelper.get(
      url: ApiNames.communityMessages(id),
      isauthorize: true,
    );

    return _extractList(response, const ['messages'])
        .map((e) => CommunityMessage.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<CommunityMessage> sendMessage(String id, String content) async {
    final response = await _dioHelper.post(
      url: ApiNames.communityMessages(id),
      reqBody: {'content': content},
      isauthorize: true,
    );

    if (response is Map) {
      final map = Map<String, dynamic>.from(response);
      final data = map['data'];
      if (data is Map) {
        final dataMap = Map<String, dynamic>.from(data);
        if (dataMap['message'] is Map) {
          return CommunityMessage.fromJson(
            Map<String, dynamic>.from(dataMap['message']),
          );
        }
        return CommunityMessage.fromJson(dataMap);
      }
      if (map['message'] is Map) {
        return CommunityMessage.fromJson(
          Map<String, dynamic>.from(map['message']),
        );
      }
      return CommunityMessage.fromJson(map);
    }

    throw Exception('Unexpected response format for community message');
  }

  CommunityModel _parseCommunity(dynamic response) {
    if (response is Map) {
      final map = Map<String, dynamic>.from(response);
      final data = map['data'];
      if (data is Map) {
        final dataMap = Map<String, dynamic>.from(data);
        if (dataMap['community'] is Map) {
          return CommunityModel.fromJson(
            Map<String, dynamic>.from(dataMap['community']),
          );
        }
        return CommunityModel.fromJson(dataMap);
      }
      if (map['community'] is Map) {
        return CommunityModel.fromJson(
          Map<String, dynamic>.from(map['community']),
        );
      }
      return CommunityModel.fromJson(map);
    }

    throw Exception('Unexpected response format for community');
  }

  List<dynamic> _extractList(dynamic response, List<String> keys) {
    if (response is List) {
      return response;
    }
    if (response is Map) {
      final map = Map<String, dynamic>.from(response);
      final data = map['data'];
      if (data is List) {
        return data;
      }
      if (data is Map) {
        final dataMap = Map<String, dynamic>.from(data);
        for (final key in keys) {
          if (dataMap[key] is List) {
            return dataMap[key] as List;
          }
        }
      }
      for (final key in keys) {
        if (map[key] is List) {
          return map[key] as List;
        }
      }
    }
    return <dynamic>[];
  }
}
