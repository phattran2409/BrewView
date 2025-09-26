import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/features/survey/viewmodel/survey_bloc.dart';
import 'package:briewview/features/survey/viewmodel/survey_event.dart';
import 'package:briewview/features/survey/viewmodel/survey_state.dart';
import 'package:briewview/features/survey/model/feature_tag_model.dart';

class FeatureTagSelectionWidget extends StatelessWidget {
  final VoidCallback onSubmit;

  const FeatureTagSelectionWidget({
    super.key,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<SurveyBloc, SurveyState>(
      listener: (context, state) {
        if (state is SurveySubmitted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Survey submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navigate back or to next screen
          // Navigator.of(context).pop();
           Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/home', (route) => false);
        } else if (state is SurveyError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<SurveyBloc, SurveyState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Choose your interests',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Get better recommendations',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),

                // Error message
                if (state is SurveyLoaded && state.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[600], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.errorMessage!,
                            style: TextStyle(color: Colors.red[600]),
                          ),
                        ),
                        IconButton(
                          onPressed: () => context.read<SurveyBloc>().add(ClearError()),
                          icon: Icon(Icons.close, color: Colors.red[600], size: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Feature Tags Grid
                Expanded(
                  child: state is FeatureTagsLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF763C0C)),
                          ),
                        )
                      : state is SurveyLoaded
                          ? GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.5,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: state.featureTags.length,
                              itemBuilder: (context, index) {
                                final featureTag = state.featureTags[index];
                                final isSelected = state.selectedFeatureTags.contains(featureTag);
                                
                                return GestureDetector(
                                  onTap: () => context.read<SurveyBloc>().add(ToggleFeatureTagSelection(featureTag)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFF763C0C) : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected ? const Color(0xFF763C0C) : Colors.grey[300]!,
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [                    
                                        if (isSelected) const SizedBox(width: 8),                     
                                        Flexible(
                                          child: Text(
                                            featureTag.name,
                                            style: TextStyle(
                                              color: isSelected ? Colors.white : Colors.black87,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text('No feature tags available'),
                            ),
                ),

                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is SurveyLoaded && state.canSubmitSurvey && state is! SurveySubmitting ? onSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF763C0C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.2),
                    ),
                    child: state is SurveySubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Submit Survey',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
