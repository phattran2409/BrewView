import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/core/widgets/wave_clipper.dart';
import 'package:briewview/app/theme/app_color.dart';
import 'package:briewview/app/di/locator.dart';
import 'package:briewview/features/survey/view/widgets/category_selection_widget.dart';
import 'package:briewview/features/survey/view/widgets/feature_tag_selection_widget.dart';
import 'package:briewview/features/survey/viewmodel/survey_bloc.dart';
import 'package:briewview/features/survey/viewmodel/survey_event.dart';
import 'package:briewview/features/survey/viewmodel/survey_state.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  late final SurveyBloc _surveyBloc;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _surveyBloc = getIt<SurveyBloc>();
    _surveyBloc.add(LoadCategories());
    _surveyBloc.add(LoadFeatureTags());
  }

  @override
  void dispose() {
    _surveyBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _surveyBloc,
      child: Builder(
        builder: (context) {
          return Scaffold(
          body: Stack(
            children: [
              // Background
              Container(
                decoration: const BoxDecoration(
                color: Color.fromARGB(255, 172, 89, 1),
              ),
            ),

            // Wave ClipPath
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF763C0C), // Màu trên
                      Color(0xFF5A2D09), // Màu transition
                    ],
                  ),
                ),
              ),
            ),

            // Content
            SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Logo
                        Image(
                          width: 80,
                          height: 100,
                          image: AssetImage('assets/images/logo_app.png'),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'BrewView',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Survey Content
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: _currentStep == 0
                          ? CategorySelectionWidget(
                              onNext: () {
                                setState(() {
                                  _currentStep = 1;
                                });
                                context.read<SurveyBloc>().add(LoadFeatureTags());
                              },
                            )
                          : FeatureTagSelectionWidget(
                               onSubmit: () {
                                      _submitSurvey(context);
                                    },
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),
                 ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _submitSurvey(BuildContext context) {  
    context.read<SurveyBloc>().add(SubmitSurvey());
  }
}
