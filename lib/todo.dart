import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Todoscreen extends StatefulWidget{
  @override
  State<Todoscreen> createState()=> _TodoscreenState();
}
class _TodoscreenState extends State<Todoscreen>{
  late Box box;
  TextEditingController controller=TextEditingController();
  List<String> _todoItems=[];
  @override
  
  void initState(){
    super.initState();
    box=Hive.box('mybox');
    loadtodoItems();
  }
  
  loadtodoItems(){
    List<String>? tasks = box.get('_todoItems')?.cast<String>();

    if (tasks != null) {
      setState(() {
        _todoItems = tasks; // Assign loaded tasks to todoItems
      });
    }
  }
   saveTodoItems() async {
    // Save updated todoItems list to Hive
    box.put('todoItems', _todoItems);
  }

  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _todoItems.add(task);
      });
      saveTodoItems();
      controller.clear(); // Clear the input after adding
    }
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
    saveTodoItems();
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo with hive"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(18))),
                  ),
                ),
                SizedBox(width: 7,),
                TextButton(onPressed: (){
                  _addTodoItem(controller.text);
                }, 
                child: Icon(Icons.add)),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _todoItems.length,
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text(_todoItems[index]),
                    trailing: GestureDetector(
                      onTap: () {
                        _removeTodoItem(index);
                      },
                      child: Icon(Icons.delete),
                    ),);
                }))
          ],
        ),
      ),
    );
  }
}