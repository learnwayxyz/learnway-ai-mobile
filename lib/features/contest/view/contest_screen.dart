import 'dart:async';
import 'dart:developer';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/contest/bloc/contest_bloc.dart';
import 'package:learnwayv2/features/contest/model/all_contest_model.dart';
import 'package:learnwayv2/features/contest/view/widgets/access_code_bottomsheet.dart';
import 'package:learnwayv2/features/contest/view/widgets/contest_card_shimmer.dart';
import 'package:learnwayv2/features/contest/view/widgets/contest_card_widget.dart';
import 'package:learnwayv2/features/contest/view/widgets/payment_bottomsheet.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/custom_tabs.dart';

@RoutePage()
class ContestScreen extends StatefulWidget {
  const ContestScreen({super.key});

  @override
  State<ContestScreen> createState() => _ContestScreenState();
}

class _ContestScreenState extends State<ContestScreen> {
  String _selectedContestTab = 'All';
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  String? _failedContestId;
  bool _isRetrying = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contestBloc = context.read<ContestBloc>();
      contestBloc.add(GetAllContestsEvent(contestStatus: null));
    });
  }

  Future<void> _onRefresh() async {
    final contestBloc = context.read<ContestBloc>();
    contestBloc.clearContestCache();
    contestBloc.add(
      GetAllContestsEvent(forceRefresh: true, contestStatus: null),
    );
    await contestBloc.stream.firstWhere(
      (state) =>
          state is FetchingContestsCompleted ||
          state is ErrorFetchingAllContests,
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.9;
    if (currentScroll >= threshold) {
      _loadMoreContests();
    }
  }

  void _checkAndLoadMoreIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final state = context.read<ContestBloc>().state;

      if (maxScroll < 100 && state is FetchingContestsCompleted) {
        final contests = state.contests;
        if (contests.page < contests.totalPages && !_isLoadingMore) {
          log('Auto-loading more contests: insufficient content to scroll');
          _loadMoreContests();
        }
      }
    });
  }

  void _loadMoreContests() {
    final state = context.read<ContestBloc>().state;
    if (state is FetchingContestsCompleted && !_isLoadingMore) {
      final contests = state.contests;
      if (contests.page < contests.totalPages) {
        setState(() {
          _isLoadingMore = true;
        });
        context.read<ContestBloc>().add(
          GetAllContestsEvent(
            page: contests.page + 1,
            isLoadMore: true,
            contestStatus: null,
          ),
        );
      }
    }
  }

  /// Restores the contest list after returning from a sub-screen (loader/quiz).
  /// The app-level ContestBloc doubles as a game-state machine, so gameplay
  /// states (StartingContest, ErrorStartingContest, …) can displace the list
  /// state. This method brings it back from cache, or re-fetches if needed.
  void _restoreContestList() {
    if (!mounted) return;
    final bloc = context.read<ContestBloc>();
    final state = bloc.state;
    if (state is FetchingContestsCompleted ||
        (state is ErrorJoiningContest && state.cachedContests != null)) {
      return; // already showing the list
    }
    if (bloc.hasCachedContests) {
      bloc.add(ResetContest());
    } else {
      bloc.add(GetAllContestsEvent(contestStatus: null));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(title: 'Contest', barHeight: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              VSpace(20),
              Row(
                children: [
                  Expanded(
                    child: CustomTabs<String>(
                      tabs: [
                        TabItem<String>(value: 'All', label: 'All'),
                        TabItem<String>(value: 'Ongoing', label: 'Ongoing'),
                        TabItem<String>(value: 'Upcoming', label: 'Upcoming'),
                        TabItem<String>(value: 'Finished', label: 'Finished'),
                      ],
                      selectedValue: _selectedContestTab,
                      onTabSelected: (String selectedTab) {
                        setState(() {
                          _selectedContestTab = selectedTab;
                        });
                        context.read<ContestBloc>().add(
                          GetAllContestsEvent(contestStatus: null),
                        );
                      },
                      defaultSelectedColor: AppColors.gray900,
                      defaultUnselectedColor: AppColors.gray200,
                      defaultSelectedTextColor: Colors.white,
                      defaultUnselectedTextColor: AppColors.gray800,
                      borderRadius: 60,
                      defaultTextStyle: AppTextStyles.smBold(context).copyWith(
                        color: AppColors.gray800,
                        fontWeight: FontWeight.w500,
                      ),
                      defaultPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      spacing: 8.0,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              VSpace(20),
              Expanded(
                child: BlocConsumer<ContestBloc, ContestState>(
                  listener: (context, state) {
                    if (state is FetchingContestsCompleted) {
                      setState(() {
                        _isLoadingMore = false;
                      });
                      _checkAndLoadMoreIfNeeded();
                    }

                    if (state is ContestInProgress) {
                      setState(() {
                        _failedContestId = null;
                        _isRetrying = false;
                      });
                    }
                    if (state is ContestJoined) {
                      setState(() {
                        _failedContestId = null;
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is FetchingAllContests) {
                      return const ContestCardShimmer();
                    }
                    if (state is FetchingContestsCompleted ||
                        (state is ErrorJoiningContest &&
                            state.cachedContests != null)) {
                      return Stack(
                        children: [
                          RefreshIndicator(
                            onRefresh: _onRefresh,
                            child: _buildTabContent(state),
                          ),
                          if (_isLoadingMore)
                            const Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: ContestCardShimmer(itemCount: 1),
                            ),
                        ],
                      );
                    }
                    return Center(
                      child: Text(
                        'No contests available',
                        style: AppTextStyles.mdRegular(context),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(ContestState state) {
    AllContestData? contestData;
    if (state is FetchingContestsCompleted) {
      contestData = state.contests;
    } else if (state is ErrorJoiningContest) {
      contestData = state.cachedContests;
    }

    if (contestData != null) {
      List<Contest> contests = contestData.content;
      if (_selectedContestTab == 'Finished') {
        contests = contests.where((contest) {
          return contest.userState?.hasCompleted ?? false;
        }).toList();
      } else if (_selectedContestTab == 'Ongoing') {
        contests = contests.where((contest) {
          return contest.contestStatus == ContestStatus.ongoing &&
              !(contest.userState?.hasCompleted ?? false);
        }).toList();
      } else if (_selectedContestTab == 'Upcoming') {
        contests = contests.where((contest) {
          return contest.contestStatus == ContestStatus.upcoming;
        }).toList();
      } else if (_selectedContestTab == 'All') {
        contests = contests.where((contest) {
          if (contest.userState?.hasCompleted ?? false) {
            return false;
          }
          if (contest.contestStatus == ContestStatus.finished) {
            return false;
          }
          return true;
        }).toList();
      }

      return ContestListBuilder(
        contests: contests,
        scrollController: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        onActionButtonTap: (contest) {
          if (_failedContestId == contest.id && !_isRetrying) {
            _handleRetryContest(contest);
          } else {
            switch (contest.type) {
              case ContestType.public:
                _handlePublicContest(contest);
                break;
              case ContestType.private:
                _handlePrivateContest(contest);
                break;
            }
          }
        },
        padding: EdgeInsets.zero,
        failedContestId: _failedContestId,
        isRetrying: _isRetrying,
        hideJoinedAndCompleted: _selectedContestTab == 'All',
      );
    }
    return Center(
      child: Text(
        'No contests available',
        style: AppTextStyles.mdRegular(context),
      ),
    );
  }

  Future<void> _handlePublicContest(Contest contest) async {
    log('Handling public contest: ${contest.title}');
    ;

    if (contest.contestStatus == ContestStatus.finished) {
      context.router.push(
        ContestLeaderBoardRoute(
          contestId: contest.id ?? '',
          arguments: {
            'title': contest.title ?? '',
            'description': contest.description,
            'date': contest.finishedAt,
          },
        ),
      );
      return;
    }
    if (contest.contestStatus == ContestStatus.upcoming) {
      context.router.push(UpcomingDetailsRoute(contest: contest));
      return;
    }

    if (contest.contestStatus == ContestStatus.ongoing &&
        ((contest.userState?.hasJoined ?? false) ||
            (contest.userState?.hasCompleted ?? false) ||
            contest.hasJoined)) {
      context.router.push(
        ContestLeaderBoardRoute(
          contestId: contest.id ?? '',
          arguments: {
            'title': contest.title ?? '',
            'description': contest.description,
            'date': contest.finishedAt,
          },
        ),
      );
      return;
    }

    final contestBloc = context.read<ContestBloc>();
    final currentState = contestBloc.state;
    if (currentState is ContestJoined &&
        currentState.participation.contestId == contest.id &&
        !currentState.hasStartedContest) {
      await context.router.push(
        ContestLoaderRoute(
          title: contest.title ?? '',
          contestId: contest.id ?? '',
        ),
      );
      if (!mounted) return;
      final afterState = contestBloc.state;
      if (afterState is ErrorStartingContest) {
        setState(() {
          _failedContestId = contest.id;
        });
      }
      _restoreContestList();
      return;
    }

    if (currentState is ErrorStartingContest &&
        currentState.contestId == contest.id) {
      log('Retrying failed start');
      await context.router.push(
        ContestLoaderRoute(
          title: contest.title ?? '',
          contestId: contest.id ?? '',
        ),
      );

      if (!mounted) return;
      final afterState = contestBloc.state;
      if (afterState is ErrorStartingContest) {
        setState(() {
          _failedContestId = contest.id;
        });
      }
      _restoreContestList();
      return;
    }

    final contestEntryBloc = locator.get<ContestBloc>();
    contestEntryBloc.add(InitializeEntry(contest: contest));

    final result = await showPaymentBottomSheet(
      context: context,
      contest: contest,
      contestBloc: contestEntryBloc,
    );

    if (result?.state is ErrorJoiningContest) {
      if ((result?.state as ErrorJoiningContest).message.toLowerCase().contains(
        'already joined',
      )) {
        if (mounted) {
          await context.router.push(
            ContestLoaderRoute(
              title: contest.title ?? '',
              contestId: contest.id ?? '',
            ),
          );
          _restoreContestList();
        }
      }
    }

    if (result?.success == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully joined ${contest.title}!'),
          backgroundColor: AppColors.gray900,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (mounted) {
        await context.router.push(
          ContestLoaderRoute(
            title: contest.title ?? '',
            contestId: contest.id ?? '',
          ),
        );
      }

      if (!mounted) return;
      final currentState = context.read<ContestBloc>().state;
      if (currentState is ErrorStartingContest &&
          currentState.failedToStartContest) {
        setState(() {
          _failedContestId = contest.id;
        });
      }
      _restoreContestList();
    } else {
      log('Failed to join contest');
    }
  }

  Future<void> _handleRetryContest(Contest contest) async {
    log('Retrying contest: ${contest.title}');
    setState(() {
      _isRetrying = true;
    });

    await context.router.push(
      ContestLoaderRoute(
        title: contest.title ?? '',
        contestId: contest.id ?? '',
      ),
    );

    if (!mounted) return;
    final afterState = context.read<ContestBloc>().state;
    if (afterState is ErrorStartingContest && afterState.failedToStartContest) {
      setState(() {
        _failedContestId = contest.id;
      });
    } else {
      setState(() {
        _failedContestId = null;
      });
    }
    setState(() {
      _isRetrying = false;
    });
    _restoreContestList();
  }

  Future<void> _handlePrivateContest(Contest contest) async {
    try {
      //Go to result screen if user has completed the contest
      if (contest.userState?.hasCompleted == true) {
        if (mounted) {
          await context.router.push(
            ContestLeaderBoardRoute(
              contestId: contest.id ?? '',
              arguments: {
                'title': contest.title ?? '',
                'date': contest.endDate ?? '',
                'description': contest.description,
              },
            ),
          );
        }
        return;
      }

      // Check if user has already joined and started but not completed
      if (contest.userState?.hasJoined == true &&
          contest.userState?.hasStarted == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You cannot take this contest anymore.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      // Check if user has already joined but not started (resuming)
      if (contest.userState?.hasJoined == true &&
          contest.userState?.hasStarted == false) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Resuming ${contest.title}...'),
              backgroundColor: AppColors.gray900,
              behavior: SnackBarBehavior.floating,
            ),
          );

          await context.router.push(
            ContestLoaderRoute(
              title: contest.title ?? '',
              contestId: contest.id ?? '',
            ),
          );

          if (!mounted) return;
          final currentState = context.read<ContestBloc>().state;
          if (currentState is ErrorStartingContest &&
              currentState.failedToStartContest) {
            setState(() {
              _failedContestId = contest.id;
            });
          }
          _restoreContestList();
        }
        return;
      }

      // User hasn't joined yet, proceed with normal flow
      final contestEntryBloc = locator.get<ContestBloc>();
      contestEntryBloc.add(InitializeEntry(contest: contest));

      final accessCode = await showAccessCodeBottomSheet(
        context: context,
        contest: contest,
        contestBloc: contestEntryBloc,
      );

      if (accessCode != null && mounted) {
        final result = await showPaymentBottomSheet(
          context: context,
          contest: contest,
          contestBloc: contestEntryBloc,
          accessCode: accessCode,
        );

        if (result?.state is ErrorJoiningContest) {
          if ((result?.state as ErrorJoiningContest).message
              .toLowerCase()
              .contains('already joined')) {
            if (mounted) {
              await context.router.push(
                ContestLoaderRoute(
                  title: contest.title ?? '',
                  contestId: contest.id ?? '',
                ),
              );
              _restoreContestList();
            }
          }
        }

        if (result?.success == true && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully joined ${contest.title}!'),
              backgroundColor: AppColors.gray900,
              behavior: SnackBarBehavior.floating,
            ),
          );

          await context.router.push(
            ContestLoaderRoute(
              title: contest.title ?? '',
              contestId: contest.id ?? '',
            ),
          );

          if (!mounted) return;
          final currentState = context.read<ContestBloc>().state;
          if (currentState is ErrorStartingContest &&
              currentState.failedToStartContest) {
            setState(() {
              _failedContestId = contest.id;
            });
          }
          _restoreContestList();
        } else {
          log('Failed to join contest');
        }
      } else {
        log('Contest joining cancelled');
      }
    } catch (e) {
      log('Error handling private contest: $e');
    }
  }
}
