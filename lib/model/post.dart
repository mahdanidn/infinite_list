import 'dart:convert';
import 'package:http/http.dart' as http;

class Post {
  String id, title, body;

  Post({this.id, this.title, this.body});

  factory Post.createPost(Map<String, dynamic> object) {
    return Post(id: object['id'], title: object['title'], body: object['body']);
  }

  static Future<List<Post>> connectToAPI(int start, int limit) async {
    String apiUrl = "https://jsonplaceholder.typicode.com/posts?_start=" +
        start.toString() +
        "&_limit=" +
        limit.toString();

    var apiResult = await http.get(apiUrl);
    //get api dari url lalu jadikan list
    var jsonObject = json.decode(apiResult.body) as List;
    // setelah jsonobject menjadi list, mapping  setiap item lalu masukkan ke dalam factory
    return jsonObject
        // jangan lupa menambahkan tipe class di sebelah map
        .map<Post>((item) =>
            Post(id: item['id'].toString(), title: item['title'], body: item['body']))
        .toList();
  }
}
