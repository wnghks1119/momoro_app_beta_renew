import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:momoro_app_beta/screen/tablecalendar_screen.dart';

import '../data_manage_component/db_helper.dart';


class InputListFirstScreen extends StatefulWidget {
  final DateTime selectedDate;

  const InputListFirstScreen({super.key, required this.selectedDate});

  @override
  State<InputListFirstScreen> createState() => _InputListFirstScreenState();
}

class _InputListFirstScreenState extends State<InputListFirstScreen> {

  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;
  //var rating;
  late double ratingValue;  // Rating_Bar 별점 점수 저장하기 위한 변수


// Get All Data From Database
  void _refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

// Add Data
  Future<void> _addData(rating, date) async {
    await SQLHelper.createData(rating, _thanksController.text, _reliefController.text, _goodController.text, date);
    _refreshData();
  }

// Update Data
  Future<void> _updateData(date) async {
    await SQLHelper.updateDescData(date, _thanksController.text, _reliefController.text, _goodController.text);
    _refreshData();
  }

  final TextEditingController _thanksController = TextEditingController();
  final TextEditingController _reliefController = TextEditingController();
  final TextEditingController _goodController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final selectedDate = widget.selectedDate;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Daily Challenge"),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    //color: Colors.amberAccent,
                    padding: EdgeInsets.only(top: 10),
                    height: 150,

                    //color: Colors.greenAccent,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일 "
                                  "${DateFormat.EEEE('ko').format(selectedDate)}",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            //color: Colors.amberAccent,
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    "오늘의 점수는?",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  padding: EdgeInsets.only(right: 8),
                                ),
                                RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 0.5,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.favorite,
                                    color: Colors.pinkAccent,
                                  ),

                                  // 여기서 점수 받는 변수 선언한 뒤 rating 받기
                                  onRatingUpdate: (rating) {
                                    ratingValue = rating as double;
                                    print(rating);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    //color: Colors.greenAccent,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        //color: Colors.indigo,
                        //width: 1,
                      ),
                      //color: Colors.greenAccent,
                    ),
                    child : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          //controller: _descController,  -> _thanksDescController 로 변경
                          maxLines: 4,
                          decoration: InputDecoration(
                            //filled: true,
                            //fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.redAccent),
                            ),
                            border: OutlineInputBorder(),
                            labelText: "1. 감사한 일",
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          //controller: _descController,  -> _reliefDescController 로 변경
                          maxLines: 4,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.redAccent),
                            ),
                            border: OutlineInputBorder(),
                            labelText: "2. 다행인 일",
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          //controller: _descController,  -> _reliefDescController 로 변경
                          maxLines: 4,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.redAccent),
                            ),
                            border: OutlineInputBorder(),
                            labelText: "3. 잘한 일",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      // 버튼 클릭 시 입력했던 데이터가 저장될 수 있도록 함수 추가 (createData -> _addData)
                      onPressed: () async {
                        await _addData(ratingValue, selectedDate);

                        _thanksController.text = "";
                        _reliefController.text = "";
                        _goodController.text = "";

                        //Navigator.of(context).pop();
                        print("Add Data");
                      },
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "저장",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}