import 'package:flutter/material.dart';

import '../../domain/entities/journal_entry.dart';
import '../controllers/journal_view_model.dart';

class JournalEntryScreen extends StatefulWidget {
  final JournalEntry? entry;

  const JournalEntryScreen({super.key, this.entry});

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final JournalViewModel _viewModel = JournalViewModel();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _promptController = TextEditingController();

  String _selectedType = 'free_write';
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _isEditing = true;
      _textController.text = widget.entry!.entryText;
      _selectedType = widget.entry!.entryType;
      _promptController.text = widget.entry!.promptQuestion ?? '';
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something in your journal')),
      );
      return;
    }

    bool success;
    if (_isEditing) {
      success = await _viewModel.updateEntry(
        id: widget.entry!.id,
        entryText: _textController.text.trim(),
      );
    } else {
      success = await _viewModel.createEntry(
        entryText: _textController.text.trim(),
        entryType: _selectedType,
        promptQuestion: _promptController.text.trim().isNotEmpty
            ? _promptController.text.trim()
            : null,
      );
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Entry updated!' : 'Entry saved!'),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Entry' : 'New Entry'),
        centerTitle: true,
        actions: [
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) => TextButton(
              onPressed: _viewModel.isSaving ? null : _saveEntry,
              child: _viewModel.isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isEditing) ...[
              const Text(
                'Entry Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildTypeChip('free_write', 'Free Write', Colors.blue),
                  _buildTypeChip('guided', 'Guided', Colors.purple),
                  _buildTypeChip('reflection', 'Reflection', Colors.teal),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _promptController,
                decoration: const InputDecoration(
                  labelText: 'Prompt (optional)',
                  hintText: 'e.g., What are you grateful for today?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'Your Thoughts',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Write your thoughts here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 15,
              minLines: 8,
            ),
            const SizedBox(height: 16),
            Text(
              '${_textController.text.length} characters',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type, String label, Color color) {
    final isSelected = _selectedType == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedType = type);
        }
      },
      selectedColor: color.withValues(alpha: 0.3),
    );
  }
}