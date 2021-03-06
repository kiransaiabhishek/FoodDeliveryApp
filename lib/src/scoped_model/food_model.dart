import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import '../models/food_model.dart';
import 'package:http/http.dart' as http;

class FoodModel extends Model{
  List<Food> _foods=[];
  bool _isLoading=false;
  bool get isLoading{
    return _isLoading;

  }

  List<Food>get foods{
    return List.from(_foods);
  }

  Future<bool> addFood(Food food) async{
  //   _foods.add(food);
  _isLoading=true;
  notifyListeners();


try{
    final Map<String,dynamic> fooddata={
    "title":food.name,
    "description":food.description,
    "category":food.category,
    "price":food.price,
    "discount":food.discount
  };
    final http.Response response=await http.post("https://foody-624ca.firebaseio.com/foods.json",body:json.encode(fooddata));
    
    final Map<String,dynamic> responsedata = json.decode(response.body);

    // print(responsedata["name"]);
    Food foodwithid=Food(
      id:responsedata["name"],
      name:food.name,
      description:food.description,
      category:food.category,
      price:food.price,
      discount:food.discount

    );
     _foods.add(foodwithid);
      _isLoading = false;
      notifyListeners();
      // fetchFoods();
      return Future.value(true);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
      print("Connection error: $e");
    }
  }

  // void fetchfoods(){
  //   http.get("https://foody-624ca.firebaseio.com/foods.json")
  //   .then((http.Response response) {
  //    print("datacheck: ${response.body}");
  //    final Map<String,dynamic> fetcheddata = json.decode(response.body);
  //     print(fetcheddata);
  //   //  final List<Food> fetchedfooditems=[];
     
  //   //   fetcheddata.forEach((val) {
     
  //   //     Food food=Food(

  //   //       id:val["id"],
  //   //       category: val["category_id"],
  //   //       discount: double.parse(val["discount"]),
  //   //       imagePath: "assets/images/"+val["image_path"],
  //   //       name: val["title"],
  //   //       price:double.parse(val["price"]),
  //   //       // ratings: val["ratings"]
  //   //     );
  //   //       fetchedfooditems.add(food);
  //   //    });
  //   //  _foods=fetchedfooditems; 
  //        http.get("https://foody-624ca.firebaseio.com/foods.json");

  //     // print("Fecthing data: ${response.body}");
  //     final Map<String, dynamic> fetchedData = json.decode(response.body);
  //     print(fetchedData);

  //     final List<Food> foodItems = [];

  //     fetchedData.forEach((String id, dynamic foodData) {
  //       Food foodItem = Food(
  //         id: id,
  //         name: foodData["title"],
  //         description: foodData["description"],
  //         category: foodData["category"],
  //         price: double.parse(foodData["price"].toString()),
  //         discount: double.parse(foodData["discount"].toString()),
  //       );

  //       foodItems.add(foodItem);  
  //     });
  //     _foods=foodItems;
  //     notifyListeners();
  //     print(_foods);



  //   }).catchError((error) {
  //     print('There is an error');
     
  //     notifyListeners();
     
  //   });
  // }
  
  Future<bool> fetchFoods() async {
    _isLoading = true;
    notifyListeners();

    try {
      final http.Response response =
          await http.get("https://foody-624ca.firebaseio.com/foods.json");

      // print("Fecthing data: ${response.body}");
      final Map<String, dynamic> fetchedData = json.decode(response.body);
      print(fetchedData);

      final List<Food> foodItems = [];

      fetchedData.forEach((String id, dynamic foodData) {
        Food foodItem = Food(
          id: id,
          name: foodData["title"],
          description: foodData["description"],
          category: foodData["category"],
          price: double.parse(foodData["price"].toString()),
          discount: double.parse(foodData["discount"].toString()),
        );

        foodItems.add(foodItem);
      });

      _foods = foodItems;
      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      print("The errror: $error");
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }


}