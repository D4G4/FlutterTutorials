/// We are going to have a HackerNews block.
/// This will manage the state of the content we are showing
/// It will do the
/// ______________Network Request
/// ______________Cache them
/// ______________Manage switching from topStories to newStories (type of API response)
///
/// Also, all the outputs are streams and all the inputs are streams.
/// Stream in - Stream out
///
///
/// Why did we use [BehaviourSubjects]? Why isn't it a [StreamController] (SC)
///
/// Coz, typically with a [Stream], I would create a [StreamController] and
/// [StreamController] will give me a reference to a [Stream] but it would also give me
/// an [add()] to add things to the stream.
///
///                                     BUT
///
/// The nice thing and the problem with [Streams] is that they are ``asynchronous``,
/// while some things, especially the [build()] in Flutter is synchronous.
///
/// But the problem with using [StreamController] is
/// If Flutter builds something and suddenly wants to show a page full of articles
/// it will be empty until something about articles changes
/// So, what [BehaviourSubject] does is
/// whenever someone new listens to it, the first thing it does it it sends you the
/// latest/last element pushed into the stream.
/// First time, no data, second time.. atleast you'll get previous data and in a while,
/// data will be updated from network. Thus you won't have to wait for it.
///
/// tl;dr
/// [StreamController]
///   -> I have to wait for something to actively come through the stream
/// [BehaviourSubject]
///   -> As long as one thing has come from the stream, I  will always
///   get the previous value when i start to listen on that stream.
///
///
///  `Rule of BLoC`:
///   Pass to the UI what you're going to represent in the UI,
///   and not have to have additional business logic in the UI.
///
///
/// We want our `StreamBuider` to listen for the list of `Article`s when it's ready.
import 'dart:async';
import 'package:boring_flutter_project/source_gen_code__parsers/json_parsing.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:collection';

enum StoriesType { topStories, newStories }

class HackerNewsBloc {
  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;

  //Multiple dataValues can be stored in Sink
  //Sink<StoriesType> get storiesType => _storiesTypeController.sink;
  StreamController<StoriesType> get storiesType => _storiesTypeController;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  final _storiesTypeController = StreamController<StoriesType>();

  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: false);

  var _articles = <Article>[]; //Initialize empty list of article

  HackerNewsBloc() {
    _getArticlesAndUpdate(_topIds);

    _storiesTypeController.stream.listen((storiesType) {
      print(
          '_StoriesTypeController is paused -> ${_storiesTypeController.isPaused}');
      print('_StoriesTypeController .sink -> ${_storiesTypeController.sink}');
      print(
          '_StoriesTypeController .toString -> ${_storiesTypeController.toString()}');
      switch (storiesType) {
        case StoriesType.topStories:
          _getArticlesAndUpdate(_topIds);
          break;
        case StoriesType.newStories:
          _getArticlesAndUpdate(_newIds);
          break;
      }
    });
  }

  _getArticlesAndUpdate(List<int> ids) async {
    _isLoadingSubject.add(true);
    await _updateArticles(ids);
    _isLoadingSubject.add(false);
    _articlesSubject.add(UnmodifiableListView(_articles));
  }

  static List<int> _topIds = [17775906, 17785162, 17787275, 17789456, 17780127];

  static List<int> _newIds = [17794509, 17790031, 17788060, 17795143, 17782918];

  Future<Article> _getArticle(int id) async {
    final url = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final response2 = await http.get(url);
    if (response2.statusCode == 200) {
      return parseArticle(response2.body);
    }
  }

  Future<Null> _updateArticles(List<int> ids) async {
    //Iterable of Future of Article
    final futureArticles = ids.map((id) => _getArticle(id));
    _articles = await Future.wait(futureArticles);
  }
}
