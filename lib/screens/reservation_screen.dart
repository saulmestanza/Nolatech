import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nolatech/bloc/court/court_bloc.dart';
import 'package:nolatech/bloc/court/court_event.dart';
import 'package:nolatech/bloc/reservation/reservation_bloc.dart';
import 'package:nolatech/bloc/reservation/reservation_event.dart';
import 'package:nolatech/bloc/reservation/reservation_state.dart';
import 'package:nolatech/models/court_model.dart';
import 'package:nolatech/models/reservation_model.dart';
import 'package:nolatech/models/user_model.dart';
import 'package:nolatech/screens/home_screen.dart';
import 'package:nolatech/utils/utils.dart';

class ReservationPage extends StatefulWidget {
  final CourtModel court;
  final UserModel user;

  const ReservationPage({super.key, required this.court, required this.user});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? selectedInstructor;
  late ReservationModel reservationModel;
  late bool isFavorite;
  TextEditingController commentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> instructors = [
    'Mark Gonzales',
    'Jose Blancas',
    'Cristian Leon',
    'Mushu Toti',
  ];

  @override
  void initState() {
    reservationModel = ReservationModel();
    isFavorite = widget.court.isFavorite!;
    super.initState();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: widget.court.startTime!,
      lastDate: widget.court.startTime!,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectStartTime() async {
    TimeOfDay time = TimeOfDay.fromDateTime(widget.court.startTime!);
    final TimeOfDay? pickedStart = await showTimePicker(
      context: context,
      initialTime: startTime ?? time,
    );

    if (pickedStart != null) {
      setState(() {
        startTime = pickedStart;
      });
      reservationModel = reservationModel.copyWith(
        startTime: Utils().timeOfDayToDateTime(startTime!, date: selectedDate),
      );
    }
  }

  Future<void> _selectEndTime() async {
    TimeOfDay time = TimeOfDay.fromDateTime(widget.court.endTime!);
    final TimeOfDay? pickedEnd = await showTimePicker(
      context: context,
      initialTime: endTime ?? time,
    );

    if (pickedEnd != null) {
      setState(() {
        endTime = pickedEnd;
      });
      reservationModel = reservationModel.copyWith(
        endTime: Utils().timeOfDayToDateTime(endTime!, date: selectedDate),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  widget.court.imageUrl!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      setState(() => isFavorite = !isFavorite);
                      context.read<CourtBloc>().add(
                        UpdateCourtFavorite(widget.court),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.yellow : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            BlocBuilder<ReservationBloc, ReservationState>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.court.title!,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '\$${widget.court.price}',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  'Por hora',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          widget.court.type!,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Disponible'),
                            SizedBox(width: 16),
                            Icon(Icons.access_time, size: 16),
                            SizedBox(width: 16),
                            Text(
                              "${DateFormat('Hm').format(widget.court.startTime!)} - ${DateFormat('Hm').format(widget.court.endTime!)}",
                            ),
                            SizedBox(width: 16),
                            Icon(Icons.sunny_snowing, size: 15),
                            Text(
                              widget.court.weather ?? "",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        state is ReservationConfirm
                            ? confirmReservation()
                            : createReservation(state),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget confirmReservation() {
    final price = reservationModel.time! * reservationModel.courtModel!.price!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resumen',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SummaryRow(
                  icon: Icons.sports_soccer,
                  text: reservationModel.courtModel!.type!,
                ),
                const SizedBox(height: 8),
                SummaryRow(
                  icon: Icons.calendar_today,
                  text: DateFormat(
                    'EEEE, d MMM, yyyy',
                  ).format(reservationModel.startTime!),
                ),
                const SizedBox(height: 8),
                SummaryRow(
                  icon: Icons.person_outline,
                  text: reservationModel.instructor!,
                ),
                const SizedBox(height: 8),
                SummaryRow(
                  icon: Icons.access_time,
                  text: '${reservationModel.time} horas',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Total Payment
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total a pagar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                Text(
                  '\$$price',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text('Por ${reservationModel.time} horas'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Center(
          child: SizedBox(
            width: 250,
            child: OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(),
              ),
              icon: const Icon(Icons.calendar_month),
              label: const Text('Reprogramar reserva'),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            context.read<ReservationBloc>().add(
              CreateReservation(reservationModel),
            );
            context.read<CourtBloc>().add(
              UpdateCourtAvailability(widget.court),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(userModel: widget.user),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Pagar', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(userModel: widget.user),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Cancelar', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Widget createReservation(ReservationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 20),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                widget.court.address!,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedInstructor,
              hint: Text('Selecciona un instructor'),
              isExpanded: true,
              items:
                  instructors.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedInstructor = newValue!;
                });
                reservationModel = reservationModel.copyWith(
                  instructor: selectedInstructor,
                );
              },
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Establecer fecha y hora',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                      : 'Seleccionar fecha',
                  style: TextStyle(color: Colors.blue),
                ),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _selectStartTime,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      startTime != null
                          ? '${startTime!.format(context)} hrs'
                          : 'Hora de Inicio:',
                      style: TextStyle(color: Colors.blue),
                    ),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: _selectEndTime,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      endTime != null
                          ? '${endTime!.format(context)} hrs'
                          : 'Hora de fin:',
                      style: TextStyle(color: Colors.blue),
                    ),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Agregar un comentario',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            validator:
                (value) =>
                    value != null && value.isNotEmpty
                        ? null
                        : 'Ingrese un comentario',
            controller: commentController,
            maxLines: 4,
            decoration: InputDecoration.collapsed(
              hintText: "Agregar un comentario...",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        SizedBox(height: 24),
        state is ReservationLoading
            ? Center(child: CircularProgressIndicator())
            : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF97BF0F),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      selectedInstructor != null &&
                      selectedDate != null &&
                      startTime != null &&
                      endTime != null) {
                    reservationModel = reservationModel.copyWith(
                      comment: commentController.text,
                      courtModel: widget.court,
                      userModel: widget.user,
                      time:
                          reservationModel.endTime!
                              .difference(reservationModel.startTime!)
                              .inHours,
                    );
                    context.read<ReservationBloc>().add(ConfirmReservation());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Seleccione todos los campos.')),
                    );
                  }
                },
                child: Text(
                  'Reservar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
      ],
    );
  }
}

class SummaryRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const SummaryRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}
