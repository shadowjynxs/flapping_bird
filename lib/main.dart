import 'dart:async';
import 'dart:math';
import 'package:flapping/my_barrier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool gameHasStarted = false;
  static double birdY = 0.0;
  double gravity = -4.9;
  double time = 0.0;
  double initialPos = birdY;
  double height = 0;
  bool isGameOver = false;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;
  static String score = "0";
  String highScore = "0";
  double sizeA = 250;
  double sizeB = 300;
  double sizeC = 300;
  double sizeD = 250;
  Random random = Random();

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 120), (timer) {
      time += 0.045;
      height = gravity * time * time + 1.7 * time;

      setState(() {
        birdY = initialPos - height;
      });

      setState(() {
        if (barrierXone < -1.1) {
          barrierXone += 3.5;
        } else {
          barrierXone -= 0.05;
        }
      });

      setState(() {
        if (barrierXtwo < -1.1) {
          barrierXtwo += 3.5;
        } else {
          barrierXtwo -= 0.05;
        }
      });

      if (birdY > 1 || birdY < -1) {
        if (birdY > 1) {
          birdY = 0.97;
        } else {
          birdY = -1;
        }
        timer.cancel();
        isGameOver = true;
        gameHasStarted = false;
      }
    });
  }

  void resetGame() {
    setState(() {
      isGameOver = false;
      birdY = 0.0;
      time = 0.0;
      initialPos = birdY;
      height = 0.0;
      barrierXone = 1.0;
      barrierXtwo = barrierXone + 1.5;
      score = "1";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          if (isGameOver) {
            resetGame();
            startGame();
          } else if (!gameHasStarted) {
            startGame();
          } else {
            jump();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.blue,
          body: Column(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 0),
                      alignment: Alignment(0, birdY),
                      color: Colors.blue,
                      child: Image.asset(
                        'lib/assets/bird.png',
                        scale: 0.6,
                      ),
                    ),
                    if (!gameHasStarted && !isGameOver)
                      Container(
                        alignment: const Alignment(0, -0.2),
                        child: Text(
                          "T  A  P    T  0   P  L  A  Y",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    if (isGameOver)
                      Container(
                        alignment: const Alignment(0, 0),
                        child: Text(
                          'Game Over',
                          style: TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800],
                          ),
                        ),
                      ),
                    Container(
                      height: 15,
                      color: Colors.green,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 0),
                      alignment: Alignment(barrierXone, 1.1),
                      child: MyBarrier(size: sizeA),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 0),
                      alignment: Alignment(barrierXone, -1.1),
                      child: MyBarrier(size: sizeB),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 0),
                      alignment: Alignment(barrierXtwo, 1.1),
                      child: MyBarrier(size: sizeC),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 0),
                      alignment: Alignment(barrierXtwo, -1.1),
                      child: MyBarrier(size: sizeD),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.brown[600],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Score: $score",
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 50),
                      Text(
                        "Best Score: $highScore",
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
