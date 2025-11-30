class VolunteerVerification {
  String? sId;
  String? userId;
  String? name;
  String? city;
  String? location;
  String? expertise;
  String? reason;
  String? cnic;
  String? status;
  String? createdAt;
  String? updatedAt;

  VolunteerVerification({
    this.sId,
    this.userId,
    this.name,
    this.city,
    this.location,
    this.expertise,
    this.reason,
    this.cnic,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  VolunteerVerification.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    name = json['name'];
    city = json['city'];
    location = json['location'];
    expertise = json['expertise'];
    reason = json['reason'];
    cnic = json['cnic'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userId'] = userId;
    data['name'] = name;
    data['city'] = city;
    data['location'] = location;
    data['expertise'] = expertise;
    data['reason'] = reason;
    data['cnic'] = cnic;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
