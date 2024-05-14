import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../model/todo.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final List<Todo> todosList = [];
  List<Todo> _foundTodo = [];
  final TextEditingController _todoController = TextEditingController();

  @override
  void initState() {
    _foundTodo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                _searchBox(),
                Expanded(
                  child: ListView.builder(
                    itemCount: _foundTodo.length,
                    itemBuilder: (context, index) {
                      final todo = _foundTodo[_foundTodo.length - 1 - index];
                      return TodoItem(
                        todo: todo,
                        onTodoChanged: _handleTodoChange,
                        onDeleteItem: _deleteTodoItem,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          _buildInputRow(),
        ],
      ),
    );
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteTodoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
      _foundTodo = todosList;
    });
  }

  void _addTodoItem(String todoText) {
    if (todoText.trim().isEmpty) return;

    setState(() {
      todosList.add(
        Todo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: todoText,
        ),
      );
      _foundTodo = todosList;
    });
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<Todo> results;
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) =>
          item.todoText.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundTodo = results;
    });
  }

  Widget _searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: _runFilter,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: "Search",
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  Widget _buildInputRow() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _todoController,
                decoration: const InputDecoration(
                  hintText: "Add a new todo item",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20, right: 20),
            child: ElevatedButton(
              onPressed: () => _addTodoItem(_todoController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: tdBlue,
                minimumSize: const Size(60, 60),
                elevation: 10,
              ),
              child: const Text(
                "+",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: tdBGColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset("assets/images/avatar.png"),
            ),
          ),
        ],
      ),
    );
  }
}
