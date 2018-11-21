import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part1_page_reveal/page.dart';
import 'dart:ui';

class PagerIndicator extends StatelessWidget {
  final PagerIndicatorViewModel pagerIndicatorViewModel;

  PagerIndicator({@required this.pagerIndicatorViewModel});
  @override
  Widget build(BuildContext context) {
    List<PageBubble> bubbles = [];
    var activeIndex = pagerIndicatorViewModel.activeIndex;
    for (var bubbleIndex = 0;
        bubbleIndex < pagerIndicatorViewModel.pages.length;
        ++bubbleIndex) {
      final PageViewModel page = pagerIndicatorViewModel.pages[bubbleIndex];

      var percentActive;
      var slideDirection = pagerIndicatorViewModel.slideDirection;

      if (bubbleIndex == activeIndex) {
        percentActive = 1.0 -
            pagerIndicatorViewModel
                .slidePercent; //This bubble's size needs to be reduced
      } else if (bubbleIndex == activeIndex - 1 &&
          slideDirection == SlideDirection.LEFT_TO_RIGHT) {
        // -->
        percentActive = pagerIndicatorViewModel.slidePercent;
      } else if (bubbleIndex == activeIndex + 1 &&
          slideDirection == SlideDirection.RIGHT_TO_LEFT) {
        // <--
        percentActive = pagerIndicatorViewModel.slidePercent;
      } else {
        percentActive = 0.0;
      }

      //Either not selected or is becoming hollow
      bool isHollow = (bubbleIndex > activeIndex) ||
          //becoming hollow
          (bubbleIndex == activeIndex &&
              slideDirection == SlideDirection.LEFT_TO_RIGHT);

      bubbles.add(
        PageBubble(
          viewModel: PagerBubbleViewModel(
            iconAssetPath: page.iconAssetPath,
            iconColor: page.color,
            isHollow: isHollow,
            activePercentAndOpacity: percentActive,
          ),
        ),
      );
    }
    // Subtract one half of the container size and then subtract one half of bubble width
    // and will manage to get the first bubble to the center
    // now add entire bubble with if the position of activeIndex is > 0 (first one)
    const BUBBLE_WIDTH = 55.0;

    final fullWidthOfPagerIndicator =
        BUBBLE_WIDTH * pagerIndicatorViewModel.pages.length;

    // when NoSliding is being done
    double baseTranslation =
        (fullWidthOfPagerIndicator / 2) - (BUBBLE_WIDTH / 2);

    double translation = baseTranslation - (activeIndex * BUBBLE_WIDTH);

    if (pagerIndicatorViewModel.slideDirection ==
        SlideDirection.LEFT_TO_RIGHT) {
      translation += BUBBLE_WIDTH * pagerIndicatorViewModel.slidePercent;
    } else if (pagerIndicatorViewModel.slideDirection ==
        SlideDirection.RIGHT_TO_LEFT) {
      translation -= BUBBLE_WIDTH * pagerIndicatorViewModel.slidePercent;
    }

    return Container(
      child: Transform(
        transform: Matrix4.translationValues(translation, 0.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: bubbles,
        ),
      ),
    );
  }
}

class PageBubble extends StatelessWidget {
  final PagerBubbleViewModel viewModel;

  PageBubble({@required this.viewModel});

  @override
  Widget build(BuildContext context) {
    double size = lerpDouble(20.0, 45.0, viewModel.activePercentAndOpacity);
    return Container(
      width: 55.0,
      height: 65.0,
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: viewModel.isHollow
                ? const Color(0x88FFFFFF).withAlpha(
                    (0x88 * viewModel.activePercentAndOpacity).round())
                : const Color(0x88FFFFFF),
            border: new Border.all(
              color: viewModel.isHollow
                  ? const Color(0x88FFFFFF).withAlpha(
                      (0x88 * (1 - viewModel.activePercentAndOpacity)).round())
                  : Colors.transparent,
              width: 3.0,
            ),
          ),
          child: Opacity(
            opacity: viewModel.activePercentAndOpacity,
            child: Image.asset(
              viewModel.iconAssetPath,
              color: viewModel.iconColor,
            ),
          ),
        ),
      ),
    );
  }
}

enum SlideDirection {
  LEFT_TO_RIGHT, // -->
  RIGHT_TO_LEFT, // <--
  NONE, // |
}

class PagerIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex; //The bubble which needs to be larger
  final SlideDirection slideDirection;
  final double slidePercent;

  PagerIndicatorViewModel({
    @required this.pages,
    this.activeIndex = 0,
    this.slideDirection,
    this.slidePercent,
  });
}

class PagerBubbleViewModel {
  final String iconAssetPath;
  final Color iconColor;
  final bool isHollow; //Bubble's index is > activeIndex
  final double activePercentAndOpacity;

  PagerBubbleViewModel({
    this.iconAssetPath = 'assets/wallet.png',
    this.iconColor = Colors.black,
    this.isHollow = true,
    this.activePercentAndOpacity = 0.0,
  });
}
