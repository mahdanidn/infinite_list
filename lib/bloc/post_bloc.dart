import 'package:bloc/bloc.dart';
import 'package:flutter_infinite_list/model/post.dart';

class PostEvent {}

abstract class PostState {}

// post unitialized ini dipakai untuk data pertamakali
class PostUnitialized extends PostState {}

// postloaded sudah meload data nya
class PostLoaded extends PostState {
  List<Post> posts;
  // boolean disini untuk meload semua data ke UI, kalau semua data sudah di load, maka boolean ini akan menjadi false
  bool hasReachMax;

  PostLoaded({this.posts, this.hasReachMax});

  // buat sebuah method untuk mengcopy PostLoaded constructor
  PostLoaded copyWith({List<Post> posts, bool hasReachMax}) {
    return PostLoaded(
        posts: posts ?? this.posts,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }
}

class PostBloc extends Bloc<PostEvent, PostState> {
  @override
  PostState get initialState => PostUnitialized();

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    List<Post> posts;
    // check apakah postnya sudah di load atau belum
    if (state is PostUnitialized) {
      posts = await Post.connectToAPI(0, 10);
      yield PostLoaded(posts: posts, hasReachMax: false);
    } else {
      PostLoaded postLoaded = state as PostLoaded;
      posts = await Post.connectToAPI(postLoaded.posts.length, 10);

      // jika hasil dari API tadi list kosong
      yield (posts.isEmpty)
          //  update hasReachMax nya menjadi true
          ? postLoaded.copyWith(hasReachMax: true)
          // tetapi jika tidak kosong yang dikembalikan adalah PostLoaded yang baru ditambah hasil dari API dan hasReachMaxnya false
          : PostLoaded(posts: postLoaded.posts + posts, hasReachMax: false);
    }
  }
}
