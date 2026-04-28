import 'package:flutter/material.dart';

import '../../domain/entities/mood_question.dart';

class MoodQuestionsWidget extends StatelessWidget {
  final List<MoodQuestion> questions;
  final Map<String, int> answers;
  final ValueChanged<MapEntry<String, int>> onAnswerChanged;

  const MoodQuestionsWidget({
    super.key,
    required this.questions,
    required this.answers,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: questions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final question = questions[index];
        final currentAnswer = answers[question.id];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (i) {
                final value = i + 1;
                final isSelected = currentAnswer == value;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onAnswerChanged(MapEntry(question.id, value)),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _getCategoryColor(question.category)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$value',
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getCategoryLabel(question.category),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  currentAnswer != null ? '$currentAnswer/5' : '-/5',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'emotional':
        return Colors.purple;
      case 'physical':
        return Colors.orange;
      case 'social':
        return Colors.blue;
      case 'cognitive':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'emotional':
        return '1=Low, 5=High';
      case 'physical':
        return '1=Low energy, 5=High energy';
      case 'social':
        return '1=Isolated, 5=Very social';
      case 'cognitive':
        return '1=Unfocused, 5=Very focused';
      default:
        return '';
    }
  }
}