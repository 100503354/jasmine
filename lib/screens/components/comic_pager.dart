import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jasmine/basic/methods.dart';
import 'package:jasmine/configs/pager_controller_mode.dart';
import 'package:jasmine/screens/components/content_builder.dart';
import 'comic_list.dart';

class ComicPager extends StatefulWidget {
  final Future<InnerComicPage> Function(int page) onPage;

  const ComicPager({required this.onPage, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ComicPagerState();
}

class _ComicPagerState extends State<ComicPager> {
  @override
  void initState() {
    currentPagerControllerModeEvent.subscribe(_setState);
    super.initState();
  }

  @override
  void dispose() {
    currentPagerControllerModeEvent.unsubscribe(_setState);
    super.dispose();
  }

  _setState(_) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    switch (currentPagerControllerMode) {
      case PagerControllerMode.stream:
        return _StreamPager(onPage: widget.onPage);
      case PagerControllerMode.pager:
        return _PagerPager(onPage: widget.onPage);
    }
  }
}

class _StreamPager extends StatefulWidget {
  final Future<InnerComicPage> Function(int page) onPage;

  const _StreamPager({Key? key, required this.onPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StreamPagerState();
}

class _StreamPagerState extends State<_StreamPager> {
  int _maxPage = 1;
  int _nextPage = 1;
  int _total = 0;

  var _joining = false;
  var _joinSuccess = true;

  Future<List<ComicSimple>> _next() async {
    var response = await widget.onPage(_nextPage);
    if (_nextPage == 1) {
      if (response.total == 0) {
        _maxPage = 1;
      } else {
        _maxPage = (response.total / response.list.length).ceil();
      }
      _total = response.total;
    }
    _nextPage++;
    return response.list;
  }

  Future _join() async {
    try {
      setState(() {
        _joining = true;
      });
      _data.addAll(await _next());
      setState(() {
        _joinSuccess = true;
        _joining = false;
      });
    } catch (e, st) {
      print("$e\n$st");
      setState(() {
        _joinSuccess = false;
        _joining = false;
      });
    }
  }

  final List<ComicSimple> _data = [];
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_onScroll);
    Future.delayed(Duration.zero, () {
      _join();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_joining || _nextPage > _maxPage) {
      return;
    }
    if (_controller.position.pixels + 100 <
        _controller.position.maxScrollExtent) {
      return;
    }
    _join();
  }

  Widget? _buildLoadingCard() {
    if (_joining) {
      return Card(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: const CupertinoActivityIndicator(
                radius: 14,
              ),
            ),
            const Text('加载中'),
          ],
        ),
      );
    }
    if (!_joinSuccess) {
      return Card(
        child: InkWell(
          onTap: () {
            _join();
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Icon(Icons.sync_problem_rounded),
              ),
              const Text('出错, 点击重试'),
            ],
          ),
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ComicList(
      controller: _controller,
      data: _data,
      append: _buildLoadingCard(),
    );
  }
}

class _PagerPager extends StatefulWidget {
  final Future<InnerComicPage> Function(int page) onPage;

  const _PagerPager({Key? key, required this.onPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PagerPagerState();
}

class _PagerPagerState extends State<_PagerPager> {
  final TextEditingController _textEditController =
      TextEditingController(text: '');
  late int _currentPage = 1;
  late int _maxPage = 1;
  late final List<ComicSimple> _data = [];
  late Future _pageFuture = _load();

  Future<dynamic> _load() async {
    var response = await widget.onPage(_currentPage);
    setState(() {
      if (_currentPage == 1) {
        if (response.total == 0) {
          _maxPage = 1;
        } else {
          _maxPage = (response.total / response.list.length).ceil();
        }
      }
      _data.clear();
      _data.addAll(response.list);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentBuilder(
      future: _pageFuture,
      onRefresh: () async {
        setState(() {
          _pageFuture = _load();
        });
      },
      successBuilder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Scaffold(
          appBar: _buildPagerBar(),
          body: ComicList(
            data: _data,
          ),
        );
      },
    );
  }

  PreferredSize _buildPagerBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: .5,
              style: BorderStyle.solid,
              color: Colors.grey[200]!,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                _textEditController.clear();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Card(
                        child: TextField(
                          controller: _textEditController,
                          decoration: const InputDecoration(
                            labelText: "请输入页数：",
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('取消'),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                            var text = _textEditController.text;
                            if (text.isEmpty || text.length > 5) {
                              return;
                            }
                            var num = int.parse(text);
                            if (num == 0 || num > _maxPage) {
                              return;
                            }
                            setState(() {
                              _currentPage = num;
                              _pageFuture = _load();
                            });
                          },
                          child: const Text('确定'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Row(
                children: [
                  Text("第 $_currentPage / $_maxPage 页"),
                ],
              ),
            ),
            Row(
              children: [
                MaterialButton(
                  minWidth: 0,
                  onPressed: () {
                    if (_currentPage > 1) {
                      setState(() {
                        _currentPage = _currentPage - 1;
                        _pageFuture = _load();
                      });
                    }
                  },
                  child: const Text('上一页'),
                ),
                MaterialButton(
                  minWidth: 0,
                  onPressed: () {
                    if (_currentPage < _maxPage) {
                      setState(() {
                        _currentPage = _currentPage + 1;
                        _pageFuture = _load();
                      });
                    }
                  },
                  child: const Text('下一页'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
