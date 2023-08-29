import 'package:cardoctor_chatapp/src/page/contains.dart';
import 'package:cardoctor_chatapp/src/utils/custom_theme.dart';

import 'package:flutter/material.dart';

import '../page/chat_detail/chat_detail_screen.dart';
import '../page/chat_list/chat_list_screen.dart';
import '../utils/utils.dart';
import 'text_field_widget.dart';

typedef SearchListItemTitleBuilder<T> = String Function(T);

class SearchListSimpleItemPopup<T> extends StatefulWidget {
  final List<T> listData;
  final List<int>? defaultIndexes;
  final String? title;
  final String? hintText;
  final bool pressClear;
  final Function(List<int> selectedIndexes) onSelect;
  final bool? showSearch;
  final bool isSingleChoice;
  final SearchListItemTitleBuilder<T>? builder;
  final Widget? child;
  final String cluseterID;
  final String apiKey;
  final String apiSecret;
  final String user1Id;
  final String user2Id;
  final int getNotifySelf;
  final int getPresence;
  final String jwt;

  const SearchListSimpleItemPopup({
    Key? key,
    required this.listData,
    this.defaultIndexes,
    this.hintText,
    required this.onSelect,
    this.builder,
    this.title,
    this.isSingleChoice = true,
    this.pressClear = false,
    this.showSearch = true,
    this.child,
    required this.cluseterID,
    required this.apiKey,
    required this.apiSecret,
    required this.user1Id,
    required this.user2Id,
    required this.getNotifySelf,
    required this.getPresence,
    required this.jwt,
  }) : super(key: key);

  @override
  State<SearchListSimpleItemPopup> createState() =>
      _SearchListSimpleItemPopupState<T>();
}

class _SearchListSimpleItemPopupState<T>
    extends State<SearchListSimpleItemPopup<T>> {
  List<T> listDataOriginal = [];
  List<T> listData = [];
  final TextEditingController controller = TextEditingController();
  List<int> selectedIndexes = [];

  late ScrollController scrollController;

  @override
  void initState() {
    listDataOriginal = widget.listData;
    listData = widget.listData;
    selectedIndexes = widget.defaultIndexes ?? [];
    int currentIndex = widget.defaultIndexes?[0] ?? 0;
    if (currentIndex < 0) {
      currentIndex = 0;
    }
    // scroll to row by row height and separator height
    scrollController = ScrollController();
    // initialScrollOffset: 53.5.h * currentIndex + currentIndex.h);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void updateListData(List<T> listData) {
    listDataOriginal = listData;
    this.listData = listData;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.title != null)
            Text(
              widget.title ?? '',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: Theme.of(context).textTheme.h5Bold,
            ),
          if (widget.title != null) SizedBox(height: 16),
          if (widget.title != null)
            Container(
              color: kColorneutral7,
              height: 1,
            ),
          SizedBox(height: 16),
          if (widget.showSearch == true)
            TextFieldWidget(
              suffixIcon:
                  !widget.pressClear ? null : 'assets/imgs/ic_delete_field.png',
              onPressSuffix: !widget.pressClear
                  ? () {}
                  : () {
                      setState(() {
                        controller.text = '';
                      });
                      _searchKeyword(controller.text.trim());
                    },
              autoFocus: false,
              controller: controller,
              icon: 'assets/imgs/ic_search.png',
              textInputAction: TextInputAction.search,
              hintText: widget.hintText ?? 'Search',
              onChanged: (text) => _searchKeyword(text?.trim()),
            ),
          Expanded(
            child: Utils.isEmpty(listData) && !Utils.isEmpty(listDataOriginal)
                ? Center(child: Text('No data'))
                : Container(
                    margin: EdgeInsets.only(
                      top: widget.title != null ? 0.0 : 16,
                      bottom: widget.title != null ? 0.0 : 16,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.title != null ? 0.0 : 16,
                    ),
                    decoration: BoxDecoration(
                        color: widget.title != null ? null : Colors.white,
                        borderRadius: widget.title != null
                            ? null
                            : BorderRadius.all(Radius.circular(16))),
                    child: Scrollbar(
                      child: Container(
                        child: ListView.separated(
                          controller: scrollController,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: listData.length,
                          itemBuilder: (context, index) {
                            return widget.child ??
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChatDetailScreen(
                                          apiKey: widget.apiKey,
                                          apiSecret: widget.apiSecret,
                                          cluseterID: widget.cluseterID,
                                          user1Id: '',
                                          user2Id: '',
                                          getNotifySelf: 1,
                                          getPresence: 1,
                                          jwt: '',
                                          avatar:
                                              list[index]['avatar'].toString(),
                                          name: list[index]['name'].toString(),
                                        ),
                                      ),
                                    );
                                    // NavigationUtils.popPage(context);
                                  },
                                  child: ChatItem(
                                    avatar: 'assets/imgs/ic_delete_field.png',
                                    name: list[index]['name'].toString(),
                                    lastMessage:
                                        list[index]['last_message'].toString(),
                                    time: list[index]['time'].toString(),
                                    read: list[index]['read']! as bool,
                                  ),
                                );
                          },
                          separatorBuilder: (context, index) => Container(
                            height: 1,
                            color: kColorlightestGray,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _searchKeyword(String? name) {
    if (Utils.isEmpty(name)) {
      listData = widget.listData;
    }
    listData = widget.listData
        .where(
          (e) =>
              Utils.convertVNtoText(widget.builder!(e)).toLowerCase().contains(
                    Utils.convertVNtoText(name!).toLowerCase(),
                  ),
        )
        .toList();
    setState(() {});
  }
}
