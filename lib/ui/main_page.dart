import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/bloc/post_bloc.dart';
import 'package:flutter_infinite_list/ui/post_item.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ScrollController controller = ScrollController();

  PostBloc bloc;

  void onScroll() {
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;

    // check apakah currentScrollnya sudah sama dengan maxscroll(mentok)
    if (currentScroll == maxScroll) {
      // panggil kembali post eventnya
      bloc.add(PostEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<PostBloc>(context);
    controller.addListener(onScroll);
    return Scaffold(
      appBar: AppBar(
        title: Text("Infinite List with Bloc"),
      ),
      body: Container(
        margin: EdgeInsets.only(right: 20, left: 20),
        child: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
          // check dulu statenya, kalau statenya postunitialized yang di kembalikan adalah indikator loadingnya
          if (state is PostUnitialized) {
            return Center(
                child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ));
          } else {
            PostLoaded postLoaded = state as PostLoaded;
            return ListView.builder(
              // daftarkan controllernya disini
              controller: controller,
              // check kalau postLoaded.hasReachMax = true, maka tidak perlu load lagi
              itemCount: (postLoaded.hasReachMax)
                  // dan kembalikan itemCountnya sesuai dengan isi/panjang dari datanya
                  ? postLoaded.posts.length
                  // tapi kalau belum mencapai maximum dari hasReachMax nya
                  // yang dikembalikan adalah isi dari datanya lalu di tambahkan satu
                  // yang ditambahkan satu itu akan memunculkan CircularProgressIndicator
                  : postLoaded.posts.length + 1,
              itemBuilder: (context, index) {
                // jadi disini jika indexnya lebih kecil dari panjang postloaded lengthnya
                // maka yang dikembalikan adalah data post itemnya
                if (index < postLoaded.posts.length) {
                  return PostItem(postLoaded.posts[index]);
                } else {
                  return Container(
                    child: Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
              },
            );
          }
        }),
      ),
    );
  }
}
