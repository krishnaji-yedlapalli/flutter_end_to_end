import 'package:flutter/material.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/core/widgets/custom_app_bar.dart';

class AnimatedListDemo extends StatefulWidget {
  const AnimatedListDemo({Key? key}) : super(key: key);

  @override
  State<AnimatedListDemo> createState() => _AnimatedListDemoState();
}

class _AnimatedListDemoState extends State<AnimatedListDemo> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<ListItem> _items = [];
  int _nextId = 1;

  @override
  void initState() {
    super.initState();
    // Add initial items
    _items.addAll([
      ListItem(id: _nextId++, title: 'Welcome Item', subtitle: 'This is the first item'),
      ListItem(id: _nextId++, title: 'Sample Task', subtitle: 'Complete the demo'),
      ListItem(id: _nextId++, title: 'Another Item', subtitle: 'Try adding and removing items'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('AnimatedList'),
        appBar: AppBar(),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addItem,
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearAll,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildInfoCard(),
          _buildControlButtons(),
          Expanded(
            child: _buildAnimatedList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: EdgeInsets.all(DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AnimatedList Demo',
                style: TextStyle(
                  fontSize: DeviceConfiguration.isMobileResolution ? 18 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'AnimatedList automatically animates list items when they are '
                'inserted or removed. Tap the + button to add items or swipe to remove them.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _addRandomItem,
              icon: const Icon(Icons.add_circle),
              label: const Text('Add Random'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _addMultipleItems,
              icon: const Icon(Icons.add_box),
              label: const Text('Add Multiple'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _items.isNotEmpty ? _removeLastItem : null,
              icon: const Icon(Icons.remove_circle),
              label: const Text('Remove Last'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedList() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: AnimatedList(
        key: _listKey,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          return _buildAnimatedItem(_items[index], animation, index);
        },
      ),
    );
  }

  Widget _buildAnimatedItem(ListItem item, Animation<double> animation, int index) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut)),
      ),
      child: FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation,
          child: _buildListItem(item, index),
        ),
      ),
    );
  }

  Widget _buildListItem(ListItem item, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      child: Dismissible(
        key: Key(item.id.toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: (direction) {
          _removeItem(index);
        },
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getColorForId(item.id),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                '${item.id}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            item.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(item.subtitle),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editItem(index),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeItem(index),
              ),
            ],
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tapped: ${item.title}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }

  void _addItem() {
    final newItem = ListItem(
      id: _nextId++,
      title: 'New Item ${_items.length + 1}',
      subtitle: 'Added at ${DateTime.now().toString().substring(11, 19)}',
    );

    _items.add(newItem);
    _listKey.currentState?.insertItem(_items.length - 1);
  }

  void _addRandomItem() {
    final titles = [
      'Task', 'Meeting', 'Call', 'Email', 'Project', 'Review', 'Update', 'Report'
    ];
    final subtitles = [
      'High priority', 'Due today', 'Follow up required', 'In progress',
      'Completed', 'Pending review', 'Urgent', 'Low priority'
    ];

    final newItem = ListItem(
      id: _nextId++,
      title: '${titles[_nextId % titles.length]} ${_nextId}',
      subtitle: subtitles[_nextId % subtitles.length],
    );

    _items.add(newItem);
    _listKey.currentState?.insertItem(_items.length - 1);
  }

  void _addMultipleItems() {
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          final newItem = ListItem(
            id: _nextId++,
            title: 'Batch Item ${i + 1}',
            subtitle: 'Added in batch operation',
          );

          _items.add(newItem);
          _listKey.currentState?.insertItem(_items.length - 1);
        }
      });
    }
  }

  void _removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      final removedItem = _items.removeAt(index);
      
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => _buildRemovedItem(removedItem, animation),
      );
    }
  }

  void _removeLastItem() {
    if (_items.isNotEmpty) {
      _removeItem(_items.length - 1);
    }
  }

  void _clearAll() {
    if (_items.isEmpty) return;

    for (int i = _items.length - 1; i >= 0; i--) {
      Future.delayed(Duration(milliseconds: ((_items.length - 1 - i) * 100)), () {
        if (mounted && _items.isNotEmpty) {
          _removeItem(_items.length - 1);
        }
      });
    }
  }

  void _editItem(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController(text: _items[index].title);
        final subtitleController = TextEditingController(text: _items[index].subtitle);

        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Subtitle',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _items[index] = ListItem(
                    id: _items[index].id,
                    title: titleController.text,
                    subtitle: subtitleController.text,
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRemovedItem(ListItem item, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut)),
      ),
      child: FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: Colors.red.withOpacity(0.1),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
              title: Text(
                item.title,
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              subtitle: Text(
                item.subtitle,
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorForId(int id) {
    final colors = [
      Colors.blue, Colors.green, Colors.orange, Colors.purple,
      Colors.red, Colors.teal, Colors.pink, Colors.indigo,
    ];
    return colors[id % colors.length];
  }
}

class ListItem {
  final int id;
  final String title;
  final String subtitle;

  ListItem({
    required this.id,
    required this.title,
    required this.subtitle,
  });
}
