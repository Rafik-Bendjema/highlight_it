import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight_it/ImageViewPage.dart';
import 'package:highlight_it/book/domain/book_provider.dart';
import 'package:highlight_it/category/domain/provider/category_provider.dart';
import 'package:highlight_it/database/database.dart';
import 'package:highlight_it/quotes/domain/provider/quote_provider.dart';
import 'package:highlight_it/quotes/presentation/quotesList.dart';
import 'package:permission_handler/permission_handler.dart';

late List<CameraDescription> _cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseImpl().database;
  _cameras = await availableCameras();
  print("here is the available cameras ${_cameras.length}");
  runApp(const ProviderScope(child: MaterialApp(home: MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  XFile? imageFile;
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    controller = CameraController(_cameras[0], ResolutionPreset.medium);

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void requestStoragePermission() async {
    // Check if the platform is not web, as web has no permissions
    if (!kIsWeb) {
      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      // Request camera permission
      var cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        await Permission.camera.request();
      }
    }
  }

  void takePicture(BuildContext context) async {
    try {
      final XFile picture = await controller.takePicture();
      setState(() {
        imageFile = picture;
      });
      print("here is the path ${imageFile!.path}");
      // Navigate to the image view page after capturing the image
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Imageviewpage(path: imageFile!.path)));
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.purple,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            )),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.purple,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Consumer(
                          builder: (context, ref, child) {
                            return IconButton(
                                onPressed: () async {
                                  await ref
                                      .read(categoriesProvider.notifier)
                                      .fetchCategories();
                                  await ref
                                      .read(quotesProvider.notifier)
                                      .fetchQuotes();
                                  await ref
                                      .read(booksProvider.notifier)
                                      .fetchBooks();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const Quoteslist()));
                                },
                                icon: const Icon(
                                  Icons.history_edu,
                                  color: Colors.white,
                                ));
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(20))),
                    child: CameraPreview(
                      controller,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  width: 50,
                  decoration: const BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: IconButton(
                      onPressed: () {
                        takePicture(context);
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
