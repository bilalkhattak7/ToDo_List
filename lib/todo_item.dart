import 'package:flutter/material.dart';

class TodoItem {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;

  TodoItem({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
  });

  TodoItem copyWith({
    String? title,
    bool? isCompleted,
  }) {
    return TodoItem(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}

class TodoItemWidget extends StatefulWidget {
  final TodoItem todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Function(String) onEdit;

  const TodoItemWidget({
    Key? key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  _TodoItemWidgetState createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends State<TodoItemWidget> {
  late TextEditingController _editController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.todo.title);
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveEdit() {
    if (_editController.text.trim().isNotEmpty) {
      widget.onEdit(_editController.text);
    }
    setState(() {
      _isEditing = false;
    });
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _editController.text = widget.todo.title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        leading: Checkbox(
          value: widget.todo.isCompleted,
          onChanged: (value) => widget.onToggle(),
          activeColor: Colors.blue,
        ),
        title: _isEditing
            ? TextField(
          controller: _editController,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          autofocus: true,
          onSubmitted: (_) => _saveEdit(),
        )
            : Text(
          widget.todo.title,
          style: TextStyle(
            fontSize: 16,
            decoration: widget.todo.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: widget.todo.isCompleted
                ? Colors.grey[600]
                : Colors.black,
          ),
        ),
        trailing: _isEditing
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: _saveEdit,
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: _cancelEdit,
            ),
          ],
        )
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: _startEditing,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: widget.onDelete,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }
}