import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<StatefulWidget> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int milliSeconds = 0, seconds = 0, minutes = 0;
  String digitMilliSeconds = "00";
  String digitSeconds = "00";
  String digitMinutes = "00";
  Timer? timer;
  bool isStarted = false;
  List<String> laps = [];

  void stop() {
    timer?.cancel();

    setState(() {
      isStarted = false;
    });
  }

  void reset() {
    timer?.cancel();

    setState(() {
      milliSeconds = 0;
      seconds = 0;
      minutes = 0;

      digitMilliSeconds = "00";
      digitSeconds = "00";
      digitMinutes = "00";

      isStarted = false;

      removeLaps();
    });
  }

  void addLaps() {
    String lap = "$digitMinutes:$digitSeconds:$digitMilliSeconds";

    setState(() {
      laps.add(lap);
    });
  }

  void removeLaps() {
    setState(() {
      laps.clear();
    });
  }

  void start() {
    isStarted = true;

    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      int currentMilliSeconds = milliSeconds + 1;
      int currentSeconds = seconds;
      int currentMinutes = minutes;

      if (currentMilliSeconds >= 99) {
        if (currentSeconds >= 59) {
          currentSeconds = 0;
          currentMinutes++;
        } else {
          currentMilliSeconds = 0;
          currentSeconds++;
        }
      }

      setState(() {
        milliSeconds = currentMilliSeconds;
        seconds = currentSeconds;
        minutes = currentMinutes;

        digitMilliSeconds =
            (milliSeconds >= 10) ? "$milliSeconds" : "0$milliSeconds";
        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "StopWatch App",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "$digitMinutes:$digitSeconds:$digitMilliSeconds",
                style: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            Container(
              height: 350,
              decoration: BoxDecoration(
                color: const Color(0xFFB0BEC5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView.builder(
                itemCount: laps.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Lap ${index + 1}",
                          style: const TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Icon(
                          Icons.flag_rounded,
                          size: 25,
                          color: Color(0xFF333333),
                        ),
                        Text(
                          laps[index],
                          style: const TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RawMaterialButton(
                    onPressed: () {
                      (!isStarted) ? start() : stop();
                    },
                    shape: const StadiumBorder(
                        side: BorderSide(
                      color: Colors.black,
                    )),
                    child: Text(
                      (!isStarted) ? "Start" : "Pause",
                      style: const TextStyle(
                        color: Color(0xFF355C7D),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    addLaps();
                  },
                  icon: const Icon(
                    Icons.flag_circle_rounded,
                    size: 50,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RawMaterialButton(
                    onPressed: () {
                      reset();
                    },
                    fillColor: const Color(0xFF333333),
                    shape: const StadiumBorder(),
                    child: const Text(
                      "Reset",
                      style: TextStyle(
                        color: Color(0xFFF28C8C),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}