import 'doctor_visit_model.dart';

class DailyCallReportModel {
  String area;
  String submittedBy;
  final String? reportId;
  final DateTime date;
  final List<DoctorVisitModel> doctorsVisited;

  DailyCallReportModel({
    required this.area,
    this.reportId,
    required this.submittedBy,
    required this.date,
    List<DoctorVisitModel>? doctorVisits,
  }) : doctorsVisited = doctorVisits ?? [];

  Map<String, dynamic> toMap() {
    return {
      'reportId': reportId,
      'date': date.toIso8601String(),
      'doctorsVisited': doctorsVisited.map((visit) => visit.toMap()).toList(),
      'area': area,
      'submittedBy': submittedBy,
    };
  }

  factory DailyCallReportModel.fromMap(Map<String, dynamic> json, String id) {
    List<Map<String, dynamic>> visits = [];
    if (json['doctorsVisited'] != null) {
      var doctorVisitsData = json['doctorsVisited'];
      if (doctorVisitsData is List<dynamic>) {
        visits = List<Map<String, dynamic>>.from(doctorVisitsData);
      }
    }
    return DailyCallReportModel(
      reportId: id,
      date: DateTime.parse(json['date']),
      area: json['area'],
      doctorVisits:
          visits.map((visit) => DoctorVisitModel.fromMap(visit)).toList(),
          submittedBy: json['submittedBy']
    );
  }

  DailyCallReportModel copyWith({
    String? reportId,
    DateTime? date,
    List<DoctorVisitModel>? doctorsVisited,
    String? area,
    String? submittedBy
  }) {
    return DailyCallReportModel(
      area: area ?? this.area,
      reportId: reportId ?? this.reportId,
      date: date ?? this.date,
      doctorVisits: doctorsVisited ?? this.doctorsVisited,
      submittedBy: submittedBy ?? this.submittedBy
    );
  }
}
