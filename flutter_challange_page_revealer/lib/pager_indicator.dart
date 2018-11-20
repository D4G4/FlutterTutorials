import 'package:flutter/material.dart';
import 'package:flutter_challange_page_revealer/page.dart';
import 'dart:ui';

class PageIndicator extends StatelessWidget {
  final PageIndicatorViewModel viewModel;

  PageIndicator({
    @required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    List<PageBubble> bubbles = [];

    for (var i = 0; i < viewModel.pages.length; i++) {
      var percentActive;
      if (i == viewModel.activeIndex) {
        percentActive = 1.0 - viewModel.slidePercent;
      } else if (i == viewModel.activeIndex - 1 &&
          viewModel.slideDirection == SlideDirection.LEFT_TO_RIGHT) {
        percentActive = viewModel.slidePercent;
      } else if (i == viewModel.activeIndex + 1 &&
          viewModel.slideDirection == SlideDirection.RIGHT_TO_LEFT) {
        percentActive = viewModel.slidePercent;
      } else {
        percentActive = 0.0;
      }

      //bool isHollow = i > viewModel.activeIndex || percentActive == 0.0;
      bool isHollow = i > viewModel.activeIndex ||
          (i == viewModel.activeIndex &&
              viewModel.slideDirection ==
                  SlideDirection.LEFT_TO_RIGHT); //If also going backwards
      var page = viewModel.pages[i];

      bubbles.add(
        PageBubble(
          viewModel: PageBubbleViewModel(
            iconAssetPath: page.iconAssetPath,
            iconColor: page.color,
            isHollow: isHollow,
            activePercent: percentActive,
          ),
        ),
      );
    }

    final BUBBLE_WIDTH = 55.0;
    final baseTranslation =
        ((viewModel.pages.length * BUBBLE_WIDTH) / 2) - (BUBBLE_WIDTH / 2);
    var translationX = baseTranslation - (viewModel.activeIndex * BUBBLE_WIDTH);
    if (viewModel.slideDirection == SlideDirection.LEFT_TO_RIGHT) {
      translationX = translationX + (BUBBLE_WIDTH * viewModel.slidePercent);
    } else if (viewModel.slideDirection == SlideDirection.LEFT_TO_RIGHT) {
      translationX = translationX - (BUBBLE_WIDTH * viewModel.slidePercent);
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        Transform(
          transform: Matrix4.translationValues(translationX, 0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bubbles,
          ),
        )
      ],
    );
  }
}

enum SlideDirection { LEFT_TO_RIGHT, RIGHT_TO_LEFT, NONE }

class PageIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  PageIndicatorViewModel({
    this.pages,
    this.activeIndex,
    this.slideDirection,
    this.slidePercent,
  });
}

class PageBubble extends StatelessWidget {
  final PageBubbleViewModel viewModel;

  PageBubble({this.viewModel});

  @override
  Widget build(BuildContext context) => Container(
      width: 55.0,
      height: 65.0,
      //color: Colors.red.withAlpha(30),
      child: Center(
        child: Container(
          width: lerpDouble(20.0, 45.0, viewModel.activePercent),
          height: lerpDouble(20.0, 45.0, viewModel.activePercent),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: viewModel.isHollow
                ? const Color(0x88FFFFFF)
                    .withAlpha((0x88 * viewModel.activePercent).round())
                : const Color(0x88FFFFFF),
            border: Border.all(
              width: 3.0,
              color: viewModel.isHollow
                  ? const Color(0x88FFFFFF)
                      .withAlpha((0x88 * (1 - viewModel.activePercent)).round())
                  : Colors.transparent,
            ),
          ),
          child: Opacity(
            opacity: viewModel.activePercent,
            child: Image.asset(
              viewModel.iconAssetPath,
              color: viewModel.iconColor,
            ),
          ),
        ),
      ));
}

class PageBubbleViewModel {
  final String iconAssetPath;
  final Color iconColor;
  final bool
      isHollow; //Bubble's index is greater than the index of the active page
  final double activePercent;

  PageBubbleViewModel(
      {this.iconAssetPath,
      this.iconColor,
      this.isHollow = true,
      this.activePercent});
}
