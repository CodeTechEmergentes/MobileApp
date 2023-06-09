import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:codetech_app/models/fullname.dart';
import 'package:codetech_app/models/user.dart';
import 'package:codetech_app/utils/http_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<String> imgList = [
  'https://img.freepik.com/vector-premium/reparacion-computadoras-solucion-problemas-mantenimiento-circuitos-electricos-recuperacion-componentes-hardware-semiconductores-probador-ilustracion-vectorial_102902-6321.jpg?w=2000',
  'https://c8.alamy.com/compes/2hndp9n/tecnico-cambiar-e-insertar-la-bateria-nueva-del-portatil-servicio-de-reparacion-del-ordenador-2hndp9n.jpg',
  'https://informatica-soluciones.com/wp-content/uploads/2020/03/repotenciar-computadora.jpg',
  'https://i.ytimg.com/vi/yKP6X28ULzY/maxresdefault.jpg',
  'https://c8.alamy.com/compes/2g7a4nf/un-tecnico-profesional-en-electronica-de-computadoras-elimina-las-teclas-de-un-teclado-inalambrico-de-computadora-viejo-y-sucio-los-utiles-de-reparacion-y-limpieza-2g7a4nf.jpg',
  'https://i.ytimg.com/vi/F9Xga-9Kzsw/maxresdefault.jpg',
];

class Home_user extends StatefulWidget {
  const Home_user({Key? key}) : super(key: key);
  @override
  State<Home_user> createState() => _Home_userState();
  static const String routeName = "/home_user";
}

class _Home_userState extends State<Home_user> {
  HttpHelper httpHelper = HttpHelper();

  List appointments = [];

  User user = new User(
      id: 0,
      fullName: FullName(firstName: "", lastName: ""),
      dni: "",
      email: "",
      password: "",
      profilePictureUrl: "",
      address: "",
      phone: "",
      birthdayDate: "");

  @override
  void initState() {
    httpHelper = HttpHelper();
    appointments = [];
    Future.delayed(Duration.zero, () {
      setState(() {
        user = ModalRoute.of(context)?.settings.arguments as User;    
        getAppointmentsByUserIdAndStatus(user.id);
      });
    });
    fetchUser();
    super.initState();
  }

  Future fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userTemp = prefs.getString('user') ?? "";
    setState(() {
      if (userTemp != "") {
        user = User.fromJson(jsonDecode(userTemp) as Map<String, dynamic>);
      }
    });
  }

  Future getAppointmentsByUserIdAndStatus(int id) async {
    httpHelper
        .fetchAppointmentsByUserIdAndStatus(id, "SCHEDULED")
        .then((value) => {
              setState(() {
                this.appointments = value;
              })
            });

    return appointments;
    
  }

  Future fetchAppointmentsByUserIdAndStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    httpHelper
        .fetchAppointmentsByUserIdAndStatus(id!, "SCHEDULED")
        .then((value) {
      setState(() {
        this.appointments = value;
      });
    });
    return appointments;
  }

  Drawer getDrawer(BuildContext context) {
    fetchUser();
    var header = DrawerHeader(
      child: Container(
        padding: EdgeInsets.only(left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'CodeTech',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePictureUrl),
                      radius: 20.0,
                    ),
                    SizedBox(width: 10),
                    Text(
                      user.fullName.firstName + " " + user.fullName.lastName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(115, 103, 240, 94),
      ),
    );

    Container getItem(Icon icon, String description, String route) {
      return Container(
        padding: EdgeInsets.only(left: 10.0),
        child: ListTile(
          leading: icon,
          title: Text(description),
          onTap: () {
            setState(() {
              Navigator.of(context).pushNamed(route);
            });
          },
        ),
      );
    }

    ListView listView = ListView(
      children: [
        header,
        getItem(new Icon(Icons.home), "Home", "/home_user"),
        getItem(new Icon(Icons.person), "Profile", "/profile_user"),
        getItem(new Icon(Icons.add), "New Appointment", "/new_appointment"),
        getItem(new Icon(Icons.calendar_today), "Upcoming Appointments",
            "/upcoming_appointments"),
        getItem(new Icon(Icons.history), "Appointment History",
            "/appointment_history"),
        getItem(new Icon(Icons.logout), "Logout", "/login"),
      ],
    );

    return new Drawer(
      child: listView,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Home User'),
        backgroundColor: Color.fromRGBO(115, 103, 240, 94),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                items: imgList
                    .map((item) => Container(
                            child: Container(
                          margin: EdgeInsets.all(10.0),
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              child: Stack(
                                children: <Widget>[
                                  Image.network(item,
                                      fit: BoxFit.cover,
                                      width: 1000,
                                      height: 700),
                                ],
                              )),
                        )))
                    .toList(),
              ),
              Divider(
                height: 5,
                thickness: 2,
                indent: 50,
                endIndent: 50,
              ),
              Text(
                'Upcoming Appointments',
                style: TextStyle(
                  color: Color.fromRGBO(115, 103, 240, 94),
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.all(5),
                      itemCount: appointments.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.white,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: 70,
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                appointments[index]
                                                    .technical
                                                    .profilePictureUrl),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(
                                                          appointments[index]
                                                              .scheduledAt),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Appointment with ' +
                                                      appointments[index]
                                                          .technical
                                                          .fullName
                                                          .firstName +
                                                      ' ' +
                                                      appointments[index]
                                                          .technical
                                                          .fullName
                                                          .lastName,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Reparation of ' +
                                                      appointments[index]
                                                          .appliance
                                                          .name,
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ));
                      }))
            ],
          ),
        ),
      ),
      drawer: new Drawer(
        child: getDrawer(context),
      ),
    );
  }
}
