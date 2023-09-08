import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class BrandText extends StatelessWidget {
  const BrandText({
    super.key,
  });

  TextStyle brandTextStyle({required Color color}) {
    return GoogleFonts.poppins(
      fontSize: 35,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "G",
            style: brandTextStyle(color: const Color.fromRGBO(233, 82, 81, 1)),
          ),
          Text(
            "a",
            style: brandTextStyle(color: const Color.fromRGBO(169, 71, 185, 1)),
          ),
          Text(
            "t",
            style: brandTextStyle(color: const Color.fromRGBO(105, 83, 238, 1)),
          ),
          Text(
            "o",
            style: brandTextStyle(color: const Color.fromRGBO(38, 151, 250, 1)),
          ),
          Text(
            "t",
            style: brandTextStyle(color: const Color.fromRGBO(56, 75, 167, 1)),
          ),
          Text(
            "k",
            style: brandTextStyle(color: const Color.fromRGBO(78, 188, 215, 1)),
          ),
          Text(
            "a",
            style: brandTextStyle(color: const Color.fromRGBO(87, 173, 77, 1)),
          ),
          Text(
            "c",
            style: brandTextStyle(color: const Color.fromRGBO(234, 192, 80, 1)),
          ),
          Text(
            "a",
            style: brandTextStyle(color: const Color.fromRGBO(242, 84, 53, 1)),
          ),
          Transform.rotate(
            angle: math.pi / 20,
            child: Text(
              "!",
              style: brandTextStyle(color: const Color.fromRGBO(145, 116, 121, 1)),
            ),
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController searchControl = TextEditingController();
  double flyPos = 0;
  bool searched = false;
  bool searching = false;
  List searchResult = [];
  Widget responseWidget = Container();

  void animate(BuildContext context) async {
    while (searching) {
      setState(() {
        flyPos = MediaQuery.of(context).size.width;
      });
      await Future.delayed(const Duration(milliseconds: 250));

      // ignore: use_build_context_synchronously
      while (flyPos > -MediaQuery.of(context).size.width) {
        await Future.delayed(const Duration(milliseconds: 10));
        setState(() {
          flyPos -= MediaQuery.of(context).size.width / 50;
        });
      }
    }
  }

  Future<Map<String, Object?>> fetchSearch() async {
    Uri url = Uri.parse("http://192.168.1.22/search?q=${searchControl.text}");
    http.Response? res;
    try {
      res = await http.get(url).timeout(
            const Duration(seconds: 30),
          );
      final json = jsonDecode(res.body);
      Map<String, Object?> resp = {"code": res.statusCode, "data": json};

      return resp;
    } catch (e) {
      final isTimeout = e.toString().contains("TimeoutException");
      Map<String, Object?> resp = {"code": isTimeout ? 408 : 500, "data": List};
      return resp;
    }
  }

  void search(BuildContext context) async {
    if (searching) return;
    if (searchControl.text.isNotEmpty) {
      setState(() {
        searchResult = [];
        responseWidget = Container();
        searched = false;
        searching = true;
      });

      animate(context);
      final resp = await fetchSearch();

      setState(() async {
        searched = true;
        searching = false;

        if (resp["data"] is List) {
          if ((resp["data"] as List).isNotEmpty) searchResult = resp["data"] as List;
        }

        if (resp["code"] == 404) responseWidget = const SearchNotFound();
        if (resp["code"] == 408) responseWidget = const SearchTimeout();
        if (resp["code"] == 503) responseWidget = const MaintenanceMessage();
        if (resp["code"] == 500) responseWidget = const SearchFailed();
        if (resp["code"] == 200 && searchResult.isNotEmpty) {
          responseWidget = FutureBuilder(
            future: Future.delayed(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SearchResult(searchResult: searchResult);
              } else {
                return const SearchOK();
              }
            },
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gatot Kaca',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  searchControl.text = "";
                  searching = false;
                  searched = false;
                  searchResult = [];
                });
              },
              child: const BrandText(),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, .25),
                    blurRadius: 2,
                    spreadRadius: 2,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchControl,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Ketik untuk mencari",
                  contentPadding: const EdgeInsets.fromLTRB(8, 18, 2, 18),
                  suffixIcon: InkWell(
                    onTap: () => search(context),
                    child: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 30,
                      weight: 5,
                    ),
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            if (searching) ...[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Mencari..",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              AnimatedContainer(
                clipBehavior: Clip.hardEdge,
                duration: Duration.zero,
                height: 120,
                width: 175,
                margin: flyPos < 0
                    ? EdgeInsets.only(
                        right: -flyPos,
                      )
                    : EdgeInsets.only(
                        left: flyPos,
                      ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/gatotkaca-fly.png"),
                  ),
                ),
                // child: SizedBox(width: 175),
              ),
            ] else
              ...[],
            searched ? responseWidget : Container(),
          ],
        ),
      ),
    );
  }
}

class SearchOK extends StatelessWidget {
  const SearchOK({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 150,
            width: 150,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/gatotkaca-ok.png"),
              ),
            ),
          ),
          Flexible(
            child: Text(
              "Pencarian berhasil.",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchNotFound extends StatelessWidget {
  const SearchNotFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 150,
            width: 150,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/gatotkaca-cry.png"),
              ),
            ),
          ),
          Flexible(
            child: Text(
              "Pencarian tidak ditemukan :(",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchFailed extends StatelessWidget {
  const SearchFailed({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 150,
            width: 150,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/gatotkaca-sad.png"),
              ),
            ),
          ),
          Flexible(
            child: Text(
              "Terjadi kesalahan :(",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchTimeout extends StatelessWidget {
  const SearchTimeout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 150,
            width: 150,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/gatotkaca-sleep.png"),
              ),
            ),
          ),
          Flexible(
            child: Text(
              "Pencarian terlalu lama",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MaintenanceMessage extends StatelessWidget {
  const MaintenanceMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 150,
            width: 150,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/gatotkaca-sit.png"),
              ),
            ),
          ),
          Flexible(
            child: Text(
              "Server sedang maintenance",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchResult extends StatelessWidget {
  const SearchResult({
    super.key,
    required this.searchResult,
  });

  final List searchResult;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      height: MediaQuery.of(context).size.height * .8,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...searchResult
                .map(
                  (e) => InkWell(
                    onTap: () async {
                      if (!await launchUrl(
                        Uri.parse(e!["url"] ?? "http://example.com"),
                        mode: LaunchMode.inAppWebView,
                      )) {}
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            e!["title"] ?? "",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(105, 83, 238, 1),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .6,
                            child: Text(
                              e!["url"] ?? "",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(145, 116, 121, 1),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            e!["description"] ?? "",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(10, 10, 10, 1),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
