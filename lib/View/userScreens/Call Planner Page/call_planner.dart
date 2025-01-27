import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:micro_pharma/components/constants.dart';
import 'package:micro_pharma/models/area_model.dart';
import 'package:micro_pharma/models/day_plan_model.dart';
import 'package:micro_pharma/models/doctor_model.dart';
import 'package:micro_pharma/viewModel/area_provider.dart';
import 'package:micro_pharma/viewModel/doctor_provider.dart';
import 'package:micro_pharma/viewModel/user_data_provider.dart';
import 'package:micro_pharma/View/userScreens/Call%20Planner%20Page/select_doctors.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../models/user_model.dart';
import '../../../viewModel/day_plans_provider.dart';

class CallPlanner extends StatefulWidget {
  static const String id = 'call_planner';

  const CallPlanner({Key? key}) : super(key: key);

  @override
  State<CallPlanner> createState() => _CallPlannerState();
}

class _CallPlannerState extends State<CallPlanner> {
  DateTime _selectedDate = DateTime.now();

  AreaModel? _selectedArea;

  List<String> _selectedDoctors = [];

  bool _isDayPlanEnabled = false;
  String _selectedShift = 'Morning';

  final TextEditingController _doctorController = TextEditingController();

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    Provider.of<AreaProvider>(context, listen: false).fetchAreas();
    Provider.of<DoctorDataProvider>(context, listen: false).fetchDoctors();
    Provider.of<UserDataProvider>(context, listen: false)
        .fetchUserData(user!.uid);

    super.initState();
  }

  void _onDateSelected(DateTime date, DateTime day) {
    setState(() {
      // Extract only the date part of the selected date
      _selectedDate = date;
    });
  }

  void _clearDayPlanSelection() {
    setState(() {
      _selectedArea = null;
      _selectedDoctors = [];
      _doctorController.clear();
      _isDayPlanEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<AreaModel> areaList = Provider.of<AreaProvider>(context).getAreas;
    List<DoctorModel> doctors =
        Provider.of<DoctorDataProvider>(context).getDoctorList;
    UserModel? userData =
        Provider.of<UserDataProvider>(context, listen: false).getUserData;
    List<AreaModel>? assignedAreas = userData.assignedAreas;

    return Scaffold(
      appBar: const MyAppBar(
        appBartxt: 'Call Planner',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _selectedDate,
              calendarFormat: CalendarFormat.week,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: _onDateSelected,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: DropdownButtonFormField<String?>(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Select Area';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Select Area',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        ),
                        value: _selectedArea?.areaName,
                        onChanged: (value) {
                          setState(() {
                            _selectedArea = assignedAreas?.firstWhere(
                                    (area) => area.areaName == value) ??
                                areaList.firstWhere(
                                  (area) => area.areaName == value,
                                );
                          });
                        },
                        items: assignedAreas
                                ?.map((area) => DropdownMenuItem(
                                      value: area.areaName,
                                      child: Text(area.areaName),
                                    ))
                                .toList() ??
                            areaList
                                .map(
                                  (area) => DropdownMenuItem(
                                    value: area.areaName,
                                    child: Text(area.areaName),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedShift,
                      hint: const Text('Select Shift'),
                      items: <String>['Morning', 'Evening'].map((String shift) {
                        return DropdownMenuItem<String>(
                          value: shift,
                          child: Text(shift),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedShift = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _isDayPlanEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isDayPlanEnabled = value ?? false;
                    });
                  },
                ),
                const Text('Add Day Plan'),
              ],
            ),
            if (_isDayPlanEnabled)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _doctorController,
                      decoration: const InputDecoration(
                        hintText: 'Select Doctors',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () async {
                        // Show doctors selection dialog
                        final filteredDoctors = _selectedArea != null
                            ? doctors
                                .where((doctor) =>
                                    doctor.area == _selectedArea!.areaName)
                                .toList()
                            : doctors;
                        final selectedDoctors = await showDialog<List<String>>(
                          context: context,
                          builder: (_) {
                            final allDoctors = filteredDoctors
                                .map((doctor) => doctor.name)
                                .toSet();
                            return SelectDoctorsDialog(
                                allDoctors: allDoctors,
                                selectedDoctors: _selectedDoctors);
                          },
                        );
                        if (selectedDoctors != null) {
                          setState(() {
                            _selectedDoctors = selectedDoctors;
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _selectedDoctors.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          tileColor: Colors.amber[100],
                          title: Text(_selectedDoctors.elementAt(index)),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    MyButton(
                      text: 'Submit Day Plan',
                      color: Colors.teal,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          final userData = Provider.of<UserDataProvider>(
                                  context,
                                  listen: false)
                              .getUserData;
                          if (_selectedDoctors.isNotEmpty) {
                            final newDayPlan = DayPlanModel(
                              shift: _selectedShift,
                              userName: userData.displayName!,
                              date: _selectedDate,
                              area: _selectedArea!.areaName,
                              doctors: _selectedDoctors.toList(),
                            );
                            await Provider.of<DayPlanProvider>(context,
                                    listen: false)
                                .addDayPlan(newDayPlan);

                            showCustomDialog(
                                context: navigatorKey.currentContext!,
                                title: 'Success',
                                content: 'Day Plan Added');

                            _clearDayPlanSelection();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
