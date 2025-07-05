import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wilson_note_taker/data/repositories/auth_repository.dart';
import 'package:wilson_note_taker/data/repositories/notes_repository.dart';
import 'package:wilson_note_taker/presentation/blocs/auth/auth_bloc.dart';
import 'package:wilson_note_taker/presentation/blocs/auth/auth_event.dart';
import 'package:wilson_note_taker/presentation/blocs/auth/auth_state.dart';
import 'package:wilson_note_taker/presentation/blocs/notes/notes_bloc.dart';
import 'package:wilson_note_taker/presentation/screens/auth_screen.dart';
import 'package:wilson_note_taker/presentation/screens/notes_screen.dart';
import 'firebase_options.dart';
import 'package:logger/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final logger = Logger();
  try {
    // Initialize Firebase with proper configuration
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    logger.e('Firebase initialization error: $e');
    // Run app without Firebase for debugging
    runApp(ErrorApp(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<NotesRepository>(
          create: (context) => NotesRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create:
                (context) =>
                    AuthBloc(authRepository: context.read<AuthRepository>())
                      ..add(AuthStarted()),
          ),
          BlocProvider<NotesBloc>(
            create:
                (context) =>
                    NotesBloc(notesRepository: context.read<NotesRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Notes App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return NotesScreen();
              } else {
                return AuthScreen();
              }
            },
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

// Error app to show when Firebase fails to initialize
class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Firebase Configuration Error',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Please run: flutter-fire configure',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Error: $error',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
