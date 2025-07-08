import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icondo/data/rest_clients/clients/mocki/mocki_clients.dart';
import 'package:icondo/data/services/home_data/home_data_service_impl.dart';
import 'package:icondo/presentation/bloc/home/home_bloc.dart';
import 'package:icondo/presentation/page/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
            homeRepositoryImpl: HomeDataServiceImpl(
              mockiClient: MockiClient(Dio(), baseUrl: 'https://mocki.io/'),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'IconDo App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomePage(),
      ),
    );
  }
}
