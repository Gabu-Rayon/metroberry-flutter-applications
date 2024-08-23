library flutter_web_pagination;

import 'dart:math';

import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_text_input_formatter/formatter.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:provider/provider.dart';


// final themeChange = Provider.of<DarkThemeProvider>(context);
class WebPagination extends StatefulWidget {
  final int currentPage;
  final int totalPage;
  final ValueChanged<int> onPageChanged;
  final int displayItemCount;
  const WebPagination(
      {super.key,
        required this.onPageChanged,
        required this.currentPage,
        required this.totalPage,
        this.displayItemCount = 11});

  @override
  _WebPaginationState createState() => _WebPaginationState();
}

class _WebPaginationState extends State<WebPagination> {
  late int currentPage = widget.currentPage;
  late int totalPage = widget.totalPage;
  late int displayItemCount = widget.displayItemCount;
  late TextEditingController controller = TextEditingController();

  @override
  void didUpdateWidget(covariant WebPagination oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentPage != widget.currentPage ||
        oldWidget.totalPage != widget.totalPage) {
      setState(() {
        currentPage = widget.currentPage;
        totalPage = widget.totalPage;
      });
    }
  }

  void _updatePage(int page) {
    setState(() {
      currentPage = page;
    });
    widget.onPageChanged(page);
  }

  List<Widget> _buildPageItemList() {
    List<Widget> widgetList = [];
    widgetList.add(_PageControlButton(
      enable: currentPage > 1,
      title: '«',
      onTap: () {
        _updatePage(currentPage - 1);
      },
    ));

    var leftPageItemCount = (displayItemCount / 2).floor();

    var rightPageItemCount = max(0, displayItemCount - leftPageItemCount - 1);

    int startPage = max(
        1,
        currentPage -
            max(leftPageItemCount,
                (displayItemCount - totalPage + currentPage - 1)));

    for (; startPage <= currentPage; startPage++) {
      widgetList.add(_PageItem(
        page: startPage,
        isChecked: startPage == currentPage,
        onTap: (page) {
          _updatePage(page);
        },
      ));
    }

    int endPage =
    min(totalPage, max(displayItemCount, currentPage + rightPageItemCount));

    for (; startPage <= endPage; startPage++) {
      widgetList.add(_PageItem(
        page: startPage,
        isChecked: startPage == currentPage,
        onTap: (page) {
          _updatePage(page);
        },
      ));
    }

    widgetList.add(_PageControlButton(
      enable: currentPage < totalPage,
      title: '»',
      onTap: () {
        _updatePage(currentPage + 1);
      },
    ));
    return widgetList;
  }

  Widget _buildPageInput() {
    return Container(
        height: 40,
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xFFE3E3E3), width: 1)),
        width: 50,
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          maxLines: 1,
          inputFormatters: CustomTextInputFormatter.getIntFormatter(
              maxValue: totalPage.toDouble()),
          style: const TextStyle(
              textBaseline: TextBaseline.alphabetic,
              color: AppThemData.primary500,
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: totalPage.toString(),
              hintStyle: const TextStyle(
                  color: Color(0xFFA3A3A3),
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ..._buildPageItemList(),
        const SizedBox(width: 10),
        _buildPageInput(),
        const SizedBox(width: 10),
        _PageControlButton(
            enable: true,
            title: "GO",
            onTap: () {
              setState(() {
                try {
                  _updatePage(int.parse(controller.text));
                  controller.clear();
                } catch (e) {
                  // print(e);
                }
              });
            })
      ],
    );
  }
}

class _PageControlButton extends StatefulWidget {
  final bool enable;
  final String title;
  final VoidCallback onTap;
  const _PageControlButton(
      {required this.enable,
        required this.title,
        required this.onTap});

  @override
  _PageControlButtonState createState() => _PageControlButtonState();
}

class _PageControlButtonState extends State<_PageControlButton> {
  Color normalTextColor =  AppThemData.primary500;
  late Color textColor = widget.enable ? normalTextColor : Colors.grey;

  @override
  void didUpdateWidget(_PageControlButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enable != widget.enable) {
      setState(() {
        textColor = widget.enable ? normalTextColor : Colors.grey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InkWell(
        onTap: widget.enable ? widget.onTap : null,
        onHover: (b) {
          if (!widget.enable) return;
          setState(() {
            textColor = b ? normalTextColor.withAlpha(200) : normalTextColor;
          });
        },
        child: _ItemContainer(
            backgroundColor: const Color(0xFFF3F3F3),
            child: Text(
              widget.title,
              style: TextStyle(color: textColor, fontSize: 14),
            )));
  }
}

class _PageItem extends StatefulWidget {
  final int page;
  final bool isChecked;
  final ValueChanged<int> onTap;
  const _PageItem(
      {required this.page,
        required this.isChecked,
        required this.onTap});

  @override
  __PageItemState createState() => __PageItemState();
}

class __PageItemState extends State<_PageItem> {
  Color normalBackgroundColor = const Color(0xFFF3F3F3);
  Color normalHighlightColor =  AppThemData.primary500;
  // Color normalHighlightColor =  AppThemData.primary500;


  late Color backgroundColor = normalBackgroundColor;
  late Color highlightColor = normalHighlightColor;

  @override
  void didUpdateWidget(covariant _PageItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isChecked != widget.isChecked) {
      if (!widget.isChecked) {
        setState(() {
          backgroundColor = normalBackgroundColor;
          highlightColor = normalHighlightColor;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onHover: (b) {
          if (widget.isChecked) return;
          setState(() {
            backgroundColor =
            b ? const Color(0xFFEAEAEA) : normalBackgroundColor;
            highlightColor = b ?  AppThemData.primary500 : normalHighlightColor;
          });
        },
        onTap: () {
          widget.onTap(widget.page);
        },
        child: _ItemContainer(
          backgroundColor: widget.isChecked ? highlightColor : backgroundColor,
          child: Text(
            widget.page.toString(),
            style: TextStyle(
                color: widget.isChecked ? Colors.white : highlightColor,
                fontWeight: FontWeight.w600,
                fontSize: 14),
          ),
        ));
  }
}

class _ItemContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  const _ItemContainer(
      {required this.child, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      decoration: BoxDecoration(
          color: themeChange.isDarkTheme() ? AppThemData.greyShade950  : backgroundColor, borderRadius: BorderRadius.circular(4)),
      child: child,
    );
  }
}